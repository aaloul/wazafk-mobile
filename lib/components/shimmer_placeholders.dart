import 'package:flutter/material.dart';

class TextPlaceHolder extends StatelessWidget {
  const TextPlaceHolder({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 14,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}

class CirclePlaceHolder extends StatelessWidget {
  const CirclePlaceHolder({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }
}

class BoxPlaceHolder extends StatelessWidget {
  const BoxPlaceHolder({
    super.key,
    required this.width,
    required this.radius,
    required this.height,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
