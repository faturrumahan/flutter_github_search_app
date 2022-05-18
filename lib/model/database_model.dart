import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'database_model.g.dart';

@HiveType(typeId: 0)
class SearchHistory extends HiveObject {
  @HiveField(0)
  final String username;

  SearchHistory({required this.username});

  @override
  String toString() {
    return 'SearchHistory{username: $username}';
  }
}
