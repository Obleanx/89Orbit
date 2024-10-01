import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links2/uni_links.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isResetLinkSent = false;
  bool _isLoading = false;
  String? _token; // To store the reset token

  // Sends the reset password email
  bool _cooldownActive = false;

  Future<void> _sendResetPasswordEmail() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _cooldownActive = true;
      });

      final email = _emailController.text;

      await Supabase.instance.client.auth.resetPasswordForEmail(email,
          redirectTo: 'fiander://reset-password'); // Add the redirect URL

      setState(() {
        _isResetLinkSent =
            true; // Set this to true to show the password reset form
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );

      // Wait for 60 seconds before allowing another request
      Future.delayed(const Duration(seconds: 60), () {
        setState(() {
          _cooldownActive = false;
        });
      });
    } catch (error) {
      print('Error sending reset password email: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Resets the password after receiving the reset link
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate() || _token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Update the user's password in Supabase
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
        ),
      );

      if (response.user == null) {
        throw Exception('Failed to update password');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );

      // Navigate to login screen after successful password reset
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen1()),
      );
    } catch (error) {
      print('Error resetting password: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks(); // Start listening for incoming links
  }

  Future<void> _handleIncomingLinks() async {
    // Implement logic to listen for incoming links
    // Example: Parse the incoming link to get the token
    linkStream.listen((String? link) {
      if (link != null && link.startsWith('fiander://reset-password')) {
        final uri = Uri.parse(link);
        setState(() {
          _token = uri.queryParameters['token'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isResetLinkSent ? 'Reset Password' : 'Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isResetLinkSent) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetPasswordEmail,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Send Reset Link'),
                ),
              ],
              if (_isResetLinkSent) ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
