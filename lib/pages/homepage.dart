import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/controllers/authcontroller.dart';

import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/providers/firebaseproviders.dart';
import 'package:loopedin/repository/authrepository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hello ${user?.name}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            ElevatedButton(
                onPressed: () async {
                  final success =
                      await ref.read(authControllerProvider).logout(ref);
                  ref.read(authStateProvider.notifier).state = false;
                  if (success) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
                child: const Text('Log Out')),
          ],
        ),
      ),
    );
  }
}
