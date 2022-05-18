import 'package:flutter/material.dart';
import 'package:github_search/user_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:github_search/model/database_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Box<SearchHistory> histDB = Hive.box<SearchHistory>('Search_History');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildHistoryList()],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ValueListenableBuilder(
      valueListenable: histDB.listenable(),
      builder: (BuildContext context, Box<dynamic> value, Widget? child) {
        if (value.isEmpty) {
          return const Center(
              child: Text(
            'No Search History',
          ));
        }
        return Expanded(
          child: ListView.builder(
            itemCount: histDB.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  background: Container(
                    color: Colors.grey,
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    histDB.deleteAt(index);
                  },
                  child: _buildItemHistory(histDB.getAt(index)!.username, histDB.length, index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItemHistory(String username, int count, int index) {
    if(count-1 == index) {
      return Card(
        child: InkWell(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) => UserPage(username: username),
            );
            Navigator.of(context).push(route);
          },
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(username),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
