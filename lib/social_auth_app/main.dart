import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integrations/firebase_options.dart';
import 'package:firebase_integrations/social_auth_app/screens/homepage_screen.dart';
import 'package:firebase_integrations/social_auth_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthWrap());
  }
}

class AuthWrap extends StatelessWidget {
  const AuthWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomepageScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
