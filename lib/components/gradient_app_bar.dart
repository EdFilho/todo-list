import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 65.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery
      .of(context)
      .padding
      .top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF333366),
            const Color(0xFF736AB7),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 36.0,
          ) ,
        ),
      ),
    );
  }
}