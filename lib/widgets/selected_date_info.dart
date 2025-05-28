import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDateInfo extends StatelessWidget {
  final String selectedDate;

  const SelectedDateInfo({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/calendar.png", width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            "Seçilen Tarih: ${DateFormat('d MMMM y', 'tr_TR').format(DateTime.parse(selectedDate))}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
