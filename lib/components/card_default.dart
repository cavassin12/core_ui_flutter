import 'package:core_ui_flutter/code_design_system_theme.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:flutter/material.dart';

/// Componente único de card do design system, com o mesmo comportamento do
/// componente `Card` do Bootstrap: cabeçalho, corpo (título/subtítulo/
/// texto/links ou conteúdo customizado), rodapé, imagem no topo/rodapé,
/// imagem de fundo com conteúdo sobreposto (`card-img-overlay`), lista
/// interna (`list-group` dentro do card), layout horizontal e cores/bordas
/// customizáveis.
///
/// Uso básico:
/// ```dart
/// CardDefault(
///   imagemTopo: Image.network('https://...', height: 160, fit: BoxFit.cover),
///   titulo: 'Título do card',
///   subtitulo: 'Subtítulo',
///   texto: 'Um texto de exemplo dentro do card.',
///   links: [
///     TextButton(onPressed: () {}, child: const Text('Ação 1')),
///     TextButton(onPressed: () {}, child: const Text('Ação 2')),
///   ],
/// )
/// ```
class CardDefault extends PlatformWidget {
  /// Imagem exibida no topo do card, ocupando toda a largura (equivalente a
  /// `card-img-top`). Em [horizontal], é exibida na lateral esquerda.
  final Widget? imagemTopo;

  /// Imagem exibida na base do card, ocupando toda a largura (equivalente a
  /// `card-img-bottom`). Ignorada quando [horizontal] é `true`.
  final Widget? imagemRodape;

  /// Quando informada, o card entra no modo `card-img-overlay`: a imagem
  /// preenche todo o card e o corpo ([corpo] ou título/subtítulo/texto/
  /// links) é exibido sobreposto a ela. Os demais parâmetros de estrutura
  /// ([cabecalho], [rodape], [itensLista], [horizontal]) são ignorados
  /// nesse modo.
  final Widget? imagemFundo;

  /// Largura da imagem lateral quando [horizontal] é `true`.
  final double larguraImagemLateral;

  /// Widget exibido em uma faixa no topo do card, acima do corpo
  /// (equivalente a `card-header`).
  final Widget? cabecalho;

  /// Widget exibido em uma faixa na base do card, abaixo do corpo
  /// (equivalente a `card-footer`).
  final Widget? rodape;

  /// Substitui totalmente o corpo padrão (título/subtítulo/texto/links) por
  /// um widget customizado (equivalente a colocar qualquer conteúdo dentro
  /// de `card-body`).
  final Widget? corpo;

  /// Título exibido no corpo (equivalente a `card-title`). Ignorado quando
  /// [corpo] é informado.
  final String? titulo;

  /// Subtítulo exibido logo abaixo do título, em tom mais claro
  /// (equivalente a `card-subtitle`). Ignorado quando [corpo] é informado.
  final String? subtitulo;

  /// Texto principal do corpo (equivalente a `card-text`). Ignorado quando
  /// [corpo] é informado.
  final String? texto;

  /// Links/ações exibidos ao final do corpo, lado a lado (equivalente a
  /// `card-link`). Ignorados quando [corpo] é informado.
  final List<Widget>? links;

  /// Itens exibidos como uma lista dentro do card, separados por divisores
  /// (equivalente a um `list-group` dentro de `card`). Exibidos abaixo do
  /// corpo, se houver.
  final List<Widget>? itensLista;

  /// Exibe [imagemTopo] na lateral esquerda em vez de no topo, com o
  /// restante do conteúdo à direita (equivalente ao card horizontal do
  /// Bootstrap, feito com `row`/`col` internos).
  final bool horizontal;

  /// Largura fixa do card. Por padrão, ocupa toda a largura disponível do
  /// widget pai (igual ao Bootstrap, onde `.card` é `width: 100%` por
  /// padrão).
  final double? largura;

  /// Altura fixa do card.
  final double? altura;

  /// Espaçamento interno do corpo do card.
  final EdgeInsetsGeometry espacamentoCorpo;

  /// Cor de fundo do card. Usa `context.design.corFundo` quando omitida.
  final Color? corFundo;

  /// Cor do texto padrão de todo o conteúdo do card (título, subtítulo,
  /// texto, cabeçalho, rodapé, itens de lista) — propagada via
  /// `DefaultTextStyle`, como o utilitário `text-white` do Bootstrap.
  final Color? corTexto;

  /// Cor da borda do card e dos divisores internos (cabeçalho/rodapé/lista).
  /// Usa `context.design.corBorda` quando omitida.
  final Color? corBorda;

  /// Espessura da borda do card. `0` remove a borda.
  final double larguraBorda;

  /// Raio das bordas do card. Usa `context.design.raioBorda` quando
  /// omitido.
  final double? raioBorda;

  /// Elevação/sombra do card (o Bootstrap não aplica sombra por padrão,
  /// mas costuma-se adicionar `shadow-sm`/`shadow` conforme a necessidade).
  final double elevacao;

  /// Torna o card inteiro tocável, com efeito visual de toque.
  final VoidCallback? aoTocar;

