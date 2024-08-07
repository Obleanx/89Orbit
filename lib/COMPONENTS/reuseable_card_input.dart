import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AtmcardTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool isCardNumberField;

  const AtmcardTextFormField({
    Key? key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.onChanged,
    this.isCardNumberField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: isCardNumberField
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ]
          : inputFormatters,
      decoration: InputDecoration(
        hintText: isCardNumberField ? 'XXXX XXXX XXXX XXXX' : hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        filled: true,
        suffixIcon: isCardNumberField
            ? ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller!,
                builder: (context, value, child) {
                  return _getCardIcon(value.text);
                },
              )
            : suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 11.0,
        ),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
      validator: isCardNumberField
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              } else if (value.replaceAll(' ', '').length != 16) {
                return 'Card number must be 16 digits';
              }
              return validator?.call(value);
            }
          : validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
    );
  }

  Widget _getCardIcon(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.isEmpty) {
      return const SizedBox.shrink();
    }
    if (cardNumber.startsWith(RegExp(r'4'))) {
      return _buildCardIcon('lib/images/visa.png');
    } else if (cardNumber.startsWith(RegExp(r'5[1-5]'))) {
      return _buildCardIcon('lib/images/master.png');
    } else if (cardNumber.startsWith(RegExp(r'6'))) {
      return _buildCardIcon('lib/images/verve.png');
    }
    return const SizedBox.shrink();
  }

  Widget _buildCardIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6, right: 8),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Image.asset(
          assetPath,
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
