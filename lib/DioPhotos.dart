import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_http_1/main.dart';
import 'package:http/http.dart' as http;

class DioPhotos extends StatefulWidget {
  const DioPhotos({Key? key}) : super(key: key);

  @override
  State<DioPhotos> createState() => _DioPhotosState();
}

class _DioPhotosState extends State<DioPhotos> {
  List l = [];
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      l=jsonDecode(response.body);
      setState(() {
        status = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dio Photos"),
          ),
          body: status
              ? ListView.builder(
            itemCount: l.length,
            itemBuilder: (context, index) {
              model m = model.fromJson(l[index]);
              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "albumId :${m.albumId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "id :${m.id}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "title :${m.title}",
                      ),
                      Text(
                        "url :${m.url}",
                      ),
                      Text(
                        "thumbnailUrl :${m.thumbnailUrl}",
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return demo();
      },
    ));
    return Future.value();
  }
}

class model {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  model({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  model.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumId'] = this.albumId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}