  const CardDefault({
    super.key,
    this.imagemTopo,
    this.imagemRodape,
    this.imagemFundo,
    this.larguraImagemLateral = 140.0,
    this.cabecalho,
    this.rodape,
    this.corpo,
    this.titulo,
    this.subtitulo,
    this.texto,
    this.links,
    this.itensLista,
    this.horizontal = false,
    this.largura,
    this.altura,
    this.espacamentoCorpo = const EdgeInsets.all(16),
    this.corFundo,
    this.corTexto,
    this.corBorda,
    this.larguraBorda = 1.0,
    this.raioBorda,
    this.elevacao = 0.0,
    this.aoTocar,
  });

  bool get _temCorpoPadrao =>
      titulo != null ||
      subtitulo != null ||
      texto != null ||
      (links != null && links!.isNotEmpty);

  Widget _buildCorpoPadrao(BuildContext context) {
    final temLinks = links != null && links!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              titulo!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        if (subtitulo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              subtitulo!,
              style: TextStyle(
                fontSize: 15,
                color: (corTexto ?? Colors.black87).withValues(alpha: 0.6),
              ),
            ),
          ),
        if (texto != null)
          Padding(
            padding: EdgeInsets.only(bottom: temLinks ? 8 : 0),
            child: Text(texto!),
          ),
        if (temLinks) Wrap(spacing: 16, runSpacing: 4, children: links!),
      ],
    );
  }

  Widget _buildFaixa(
    Widget conteudo,
    Color corFundoBase,
    Color corBordaResolvida, {
    required bool eCabecalho,
  }) {
    final corFundoFaixa = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.03),
      corFundoBase,
    );
    final bordaLarga = larguraBorda > 0 ? larguraBorda : 1.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: corFundoFaixa,
        border: Border(
          bottom: eCabecalho
              ? BorderSide(color: corBordaResolvida, width: bordaLarga)
              : BorderSide.none,
          top: !eCabecalho
              ? BorderSide(color: corBordaResolvida, width: bordaLarga)
              : BorderSide.none,
        ),
      ),
      child: conteudo,
    );
  }

  Widget _buildLista(Color corBordaResolvida) {
    final itens = itensLista!;
    final children = <Widget>[];
    for (var i = 0; i < itens.length; i++) {
      if (i > 0) {
        children.add(
          Divider(height: 1, thickness: 1, color: corBordaResolvida),
        );
      }
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: itens[i],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        imagemFundo!,
        Positioned.fill(
          child: Container(
            padding: espacamentoCorpo,
            alignment: Alignment.bottomLeft,
            child: corpo ?? _buildCorpoPadrao(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEstruturaPadrao(
    BuildContext context,
    Color corFundoResolvida,
    Color corBordaResolvida,
  ) {
    final temCorpo = corpo != null || _temCorpoPadrao;
    final temLista = itensLista != null && itensLista!.isNotEmpty;

    final blocoCorpo = temCorpo
        ? Padding(
            padding: espacamentoCorpo,
            child: corpo ?? _buildCorpoPadrao(context),
          )
        : null;
    final blocoLista = temLista ? _buildLista(corBordaResolvida) : null;
    final blocoCabecalho = cabecalho != null
        ? _buildFaixa(
            cabecalho!,
            corFundoResolvida,
            corBordaResolvida,
            eCabecalho: true,
          )
        : null;
    final blocoRodape = rodape != null
        ? _buildFaixa(
            rodape!,
            corFundoResolvida,
            corBordaResolvida,
            eCabecalho: false,
          )
        : null;

    if (horizontal && imagemTopo != null) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: larguraImagemLateral, child: imagemTopo!),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ?blocoCabecalho,
                  ?blocoCorpo,
                  ?blocoLista,
                  ?blocoRodape,
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?imagemTopo,
        ?blocoCabecalho,
        ?blocoCorpo,
        ?blocoLista,
        ?blocoRodape,
        ?imagemRodape,
      ],
    );
  }

  Widget _build(BuildContext context) {
    final design = context.design;
    final corFundoResolvida = corFundo ?? design.corFundo;
    final corBordaResolvida = corBorda ?? design.corBorda;
    final raio = raioBorda ?? design.raioBorda;

    final conteudo = imagemFundo != null
        ? _buildOverlay(context)
        : _buildEstruturaPadrao(context, corFundoResolvida, corBordaResolvida);

    Widget card = Material(
      color: corFundoResolvida,
      elevation: elevacao,
      borderRadius: BorderRadius.circular(raio),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: larguraBorda > 0
            ? BoxDecoration(
                border: Border.all(
                  color: corBordaResolvida,
                  width: larguraBorda,
                ),
                borderRadius: BorderRadius.circular(raio),
              )
            : null,
        child: aoTocar != null
            ? InkWell(onTap: aoTocar, child: conteudo)
            : conteudo,
      ),
    );

    card = DefaultTextStyle.merge(
      style: TextStyle(color: corTexto),
      child: card,
    );

    if (largura != null || altura != null) {
      card = SizedBox(width: largura, height: altura, child: card);
    }

    return card;
  }

  // Um card não tem uma variação visual nativa relevante entre plataformas —
  // a mesma implementação é usada em todas.
  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}
