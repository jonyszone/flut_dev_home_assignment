import 'package:flutter/material.dart';


class CustomMultilineText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? alignment;
  final int? maxLine;
  const CustomMultilineText({super.key, required this.text, this.fontWeight, this.color, this.fontSize, this.fontStyle, this.alignment, this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment?? TextAlign.justify,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      textDirection: TextDirection.ltr,
      style: TextStyle(
          color: color?? Theme.of(context).textTheme.displayLarge?.color,
          fontWeight: fontWeight??Theme.of(context).textTheme.displayLarge?.fontWeight,
          fontSize: fontSize??Theme.of(context).textTheme.displayLarge?.fontSize,
          fontStyle: fontStyle?? Theme.of(context).textTheme.displayLarge?.fontStyle
      ),
    );
  }
}


class CustomSimpleText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? alignment;
  final TextDecoration? textDecoration;

  const CustomSimpleText({
    super.key,
    required this.text,
    this.fontWeight,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.alignment,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment ?? TextAlign.center,
      style: TextStyle(
        color: color ?? Theme.of(context).textTheme.displayLarge?.color,
        fontWeight: fontWeight ?? Theme.of(context).textTheme.displayLarge?.fontWeight,
        fontSize: fontSize ?? Theme.of(context).textTheme.displayLarge?.fontSize,
        fontStyle: fontStyle ?? Theme.of(context).textTheme.displayLarge?.fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}


class FieldTitleText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? alignment;
  const FieldTitleText({super.key, required this.text, this.fontWeight, this.color, this.fontSize, this.fontStyle, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment?? TextAlign.start,
      style: TextStyle(
          color: color?? Colors.grey,
          fontWeight: fontWeight??Theme.of(context).textTheme.displayLarge?.fontWeight,
          fontSize: fontSize?? 14,
          fontStyle: fontStyle?? Theme.of(context).textTheme.displayLarge?.fontStyle
      ),
    );
  }
}

