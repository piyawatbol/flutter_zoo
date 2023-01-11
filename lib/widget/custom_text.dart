// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Custom_text extends StatefulWidget {
  double? width;
  String? text;
  Color? color;
  double? fontSize;
  TextAlign? text_align;
  FontWeight? fontWeight;
  Custom_text(
      {required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  State<Custom_text> createState() => _Custom_textState();
}

class _Custom_textState extends State<Custom_text> {
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      overflow: TextOverflow.ellipsis,
      "${widget.text}",
      textAlign: widget.text_align,
      style: GoogleFonts.itim(
        textStyle: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}

class Custom_text2 extends StatefulWidget {
  double? width;
  String? text;
  Color? color;
  double? fontSize;
  TextAlign? text_align;
  FontWeight? fontWeight;
  Custom_text2(
      {required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  State<Custom_text2> createState() => _Custom_text2State();
}

class _Custom_text2State extends State<Custom_text2> {
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      overflow: TextOverflow.ellipsis,
      "${widget.text}",
      textAlign: widget.text_align,
      maxLines: 5,
      style: GoogleFonts.itim(
        textStyle: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
