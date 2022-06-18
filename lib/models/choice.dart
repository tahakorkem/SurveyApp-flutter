import 'package:cloud_firestore/cloud_firestore.dart';

class Choice {
  String id;
  String name;
  List<String> voterIds;

  int get voteCount => voterIds.length;

  Choice(this.id, this.name, this.voterIds);

  Choice.fromDocSnapshot(QueryDocumentSnapshot snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        voterIds = List<String>.from(snapshot['voters']);

  @override
  String toString() {
    return 'Choice{id: $id, name: $name, voterIds: $voterIds}';
  }
}
