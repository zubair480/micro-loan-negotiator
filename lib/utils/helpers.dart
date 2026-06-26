import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return format.format(amount);
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String formatRate(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  static String formatTerm(int months) {
    if (months < 12) return '$months months';
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$years ${years == 1 ? 'year' : 'years'}, $remainingMonths months';
  }

  static String riskLabel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return 'Low Risk';
      case 'medium':
        return 'Medium Risk';
      case 'high':
        return 'High Risk';
      default:
        return 'Unknown';
    }
  }

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
