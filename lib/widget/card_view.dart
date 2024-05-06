import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final double elevtion;
  final double borderRadius;
  final Color color;
  final Widget child;
  final double marginCard;
  final double padingContainer;
  const CardView({
    required this.elevtion,
    required this.borderRadius,
    required this.color,
    required this.child,
    required this.marginCard,
    required this.padingContainer,
    super.key, required int paddingContainer, required int elevation
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(marginCard),
      elevation: elevtion,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color,
      child: Container(
        padding: EdgeInsets.all(padingContainer),
        child: child,
      ),
    );
  }
}