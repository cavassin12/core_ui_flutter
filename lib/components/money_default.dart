import 'dart:math' as math;

import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto para valores monetários — mesma proposta do
/// [InputDefault], mas especializado em dinheiro: formata o valor digitado
/// como moeda em tempo real (estilo "máscara de caixa eletrônico", onde
/// cada dígito digitado empurra os anteriores para a esquerda), com
/// quantidade de casas decimais e separadores de milhar/decimal
/// configuráveis (já preparado para 2, 3 ou qualquer outra quantidade de
/// casas decimais).
///
/// Estende `PlatformWidget`: mesma aparência de campo em todas as
/// plataformas, com raio de borda levemente maior no iOS/macOS — mesmo
/// padrão visual do [InputDefault].
///
/// Uso básico:
/// ```dart
/// MoneyDefault(
///   label: 'Valor do produto',
///   onChanged: (valor) => print(valor), // double?
/// )
/// ```
class MoneyDefault extends PlatformWidget {
  final String label;
  final String placeholder;
  final bool required;
  final bool readonly;
  final bool disabled;

  /// Quantidade de casas decimais (ex.: `2` para reais, `3` para algumas
  /// moedas/criptomoedas). Deve ser `>= 0`.
  final int casasDecimais;

  /// Separador de milhar (agrupamento de 3 em 3 dígitos da parte inteira).
  /// Use `''` para não agrupar.
  final String separadorMilhar;

  /// Separador entre a parte inteira e a parte decimal. Ignorado quando
  /// [casasDecimais] é `0`.
  final String separadorDecimal;

  /// Texto de prefixo exibido antes do valor (ex.: `'R\$'`, `'US\$'`,
  /// `'€'`). `null`/`''` = sem prefixo.
  final String? prefixo;

  /// Valor mínimo permitido.
  final double? min;

  /// Valor máximo permitido.
  final double? max;

  final Map<String, String>? errorMessages;

  /// Valor inicial (ignorado se [controller] for informado).
  final double? initialValue;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Chamado a cada digitação, com o valor numérico já convertido
  /// (`null` quando o campo está vazio).
  final ValueChanged<double?>? onChanged;

  final VoidCallback? onBlur;

  /// Validação adicional, executada somente se `required`/`min`/`max`
  /// passarem.
  final FormFieldValidator<double?>? validator;

  final String? errorText;

  const MoneyDefault({
    super.key,
    this.label = '',
    this.placeholder = '',
    this.required = true,
    this.readonly = false,
    this.disabled = false,
    this.casasDecimais = 2,
    this.separadorMilhar = '.',
    this.separadorDecimal = ',',
    this.prefixo = 'R\$',
    this.min,
    this.max,
    this.errorMessages,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onBlur,
    this.validator,
    this.errorText,
  }) : assert(casasDecimais >= 0, 'casasDecimais deve ser >= 0');

  static const Map<String, String> defaultErrorMessages = {
    'required': 'Este campo é obrigatório.',
    'min': 'O valor é menor que o mínimo permitido.',
    'max': 'O valor é maior que o máximo permitido.',
  };

  static String _apenasDigitos(String texto) =>
      texto.replaceAll(RegExp(r'[^0-9]'), '');

  /// Converte uma string de dígitos (representando a menor unidade
  /// monetária — ex.: centavos, conforme [casasDecimais]) para o valor
  /// numérico correspondente.
  static double? digitosParaValor(String digitos, int casasDecimais) {
    if (digitos.isEmpty) return null;
    final semZerosEsquerda = digitos.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final valorMenorUnidade = int.parse(semZerosEsquerda);
    if (casasDecimais == 0) return valorMenorUnidade.toDouble();
    return valorMenorUnidade / math.pow(10, casasDecimais);
  }

  /// Formata uma string de dígitos como valor monetário, agrupando a parte
  /// inteira por [separadorMilhar] e separando a parte decimal por
  /// [separadorDecimal].
  static String formatarDigitos(
    String digitos, {
    required int casasDecimais,
    required String separadorMilhar,
    required String separadorDecimal,
  }) {
    var d = digitos.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (d.isEmpty) return '';

    if (d.length <= casasDecimais) {
      d = d.padLeft(casasDecimais + 1, '0');
    }

    final parteInteira = casasDecimais > 0
        ? d.substring(0, d.length - casasDecimais)
        : d;
    final parteDecimal = casasDecimais > 0
        ? d.substring(d.length - casasDecimais)
        : '';
    final parteInteiraAgrupada = _agruparMilhares(
      parteInteira,
      separadorMilhar,
    );

    return casasDecimais > 0
        ? '$parteInteiraAgrupada$separadorDecimal$parteDecimal'
        : parteInteiraAgrupada;
  }

  static String _agruparMilhares(String numero, String separador) {
    if (separador.isEmpty) return numero;

    final buffer = StringBuffer();
    final tamanho = numero.length;
    for (var i = 0; i < tamanho; i++) {
      if (i > 0 && (tamanho - i) % 3 == 0) buffer.write(separador);
      buffer.write(numero[i]);
    }
    return buffer.toString();
  }

