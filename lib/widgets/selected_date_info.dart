import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDateInfo extends StatelessWidget {
  final String selectedDate;
  final String? comparisonDate;

  const SelectedDateInfo({
    super.key,
    required this.selectedDate,
    this.comparisonDate,
  });

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'tr_TR').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/calendar.png", width: 24, height: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              comparisonDate != null
                  ? 'Seçilen Tarih: ${_formatDate(selectedDate)} - ${_formatDate(comparisonDate!)}'
                  : 'Seçilen Tarih: ${_formatDate(selectedDate)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
