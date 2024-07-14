import 'dart:math' as math;
import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    int selectionIndex = newValue.selection.end;

    // Handle deletion
    if (newText.length < oldValue.text.length) {
      // Determine which digit was deleted
      int deletedIndex = oldValue.selection.end - 1;
      if (deletedIndex >= 0) {
        // Skip colon when deleting
        if (deletedIndex == 2) {
          deletedIndex = 1;
        }
        // Replace the deleted digit with '0'
        String updatedText =
            oldValue.text.replaceRange(deletedIndex, deletedIndex + 1, '0');

        // Adjust cursor position for deletion
        if (deletedIndex >= 3) {
          // If deleting digit after colon
          selectionIndex = deletedIndex;
        } else {
          // If deleting digit before colon
          selectionIndex = deletedIndex;
        }

        return TextEditingValue(
          text: updatedText,
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
      }
    }

    // Remove all non-digit characters
    final digitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 4 digits
    final limitedDigits =
        digitsOnly.substring(0, math.min(4, digitsOnly.length));

    // Format the time
    final formattedValue = StringBuffer();
    for (int i = 0; i < 4; i++) {
      if (i == 2) formattedValue.write(':');
      formattedValue.write(i < limitedDigits.length ? limitedDigits[i] : '0');
    }

    // Adjust cursor position for insertion
    if (newText.length > oldValue.text.length) {
      if (selectionIndex > 2) selectionIndex++;
      if (selectionIndex > 5) selectionIndex = 5;
    }

    // If all digits were deleted, reset to "00:00"
    if (limitedDigits.isEmpty) {
      return const TextEditingValue(
        text: "00:00",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    return TextEditingValue(
      text: formattedValue.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
