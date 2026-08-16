import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/platform_widget.dart';
import '../types/date_picker_modo_default.dart';
import '../types/icones_default.dart';
import 'input_default.dart';

/// Campo de seleção de data e/ou hora, que reaproveita o [InputDefault]
/// como campo de exibição (rótulo, asterisco de obrigatório, estilo visual
/// e mensagem de erro idênticos) e adiciona a abertura do seletor nativo de
/// data/hora ao tocar no campo — o [InputDefault] sozinho já previa os
/// tipos `'date'`/`'time'`/`'datetime-local'`, mas apenas ajustava o
/// teclado, sem abrir nenhum seletor.
///
/// Estende `PlatformWidget`: abre `showDatePicker`/`showTimePicker`
/// (Material) no Android/Web/Windows, e um `CupertinoDatePicker` (dentro de
/// `showCupertinoModalPopup`) no iOS/macOS — os seletores nativos de
/// data/hora têm aparência e interação bem distintas entre essas
/// plataformas, então essa é uma variação intencional.
///
/// Uso básico:
/// ```dart
/// DatePickerDefault(
///   label: 'Data de nascimento',
///   valor: dataNascimento,
///   onChanged: (novaData) => setState(() => dataNascimento = novaData),
/// )
/// ```
class DatePickerDefault extends PlatformWidget {
  /// Rótulo flutuante do campo (repassado ao [InputDefault] interno).
  final String label;

  /// Texto de exemplo exibido quando o campo está vazio.
  final String placeholder;

  /// Define se o seletor trabalha com data, hora, ou data e hora
  /// combinadas.
  final DatePickerModoDefault modo;

  /// Valor selecionado (controlado externamente).
  final DateTime? valor;

  /// Data/hora mínima permitida. `null` = sem limite inferior (o seletor
  /// nativo usa `DateTime(1900)` como padrão interno).
  final DateTime? dataMinima;

  /// Data/hora máxima permitida. `null` = sem limite superior (o seletor
  /// nativo usa `DateTime(2100)` como padrão interno).
  final DateTime? dataMaxima;

  /// Exibe `*` ao lado do rótulo e valida como obrigatório.
  final bool required;

  /// Bloqueia a abertura do seletor, com o mesmo tratamento visual de
  /// [disabled] (fundo destacado).
  final bool readonly;

  /// Desabilita totalmente o campo (opacidade reduzida, sem interação).
  final bool disabled;

  /// Sobrepõe mensagens de erro por chave (`required`, `min`, `max`).
  final Map<String, String>? errorMessages;

  /// Chamado com o novo valor selecionado.
  final ValueChanged<DateTime?>? onChanged;

  /// Validação adicional, executada somente se as validações internas
  /// (`required`/`min`/`max`) passarem.
  final FormFieldValidator<DateTime?>? validator;

  /// Força uma mensagem de erro específica, com prioridade sobre todas as
  /// outras.
  final String? errorText;

  const DatePickerDefault({
    super.key,
    this.label = '',
    this.placeholder = '',
    this.modo = DatePickerModoDefault.data,
    this.valor,
    this.dataMinima,
    this.dataMaxima,
    this.required = true,
    this.readonly = false,
    this.disabled = false,
    this.errorMessages,
    this.onChanged,
    this.validator,
    this.errorText,
  });

  /// Formata [data] conforme [modo] (`dd/MM/yyyy`, `HH:mm`, ou ambos).
  String formatar(DateTime? data) {
    if (data == null) return '';

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');

    switch (modo) {
      case DatePickerModoDefault.data:
        return '$dia/$mes/$ano';
      case DatePickerModoDefault.hora:
        return '$hora:$minuto';
      case DatePickerModoDefault.dataHora:
        return '$dia/$mes/$ano $hora:$minuto';
    }
  }

  /// Resolve a mensagem de erro seguindo a mesma prioridade do
  /// [InputDefault].
  String? resolveErrorMessage(Map<String, dynamic> errors) {
    if (errorText != null) return errorText;
    if (errors.isEmpty) return null;

    final chave = errors.keys.first;
    if (errorMessages != null && errorMessages!.containsKey(chave)) {
      return errorMessages![chave];
    }

    switch (chave) {
      case 'required':
        return 'Este campo é obrigatório.';
      case 'min':
        return 'A data é anterior ao mínimo permitido.';
      case 'max':
        return 'A data é posterior ao máximo permitido.';
      default:
        return 'Campo inválido.';
    }
  }

  @override
  Widget createAndroidWidget(BuildContext context) =>
      _DatePickerDefaultBase(parent: this, cupertino: false);

