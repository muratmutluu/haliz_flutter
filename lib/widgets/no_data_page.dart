import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  const NoDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Eğer bu sayfa bir Scaffold içinde değilse, ekledik
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bu tarihte veri bulunamadı.\nLütfen başka bir tarih seçin.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Image.asset('assets/sad_carrot.png', width: 100, height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
