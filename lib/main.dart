import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> data = [];
  List _filteredData = [];

// this wont work in this api call because data list donot contain a single type of list items, it is a map type of data so each item should be accessed using key
  // void filterData(String query) {
  //   _filteredData = data
  //       .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   print("Filtered data: $_filteredData");
  // }

  // this will access the name and email of map type of api data and checks if these contains user queries or not
  void filterData(String query) {
    _filteredData = data.where((element) {
      // as there are key value pairs in a list, required string data should be assigned to a variable first
      String name = element["name"];
      String email = element["email"];
      return name.toLowerCase().contains(query.toLowerCase()) ||
          email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = 'https://jsonplaceholder.typicode.com/users';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        _filteredData = data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController _textEditingController = TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('API List Searching'),
          ),
          body: Column(
            children: [
              TextField(
                // controller: _textEditingController,
                onChanged: (query) => setState(() {
                  // no need to use textediting controller because here query is already a updated text in the textfield
                  // query = _textEditingController.text;
                  filterData(query);
                }),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredData[index]["name"]),
                      subtitle: Text(_filteredData[index]['email']),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
