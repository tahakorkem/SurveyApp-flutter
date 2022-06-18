import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:survey/network/auth/authenticator.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/survey/add/new_survey_screen.dart';
import 'screens/survey/detail/survey_detail_screen.dart';
import 'screens/survey/list/survey_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // if(snapshot.hasError) {
        //   print(snapshot.error);
        //   return Oops();
        // }
        if (snapshot.connectionState == ConnectionState.done) {
          final authenticator = Authenticator.instance;
          final initialRoute = authenticator.isUserLoggedIn()
              ? SurveyListScreen.routeName
              : HomeScreen.routeName;
          return MyApp(initialRoute);
        }
        return Loading();
      },
    );
  }
}

// class Oops extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       title: "Bekle",
//     );// Text("Oops");
//   }
// }
//
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(body: Text("Loading")),
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme
            .copyWith(primary: Colors.blue, secondary: Colors.green),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        SignupScreen.routeName: (_) => SignupScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        SurveyListScreen.routeName: (_) => SurveyListScreen(),
        SurveyDetailScreen.routeName: (_) => SurveyDetailScreen(),
        NewSurveyScreen.routeName: (_) => NewSurveyScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text("Bir şeyler ters gitti!"),
                ),
              )),
    );
  }
}
