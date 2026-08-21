import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/date_utils.dart';
import '../core/platform_widget.dart';
import '../models/dynamic_column_dto.dart';
import '../models/table_action.dart';
import '../models/table_lazy_load_event.dart';
import '../types/icones_default.dart';
import '../types/type_colunm.dart';
import 'icone_default_component.dart';

/// Extrai o valor do campo [campo] de [row]. O resolvedor padrão só entende `Map` (o formato
/// mais comum vindo de JSON/APIs) — Dart não tem reflection disponível em builds de produção,
/// então acesso dinâmico por nome de propriedade em objetos fortemente tipados exige que quem
/// consome [TableGrid] informe seu próprio [TableGrid.resolverCampo].
dynamic _resolverCampoPadrao(dynamic row, String campo) {
  if (row is Map) return row[campo];
  return null;
}

/// Replica a checagem "truthy" do JavaScript usada pelo `TypeColunm.simNao` original
/// (`rowData[col.field] ? 'Sim' : 'Não'` — não é uma comparação estrita com `true`).
bool _ehVerdadeiro(dynamic valor) {
  if (valor == null) return false;
  if (valor is bool) return valor;
  if (valor is num) return valor != 0;
  if (valor is String) return valor.isNotEmpty;
  return true;
}

String _escaparCsv(dynamic valor) {
  final texto = valor?.toString() ?? '';
  if (!texto.contains(RegExp('[",\r\n]'))) return texto;
  return '"${texto.replaceAll('"', '""')}"';
}

/// Gera o conteúdo CSV usado pela exportação do [TableGrid].
///
/// É público para permitir validação automatizada e usos avançados, mas o fluxo
/// comum deve ser iniciado pelo botão de exportação da própria tabela.
String gerarCsvTableGrid<T>({
  required List<T> data,
  required List<DynamicColumnDTO> colunas,
  required dynamic Function(dynamic row, String campo) resolverCampo,
}) {
  dynamic campo(dynamic row, String nome) => resolverCampo(row, nome);

  String resolverCaminho(dynamic row, String? caminho) {
    if (caminho == null || caminho.isEmpty) return '';
    dynamic atual = row;
    for (final parte in caminho.split(';')) {
      if (atual == null) return '';
      atual = campo(atual, parte);
    }
    return atual?.toString() ?? '';
  }

  String valorCelula(dynamic row, DynamicColumnDTO coluna) {
    switch (coluna.type) {
      case TypeColunm.texto:
        return campo(row, coluna.field)?.toString() ?? '';
      case TypeColunm.simNao:
        return _ehVerdadeiro(campo(row, coluna.field)) ? 'Sim' : 'Não';
      case TypeColunm.status:
        return campo(row, coluna.field) == null ? 'Ativo' : 'Inativo';
      case TypeColunm.statusBoolean:
        return campo(row, coluna.field) == true ? 'Ativo' : 'Inativo';
      case TypeColunm.simNaoCard:
        return campo(row, coluna.field) == true ? 'Sim' : 'Não';
      case TypeColunm.dataBR:
        return toUtcLocal(campo(row, coluna.field)?.toString());
      case TypeColunm.dataHoraBR:
        return toUtcLocalDateTime(campo(row, coluna.field)?.toString());
      case TypeColunm.objeto:
        return resolverCaminho(row, coluna.objeto);
      case TypeColunm.textoConcatenado:
        return coluna.field
            .split(';')
            .map((nome) => campo(row, nome)?.toString() ?? '')
            .join(' ')
            .trim();
      case TypeColunm.array:
        final lista = campo(row, coluna.objeto ?? '');
        if (lista is! List) return '';
        return lista
            .map(
              (item) => coluna.field.isEmpty ? item : campo(item, coluna.field),
            )
            .where((valor) => valor != null)
            .join(', ');
      case TypeColunm.cor:
        return campo(row, coluna.field)?.toString() ?? '';
      case TypeColunm.botao:
        return '';
    }
  }

  final linhas = <String>[
    colunas.map((coluna) => _escaparCsv(coluna.title)).join(','),
    for (final row in data)
      colunas.map((coluna) => _escaparCsv(valorCelula(row, coluna))).join(','),
  ];
  return linhas.join('\r\n');
}

