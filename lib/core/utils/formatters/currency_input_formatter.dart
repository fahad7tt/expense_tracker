import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Allow only digits and a single decimal point
    if (newValue.text.contains('.')) {
      if (newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
        return oldValue;
      }
    }

    String newText = newValue.text.replaceAll(',', '');

    // Check if the input is a valid number
    if (double.tryParse(newText) == null && newText != '.') {
      return oldValue;
    }

    // Handle decimal formatting
    if (newText.contains('.')) {
      final parts = newText.split('.');
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : '';

      if (integerPart.isEmpty) {
        integerPart = '0';
      }

      final formattedInteger =
          NumberFormat("#,##0", "en_US").format(int.parse(integerPart));
      final formattedText = '$formattedInteger.$decimalPart';

      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    final formattedText =
        NumberFormat("#,##0", "en_US").format(int.parse(newText));

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
