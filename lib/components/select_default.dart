import 'package:core_ui_flutter/components/button_default.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:core_ui_flutter/types/icones_default.dart';
import 'package:core_ui_flutter/types/tipo_botao.dart';
import 'package:flutter/material.dart';

class SelectDefault extends PlatformWidget {
  final List<dynamic> options;
  final String optionLabel;
  final String optionValue;
  final String placeholder;
  final bool filter;
  final bool showClear;
  final bool editable;
  final bool required;
  final bool disabled;
  final bool readonly;
  final String? rotaCadastroAuxiliar;
  final bool permitirCadastroAuxiliar;
  final String textoCadastroAuxiliar;
  final Map<String, String>? errorMessages;

  final dynamic value;
  final dynamic itemCadastrado;

  final ValueChanged<dynamic>? onChanged;
  final VoidCallback? onCadastroAuxiliarSolicitado;
  final FormFieldValidator<dynamic>? validator;
  final String? errorText;

  const SelectDefault({
    super.key,
    this.options = const [],
    this.optionLabel = 'label',
    this.optionValue = 'value',
    this.placeholder = 'Selecione...',
    this.filter = true,
    this.showClear = true,
    this.editable = false,
    this.required = true,
    this.disabled = false,
    this.readonly = false,
    this.rotaCadastroAuxiliar,
    this.permitirCadastroAuxiliar = false,
    this.textoCadastroAuxiliar = 'Novo',
    this.errorMessages,
    this.value,
    this.itemCadastrado,
    this.onChanged,
    this.onCadastroAuxiliarSolicitado,
    this.validator,
    this.errorText,
  });

  /// Extrai a propriedade referente ao 'value' do item (suporta Maps ou Objeto direto)
  static dynamic obterValor(dynamic item, String optionValue) {
    if (item == null) return null;
    if (item is Map) return item[optionValue];
    try {
      return (item as dynamic)[optionValue];
    } catch (_) {
      return item;
    }
  }

  /// Extrai a propriedade referente ao 'label' do item (suporta Maps ou Objeto direto)
  static String obterRotulo(dynamic item, String optionLabel) {
    if (item == null) return '';
    if (item is Map) return item[optionLabel]?.toString() ?? '';
    try {
      final val = (item as dynamic)[optionLabel];
      if (val != null) return val.toString();
    } catch (_) {}
    return item.toString();
  }

  /// Resolve as mensagens de erro seguindo a prioridade do TypeScript
  String? resolveErrorMessage(Map<String, dynamic>? errors) {
    if (errorText != null) return errorText;
    if (errors == null || errors.isEmpty) return null;

    final firstErrorKey = errors.keys.first;

    if (errorMessages != null && errorMessages!.containsKey(firstErrorKey)) {
      return errorMessages![firstErrorKey];
    }

    if (errors[firstErrorKey] is String) {
      return errors[firstErrorKey] as String;
    }

    if (required) {
      return 'Este campo é obrigatório.';
    }

    return 'Campo inválido.';
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return _SelectDefaultBase(parent: this, platform: TargetPlatform.android);
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return _SelectDefaultBase(parent: this, platform: TargetPlatform.iOS);
  }

  @override
  Widget createWebWidget(BuildContext context) {
    return _SelectDefaultBase(parent: this, platform: TargetPlatform.fuchsia);
  }

  @override
  Widget createWindowsWidget(BuildContext context) {
    return _SelectDefaultBase(parent: this, platform: TargetPlatform.windows);
  }
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _SelectDefaultBase extends StatefulWidget {
  final SelectDefault parent;
  final TargetPlatform platform;

  const _SelectDefaultBase({required this.parent, required this.platform});

  @override
  State<_SelectDefaultBase> createState() => _SelectDefaultBaseState();
}

class _SelectDefaultBaseState extends State<_SelectDefaultBase> {
  dynamic _selectedValue;
  late List<dynamic> _localOptions;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.parent.value;
    _localOptions = List.from(widget.parent.options);

    if (widget.parent.itemCadastrado != null) {
      _selecionarItemCadastrado(widget.parent.itemCadastrado);
    }
  }

