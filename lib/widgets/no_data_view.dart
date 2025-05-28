import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  final String message;
  final String imagePath;
  final double imageSize;

  const NoDataView({
    super.key,
    required this.message,
    this.imagePath = 'assets/sad_carrot.png',
    this.imageSize = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Image.asset(imagePath, width: imageSize, height: imageSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
