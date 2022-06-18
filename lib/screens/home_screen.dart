import 'dart:ui';
import 'package:flutter/material.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/signup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(flex: 2),
        Text("Merhaba.",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text("Survee ile anket oluşturabilir, anketlere katılabilirsin."),
        Spacer(),
        ElevatedButton(
            onPressed: () => onClickLogin(context), child: Text("Giriş Yap")),
        SizedBox(height: 6),
        Text("ya da", textAlign: TextAlign.center),
        SizedBox(height: 6),
        ElevatedButton(
            onPressed: () => onClickSignup(context), child: Text("Kaydol")),
        Spacer(flex: 2),
      ],
    );
  }

  void onClickLogin(BuildContext context) =>
      Navigator.pushNamed(context, LoginScreen.routeName);

  void onClickSignup(BuildContext context) =>
      Navigator.pushNamed(context, SignupScreen.routeName);
}
