import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color txtColor;
  final Color btnColor;
  final double height;

  const DefaultButton({
    this.txtColor = Colors.black,
    this.btnColor = Colors.pinkAccent,
    Key? key,
    this.height = 55,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
            color: txtColor,
          ),
        ),
      ),
    );
  }
}
