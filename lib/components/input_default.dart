import 'package:core_ui_flutter/components/icone_default_component.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InputDefault extends PlatformWidget {
  final String label;
  final String type; // 'text' | 'password' | 'number' | 'email' | 'date' | etc.
  final String placeholder;
  final bool required;
  final bool readonly;
  final bool disabled;
  final String? mask;
  final String slotChar;
  final dynamic icon; // Aceita IconData, IconesDefault, IconesLucide ou String
  final Map<String, String>? errorMessages;
  final int? maxlength;
  final int? minlength;
  final double? min;
  final double? max;
  final double? step;
  final String autocomplete;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<dynamic>? onChanged;
  final VoidCallback? onBlur;
  final FormFieldValidator<String>? validator;
  final String? errorText;

  const InputDefault({
    super.key,
    this.label = '',
    this.type = 'text',
    this.placeholder = '',
    this.required = true,
    this.readonly = false,
    this.disabled = false,
    this.mask,
    this.slotChar = '_',
    this.icon,
    this.errorMessages,
    this.maxlength,
    this.minlength,
    this.min,
    this.max,
    this.step,
    this.autocomplete = 'off',
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onBlur,
    this.validator,
    this.errorText,
  });

  // Mensagens de erro padrão (Fidelidade ao Angular)
  static const Map<String, String> defaultErrorMessages = {
    'required': 'Este campo é obrigatório.',
    'email': 'E-mail inválido.',
    'minlength': 'O valor é muito curto.',
    'maxlength': 'O valor é muito longo.',
    'min': 'O valor é menor que o mínimo permitido.',
    'max': 'O valor é maior que o máximo permitido.',
    'nameValidationError': '* O nome contém caracteres inválidos.',
  };

  /// Normaliza valores numéricos (aceita ',' ou '.') conforme método do TS
  static dynamic normalizeNumber(dynamic value) {
    if (value == null || value == '') return null;
    if (value is num) return value.toDouble();

    final parsed = double.tryParse(value.toString().replaceAll(',', '.'));
    return parsed;
  }

  /// Resolve a mensagem de erro seguindo a prioridade exata do TypeScript
  String? resolveErrorMessage(Map<String, dynamic>? errors) {
    if (errorText != null) return errorText;
    if (errors == null || errors.isEmpty) return null;

    final firstErrorKey = errors.keys.first;

    // 1. Mensagem customizada enviada via parâmetro errorMessages
    if (errorMessages != null && errorMessages!.containsKey(firstErrorKey)) {
      return errorMessages![firstErrorKey];
    }

    // 2. Se o valor do erro no validator for uma string direta
    if (errors[firstErrorKey] is String) {
      return errors[firstErrorKey] as String;
    }

    // 3. Dicionário de erros padrão
    if (defaultErrorMessages.containsKey(firstErrorKey)) {
      return defaultErrorMessages[firstErrorKey];
    }

    // 4. Fallback padrão
    return 'Campo inválido.';
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return _InputDefaultBase(parent: this, platform: TargetPlatform.android);
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return _InputDefaultBase(parent: this, platform: TargetPlatform.iOS);
  }

  @override
  Widget createWebWidget(BuildContext context) {
    return _InputDefaultBase(
      parent: this,
      platform: TargetPlatform.fuchsia, // Usado para Web/Desktop Style
    );
  }

  @override
  Widget createWindowsWidget(BuildContext context) {
    return _InputDefaultBase(parent: this, platform: TargetPlatform.windows);
  }
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _InputDefaultBase extends StatefulWidget {
  final InputDefault parent;
  final TargetPlatform platform;

  const _InputDefaultBase({required this.parent, required this.platform});

  @override
  State<_InputDefaultBase> createState() => _InputDefaultBaseState();
}

