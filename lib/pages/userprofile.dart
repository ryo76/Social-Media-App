import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/controllers/authcontroller.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/providers/firebaseproviders.dart';
import 'package:loopedin/repository/authrepository.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen to the userNotifierProvider and update the loading state accordingly
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    ref.listen(userNotifierProvider, (previous, next) {
      if (next == null) {
        ref.read(isLoadingProvider.notifier).state = true;
      } else {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Top Banner with Profile Picture
                  Stack(
                    children: [
                      SizedBox(
                          height: 150,
                          child: Image.asset(
                            defBannerPath,
                            fit: BoxFit.cover,
                          )),
                      Column(
                        children: [
                          const SizedBox(height: 80), // Space for the banner
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // Makes the container circular
                              border: Border.all(
                                  color: Colors.white,
                                  width: 5), // Border color and width
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                defAvatarPath,
                                fit: BoxFit
                                    .cover, // Ensures the image fits within the container
                                width:
                                    100, // Set width (and height) to control the size of the image
                                height: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${user?.name}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            user!.bio,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 10),
                          // Follower & Following Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('${user.followers}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text(
                                    'Followers',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 75),
                              Column(
                                children: [
                                  Text(
                                    '${user.following}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Following',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  minimumSize: const Size(200, 40),
                                  shape: const RoundedRectangleBorder(),
                                ),
                                child: Text('Edit profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.settings),
                                  color: Colors.white,
                                  iconSize: 25,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                  // Photos Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Photos',
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 51, 65),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 5, // You can update with actual count
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Videos Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Videos',
                          style: TextStyle(
                            color: Color.fromARGB(255, 52, 51, 65),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 6, // You can update with actual count
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            onPressed: () async {
                              final success = await ref
                                  .read(authControllerProvider)
                                  .logout(ref);
                              ref.read(authStateProvider.notifier).state =
                                  false;
                              if (success) {
                                // Once the logout is successful, reset the loading state and navigate
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                ref.read(authStateProvider.notifier).state =
                                    false;

                                // Navigate to the login page
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              } else {
                                // Reset the loading state if logout fails
                                ref.read(isLoadingProvider.notifier).state =
                                    false;

                                // Show an error message or take appropriate action
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Logout failed. Please try again.')),
                                );
                              }
                            },
                            child: const Text('Log Out')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
