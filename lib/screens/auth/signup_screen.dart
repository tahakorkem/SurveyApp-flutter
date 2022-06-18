import 'package:flutter/material.dart';
import 'package:survey/models/result.dart';
import 'package:survey/models/user.dart';
import 'package:survey/network/auth/authenticator.dart';
import 'package:survey/screens/survey/list/survey_list_screen.dart';
import 'package:survey/util/context_utils.dart';
import 'package:survey/validate/validator.dart';
import 'package:survey/widgets/progress_button.dart';
import 'package:survey/util/alert_utils.dart';

class SignupScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  SignupScreen({Key? key}) : super(key: key);

  static const routeName = "/auth/signup";

  final authenticator = Authenticator.instance;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

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
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.width(0.15)),
                Text(
                  "Hesap Oluştur",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.height(0.1)),
                TextFormField(
                  maxLength: Validator.MAX_USERNAME_LENGTH,
                  validator: Validator.validateUsername,
                  controller: usernameController,
                  decoration: InputDecoration(
                      labelText: "Kullanıcı adınız",
                      border: OutlineInputBorder(),
                      counterText: ""),
                ),
                SizedBox(height: 16),
                TextFormField(
                  validator: Validator.validateEmail,
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "E-posta adresiniz",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                TextFormField(
                  validator: Validator.validatePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  validator: (value) => Validator.validatePasswordRepeat(
                      passwordController.text, value),
                  controller: passwordRepeatController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifreniz (tekrar)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ProgressButton(
                  onPressed: () => onClickButton(context),
                  child: Text("Kaydol"),
                ),
                SizedBox(height: context.height(0.05)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClickButton(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await createAccount(context);
    }
  }

  Future<void> createAccount(BuildContext context) async {
    final result = await authenticator.signup(usernameController.text.trim(),
        emailController.text.trim(), passwordController.text);
    if (result is Success<User>) {
      final loggedInUser = result.data;
      onSignup(context, loggedInUser);
    } else {
      context.alertError(result);
    }
  }

  void onSignup(BuildContext context, User user) {
    print(user);
    Navigator.pushReplacementNamed(context, SurveyListScreen.routeName);
  }
}
