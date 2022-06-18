import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/models/exceptions/auth_exception.dart';
import 'package:survey/models/result.dart';
import 'package:survey/models/survey.dart';
import 'package:survey/models/user.dart';
import 'package:survey/network/prefs/shared_prefs.dart';

class DbHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late SharedPrefs _sharedPrefs;

  DbHelper._();

  static final DbHelper instance = DbHelper._()
    ..init().then((_) => print("DbHelper initialized.."));

  Future<void> init() async {
    _sharedPrefs = await SharedPrefs.getInstance();
  }

  Future<List<Survey>> get surveysFuture async {
    final surveysSnapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .orderBy("createdAt", descending: true)
        .get();
    final surveys = surveysSnapshot.docs.map((e) async {
      //join user
      final creatorId = e['creatorId'];
      final creatorDocSnapshot =
          await _db.collection("users").doc(creatorId).get();
      final creator = User.fromDocSnapshot(creatorDocSnapshot);
      //get vote count
      final choicesSnapshot = await e.reference.collection("choices").get();
      final totalVoteCount = choicesSnapshot.docs
          .fold(0, (int acc, e) => acc + List.from(e['voters']).length);
      return Survey.fromDocSnapshot(e, creator, totalVoteCount);
    }).toList();
    return Future.wait(surveys);
  }

  Future<Result<User>> findUserByUsername(String username) async {
    final snapshot = await _db
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    try {
      final doc = snapshot.docs.single;
      return Success(User.fromDocSnapshot(doc));
    } on StateError catch (e) {
      print(e);
      return Error(AuthException.userNotFound);
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<Result<User>> findUserByEmail(String email) async {
    final snapshot =
        await _db.collection("users").where("email", isEqualTo: email).get();
    try {
      final doc = snapshot.docs.single;
      return Success(User.fromDocSnapshot(doc));
    } on StateError catch (e) {
      print(e);
      return Error(AuthException.userNotFound);
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<void> createNewUser(User user) async {
    await _db
        .collection("users")
        .doc(user.id)
        .set({'username': user.username, 'email': user.email});
  }

  Future<Survey> createNewSurvey(String title, List<String> choices) async {
    final creator = _sharedPrefs.getUser()!;
    final ref = await _db.collection("surveys").add({
      'name': title,
      'creatorId': creator.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
    for (String choice in choices) {
      await ref.collection("choices").add({
        'name': choice,
        'voters': [],
      });
    }
    return Survey(ref.id, title, creator, DateTime.now(), 0);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> choicesCollectionStream(
      String id) {
    return _db.collection("surveys").doc(id).collection("choices").snapshots();
  }

  Future<void> removeMeFromVoters(String surveyId, String choiceId) async {
    _db
        .collection("surveys")
        .doc(surveyId)
        .collection("choices")
        .doc(choiceId)
        .update({
      'voters': FieldValue.arrayRemove([_sharedPrefs.getUser()!.id])
    });
  }

  Future<void> addMeToVoters(String surveyId, String choiceId) async {
    _db
        .collection("surveys")
        .doc(surveyId)
        .collection("choices")
        .doc(choiceId)
        .update({
      'voters': FieldValue.arrayUnion([_sharedPrefs.getUser()!.id])
    });
  }
}