  /// Formata um valor numérico (ex.: vindo do backend) para o texto exibido
  /// no campo, seguindo as mesmas regras de [casasDecimais]/separadores.
  /// Valores negativos são exibidos pelo módulo — esta versão não suporta
  /// valores monetários negativos.
  String formatarValor(double? valor) {
    if (valor == null) return '';
    final menorUnidade = (valor * math.pow(10, casasDecimais)).round().abs();
    return formatarDigitos(
      menorUnidade.toString(),
      casasDecimais: casasDecimais,
      separadorMilhar: separadorMilhar,
      separadorDecimal: separadorDecimal,
    );
  }

  /// Resolve a mensagem de erro seguindo a mesma prioridade do
  /// [InputDefault].
  String? resolveErrorMessage(Map<String, dynamic>? errors) {
    if (errorText != null) return errorText;
    if (errors == null || errors.isEmpty) return null;

    final chave = errors.keys.first;
    if (errorMessages != null && errorMessages!.containsKey(chave)) {
      return errorMessages![chave];
    }
    if (errors[chave] is String) return errors[chave] as String;
    if (defaultErrorMessages.containsKey(chave)) {
      return defaultErrorMessages[chave];
    }
    return 'Campo inválido.';
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return _MoneyDefaultBase(parent: this, platform: TargetPlatform.android);
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return _MoneyDefaultBase(parent: this, platform: TargetPlatform.iOS);
  }

  @override
  Widget createWebWidget(BuildContext context) {
    return _MoneyDefaultBase(parent: this, platform: TargetPlatform.fuchsia);
  }

  @override
  Widget createWindowsWidget(BuildContext context) {
    return _MoneyDefaultBase(parent: this, platform: TargetPlatform.windows);
  }
}

// =============================================================================
// FORMATADOR DE MÁSCARA MONETÁRIA
// =============================================================================

class _MoneyInputFormatter extends TextInputFormatter {
  final MoneyDefault parent;

  _MoneyInputFormatter(this.parent);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = MoneyDefault._apenasDigitos(newValue.text);

    final texto = MoneyDefault.formatarDigitos(
      digitos,
      casasDecimais: parent.casasDecimais,
      separadorMilhar: parent.separadorMilhar,
      separadorDecimal: parent.separadorDecimal,
    );

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _MoneyDefaultBase extends StatefulWidget {
  final MoneyDefault parent;
  final TargetPlatform platform;

  const _MoneyDefaultBase({required this.parent, required this.platform});

  @override
  State<_MoneyDefaultBase> createState() => _MoneyDefaultBaseState();
}

class _MoneyDefaultBaseState extends State<_MoneyDefaultBase> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();

    if (widget.parent.controller != null) {
      _controller = widget.parent.controller!;
    } else {
      _controller = TextEditingController(
        text: widget.parent.formatarValor(widget.parent.initialValue),
      );
      _isInternalController = true;
    }

    _focusNode = widget.parent.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.parent.focusNode == null) _focusNode.dispose();
    if (_isInternalController) _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) widget.parent.onBlur?.call();
  }

  double? get _valorAtual {
    final digitos = MoneyDefault._apenasDigitos(_controller.text);
    return MoneyDefault.digitosParaValor(digitos, widget.parent.casasDecimais);
  }

  void _handleChanged(String rawValue) {
    widget.parent.onChanged?.call(_valorAtual);
  }

  String? _internalValidator(String? value) {
    final Map<String, dynamic> errors = {};
    final valor = _valorAtual;

    if (widget.parent.required && valor == null) {
      errors['required'] = true;
    } else if (valor != null) {
      if (widget.parent.min != null && valor < widget.parent.min!) {
        errors['min'] = true;
      } else if (widget.parent.max != null && valor > widget.parent.max!) {
        errors['max'] = true;
      }
    }

    if (errors.isNotEmpty) return widget.parent.resolveErrorMessage(errors);
    if (widget.parent.validator != null) return widget.parent.validator!(valor);
    return null;
  }

  Widget _buildLabelWidget(BuildContext context) {
    if (widget.parent.label.isEmpty) return const SizedBox.shrink();

    return Text.rich(
      TextSpan(
        text: widget.parent.label,
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
    final temPrefixo =
        widget.parent.prefixo != null && widget.parent.prefixo!.isNotEmpty;

    final inputDecoration = InputDecoration(
      label: widget.parent.label.isNotEmpty ? _buildLabelWidget(context) : null,
      hintText: widget.parent.placeholder.isNotEmpty
          ? widget.parent.placeholder
          : null,
      prefixText: temPrefixo ? '${widget.parent.prefixo} ' : null,
      filled: widget.parent.disabled || widget.parent.readonly,
      fillColor: widget.parent.disabled
          ? theme.disabledColor.withValues(alpha: 0.08)
          : (widget.parent.readonly
                ? theme.colorScheme.surfaceContainerHighest
                : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIos ? 8.0 : 6.0),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
    );

    return Opacity(
      opacity: widget.parent.disabled ? 0.6 : 1.0,
      child: IgnorePointer(
        ignoring: widget.parent.disabled,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: widget.parent.readonly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_MoneyInputFormatter(widget.parent)],
          onChanged: _handleChanged,
          validator: _internalValidator,
          decoration: inputDecoration,
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
