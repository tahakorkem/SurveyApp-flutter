import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth show User;
import 'package:survey/models/exceptions/auth_exception.dart';
import 'package:survey/models/user.dart';
import 'package:survey/models/result.dart';
import 'package:survey/network/db/db_helper.dart';
import 'package:survey/network/prefs/shared_prefs.dart';
import 'package:survey/validate/validator.dart';

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DbHelper _dbHelper = DbHelper.instance;
  late User? _user;
  late SharedPrefs _sharedPrefs;

  Authenticator._();

  static final Authenticator instance = Authenticator._()
    ..init().then((_) => print("Authenticator initialized.."));

  Future<void> init() async {
    _sharedPrefs = await SharedPrefs.getInstance();
    _user = _sharedPrefs.getUser();
  }

  Future<Result<User>> login(String usernameOrEmail, String password) async {
    final isEmailInputted = Validator.validateEmail(usernameOrEmail) == null;

    final String email, username;

    final userFindingResult = isEmailInputted
        ? await _dbHelper.findUserByEmail(usernameOrEmail)
        : await _dbHelper.findUserByUsername(usernameOrEmail);

    if (userFindingResult is Success<User>) {
      username = userFindingResult.data.username;
      email = userFindingResult.data.email;
    } else
      return userFindingResult as Error<User>;

    return await _loginWithEmailAndPassword(username, email, password);
  }

  Future<Result<User>> _loginWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = User.fromFirebaseUser(userCredential.user!, username);
      await _sharedPrefs.putUser(_user!);
      return Success(_user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print(e.message);
          return Error(AuthException.userNotFound);
        case 'wrong-password':
          print(e.message);
          return Error(AuthException.wrongPassword);
        case 'too-many-requests':
          print(e.message);
          return Error(AuthException.tooManyRequests);
        default:
          return Error(e);
      }
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<Result<User>> signup(
      String username, String email, String password) async {
    final userFindingResult = await _dbHelper.findUserByUsername(username);
    if (userFindingResult is Success<User>) {
      return Error(AuthException.usernameAlreadyInUse);
    }
    return await _signupWithEmailAndPassword(username, email, password);
  }

  Future<Result<User>> _signupWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final userToCreate = User(userCredential.user!.uid, username, email);
      await _dbHelper.createNewUser(userToCreate);
      _user = userToCreate;
      await _sharedPrefs.putUser(_user!);
      return Success(_user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          print('The account already exists for that email');
          return Error(AuthException.emailAlreadyInUse);
        case 'weak-password':
          print('The password provided is too weak.');
          return Error(AuthException.weakPassword);
        default:
          print(e);
          return Error(e);
      }
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<void> sendEmailVerification(fb_auth.User user) async {
    await user.sendEmailVerification();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    await _sharedPrefs.removeUser();
  }

  bool isUserLoggedIn() => _auth.currentUser != null;
}
