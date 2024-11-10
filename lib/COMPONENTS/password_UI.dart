// File: lib/widgets/password_form_widgets.dart
import 'package:fiander/PROVIDERS/create_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordFormWidgets {
  static Widget buildPasswordField(BuildContext context) {
    final provider = Provider.of<CreateAccountProvider>(context);
    return TextFormField(
      controller: provider.passwordController,
      obscureText: !provider.isPasswordVisible,
      onChanged: provider.setPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: provider.validatePassword,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        isDense: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'Enter your password',
        hintStyle: const TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          icon: Icon(
            provider.isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: provider.togglePasswordVisibility,
        ),
      ),
    );
  }

  static Widget buildConfirmPasswordField(BuildContext context) {
    final provider = Provider.of<CreateAccountProvider>(context);
    return TextFormField(
      controller: provider.confirmPasswordController,
      obscureText: !provider.isConfirmPasswordVisible,
      onChanged: provider.setConfirmPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: provider.validateConfirmPassword,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        isDense: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'Confirm password',
        hintStyle: const TextStyle(fontSize: 12),
        errorText: !provider.passwordsMatch() ? 'Passwords do not match' : null,
        suffixIcon: IconButton(
          icon: Icon(
            provider.isConfirmPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: provider.toggleConfirmPasswordVisibility,
        ),
      ),
    );
  }

  static Widget buildPasswordValidationIndicators(BuildContext context) {
    final provider = Provider.of<CreateAccountProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildValidationIndicator(
          isValid: provider.hasEightCharacters(),
          text: '8 characters password',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: provider.hasUpperCase(),
          text: '1 upper case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: provider.hasLowerCase(),
          text: '1 lower case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: provider.hasSpecialCharacter(),
          text: '1 special character',
        ),
      ],
    );
  }

  static Widget _buildValidationIndicator({
    required bool isValid,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? Colors.green : Colors.red,
          ),
          child: Center(
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
