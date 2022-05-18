import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class RepoPage extends StatefulWidget {
  final String username;

  const RepoPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _RepoPageState createState() => _RepoPageState();
}

class _RepoPageState extends State<RepoPage> {
  @override
  void initState() {
    super.initState();
    getJsonRepo(widget.username);
  }

  var repo = [];
  var repoCount = 0;
  bool isLoading = true;

  void getJsonRepo(String username) async {
    var response = await http
        .get(Uri.parse('https://api.github.com/users/' + username + '/repos'));
    setState(() {
      isLoading = false;
      repo = json.decode(response.body);
      repoCount = repo.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    if (repoCount > 0) {
      return ListView.builder(
          itemCount: repo.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemRepo(repo[index]["name"], repo[index]["html_url"]);
          });
    } else {
      return const Center(
        child: Text("this account doesn't have repositories yet"),
      );
    }
  }

  Widget _buildItemRepo(String name, String url) {
    return Card(
      child: InkWell(
        onTap: () {
          _goUrl(url);
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
