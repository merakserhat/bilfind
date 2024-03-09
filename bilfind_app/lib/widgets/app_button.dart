import "package:flutter/material.dart";

class AppButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final EdgeInsets customPadding;
  final double? horizontalPadding;
  final double? verticalPadding;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? textColor;
  final bool disabled;
  final bool disableResizeButton;

  final Widget? child;

  const AppButton({
    this.color,
    this.onPressed,
    required this.label,
    this.customPadding =
        const EdgeInsets.symmetric(vertical: 9, horizontal: 45),
    this.horizontalPadding,
    this.verticalPadding,
    this.fontWeight,
    this.disabled = false,
    this.disableResizeButton = false,
    this.child,
    this.textColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    var fontSize = 12.0;
    if (!widget.disableResizeButton) {
      final width = MediaQuery.of(context).size.width;
      if (width <= 480) {
        fontSize = 10.0;
      } else if (width > 480 && width <= 960) {
        fontSize = 14.0;
      } else {
        fontSize = 18.0;
      }
    }
    return InkWell(
      onTap: widget.disabled ? () {} : widget.onPressed,
      onHover: (val) {
        setState(() {
          isHover = val;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _getColor(context),
        ),
        child: Padding(
          padding: widget.customPadding,
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: widget.fontWeight ?? FontWeight.w600,
                  fontSize: fontSize,
                  color: widget.textColor ?? Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (widget.color != null) {
      if (widget.disabled) {
        return widget.color!.withOpacity(0.5);
      } else if (isHover) {
        return widget.color!.withOpacity(0.7);
      }

      return widget.color!;
    } else {
      if (widget.disabled) {
        return Theme.of(context).primaryColor.withOpacity(0.5);
      } else if (isHover) {
        return Theme.of(context).primaryColor.withOpacity(0.7);
      }
      return Theme.of(context).primaryColor;
    }
  }
}
