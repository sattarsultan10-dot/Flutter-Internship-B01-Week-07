import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrations/social_auth_app/services/google_auth_service.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email:${user!.email}"),
            Text("Name:${user.displayName}"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _googleAuthService.signOut();
              },
              child: Text("SignOut"),
            ),
          ],
        ),
      ),
    );
  }
}
