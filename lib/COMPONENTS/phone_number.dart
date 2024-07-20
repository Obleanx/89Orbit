import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const PhoneNumberInput({
    Key? key,
    required this.onChanged,
    this.initialValue,
    required TextEditingController controller,
  }) : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '+234');
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _controller.text == '+234') {
        _controller.selection = TextSelection(
          baseOffset: 4,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        labelText: 'Phone Number',
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        hintText: '+234 XXXXXXXXXX',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a phone number';
        }
        if (!value.startsWith('+')) {
          return 'Phone number must start with a country code';
        }
        // Check length (e.g., minimum 10 digits after country code)
        final phoneNumberWithoutCode = value.substring(1); // Remove the '+'
        if (phoneNumberWithoutCode.length < 10) {
          return 'Phone number must be at least 10 digits long';
        }
        // Check if the remaining part contains only digits
        if (!RegExp(r'^\d+$').hasMatch(phoneNumberWithoutCode)) {
          return 'Phone number can only contain digits';
        }
        return null;
      },
      onChanged: (value) {
        if (value.isEmpty) {
          _controller.text = '+234';
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        } else if (!value.startsWith('+')) {
          _controller.text = '+$value';
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
        widget.onChanged(_controller.text);
      },
    );
  }
}
