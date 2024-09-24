import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomEmailTextFormField extends StatefulWidget {
  final TextEditingController controller;

  const CustomEmailTextFormField({Key? key, required this.controller})
      : super(key: key);

  @override
  _CustomEmailTextFormFieldState createState() =>
      _CustomEmailTextFormFieldState();
}

class _CustomEmailTextFormFieldState extends State<CustomEmailTextFormField> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    try {
      final user = Supabase.instance.client.auth
          .currentUser; //this late variable fetches the users email form the backend and displays it in the next screen so that the user data and basic information will be assigned uniquelly to this user and this user alone.

      if (user != null) {
        // Assuming the email is stored in user.email of which is the place the email is stored!
        widget.controller.text = user.email ?? '';
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch email: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: _errorMessage,
            border: const OutlineInputBorder(),
          ),
          readOnly: true, // Prevent editing, just display the email
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
