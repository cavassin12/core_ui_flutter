import 'package:flutter/material.dart';

import '../core/platform_widget.dart';

class CheckboxDefault extends PlatformWidget {
  const CheckboxDefault({
    super.key,
    this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.disabledColor,
    this.border,
    this.borderColor,
    this.size,
    this.animationDuration,
    this.isRound = true,
    required this.onTap,
  });

  ///Define wether the checkbox is marked or not
  final bool? isChecked;

  ///Define the widget that is shown when Widgets is checked
  final Widget? checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget? uncheckedWidget;

  ///Define the color that is shown when Widgets is checked
  final Color? checkedColor;

  ///Define the color that is shown when Widgets is unchecked
  final Color? uncheckedColor;

  ///Define the color that is shown when Widgets is disabled
  final Color? disabledColor;

  ///Define the border of the widget
  final Border? border;

  ///Define the border color  of the widget
  final Color? borderColor;

  ///Define the size of the checkbox
  final double? size;

  ///Define Function that os executed when user tap on checkbox
  ///If onTap is given a null callack, it will be disabled
  final Function(bool?)? onTap;

  ///Define the duration of the animation. If any
  final Duration? animationDuration;

  final bool isRound;

  // Um checkbox não tem uma variação visual nativa relevante entre
  // plataformas — a mesma implementação é usada em todas.
  @override
  Widget createAndroidWidget(BuildContext context) =>
      _CheckboxDefaultBase(parent: this);

  @override
  Widget createIosWidget(BuildContext context) =>
      _CheckboxDefaultBase(parent: this);
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _CheckboxDefaultBase extends StatefulWidget {
  final CheckboxDefault parent;

  const _CheckboxDefaultBase({required this.parent});

  @override
  State<_CheckboxDefaultBase> createState() => _CheckboxDefaultBaseState();
}

class _CheckboxDefaultBaseState extends State<_CheckboxDefaultBase> {
  bool? isChecked;
  late Duration animationDuration;
  double? size;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  Color? checkedColor;
  Color? uncheckedColor;
  Color? disabledColor;
  late Color borderColor;

  @override
  void initState() {
    isChecked = widget.parent.isChecked ?? false;
    animationDuration =
        widget.parent.animationDuration ?? Duration(milliseconds: 500);
    size = widget.parent.size ?? 40.0;
    checkedColor = widget.parent.checkedColor ?? Colors.green;
    uncheckedColor = widget.parent.uncheckedColor;
    borderColor = widget.parent.borderColor ?? Colors.grey;
    checkedWidget =
        widget.parent.checkedWidget ?? Icon(Icons.check, color: Colors.white);
    uncheckedWidget = widget.parent.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  void didUpdateWidget(_CheckboxDefaultBase oldWidget) {
    uncheckedColor =
        widget.parent.uncheckedColor ??
        Theme.of(context).scaffoldBackgroundColor;
    if (isChecked != widget.parent.isChecked) {
      isChecked = widget.parent.isChecked ?? false;
    }
    if (animationDuration != widget.parent.animationDuration) {
      animationDuration =
          widget.parent.animationDuration ?? Duration(milliseconds: 500);
    }
    if (size != widget.parent.size) {
      size = widget.parent.size ?? 40.0;
    }
    if (checkedColor != widget.parent.checkedColor) {
      checkedColor = widget.parent.checkedColor ?? Colors.green;
    }
    if (borderColor != widget.parent.borderColor) {
      borderColor = widget.parent.borderColor ?? Colors.grey;
    }
    if (checkedWidget != widget.parent.checkedWidget) {
      checkedWidget =
          widget.parent.checkedWidget ?? Icon(Icons.check, color: Colors.white);
    }
    if (uncheckedWidget != widget.parent.uncheckedWidget) {
      uncheckedWidget =
          widget.parent.uncheckedWidget ?? const SizedBox.shrink();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.parent.onTap != null
        ? GestureDetector(
            onTap: () {
              setState(() => isChecked = !isChecked!);
              widget.parent.onTap!(isChecked);
            },
            child: ClipRRect(
              borderRadius: borderRadius,
              child: AnimatedContainer(
                duration: animationDuration,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: isChecked! ? checkedColor : uncheckedColor,
                  border:
                      widget.parent.border ?? Border.all(color: borderColor),
                  borderRadius: borderRadius,
                ),
                child: isChecked! ? checkedWidget : uncheckedWidget,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: borderRadius,
            child: AnimatedContainer(
              duration: animationDuration,
              height: size,
              width: size,
              decoration: BoxDecoration(
                color:
                    widget.parent.disabledColor ??
                    Theme.of(context).disabledColor,
                border:
                    widget.parent.border ??
                    Border.all(
                      color:
                          widget.parent.disabledColor ??
                          Theme.of(context).disabledColor,
                    ),
                borderRadius: borderRadius,
              ),
              child: isChecked! ? checkedWidget : uncheckedWidget,
            ),
          );
  }

  BorderRadius get borderRadius {
    if (widget.parent.isRound) {
      return BorderRadius.circular(size! / 2);
    } else {
      return BorderRadius.zero;
    }
  }
}
