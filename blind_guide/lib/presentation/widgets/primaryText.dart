import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
class PrimaryText extends StatelessWidget {
  final Color? color;
  final String text;
  TextOverflow overFlow;
  double size;

  PrimaryText({
    this.color,
    required this.text,
    this.overFlow = TextOverflow.ellipsis,
    this.size=0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        overflow: overFlow,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: color,
          fontSize:size==0 ? 100.h/(100.h/18): size,
          fontWeight: FontWeight.w500,)
    );
  }
}