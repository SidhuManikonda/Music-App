import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myportifolio/app_constants.dart';


class CustomFieldWidget extends StatelessWidget {
  const CustomFieldWidget(
      {super.key,
      required this.fieldTitle,
      this.padding,
      this.child = const SizedBox(),
      this.width,
      this.height,
      this.required = false,
      this.showBorder = false,
      this.renderingOnPopup = false,
      this.color});

  final String fieldTitle;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final double? width;
  final double? height;
  final bool required, showBorder, renderingOnPopup;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fieldTitle.isNotEmpty)
            RichText(
              text: TextSpan(
                  text: fieldTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.4,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF121212)
                          : Colors.white),
                  children: [
                    if (required)
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.redAccent)),
                  ]),
            ),
          if (fieldTitle.isNotEmpty) SizedBox(height: 8),
          SizedBox(
            height: height ?? 48,
            width: width ?? (kIsWeb ? 320 : double.maxFinite),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: showBorder
                      ? Border.all(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white)
                      : null,
                  color: showBorder
                      ? null
                      : color ??
                          (Theme.of(context).brightness == Brightness.light
                              ? AppConstants.lightCardBgColor
                              : renderingOnPopup
                                  ? AppConstants.darkBackgroundColor
                                  : AppConstants.darkCardBgColor),
                  borderRadius: BorderRadius.circular(8)),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
