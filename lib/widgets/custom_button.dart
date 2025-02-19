import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutlined = false,
    this.width = double.maxFinite,
    this.height = 48,
    this.fontSize = 14,
    this.oulinedColor = false,
  });

  final String text;
  final Function() onTap;
  final bool isOutlined;
  final double? width;
  final double height;
  final double fontSize;
  final bool oulinedColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width ?? (kIsWeb ? 320 : double.maxFinite),
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isOutlined ? null : Theme.of(context).primaryColor,
            border: isOutlined
                ? Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColor
                        : oulinedColor
                            ? Theme.of(context).primaryColor
                            : Color(0xFFFFFFFF).withOpacity(0.16))
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isOutlined
                      ? Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : oulinedColor
                              ? Theme.of(context).primaryColor
                              : Colors.white
                      : Colors.white,
                  fontSize: fontSize,
                  height: 1.4,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
