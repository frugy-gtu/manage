import 'package:flutter/material.dart';
import 'package:manage/extra/length_limiting_text_field_formatter_fixed.dart';

class UpperCaseLengthLimitingFormatter extends LengthLimitingTextFieldFormatterFixed {
  UpperCaseLengthLimitingFormatter(int maxLength) : super(maxLength);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextEditingValue limitedValue = super.formatEditUpdate(oldValue, newValue);
    return TextEditingValue(
      text: limitedValue.text?.toUpperCase(),
      selection: limitedValue.selection,
    );
  }
}
