import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/controllers/authcontroller.dart';
import 'package:loopedin/pages/homepage.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/providers/firebaseproviders.dart';
import 'package:loopedin/utils/showsnackbar.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});

  final passwordVisibilityProvider1 = StateProvider((ref) {
    return false;
  });
  final passwordVisibilityProvider2 = StateProvider((ref) {
    return false;
  });

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(authControllerProvider).continueWithGoogle(ref);
    if (success) {
      ref.read(authStateProvider.notifier).state = true;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  void signUp(BuildContext context, WidgetRef ref) async {
    if (password.text.trim().isEmpty || confirmpassword.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Password fields cannot be empty.');
      return;
    }

    if (email.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your email.');
    }
    if (fullname.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your name.');
    }
    if (username.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your username.');
    }

    if (password.text.trim() != confirmpassword.text.trim()) {
      showSnackBar(context: context, text: 'Passwords do not match.');
      return;
    }

    final success = await ref.read(authControllerProvider).signUp(
        email: email.text.trim(),
        password: password.text.trim() == confirmpassword.text.trim()
            ? password.text.trim()
            : '',
        name: fullname.text,
        username: username.text.toLowerCase(),
        context: context,
        ref: ref);

    if (success) {
      ref.read(authStateProvider.notifier).state = true;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  final TextEditingController email = TextEditingController();
  final password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final fullname = TextEditingController();
  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisibility1 = ref.watch(passwordVisibilityProvider1);
    final passwordVisibility2 = ref.watch(passwordVisibilityProvider2);
    final isAuthenticated = ref.watch(authStateProvider);
    if (isAuthenticated) {
      return const HomePage();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
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
                  'Let\'s create an account',
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
                height: 16,
              ),
              TextFormField(
                controller: fullname,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.insert_emoticon),
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
                  hintText: 'Full Name',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  prefixIconColor: Theme.of(context).primaryColor,
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
                  hintText: 'Username',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  prefixIconColor: Theme.of(context).primaryColor,
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
                        ref.read(passwordVisibilityProvider1.notifier).state =
                            !passwordVisibility1;
                      },
                      child: passwordVisibility1
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off)),
                ),
                obscureText: !passwordVisibility1,
              ),
              Text('Must contain a number and least of 6 characters',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15)),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: confirmpassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  prefixIconColor: Theme.of(context).primaryColor,
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
                  hintText: 'Confirm Password',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        ref.read(passwordVisibilityProvider2.notifier).state =
                            !passwordVisibility2;
                      },
                      child: passwordVisibility2
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off)),
                ),
                obscureText: !passwordVisibility2,
              ),
              Text('Must contain a number and least of 6 characters',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15)),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                onPressed: () {
                  signUp(context, ref);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  foregroundColor:
                      Theme.of(context).textTheme.bodyMedium!.color,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text('Sign In'),
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
                              'Sign Up with Google',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Have an account? ', // Main text
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 16), // Default style
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "Log In", // The part you want to style differently
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: const Color.fromARGB(255, 52, 51, 65),
                                fontSize: 16,
                              ), // Bold style
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
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
