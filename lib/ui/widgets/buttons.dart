import 'package:flutter/material.dart';

import '../shared/theme.dart';

class Button extends StatelessWidget {
  final String text;
  final double width;
  final Color textColor;
  final Color startColor;
  final Color endColor;
  final EdgeInsets margin;
  final Function() onPressed;

  const Button(
      {Key? key,
      required this.text,
      this.width = double.infinity,
      required this.textColor,
      required this.startColor,
      required this.endColor,
      required this.onPressed,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          width: width,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: blackTextStyle.copyWith(
                  color: textColor, fontSize: 18, fontWeight: extraBold),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonOutline extends StatelessWidget {
  final String text;
  final double width;
  final Color textColor;
  final Color borderColor;
  final EdgeInsets margin;
  final Function() onPressed;

  const ButtonOutline(
      {Key? key,
      required this.text,
      this.width = double.infinity,
      required this.textColor,
      required this.borderColor,
      required this.onPressed,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          width: width,
          height: 55,
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: blackTextStyle.copyWith(color: textColor, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