  @override
  void didUpdateWidget(covariant _SelectDefaultBase oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.parent.value != oldWidget.parent.value) {
      setState(() {
        _selectedValue = widget.parent.value;
      });
    }

    if (widget.parent.options != oldWidget.parent.options) {
      setState(() {
        _localOptions = List.from(widget.parent.options);
      });
    }

    if (widget.parent.itemCadastrado != oldWidget.parent.itemCadastrado &&
        widget.parent.itemCadastrado != null) {
      _selecionarItemCadastrado(widget.parent.itemCadastrado);
    }
  }

  void _selecionarItemCadastrado(dynamic item) {
    _incluirOpcaoSeNecessario(item);
    final valor = SelectDefault.obterValor(item, widget.parent.optionValue);
    _onModelChange(valor);
  }

  void _incluirOpcaoSeNecessario(dynamic item) {
    final valorItem = SelectDefault.obterValor(item, widget.parent.optionValue);
    final jaExiste = _localOptions.any(
      (opcao) =>
          SelectDefault.obterValor(opcao, widget.parent.optionValue) ==
          valorItem,
    );

    if (!jaExiste) {
      setState(() {
        _localOptions.add(item);
      });
    }
  }

  void _onModelChange(dynamic value) {
    setState(() {
      _selectedValue = value;
    });
    widget.parent.onChanged?.call(value);
  }

  void _solicitarCadastroAuxiliar() {
    if (!widget.parent.disabled && !widget.parent.readonly) {
      widget.parent.onCadastroAuxiliarSolicitado?.call();
    }
  }

  /// Validador interno equivalente ao NgControl do Angular
  String? _internalValidator(dynamic value) {
    final Map<String, dynamic> errors = {};

    if (widget.parent.required && (value == null || value.toString().isEmpty)) {
      errors['required'] = true;
    }

    if (errors.isNotEmpty) {
      return widget.parent.resolveErrorMessage(errors);
    }

    if (widget.parent.validator != null) {
      return widget.parent.validator!(value);
    }

    return null;
  }

  /// Modal / BottomSheet de busca para quando filter == true
  Future<void> _abrirModalSelecaoComFiltro(BuildContext context) async {
    final tema = Theme.of(context);
    String query = '';

    final selecionado = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final opcoesFiltradas = _localOptions.where((opcao) {
              final rotulo = SelectDefault.obterRotulo(
                opcao,
                widget.parent.optionLabel,
              );
              return rotulo.toLowerCase().contains(query.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Barra de cabeçalho com filtro de busca
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Buscar...',
                            prefixIcon: const Icon(
                              LucideIcons.search,
                              size: 18,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (val) {
                            setModalState(() {
                              query = val;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Lista de opções filtradas
                  Expanded(
                    child: opcoesFiltradas.isEmpty
                        ? const Center(child: Text('Nenhuma opção encontrada.'))
                        : ListView.builder(
                            itemCount: opcoesFiltradas.length,
                            itemBuilder: (context, index) {
                              final item = opcoesFiltradas[index];
                              final valor = SelectDefault.obterValor(
                                item,
                                widget.parent.optionValue,
                              );
                              final rotulo = SelectDefault.obterRotulo(
                                item,
                                widget.parent.optionLabel,
                              );
                              final isSelected = valor == _selectedValue;

                              return ListTile(
                                title: Text(rotulo),
                                selected: isSelected,
                                selectedTileColor: tema.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                trailing: isSelected
                                    ? Icon(
                                        LucideIcons.check,
                                        color: tema.colorScheme.primary,
                                      )
                                    : null,
                                onTap: () => Navigator.of(context).pop(valor),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selecionado != null || (selecionado == null && query.isEmpty)) {
      if (selecionado != null) {
        _onModelChange(selecionado);
      }
    }
  }

  Widget _buildLabelWidget(BuildContext context) {
    if (widget.parent.placeholder.isEmpty) return const SizedBox.shrink();

    return Text.rich(
      TextSpan(
        text: widget.parent.placeholder,
        style: TextStyle(
          fontSize: 14,
          color: widget.parent.disabled
              ? Theme.of(context).disabledColor
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
        children: [
          if (widget.parent.required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = widget.platform == TargetPlatform.iOS;

    final bool estaDesabilitado =
        widget.parent.disabled || widget.parent.readonly;

    // Ações auxiliares do campo (Botão Limpar X e Seta Dropdown)
    List<Widget> suffixActions = [];

    if (widget.parent.showClear &&
        _selectedValue != null &&
        !estaDesabilitado) {
      suffixActions.add(
        GestureDetector(
          onTap: () => _onModelChange(null),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(LucideIcons.x, size: 16),
          ),
        ),
      );
    }

    suffixActions.add(
      const Padding(
        padding: EdgeInsets.only(left: 4.0, right: 8.0),
        child: Icon(LucideIcons.chevronDown, size: 18),
      ),
    );

    // Renderização do Campo Select Principal
    Widget selectField = FormField<dynamic>(
      initialValue: _selectedValue,
      validator: _internalValidator,
      builder: (FormFieldState<dynamic> state) {
        final rotuloSelecionado = _localOptions
            .where(
              (opt) =>
                  SelectDefault.obterValor(opt, widget.parent.optionValue) ==
                  _selectedValue,
            )
            .map(
              (opt) =>
                  SelectDefault.obterRotulo(opt, widget.parent.optionLabel),
            )
            .firstWhere((_) => true, orElse: () => '');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: estaDesabilitado
                  ? null
                  : () {
                      if (widget.parent.filter) {
                        _abrirModalSelecaoComFiltro(context);
                      } else {
                        // Exibe Menu Dropdown Padrão
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final offset = renderBox.localToGlobal(Offset.zero);

                        showMenu<dynamic>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            offset.dx,
                            offset.dy + renderBox.size.height,
                            offset.dx + renderBox.size.width,
                            0,
                          ),
                          items: _localOptions.map((item) {
                            final val = SelectDefault.obterValor(
                              item,
                              widget.parent.optionValue,
                            );
                            final lab = SelectDefault.obterRotulo(
                              item,
                              widget.parent.optionLabel,
                            );
                            return PopupMenuItem<dynamic>(
                              value: val,
                              child: Text(lab),
                            );
                          }).toList(),
                        ).then((novoValor) {
                          if (novoValor != null) {
                            _onModelChange(novoValor);
                            state.didChange(novoValor);
                          }
                        });
                      }
                    },
              child: InputDecorator(
                decoration: InputDecoration(
                  label: _buildLabelWidget(context),
                  filled: estaDesabilitado,
                  fillColor: widget.parent.disabled
                      ? theme.disabledColor.withValues(alpha: 0.08)
                      : (widget.parent.readonly
                            ? theme.colorScheme.surfaceContainerHighest
                            : null),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
                    borderSide: BorderSide(
                      color: state.hasError
                          ? theme.colorScheme.error
                          : theme.dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.8,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rotuloSelecionado,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: suffixActions,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );

    // Integração do Botão de Cadastro Auxiliar (Side-by-Side em Row)
    Widget? botaoAuxiliarWidget;

    if (widget.parent.permitirCadastroAuxiliar) {
      botaoAuxiliarWidget = SizedBox(
        height: 37,
        child: ButtonDefault(
          tipo: TipoBotao.defaultType,
          iconeDefault: IconesDefault.plus,
          texto: widget.parent.textoCadastroAuxiliar,
          disabled: estaDesabilitado,
          altura: 37,
          acaoExecutar: _solicitarCadastroAuxiliar,
        ),
      );
    } else if (widget.parent.rotaCadastroAuxiliar != null) {
      botaoAuxiliarWidget = SizedBox(
        height: 37,
        child: ButtonDefault(
          tipo: TipoBotao.defaultType,
          iconeDefault: IconesDefault.plus,
          altura: 37,
          acaoExecutar: _solicitarCadastroAuxiliar,
        ),
      );
    }

    return Opacity(
      opacity: widget.parent.disabled ? 0.6 : 1.0,
      child: IgnorePointer(
        ignoring: widget.parent.disabled,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: selectField),
            if (botaoAuxiliarWidget != null) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: botaoAuxiliarWidget,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