  @override
  Widget createIosWidget(BuildContext context) =>
      _DatePickerDefaultBase(parent: this, cupertino: true);
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _DatePickerDefaultBase extends StatefulWidget {
  final DatePickerDefault parent;
  final bool cupertino;

  const _DatePickerDefaultBase({required this.parent, required this.cupertino});

  @override
  State<_DatePickerDefaultBase> createState() => _DatePickerDefaultBaseState();
}

class _DatePickerDefaultBaseState extends State<_DatePickerDefaultBase> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.parent.formatar(widget.parent.valor));
  }

  @override
  void didUpdateWidget(covariant _DatePickerDefaultBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parent.valor != oldWidget.parent.valor ||
        widget.parent.modo != oldWidget.parent.modo) {
      _controller.text = widget.parent.formatar(widget.parent.valor);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _estaDesabilitado => widget.parent.disabled || widget.parent.readonly;

  String? _internalValidator(DateTime? valor) {
    final Map<String, dynamic> errors = {};

    if (widget.parent.required && valor == null) {
      errors['required'] = true;
    } else if (valor != null) {
      if (widget.parent.dataMinima != null && valor.isBefore(widget.parent.dataMinima!)) {
        errors['min'] = true;
      } else if (widget.parent.dataMaxima != null && valor.isAfter(widget.parent.dataMaxima!)) {
        errors['max'] = true;
      }
    }

    if (errors.isNotEmpty) return widget.parent.resolveErrorMessage(errors);
    if (widget.parent.validator != null) return widget.parent.validator!(valor);
    return null;
  }

  DateTime _clamp(DateTime data, DateTime minima, DateTime maxima) {
    if (data.isBefore(minima)) return minima;
    if (data.isAfter(maxima)) return maxima;
    return data;
  }

  Future<void> _abrirSeletor(FormFieldState<DateTime?> state) async {
    if (_estaDesabilitado) return;

    final novaData = widget.cupertino
        ? await _abrirSeletorCupertino()
        : await _abrirSeletorMaterial();
    if (novaData == null || !mounted) return;

    setState(() => _controller.text = widget.parent.formatar(novaData));
    widget.parent.onChanged?.call(novaData);
    state.didChange(novaData);
  }

  Future<DateTime?> _abrirSeletorMaterial() async {
    final agora = DateTime.now();
    final inicial = widget.parent.valor ?? agora;
    final minima = widget.parent.dataMinima ?? DateTime(1900);
    final maxima = widget.parent.dataMaxima ?? DateTime(2100);

    DateTime? data = inicial;

    if (widget.parent.modo != DatePickerModoDefault.hora) {
      data = await showDatePicker(
        context: context,
        initialDate: _clamp(inicial, minima, maxima),
        firstDate: minima,
        lastDate: maxima,
      );
      if (data == null) return null;
    }

    if (widget.parent.modo == DatePickerModoDefault.hora ||
        widget.parent.modo == DatePickerModoDefault.dataHora) {
      if (!mounted) return null;
      final horaSelecionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(inicial),
      );
      if (horaSelecionada == null) {
        return widget.parent.modo == DatePickerModoDefault.hora ? null : data;
      }
      data = DateTime(
        data.year,
        data.month,
        data.day,
        horaSelecionada.hour,
        horaSelecionada.minute,
      );
    }

    return data;
  }

  Future<DateTime?> _abrirSeletorCupertino() async {
    final agora = DateTime.now();
    var valorTemporario = widget.parent.valor ?? agora;
    final minima = widget.parent.dataMinima ?? DateTime(1900);
    final maxima = widget.parent.dataMaxima ?? DateTime(2100);
    valorTemporario = _clamp(valorTemporario, minima, maxima);

    final modoCupertino = switch (widget.parent.modo) {
      DatePickerModoDefault.data => CupertinoDatePickerMode.date,
      DatePickerModoDefault.hora => CupertinoDatePickerMode.time,
      DatePickerModoDefault.dataHora => CupertinoDatePickerMode.dateAndTime,
    };

    final confirmou = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: modoCupertino,
                  initialDateTime: valorTemporario,
                  minimumDate: minima,
                  maximumDate: maxima,
                  onDateTimeChanged: (novaData) => valorTemporario = novaData,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmou != true) return null;
    return valorTemporario;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      initialValue: widget.parent.valor,
      validator: _internalValidator,
      builder: (state) {
        return GestureDetector(
          onTap: _estaDesabilitado ? null : () => _abrirSeletor(state),
          child: AbsorbPointer(
            child: InputDefault(
              label: widget.parent.label,
              placeholder: widget.parent.placeholder,
              readonly: true,
              disabled: widget.parent.disabled,
              required: widget.parent.required,
              icon: widget.parent.modo == DatePickerModoDefault.hora
                  ? 'clock'
                  : IconesDefault.calendario,
              controller: _controller,
              errorText: state.errorText,
            ),
          ),
        );
      },
    );
  }
}
