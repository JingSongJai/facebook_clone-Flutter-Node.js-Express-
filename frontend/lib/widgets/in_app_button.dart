import 'package:flutter/material.dart';

class InAppButton extends StatefulWidget {
  const InAppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = 1,
    this.radius = 25,
    this.height = 45,
    this.fontSize = 16,
    this.isBold = false,
    this.color,
    this.width = double.infinity,
  });
  final String label;
  final int type;
  final Function() onPressed;
  final double radius, height, fontSize, width;
  final bool isBold;
  final Color? color;

  @override
  State<InAppButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<InAppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(widget.width, widget.height),
        elevation: 0,
        backgroundColor:
            widget.color ??
            (widget.type == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          side: BorderSide(
            color:
                widget.color ??
                (widget.type == 1
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: widget.fontSize,
          color:
              widget.type == 1
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
