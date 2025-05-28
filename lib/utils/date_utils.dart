import 'package:intl/intl.dart';

class DateUtilsHelper {
  /// Verilen tarihi kontrol eder, eğer hafta sonuna denk geliyorsa
  /// en yakın Cuma gününe çeker ve 'yyyy-MM-dd' formatında döner.
  static String getValidDate(DateTime date) {
    return date.toString().split(' ')[0];
  }

  static String getPreviousDate(DateTime date) {
    final previousDate = date.subtract(const Duration(days: 1));
    return getValidDate(previousDate);
  }
}
