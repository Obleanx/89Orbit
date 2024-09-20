// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/PROVIDERS/email_password_provider.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/basic_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links2/uni_links.dart';
import '../../CONSTANTS/constants.dart';

class EmailandPassword extends StatefulWidget {
  //final Function setCurrentUser;

  @override
  _EmailandPasswordState createState() => _EmailandPasswordState();
}

class _EmailandPasswordState extends State<EmailandPassword> {
  StreamSubscription? _sub;
  bool accountVerified = false; // To track if account is verified via deep link
  late final StreamSubscription<AuthState> _authSubscriptions;

  @override
  void initState() {
    super.initState();

    handleInitialDeepLink();
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.host == 'email-verification') {
        handleEmailVerification(uri);
      }
    });
  }

  Future<void> handleInitialDeepLink() async {
    final initialUri = await getInitialUri();
    if (initialUri != null && initialUri.host == 'email-verification') {
      handleEmailVerification(initialUri);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
    _authSubscriptions.cancel();
  }

  // Handle email verification via deep link
  void handleEmailVerification(Uri uri) async {
    final token = uri.queryParameters['token'];
    if (token != null) {
      try {
        final response = await Supabase.instance.client.auth.verifyOTP(
          token: token,
          type: OtpType.email,
        );
        if (response.session != null) {
          setState(() {
            accountVerified = true; // Mark the account as verified
          });

          // Automatically navigate to BsicInfoScreen after verification
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BsicInfoScreen(
                setCurrentUser: (User) {},
              ),
            ),
          );
        } else {
          showErrorDialog('Email verification failed.');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error during email verification: $e');
        }
        showErrorDialog('An error occurred during email verification.');
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  // Supabase Next Button with dynamic behavior based on verification
                  _buildNextButtonForSupabaseSignUp(context),
                ],
              ),
            ),
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

Widget _buildNextButtonForSupabaseSignUp(BuildContext context) {
  final provider = Provider.of<EmailPasswordProvider>(context);

  return Align(
    alignment: Alignment.bottomCenter,
    child: ElevatedButton(
      onPressed: () async {
        // Refresh the session on button press to update the user's account state
        await Supabase.instance.client.auth.refreshSession();
        final session = Supabase.instance.client.auth.currentSession;

        // Check if the email is verified, then navigate to the BasicInfoScreen
        if (session != null && provider.isEmailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BsicInfoScreen(
                setCurrentUser: (User) {},
              ),
            ),
          );
        } else if (provider.isFormValid()) {
          await createAccountAndNavigate(context, provider);
        } else {
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
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: TextsInsideButtonColor,
      ),
      child: Text(
        provider.isEmailVerified ? 'Next' : 'Create Account',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Future<void> createAccountAndNavigate(
    BuildContext context, EmailPasswordProvider provider) async {
  try {
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

    final response = await Supabase.instance.client.auth.signUp(
      email: provider.emailController.text.trim(),
      password: provider.password,
      emailRedirectTo: "fiander://email-verification",
    );

    Navigator.of(context).pop(); // Close the loading dialog

    if (response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created! Please check your email to verify your account.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );

      // Set up a listener for auth state changes
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.userUpdated) {
          // Refresh the session to reflect the updated state
          await Supabase.instance.client.auth.refreshSession();

          // Navigate to the BasicInfoScreen when the user updates (likely email verification)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BsicInfoScreen(
                setCurrentUser: (User) {},
              ),
            ),
          );
        }
      });
    }
  } on AuthException catch (e) {
    Navigator.of(context).pop(); // Close the loading dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Creation Failed'),
          content: Text(e.message ?? 'Unknown error occurred'),
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


// Ensure your deep link handling logic is already set up as discussed previously.
// The user will be redirected to the next screen when they verify their email.