/// Porte de `TablegridComponent` (core/commom-views/tablegrid/tablegrid.component.ts).
///
/// Diferenças de design em relação ao original (Angular + PrimeNG `p-table`), por não haver
/// equivalente direto em Flutter:
/// - Acesso a campos de [T] é feito via [resolverCampo] (ou o resolvedor padrão, que só
///   entende `Map`) em vez de indexação dinâmica (`rowData[col.field]`).
/// - `alturaRolagem` era uma expressão CSS (`min(22rem, calc(100vh - 24rem))`); aqui é uma
///   altura fixa em pixels.
/// - Paginação é construída localmente (botões Anterior/Próxima) em vez de delegar ao
///   componente de paginação do PrimeNG — o contrato "lazy" (o pai busca os dados e informa
///   `totalRegistros`) é preservado via [lazyLoadDados].
class TableGrid<T> extends PlatformWidget {
  final List<T> data;
  final List<DynamicColumnDTO> cols;

  final bool mostrarChkItem;
  final bool mostrarChkExcluidos;

  /// Exibe no cabeçalho um botão para escolher colunas e exportar os dados em CSV.
  final bool exportarCSV;

  /// Rótulo do filtro opcional exibido no rodapé da grade.
  final String rotuloChkExcluidos;

  /// Estado controlado do filtro opcional exibido no rodapé da grade.
  final bool chkExcluidosSelecionado;
  final bool mostrarReativar;
  final String colunaExcluidos;

  final int totalRegistros;
  final int totalPorPag;
  final bool mostrarPaginacao;

  /// Mantém o cabeçalho e a paginação visíveis, rolando somente as linhas da tabela.
  final bool rolavel;
  final double? alturaRolagem;

  final List<TableAction<T>> acoesLinha;

  /// Habilita a coluna de expansão (ícone +/-) no início da grade, com uma sub-grade por linha.
  final bool mostrarExpansao;

  /// Colunas da sub-grade exibida ao expandir uma linha — mesmo formato/tipos de [cols].
  final List<DynamicColumnDTO> colsExpansao;

  /// Nome da propriedade em cada item de [data] que contém as sub-linhas a exibir quando
  /// expandido. Convenção de estado (quem escreve essa propriedade é o pai, tipicamente no
  /// handler de [aoExpandir]): `null` = ainda não buscado ou buscando (mostra "Carregando...");
  /// lista vazia = já carregado e sem registros; lista não vazia = já carregado.
  final String campoExpansao;

  /// Resolve o valor de um campo em [row]. Padrão: funciona para `Map<String, dynamic>`.
  final dynamic Function(T row, String campo)? resolverCampo;

  /// Chamado ao tocar em uma linha da tabela.
  final void Function(T row)? aoVisualizar;
  final void Function(bool mostrarInativos)? aoChkExcluidos;
  final void Function(TableLazyLoadEvent evento)? lazyLoadDados;
  final void Function(List<T> selecionados)? aoSelecionados;
  final void Function(T row)? aoReativar;

  /// Emitido quando uma linha é expandida (não quando é recolhida) — uso típico: buscar sob
  /// demanda os dados de [campoExpansao] na primeira expansão.
  final void Function(T row)? aoExpandir;

  const TableGrid({
    super.key,
    this.data = const [],
    this.cols = const [],
    this.mostrarChkItem = false,
    this.mostrarChkExcluidos = false,
    this.exportarCSV = false,
    this.rotuloChkExcluidos = 'Mostrar Excluídos',
    this.chkExcluidosSelecionado = false,
    this.mostrarReativar = false,
    this.colunaExcluidos = '',
    this.totalRegistros = 0,
    this.totalPorPag = 12,
    this.mostrarPaginacao = false,
    this.rolavel = false,
    this.alturaRolagem,
    this.acoesLinha = const [],
    this.mostrarExpansao = false,
    this.colsExpansao = const [],
    this.campoExpansao = '',
    this.resolverCampo,
    this.aoVisualizar,
    this.aoChkExcluidos,
    this.lazyLoadDados,
    this.aoSelecionados,
    this.aoReativar,
    this.aoExpandir,
  });

  dynamic campo(dynamic row, String nomeCampo) =>
      (resolverCampo ?? _resolverCampoPadrao)(row, nomeCampo);