class _InputDefaultBaseState extends State<_InputDefaultBase> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.parent.type == 'password';

    if (widget.parent.controller != null) {
      _controller = widget.parent.controller!;
    } else {
      _controller = TextEditingController(text: widget.parent.initialValue);
      _isInternalController = true;
    }

    _focusNode = widget.parent.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.parent.focusNode == null) {
      _focusNode.dispose();
    }
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.parent.onBlur?.call();
    }
  }

  void _handleChanged(String rawValue) {
    dynamic finalValue = rawValue;
    if (widget.parent.type == 'number') {
      finalValue = InputDefault.normalizeNumber(rawValue);
    }
    widget.parent.onChanged?.call(finalValue);
  }

  TextInputType _resolveKeyboardType() {
    switch (widget.parent.type) {
      case 'number':
        return const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
      case 'email':
        return TextInputType.emailAddress;
      case 'date':
      case 'datetime-local':
      case 'time':
        return TextInputType.datetime;
      case 'password':
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _resolveFormatters() {
    final formatters = <TextInputFormatter>[];

    if (widget.parent.maxlength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.parent.maxlength));
    }

    if (widget.parent.type == 'number') {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]')));
    }

    if (widget.parent.mask != null && widget.parent.mask!.isNotEmpty) {
      formatters.add(
        _SimpleMaskFormatter(
          mask: widget.parent.mask!,
          slotChar: widget.parent.slotChar,
        ),
      );
    }

    return formatters;
  }

  Iterable<String>? _resolveAutofillHints() {
    if (widget.parent.autocomplete == 'off') return null;
    switch (widget.parent.type) {
      case 'email':
        return [AutofillHints.email];
      case 'password':
        return [AutofillHints.password];
      default:
        return null;
    }
  }

  /// Validador integrado que espelha as regras do Angular Forms
  String? _internalValidator(String? value) {
    final Map<String, dynamic> errors = {};
    final text = value ?? '';

    if (widget.parent.required && text.trim().isEmpty) {
      errors['required'] = true;
    }

    if (text.isNotEmpty && widget.parent.type == 'email') {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(text)) {
        errors['email'] = true;
      }
    }

    if (text.isNotEmpty && widget.parent.minlength != null) {
      if (text.length < widget.parent.minlength!) {
        errors['minlength'] = true;
      }
    }

    if (text.isNotEmpty && widget.parent.type == 'number') {
      final numValue = InputDefault.normalizeNumber(text);
      if (numValue != null) {
        if (widget.parent.min != null && numValue < widget.parent.min!) {
          errors['min'] = true;
        }
        if (widget.parent.max != null && numValue > widget.parent.max!) {
          errors['max'] = true;
        }
      }
    }

    if (errors.isNotEmpty) {
      return widget.parent.resolveErrorMessage(errors);
    }

    if (widget.parent.validator != null) {
      return widget.parent.validator!(value);
    }

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

    // Ícone frontal (Prefix)
    Widget? prefixIconWidget;
    if (widget.parent.icon != null) {
      prefixIconWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: IconeDefaultComponent(
          icone: widget.parent.icon,
          tamanho: 18,
          cor: theme.iconTheme.color,
        ),
      );
    }

    // Botão de alternar visibilidade de senha (Suffix)
    Widget? suffixIconWidget;
    if (widget.parent.type == 'password') {
      suffixIconWidget = IconButton(
        icon: Icon(
          _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
          size: 18,
        ),
        onPressed: widget.parent.disabled
            ? null
            : () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
      );
    }

    // Material / Desktop / Web Input Style (Simulando PrimeNG p-floatlabel "on")
    final inputDecoration = InputDecoration(
      label: widget.parent.label.isNotEmpty ? _buildLabelWidget(context) : null,
      hintText: widget.parent.placeholder.isNotEmpty
          ? widget.parent.placeholder
          : null,
      prefixIcon: prefixIconWidget,
      suffixIcon: suffixIconWidget,
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
          obscureText: _obscureText,
          keyboardType: _resolveKeyboardType(),
          inputFormatters: _resolveFormatters(),
          autofillHints: _resolveAutofillHints(),
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

class _SimpleMaskFormatter extends TextInputFormatter {
  final String mask;
  final String slotChar;

  _SimpleMaskFormatter({required this.mask, required this.slotChar});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    if (newValue.text.length < oldValue.text.length) return newValue;

    final unmaskedText = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    int textIndex = 0;

    for (int i = 0; i < mask.length; i++) {
      if (textIndex >= unmaskedText.length) break;

      final maskChar = mask[i];
      if (maskChar == '9' || maskChar == '0' || maskChar == '#') {
        buffer.write(unmaskedText[textIndex]);
        textIndex++;
      } else {
        buffer.write(maskChar);
      }
    }

    final result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
