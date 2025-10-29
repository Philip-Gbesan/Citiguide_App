import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final String cardText;
  final EdgeInsets padding;

  const ReusableCard(
      {super.key,
      required this.width,
      required this.height,
      required this.imageUrl,
      required this.cardText,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            image:
                DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.fill)),
        child: Text(
          cardText,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              wordSpacing: 2),
        ),
      ),
    );
  }
}