  // Uma tabela densa de dados corporativos não tem uma variação visual nativa relevante entre
  // Android/iOS/Web/Windows (o componente original tampouco distingue) — uma única
  // implementação é usada em todas as plataformas.
  @override
  Widget createAndroidWidget(BuildContext context) =>
      _TableGridBase<T>(parent: this);

  @override
  Widget createIosWidget(BuildContext context) =>
      _TableGridBase<T>(parent: this);
}

class _TableGridBase<T> extends StatefulWidget {
  final TableGrid<T> parent;

  const _TableGridBase({required this.parent});

  @override
  State<_TableGridBase<T>> createState() => _TableGridBaseState<T>();
}

class _TableGridBaseState<T> extends State<_TableGridBase<T>> {
  List<T> itensSelecionados = [];
  T? linhaSelecionada;
  final List<T> linhasExpandidas = [];
  late bool _chkExcluidosSelecionado;

  /// Índice (0-based) do primeiro registro da página atual — mesma convenção do
  /// `TableLazyLoadEvent.first` do PrimeNG.
  int _paginaFirst = 0;

  TableGrid<T> get parent => widget.parent;

  static const _corAcaoPadrao = Color(0xFF3B82F6);
  static const _corAtivar = Color(0xFF1257A1);

  static const _corBadgeAtivoTexto = Color(0xFF166534);
  static const _corBadgeAtivoFundo = Color(0xFFDCFCE7);
  static const _corBadgeInativoTexto = Color(0xFF991B1B);
  static const _corBadgeInativoFundo = Color(0xFFFEE2E2);
  static const _corItemExcluidoFundo = Color(0xFFFFF1F2);
  static const _corItemExcluidoTexto = Color(0xFFBE123C);

  @override
  void initState() {
    super.initState();
    _chkExcluidosSelecionado = parent.chkExcluidosSelecionado;
  }

