import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/controllers/authcontroller.dart';

import 'package:loopedin/pages/forgotpass.dart';
import 'package:loopedin/pages/signup.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/providers/firebaseproviders.dart';
import 'package:loopedin/repository/authrepository.dart';

import 'package:loopedin/utils/showsnackbar.dart';
final isLoadingProvider = StateProvider<bool>((ref) {
    return false;
  });

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});
  
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(authControllerProvider).continueWithGoogle(ref);
    print(success);

    if (success) {
      ref.read(authStateProvider.notifier).state = true;
      final user2 = await ref.read(userNotifierProvider.notifier).fetchUserData(
          FirebaseAuth.instance,
          FirebaseFirestore.instance.collection('users'));
      ref.read(userNotifierProvider.notifier).setUser(user2!);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  void signIn(BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state=true;
    if (email.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your email.');
    }
    if (password.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Password Field cannot be empty');
      return;
    }
    final success = await ref.read(authControllerProvider).signIn(
        email: email.text.trim(),
        password: password.text.trim(),
        context: context,
        ref: ref);
    if (success) {
      ref.read(authStateProvider.notifier).state = true;

      final user2 = await ref.read(userNotifierProvider.notifier).fetchUserData(
          FirebaseAuth.instance,
          FirebaseFirestore.instance.collection('users'));
      ref.read(userNotifierProvider.notifier).setUser(user2!);
      ref.read(isLoadingProvider.notifier).state=false;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  final passwordVisibilityProvider = StateProvider<bool>((ref) {
    return false;
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisibility = ref.watch(passwordVisibilityProvider);
    final isAuthenticated = ref.watch(authStateProvider);
    final isLoading = ref.watch(isLoadingProvider);
    if (isAuthenticated) {
      return const ProfilePage();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Image.asset(
                        appLogoPath,
                        width: 250,
                        height: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Hi!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'Please enter your details below',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: Theme.of(context).primaryColor,
                        contentPadding: const EdgeInsets.only(top: 13),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 194, 194, 194),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 52, 51, 65),
                          ),
                        ),
                        hintText: 'Email',
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: Theme.of(context).primaryColor,
                        contentPadding: const EdgeInsets.only(top: 15),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 194, 194, 194),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 52, 51, 65),
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              ref
                                  .read(passwordVisibilityProvider.notifier)
                                  .state = !passwordVisibility;
                            },
                            child: passwordVisibility
                                ? const Icon(Icons.remove_red_eye)
                                : const Icon(Icons.visibility_off)),
                      ),
                      obscureText: !passwordVisibility,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signIn(context, ref);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        foregroundColor:
                            Theme.of(context).textTheme.bodyMedium!.color,
                        minimumSize: const Size(double.infinity, 50),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text('Log In'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: double.infinity, // Button takes full width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20), // Padding for button height
                            backgroundColor: Theme.of(context)
                                .scaffoldBackgroundColor, // Button background color
                            side: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .color!), // Border color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            // Implement your Google sign-up logic here
                            signInWithGoogle(context, ref);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/google_logo.png',
                                height: 30,
                              ),
                              const SizedBox(width: 34),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Continue with Google',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ', // Main text
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 16), // Default style
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    "Sign Up", // The part you want to style differently
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color:
                                          const Color.fromARGB(255, 52, 51, 65),
                                      fontSize: 16,
                                    ), // Bold style
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()),
                                    );
                                  }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ),
    );
  }
}
