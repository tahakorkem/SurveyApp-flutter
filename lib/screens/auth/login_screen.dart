import 'package:flutter/material.dart';
import 'package:survey/models/result.dart';
import 'package:survey/models/user.dart';
import 'package:survey/network/auth/authenticator.dart';
import 'package:survey/screens/survey/list/survey_list_screen.dart';
import 'package:survey/util/context_utils.dart';
import 'package:survey/widgets/progress_button.dart';
import 'package:survey/util/alert_utils.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const routeName = "/auth/login";

  final authenticator = Authenticator.instance;

  final usernameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.height(.15)),
            Text(
              "Kullanıcı Girişi",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.height(.1)),
            TextFormField(
              controller: usernameOrEmailController,
              decoration: InputDecoration(
                  labelText: "E-posta adresi/Kullanıcı adı",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ProgressButton(
              child: Text("Giriş Yap"),
              onPressed: () => onClickButton(context),
            ),
            SizedBox(height: context.height(.05)),
          ],
        ),
      ),
    );
  }

  Future onClickButton(BuildContext context) async {
    final result = await authenticator.login(
        usernameOrEmailController.text.trim(), passwordController.text);
    if (result is Success<User>) {
      final loggedInUser = result.data;
      onLogin(context, loggedInUser);
    } else {
      context.alertError(result);
    }
    //await Future.delayed(const Duration(seconds: 1), () {});
  }

  void onLogin(BuildContext context, User user) {
    print(user);
    Navigator.pushReplacementNamed(context, SurveyListScreen.routeName);
  }

}
