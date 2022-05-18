import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_search/user_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FollowersPage extends StatefulWidget {
  final String username;

  const FollowersPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  void initState() {
    super.initState();
    getJsonFollower(widget.username);
  }

  var follower = [];
  var followerCount = 0;
  bool isLoading = true;

  void getJsonFollower(String username) async {
    var response = await http.get(
        Uri.parse('https://api.github.com/users/' + username + '/followers'));
    setState(() {
      isLoading = false;
      follower = json.decode(response.body);
      followerCount = follower.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    if (followerCount > 0) {
      return ListView.builder(
          itemCount: follower.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemFollowers(follower[index]["login"], follower[index]["html_url"]);
          });
    } else {
      return const Center(
        child: Text("this account doesn't have followers yet"),
      );
    }
  }

  Widget _buildItemFollowers(String name, String url) {
    return Card(
      child: InkWell(
        onTap: () {
          // _goUrl(url);
          var route = MaterialPageRoute(
            builder: (BuildContext context) =>
                UserPage(username: name),
          );
          Navigator.of(context).push(route);
        },
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(name),
            ],
          ),
        ),
      ),
    );
  }

  _goUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
