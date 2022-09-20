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
  TextEditingController titleCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  final List<String> newPhotoList = [""];
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
        titleCont.text = titleName.toString();
        firstNameCont.text = firstName.toString();
        lastNameCont.text = lastName.toString();

        print(photoThumbnail);
        print(photoLarge);
        print(firstName);
        print(lastName);
        setState(() {
          // newPhotoList.add(newPhoto);
        });
        // return "Okey";
      } else {
        throw Exception('Failed to load the api');
      }
    } on Exception catch (error) {
      print(error);
    }
    return "Okey";
  }

  @override
  Widget build(BuildContext context) {
    final allWidget = Row(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Image(image: NetworkImage(photoThumbnail)),
        Container(
          width: 100,
          child: TextFormField(
            controller: titleCont,
            readOnly: true,
            decoration:
                const InputDecoration(hintText: "", border: InputBorder.none),
          ),
        ),
        Container(
          width: 100,
          child: TextFormField(
            controller: firstNameCont,
            readOnly: true,
            decoration:
                const InputDecoration(hintText: "", border: InputBorder.none),
          ),
        ),
        Container(
          width: 100,
          child: TextFormField(
            controller: lastNameCont,
            readOnly: true,
            decoration:
                const InputDecoration(hintText: "", border: InputBorder.none),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: getData,
              child: new Text("New Photo"),
            ),
            // ListView.builder(
            //   padding: const EdgeInsets.all(8),
            //   itemCount: newPhotoList.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Container();
            //   },
            // ),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [allWidget],
            )
          ],
        ));
  }
}
