import 'package:github_search/func/base_network.dart';

class UserDataSource {
  static UserDataSource instance = UserDataSource();
  Future<Map<String, dynamic>> loadUser(String username) {
    return BaseNetwork.get("users/" + username);
  }
}