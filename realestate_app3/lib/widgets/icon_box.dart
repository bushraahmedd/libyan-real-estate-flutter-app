import 'package:flutter/material.dart';
import 'package:realestate_app3/theme/color.dart';

class IconBox extends StatelessWidget {
  const IconBox({
    Key? key,
    required this.child,
    this.bgColor,
    this.onTap,
    this.borderColor = Colors.transparent,
    this.radius = 50,
  }) : super(key: key);

  final Widget child;
  final Color borderColor;
  final Color? bgColor;
  final double radius;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}