import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothesAnswer extends StatelessWidget {
  String answerText;
  VoidCallback tapped;
  ClothesAnswer(this.tapped, this.answerText);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: tapped,
      child: Text(
        answerText,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
