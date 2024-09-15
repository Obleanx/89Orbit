// ignore_for_file: use_build_context_synchronously
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/PROVIDERS/email_password_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CONSTANTS/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'basic_info.dart';

class EmailandPassword extends StatelessWidget {
  const EmailandPassword({Key? key, required setCurrentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmailPasswordProvider(),
      child: const _EmailandPasswordContent(),
    );
  }
}

class _EmailandPasswordContent extends StatelessWidget {
  const _EmailandPasswordContent();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailPasswordProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Text(
                'Basic Information',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.lock, color: Color(0xfffb40ad), size: 12),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We won’t share this information with anyone and it won’t show on your profile.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Form(
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: provider.emailController,
                    labelText: 'Email address',
                    hintText: 'Enter your email',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your email'
                        : null,
                  ),
                  const SizedBox(height: 30),
                  _buildPasswordField(context),
                  const SizedBox(height: 20),
                  _buildPasswordValidationIndicators(context),
                  const SizedBox(height: 8),
                  _buildConfirmPasswordField(context),
                  const SizedBox(height: 150),
                  _buildNextButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    final provider = Provider.of<EmailPasswordProvider>(context);
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

  Widget _buildConfirmPasswordField(BuildContext context) {
    final provider = Provider.of<EmailPasswordProvider>(context);
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

  Widget _buildPasswordValidationIndicators(BuildContext context) {
    final provider = Provider.of<EmailPasswordProvider>(context);

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

  Widget _buildNextButton(BuildContext context) {
    final provider = Provider.of<EmailPasswordProvider>(context);
    Future<void> createAccountAndNavigate() async {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: const Text("Creating account..."),
                  ),
                ],
              ),
            );
          },
        );

        // Create user account
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: provider.emailController.text.trim(),
          password: provider.password,
        );

        if (kDebugMode) {
          print("User creation successful: ${userCredential.user?.uid}");
        }

        // Add a small delay to ensure the dialog shows up
        await Future.delayed(const Duration(milliseconds: 500));

        // Close loading indicator
        Navigator.of(context).pop();

        if (userCredential.user != null) {
          // Navigate to the next screen and pass the user object
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BsicInfoScreen(user: userCredential.user!),
          ));
        }
      } on FirebaseAuthException catch (e) {
        // Close loading indicator
        Navigator.of(context).pop();

        if (kDebugMode) {
          print("FirebaseAuthException: ${e.message}");
        }

        // Show error message when users try to create account.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Creation Failed'),
              content:
                  Text(e.message ?? 'An error occurred. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Close loading indicator
        Navigator.of(context).pop();

        if (kDebugMode) {
          print("Unexpected error: $e");
        }

        // Show error message for unexpected errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Creation Failed'),
              content:
                  const Text('An unexpected error occurred. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: provider.isFormValid()
            ? createAccountAndNavigate
            : () {
                // Show a popup message to the user about what needs to be completed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Incomplete Information'),
                      content: const Text(
                          'Please fill in all required information correctly.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: TextsInsideButtonColor,
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildValidationIndicator(
      {required bool isValid, required String text}) {
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
