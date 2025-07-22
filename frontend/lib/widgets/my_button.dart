import 'package:facebook_clone/utils/loadingstatemixin.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    this.label,
    required this.onPressed,
    this.type = 1,
    this.radius = 25,
    this.height = 45,
    this.fontSize = 16,
    this.isBold = false,
    this.color,
    this.width = double.infinity,
    this.icon,
    this.fontColor,
  });
  final String? label;
  final int type;
  final Function() onPressed;
  final double radius, height, fontSize, width;
  final bool isBold;
  final Color? color, fontColor;
  final Widget? icon;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with LoadingStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      children: [
        InkWell(
          onTap: () {
            withLoading(widget.onPressed);
          },
          radius: widget.radius,
          borderRadius: BorderRadius.circular(widget.radius),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color:
                    widget.color ??
                    (widget.type == 1
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.primary),
              ),
              color:
                  widget.color ??
                  (widget.type == 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                if (widget.icon != null) widget.icon!,
                if (widget.label != null)
                  Text(
                    widget.label ?? '',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color:
                          widget.fontColor ??
                          (widget.type == 1
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.primary),
                      fontWeight:
                          widget.isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder:
              (context, value, child) =>
                  value
                      ? Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(widget.radius),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: widget.height * 0.5,
                              height: widget.height * 0.5,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
