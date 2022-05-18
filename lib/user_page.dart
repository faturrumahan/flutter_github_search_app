import 'package:flutter/material.dart';
import 'package:github_search/repo_page.dart';
import 'package:github_search/followers_page.dart';
import 'package:github_search/following_page.dart';
import 'package:github_search/func/data_source.dart';
import 'package:github_search/model/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  final String username;

  const UserPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserData(widget.username),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            _goUrl('https://github.com/' + widget.username);
          },
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn.icon-icons.com/icons2/2429/PNG/512/github_logo_icon_147285.png',
                    height: 15,
                  ),
                  const Text(
                    ' Github Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserData(String username) {
    return FutureBuilder(
      future: UserDataSource.instance.loadUser(username),
      builder: (
        BuildContext context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          UserModel userModel = UserModel.fromJson(snapshot.data);
          return Center(child: _buildSuccessUserSection(userModel));
        }
        return Center(child: _buildLoadingSection());
      },
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessUserSection(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(user.avatarUrl ??
                      "https://cdn.iconscout.com/icon/free/png-256/data-not-found-1965034-1662569.png"),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Column(
                    children: [
                      Text("${user.publicRepos}"),
                      const Text(
                        "Repos",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RepoPage(username: widget.username),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Column(
                    children: [
                      Text("${user.followers}"),
                      const Text(
                        "Followers",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FollowersPage(username: widget.username),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Column(
                    children: [
                      Text("${user.following}"),
                      const Text(
                        "Following",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FollowingPage(username: widget.username),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _buildProfileInfo(user),
      ],
    );
  }

  Widget _buildProfileInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.login ?? "NOT FOUND",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(
          height: 1,
        ),
        Text(user.name ?? ""),
        const SizedBox(
          height: 1,
        ),
        Text(user.location ?? ""),
        const SizedBox(
          height: 1,
        ),
        Text(user.bio ?? ""),
        // _githubButton(user.htmlUrl),
      ],
    );
  }

  // Widget _githubButton(String? url) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       _goUrl(url);
  //     },
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.network(
  //           'https://cdn.icon-icons.com/icons2/2429/PNG/512/github_logo_icon_147285.png',
  //           height: 15,
  //         ),
  //         const Text(' Github Page')
  //       ],
  //     ),
  //   );
  // }

  _goUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
