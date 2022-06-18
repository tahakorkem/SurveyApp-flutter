import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/models/user.dart';

class Survey {
  final String id;
  final String name;
  final User creator;
  final DateTime createdAt;
  final int totalVoteCount;

  Survey(this.id, this.name, this.creator, this.createdAt, this.totalVoteCount);

  Survey.fromDocSnapshot(DocumentSnapshot snapshot, User creator, int totalVoteCount)
      : id = snapshot.id,
        name = snapshot['name'],
        createdAt = snapshot['createdAt'].toDate(),
        creator = creator,
        totalVoteCount = totalVoteCount;

  @override
  String toString() {
    return 'Survey{id: $id, name: $name, creator: $creator, createdAt: $createdAt}';
  }
}
