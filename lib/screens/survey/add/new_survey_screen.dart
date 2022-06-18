import 'package:flutter/material.dart';
import 'package:survey/network/db/db_helper.dart';
import 'package:survey/util/snackbar_utils.dart';

class NewSurveyScreen extends StatefulWidget {
  const NewSurveyScreen({Key? key}) : super(key: key);

  static const routeName = "/survey/add";

  @override
  _NewSurveyScreenState createState() => _NewSurveyScreenState();
}

class _NewSurveyScreenState extends State<NewSurveyScreen> {
  bool get isAnythingInserted =>
      choices.any((element) => element.trim().isNotEmpty);

  bool get isAllInserted =>
      choices.every((element) => element.trim().isNotEmpty);

  bool get isSurveyNameInserted => surveyNameController.text.trim().isNotEmpty;

  final dbHelper = DbHelper.instance;

  final surveyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: buildSurveyNameTextField(),
          leading: buildCancelAction(),
          actions: [buildCompleteAction()],
        ),
        body: buildBody(),
      ),
    );
  }

  @override
  void dispose() {
    surveyNameController.dispose();
    super.dispose();
  }

  Widget buildSurveyNameTextField() {
    return TextField(
      //keyboardType: TextInputType.text,
      autofocus: true,
      controller: surveyNameController,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.white60,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: "Anket İsmi",
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none),
    );
  }

  Widget buildCancelAction() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => onClickClose(),
      tooltip: "İptal",
    );
  }

  Widget buildCompleteAction() {
    return IconButton(
      onPressed: () => onClickComplete(),
      icon: Icon(Icons.done),
      tooltip: "Tamamla",
    );
  }

  final choices = ["", ""];

  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        for (int i = 0; i < choices.length; i++) buildRow(i, choices[i]),
        Divider(color: Theme.of(context).primaryColor),
        buildAddButton()
      ],
    );
  }

  Widget buildAddButton() {
    return TextButton.icon(
      onPressed: () => onClickAdd(),
      icon: Icon(Icons.add),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(""),
      ),
    );
  }

  Widget buildRow(int index, String item) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: TextField(
        controller: TextEditingController(text: item),
        onChanged: (text) => choices[index] = text,
        decoration: InputDecoration(
          hintText: "${index + 1}. Seçenek",
          border: InputBorder.none,
          icon: Icon(Icons.radio_button_unchecked),
          suffixIcon: index > 1
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => onDeleteItem(index),
                  color: Colors.grey,
                  splashRadius: 24,
                )
              : null,
        ),
      ),
    );
  }

  Future<bool> onClickClose() async {
    if (!isAnythingInserted) {
      Navigator.of(context).pop();
      return true;
    }
    var isConfirmed = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Uyarı"),
              content: Text(
                  "Çıkarsanız oluşturmakta olduğunuz anket taslağı silinecektir. Onaylıyor musunuz?"),
              actions: [
                TextButton(
                  child: Text("İptal"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Evet"),
                  onPressed: () {
                    isConfirmed = true;
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
    if (isConfirmed) Navigator.of(context).pop();
    return isConfirmed;
  }

  Future<void> onClickComplete() async {
    if (!isSurveyNameInserted) {
      context.snackbar("Anket ismini yazmanız gerekmekte!");
      return;
    }

    if (!isAllInserted) {
      context.snackbar("Tüm seçenekleri doldurmanız gerekmekte!");
      return;
    }

    final title = surveyNameController.text;
    final newSurvey = await dbHelper.createNewSurvey(title, choices);

    Navigator.pop(context, newSurvey);
  }

  void onClickAdd() {
    //add new radio button
    if (isAllInserted)
      setState(() => choices.add(""));
    else
      context.snackbar("Lütfen önce tüm seçenekleri doldurun");
  }

  void onDeleteItem(int index) {
    setState(() {
      print("item deleted: ${choices.removeAt(index)}");
      print(choices);
    });
  }

  Future<bool> _onWillPop() => onClickClose();
}
