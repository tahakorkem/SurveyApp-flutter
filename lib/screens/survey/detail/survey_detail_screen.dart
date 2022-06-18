import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:survey/models/choice.dart';
import 'package:survey/models/survey.dart';
import 'package:survey/models/user.dart';
import 'package:survey/network/db/db_helper.dart';
import 'package:survey/network/prefs/shared_prefs.dart';

class SurveyDetailScreen extends StatefulWidget {
  static const routeName = "/survey/detail";

  const SurveyDetailScreen({Key? key}) : super(key: key);

  @override
  _SurveyDetailScreenState createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  final dbHelper = DbHelper.instance;
  String? selectedChoiceId;
  late User user;
  late Survey survey;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getInstance().then((prefs) {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      setState(() => isInitialDataFetched = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    survey = ModalRoute.of(context)!.settings.arguments as Survey;

    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            survey.name,
            style: TextStyle(fontSize: 18),
          ),
          InkWell(
            child: Text("@${survey.creator.username}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            onTap: onClickCreator,
          )
        ],
      )),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return isInitialDataFetched ? buildChoiceList() : buildProgress();
  }

  Widget buildChoiceList() {
    return StreamBuilder<QuerySnapshot>(
      stream: dbHelper.choicesCollectionStream(survey.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error: ${snapshot.error}}");
        if (snapshot.connectionState == ConnectionState.waiting)
          return buildProgress();
        return buildList(snapshot.data!.docs);
      },
    );
  }

  LinearProgressIndicator buildProgress() => LinearProgressIndicator();

  Widget buildList(List<QueryDocumentSnapshot> snapshot) {
    final choices = snapshot.map((e) {
      final choice = Choice.fromDocSnapshot(e);
      if (choice.voterIds.contains(user.id)) selectedChoiceId = choice.id;
      return choice;
    }).toList();
    final totalVoteCount =
        choices.fold(0, (int acc, choice) => acc + choice.voteCount);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 6),
      children: [
        buildTotalVoteCount(totalVoteCount),
        ...choices.map((e) => buildRow(e, totalVoteCount)).toList(),
      ],
    );
  }

  Padding buildTotalVoteCount(int totalVoteCount) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        "Toplam $totalVoteCount oy verildi.",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildRow(Choice choice, int totalVoteCount) {
    final voteRatio =
        totalVoteCount > 0 ? choice.voteCount / totalVoteCount : 0.0;
    final isSelected = choice.id == selectedChoiceId;
    return GestureDetector(
      onTap: () => onClickSurveyItem(choice),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        //key: ValueKey(choice.id),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Color(0xff9ba3a7),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Color(0xff9ba3a7)),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (selectedChoiceId != null)
                        SizedBox(
                          height: double.infinity,
                          child: LinearProgressIndicator(
                            value: voteRatio,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withAlpha(100)
                                : Color(0x609ba3a7),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(choice.name)),
                      ),
                      if (selectedChoiceId != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  "%${(voteRatio * 100).toStringAsFixed(1)}")),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onClickSurveyItem(Choice choice) async {
    final previousSelectedChoiceId = selectedChoiceId;
    if (selectedChoiceId == choice.id) {
      selectedChoiceId = null;
      await dbHelper.removeMeFromVoters(survey.id, previousSelectedChoiceId!);
      return;
    }
    //selectedChoiceId = choice.id;
    if (previousSelectedChoiceId != null)
      dbHelper.removeMeFromVoters(survey.id, previousSelectedChoiceId);
    dbHelper.addMeToVoters(survey.id, choice.id);
  }

  void onClickCreator() {
    print("clicked: ${survey.creator}");
  }
}
