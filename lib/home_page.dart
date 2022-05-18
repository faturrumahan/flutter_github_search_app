import 'package:flutter/material.dart';
import 'package:github_search/history_page.dart';
import 'package:github_search/model/database_model.dart';
import 'package:github_search/user_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  Box<SearchHistory> histDB = Hive.box<SearchHistory>('Search_History');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn.icon-icons.com/icons2/2429/PNG/512/github_logo_icon_147285.png',
              height: 90,
            ),
            const SizedBox(
              height: 20,
            ),
            _buildForm()
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter Username',
              filled: true,
              fillColor: Colors.white,
              labelText: 'Github Username',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                histDB.add(SearchHistory(username: usernameController.text));
                var route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UserPage(username: usernameController.text),
                );
                Navigator.of(context).push(route);
              }
            },
            child: const Text('Search'),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: const Text(
              'History',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onTap: (){
              var route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    HistoryPage(),
              );
              Navigator.of(context).push(route);
            },
          )
        ],
      ),
    );
  }
}
