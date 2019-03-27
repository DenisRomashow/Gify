import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wellcome to Giphy",
      home: new Scaffold(appBar: new AppBar(title: new Text('Giphy'),
      ), body: new Center(child: new GiphyCollectionPage()),
      )
    );
  }
}

class GiphyCollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GiphyCollectionState();
  }
}

class GiphyCollectionState extends State<GiphyCollectionPage> {

  List gifs = [];

  @override
  void initState() {
    super.initState();

    searchGifs("cheeseburgers");
  }

  searchGifs(String search) async {
    String host = "https://api.giphy.com";
    String path = "/v1/gifs/search?api_key=FjfZ2BL5R2FZG8uYk73Ww453OBDvaP5y&q="+search;
    String url = host+path;

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        gifs = jsonResponse["data"];
      });

      print(jsonResponse["data"]);
    } else {
      print("something goes wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gifs.length == 0) {
      return new Text("Loading");
    } else {
      return GridView.count(crossAxisCount: 2,
          children: List.generate(gifs.length, (i) {
            return _buildRow(gifs[i]["id"]);
          })
      );
    };
  }

  Widget _buildRow(String data) {
    return new ListTile(title: new Text(data),);
  }
}