  @override
  void didUpdateWidget(covariant _TableGridBase<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parent.chkExcluidosSelecionado !=
        oldWidget.parent.chkExcluidosSelecionado) {
      _chkExcluidosSelecionado = widget.parent.chkExcluidosSelecionado;
    }
  }

  // ── Seleção / navegação de linha ──────────────────────────────────────────

  void _toggleSelecionado(T rowData, bool? checked) {
    setState(() {
      if (checked ?? false) {
        itensSelecionados = [...itensSelecionados, rowData];
      } else {
        itensSelecionados = itensSelecionados
            .where((i) => i != rowData)
            .toList();
      }
    });
    parent.aoSelecionados?.call(itensSelecionados);
  }

  void _onVisualizarClick(T rowData) {
    setState(() => linhaSelecionada = rowData);
    parent.aoVisualizar?.call(rowData);
  }

  void _onAcaoLinhaClick(TableAction<T> action, T rowData) =>
      action.handler(rowData);

  void _chkExcluidosChanged(bool valor) {
    setState(() => _chkExcluidosSelecionado = valor);
    parent.aoChkExcluidos?.call(valor);
  }

  void _toggleExpansao(T rowData) {
    final estava = _estaExpandida(rowData);
    setState(() {
      if (estava) {
        linhasExpandidas.remove(rowData);
      } else {
        linhasExpandidas.add(rowData);
      }
    });
    if (!estava) {
      parent.aoExpandir?.call(rowData);
    }
  }

  bool _estaExpandida(T rowData) => linhasExpandidas.contains(rowData);

  bool _linhaEstaExcluida(T rowData) =>
      parent.colunaExcluidos.isNotEmpty &&
      parent.campo(rowData, parent.colunaExcluidos) != null;

  /// Cor de fundo da linha — porte de `rowClass()`, que no original retornava uma string de
  /// classes CSS (`item-excluido` / `linha-selecionada`).
  Color? _corDaLinha(T rowData) {
    if (_linhaEstaExcluida(rowData)) return _corItemExcluidoFundo;
    if (linhaSelecionada == rowData) return context.design.corLinhaSelecionada;
    return null;
  }

  /// Cor de texto da linha — no CSS original, `.item-excluido` também sobrescreve a cor do
  /// texto (não só o fundo).
  Color? _corTextoDaLinha(T rowData) =>
      _linhaEstaExcluida(rowData) ? _corItemExcluidoTexto : null;

  bool _validarReativar(bool mostrar, T rowData) {
    if (!mostrar) return false;
    if (parent.colunaExcluidos.isNotEmpty) {
      if (parent.campo(rowData, parent.colunaExcluidos) != null) return true;
    }
    return false;
  }

  /// Porte de `resolvePropertyPath` — navega por segmentos separados por `;` (ex.:
  /// `'tipo;descricao'`), aplicando [TableGrid.resolverCampo] a cada nível.
  String _resolvePropertyPath(dynamic rowData, String? path) {
    if (path == null || path.isEmpty) return '';

    dynamic atual = rowData;
    for (final parte in path.split(';')) {
      if (atual == null) return '';
      atual = parent.campo(atual, parte);
    }

    if (atual == null) return '';
    return atual.toString();
  }

  Future<void> _abrirModalExportacao(
    List<DynamicColumnDTO> colunasVisiveis,
  ) async {
    final colunasExportaveis = colunasVisiveis
        .where((coluna) => coluna.type != TypeColunm.botao)
        .toList();
    final selecionadas = colunasExportaveis.toSet();

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (modalContext) => StatefulBuilder(
        builder: (context, atualizarModal) => AlertDialog(
          title: const Text('Exportar dados em CSV'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecione as colunas que deseja exportar:'),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final coluna in colunasExportaveis)
                          CheckboxListTile(
                            key: ValueKey('csv-coluna-${coluna.field}'),
                            value: selecionadas.contains(coluna),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            title: Text(coluna.title),
                            onChanged: (marcada) => atualizarModal(() {
                              if (marcada ?? false) {
                                selecionadas.add(coluna);
                              } else {
                                selecionadas.remove(coluna);
                              }
                            }),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(modalContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              key: const ValueKey('tablegrid-exportar-confirmar'),
              onPressed: selecionadas.isEmpty
                  ? null
                  : () => Navigator.of(modalContext).pop(true),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Exportar'),
            ),
          ],
        ),
      ),
    );

    if (confirmou != true) return;
    await _exportarCsv(
      colunasExportaveis.where(selecionadas.contains).toList(growable: false),
    );
  }

  Future<void> _exportarCsv(List<DynamicColumnDTO> colunas) async {
    final csv = gerarCsvTableGrid<T>(
      data: parent.data,
      colunas: colunas,
      resolverCampo: (row, campo) => parent.campo(row, campo),
    );
    await FileSaver.instance.saveFile(
      name: 'tablegrid_${DateTime.now().millisecondsSinceEpoch}',
      bytes: Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]),
      fileExtension: 'csv',
      mimeType: MimeType.csv,
    );
  }

  // ── Paginação (lazy, delegada ao pai) ─────────────────────────────────────

  int get _totalPaginas => parent.totalRegistros == 0
      ? 1
      : (parent.totalRegistros / parent.totalPorPag).ceil();

  int get _paginaAtual => (_paginaFirst / parent.totalPorPag).floor() + 1;

  void _irParaPagina(int novaPaginaFirst) {
    setState(() => _paginaFirst = novaPaginaFirst);
    parent.lazyLoadDados?.call(
      TableLazyLoadEvent(first: novaPaginaFirst, rows: parent.totalPorPag),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final design = context.design;
    final colunasVisiveis = parent.cols.where((c) => c.visible).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final corpo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final rowData in parent.data) ...[
          _buildLinha(context, rowData, colunasVisiveis),
          if (parent.mostrarExpansao && _estaExpandida(rowData))
            _buildLinhaExpansao(context, rowData),
        ],
        if (parent.data.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Nenhum registro encontrado.',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: design.corFundo,
        borderRadius: BorderRadius.circular(design.raioBorda),
        border: Border.all(color: design.corBorda),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCabecalho(context, colunasVisiveis),
          if (parent.rolavel && parent.alturaRolagem != null)
            SizedBox(
              height: parent.alturaRolagem,
              child: SingleChildScrollView(child: corpo),
            )
          else
            corpo,
          if (parent.mostrarPaginacao) _buildPaginacao(context),
          if (parent.mostrarChkExcluidos) _buildRodapeChkExcluidos(context),
        ],
      ),
    );
  }

  Widget _buildCabecalho(
    BuildContext context,
    List<DynamicColumnDTO> colunasVisiveis,
  ) {
    final design = context.design;
    return Container(
      color: design.corCabecalhoTabela,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (parent.mostrarExpansao) const SizedBox(width: 40),
          if (parent.mostrarChkItem) const SizedBox(width: 40),
          for (var indice = 0; indice < colunasVisiveis.length; indice++)
            _celulaContainer(
              width: colunasVisiveis[indice].width,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      colunasVisiveis[indice].title,
                      style:
                          colunasVisiveis[indice].headerStyle ??
                          const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 0.3,
                          ),
                    ),
                  ),
                  if (parent.exportarCSV &&
                      indice == colunasVisiveis.length - 1)
                    Tooltip(
                      message: 'Exportar CSV',
                      child: IconButton(
                        key: const ValueKey('tablegrid-exportar-csv'),
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.download_outlined, size: 19),
                        onPressed: () => _abrirModalExportacao(colunasVisiveis),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLinha(
    BuildContext context,
    T rowData,
    List<DynamicColumnDTO> colunasVisiveis,
  ) {
    final design = context.design;
    return InkWell(
      onTap: () => _onVisualizarClick(rowData),
      child: Container(
        decoration: BoxDecoration(
          color: _corDaLinha(rowData),
          border: Border(bottom: BorderSide(color: design.corBorda)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (parent.mostrarExpansao)
              SizedBox(
                width: 40,
                child: GestureDetector(
                  onTap: () => _toggleExpansao(rowData),
                  child: IconeDefaultComponent(
                    iconeDefault: _estaExpandida(rowData)
                        ? IconesDefault.minus
                        : IconesDefault.plus,
                    cor: _corAcaoPadrao,
                    tamanho: 17,
                  ),
                ),
              ),
            if (parent.mostrarChkItem)
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: itensSelecionados.contains(rowData),
                  onChanged: (checked) => _toggleSelecionado(rowData, checked),
                ),
              ),
            for (final col in colunasVisiveis)
              _celulaContainer(
                width: col.width,
                child: DefaultTextStyle.merge(
                  style: (col.cellStyle ?? const TextStyle(fontSize: 13))
                      .copyWith(color: _corTextoDaLinha(rowData)),
                  child: _buildCelula(context, rowData, col),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinhaExpansao(BuildContext context, T rowData) {
    final design = context.design;
    final subLinhas =
        parent.campo(rowData, parent.campoExpansao) as List<dynamic>?;

    Widget conteudo;
    if (subLinhas == null) {
      conteudo = Text(
        'Carregando...',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    } else if (subLinhas.isEmpty) {
      conteudo = Text(
        'Nenhum registro encontrado.',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    } else {
      conteudo = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (final subcol in parent.colsExpansao)
                _celulaContainer(
                  width: subcol.width,
                  child: Text(
                    subcol.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
          for (final subRowData in subLinhas)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  for (final subcol in parent.colsExpansao)
                    _celulaContainer(
                      width: subcol.width,
                      child: DefaultTextStyle.merge(
                        style: const TextStyle(fontSize: 12.5),
                        child: _buildCelula(context, subRowData, subcol),
                      ),
                    ),
                ],
              ),
            ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      color: design.corCabecalhoTabela,
      padding: const EdgeInsets.all(10),
      child: conteudo,
    );
  }

  Widget _celulaContainer({required double? width, required Widget child}) {
    final conteudo = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
    return width != null
        ? SizedBox(width: width, child: conteudo)
        : Expanded(child: conteudo);
  }

  /// Porte do `<ng-template #celula>` — resolve o conteúdo de uma célula conforme `col.type`.
  Widget _buildCelula(
    BuildContext context,
    dynamic rowData,
    DynamicColumnDTO col,
  ) {
    switch (col.type) {
      case TypeColunm.texto:
        final valor = parent.campo(rowData, col.field);
        return Text(valor == null ? '' : '$valor');

      case TypeColunm.simNao:
        return Text(
          _ehVerdadeiro(parent.campo(rowData, col.field)) ? 'Sim' : 'Não',
        );

      case TypeColunm.cor:
        return IconeDefaultComponent(
          iconeLucide: 'tag',
          cor: parent.campo(rowData, col.field),
          tamanho: 14,
        );

      case TypeColunm.status:
        // Fiel ao original: `campo === null` decide "Ativo" (não é um booleano de negócio —
        // tipicamente aponta para uma coluna como `dthrexclusao`, onde null = não excluído).
        return _statusBadge(
          parent.campo(rowData, col.field) == null ? 'Ativo' : 'Inativo',
        );

      case TypeColunm.statusBoolean:
        return _statusBadge(
          parent.campo(rowData, col.field) == true ? 'Ativo' : 'Inativo',
        );

      case TypeColunm.simNaoCard:
        return _statusBadge(
          parent.campo(rowData, col.field) == true ? 'Sim' : 'Não',
        );

      case TypeColunm.array:
        final lista =
            parent.campo(rowData, col.objeto ?? '') as List<dynamic>? ??
            const [];
        final texto = lista
            .map(
              (item) =>
                  col.field.isNotEmpty ? parent.campo(item, col.field) : item,
            )
            .map((valor) => '$valor, ')
            .join();
        return Text(texto);

      case TypeColunm.dataBR:
        return Text(toUtcLocal(parent.campo(rowData, col.field)?.toString()));

      case TypeColunm.dataHoraBR:
        return Text(
          toUtcLocalDateTime(parent.campo(rowData, col.field)?.toString()),
        );

      case TypeColunm.objeto:
        return Text(_resolvePropertyPath(rowData, col.objeto));

      case TypeColunm.textoConcatenado:
        final texto = col.field
            .split(';')
            .map((campo) => '${parent.campo(rowData, campo) ?? ''} ')
            .join();
        return Text(texto);

      case TypeColunm.botao:
        // Ações de linha ([TableAction<T>]) recebem T da tabela principal — colsExpansao
        // não deveria usar essa coluna (a sub-tabela de expansão tipicamente representa um
        // tipo diferente do da linha principal, ex.: saldo por unidade x produto), mas o
        // cast seguro evita uma exceção em runtime caso alguém o faça mesmo assim.
        return rowData is T
            ? _buildAcoes(context, rowData)
            : const SizedBox.shrink();
    }
  }

  Widget _statusBadge(String texto) {
    final ativo = texto == 'Ativo' || texto == 'Sim';
    return Container(
      constraints: const BoxConstraints(minWidth: 78),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ativo ? _corBadgeAtivoFundo : _corBadgeInativoFundo,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ativo ? _corBadgeAtivoTexto : _corBadgeInativoTexto,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Porte da coluna `TypeColunm.botao` — ações customizadas ([TableGrid.acoesLinha]) e,
  /// opcionalmente, a ação de reativar registros excluídos.
  Widget _buildAcoes(BuildContext context, T rowData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final acao in parent.acoesLinha)
          if (acao.podeMostrar(rowData))
            _acaoIcone(
              tooltip: acao.tooltip,
              cor: acao.color ?? _corAcaoPadrao,
              icone: acao.icon,
              onTap: () => _onAcaoLinhaClick(acao, rowData),
            ),
        if (_validarReativar(parent.mostrarReativar, rowData))
          _acaoIcone(
            tooltip: 'Ativar Registro',
            cor: _corAtivar,
            iconeDefault: IconesDefault.ativar,
            onTap: () => parent.aoReativar?.call(rowData),
          ),
      ],
    );
  }

  Widget _acaoIcone({
    required String tooltip,
    required Color cor,
    String? icone,
    IconesDefault? iconeDefault,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          child: IconeDefaultComponent(
            icone: icone,
            iconeDefault: iconeDefault,
            cor: cor,
            tamanho: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginacao(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.design.corBorda)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Página $_paginaAtual de $_totalPaginas'),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _paginaFirst > 0
                ? () => _irParaPagina(max(0, _paginaFirst - parent.totalPorPag))
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _paginaAtual < _totalPaginas
                ? () => _irParaPagina(_paginaFirst + parent.totalPorPag)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildRodapeChkExcluidos(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Switch(
            value: _chkExcluidosSelecionado,
            onChanged: _chkExcluidosChanged,
          ),
          const SizedBox(width: 8),
          Text(parent.rotuloChkExcluidos),
        ],
      ),
    );
  }
}
