import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "JSON App",
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final String URL = "https://swapi.co/api/people";
  List data;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    submitting = true;
    var response = await http.get(
        // Encode the URL
        Uri.encodeFull(URL),
        headers: {"Accept": "application/json"});
    
    print("Main Response");
    print(response);

    if (response.statusCode == 200) {
      submitting = false;
      setState(() {
        var convertDataToJSON = jsonDecode(response.body);
        data = convertDataToJSON['results'];
        print("JSON RESPONSE");
        print(convertDataToJSON);
      });
    } else {
      print("No Data found");
    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("JSON App"),
      ),
      body: !submitting
          ? new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Center(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Card(
                          child: new Container(
                            child: new Text(data[index]['name']),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : const Center(child: const CircularProgressIndicator()),
    );
  }
}
