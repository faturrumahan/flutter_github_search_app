import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_search/user_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FollowingPage extends StatefulWidget {
  final String username;

  const FollowingPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  void initState() {
    super.initState();
    getJsonFollowing(widget.username);
  }

  var following = [];
  var followingCount = 0;
  bool isLoading = true;

  void getJsonFollowing(String username) async {
    var response = await http.get(
        Uri.parse('https://api.github.com/users/' + username + '/following'));
    setState(() {
      isLoading = false;
      following = json.decode(response.body);
      followingCount = following.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    if (followingCount > 0) {
      return ListView.builder(
          itemCount: following.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemFollowing(
                following[index]["login"], following[index]["html_url"]);
          });
    } else {
      return const Center(
        child: Text("this account doesn't have following yet"),
      );
    }
  }

  Widget _buildItemFollowing(String name, String url) {
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
