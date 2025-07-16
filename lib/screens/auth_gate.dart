import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'admin_home_screen.dart';
import 'user_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> _getHomeScreen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (!snapshot.exists) return const LoginScreen();

    final rol = snapshot.data()?['rol'];
    if (rol == 'admin') return const AdminHomeScreen();
    return const UserHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getHomeScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error cargando la sesión')),
          );
        }

        return snapshot.data as Widget;
      },
    );
  }
}
