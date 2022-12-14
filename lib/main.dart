import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String photoThumbnail = "https://randomuser.me/api/portraits/men/4.jpg";
  String photoLarge = "https://randomuser.me/api/portraits/men/4.jpg";

  final List<String> photoThumbnailList = <String>[];
  final List<String> photoLargeList = <String>[];
  final List<String> titleNameList = <String>[];
  final List<String> firstNameList = <String>[];
  final List<String> lastNameList = <String>[];
  Future<String> getData() async {
    var response = await http.get(Uri.parse("https://randomuser.me/api/"),
        headers: {"Accept": "application/json"});
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        photoThumbnail = map["results"][0]["picture"]["thumbnail"];
        photoLarge = map["results"][0]["picture"]["large"];
        String titleName = map["results"][0]["name"]["title"];
        String firstName = map["results"][0]["name"]["first"];
        String lastName = map["results"][0]["name"]["last"];
        setState(() {
          photoThumbnailList.add(photoThumbnail);
          photoLargeList.add(photoThumbnail);
          titleNameList.add(titleName);
          firstNameList.add(firstName);
          lastNameList.add(lastName);
        });
      } else {
        throw Exception('Failed to load the api');
      }
    } on Exception catch (error) {
      print(error);
    }
    // print(firstNameList);
    return "Okey";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            ElevatedButton(
              onPressed: getData,
              child: new Text("New Photo"),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: titleNameList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Image(image: NetworkImage(photoThumbnailList[index])),
                    Container(width: 100, child: Text(titleNameList[index])),
                    Container(width: 100, child: Text(firstNameList[index])),
                    Container(width: 100, child: Text(lastNameList[index])),
                  ],
                );
              },
            )
          ],
        ));
  }
}
