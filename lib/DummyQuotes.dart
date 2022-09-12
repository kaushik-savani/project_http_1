import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_http_1/main.dart';
import 'package:http/http.dart' as http;


class DummyQuotes extends StatefulWidget {
  const DummyQuotes({Key? key}) : super(key: key);

  @override
  State<DummyQuotes> createState() => _DummyQuotesState();
}

class _DummyQuotesState extends State<DummyQuotes> {
  Map<String, dynamic> m = {};
  bool status = false;
  dummy? d;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      var url = Uri.parse('https://dummyjson.com/quotes');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      m=jsonDecode(response.body);
      d=dummy.fromJson(m);
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
            title: Text("Dummy Quotes"),
          ),
          body: status
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("quotes :"),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: d!.quotes!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Text("${d!.quotes![index].id}"),
                        title: Text("${d!.quotes![index].author}"),
                        subtitle: Text("${d!.quotes![index].quote}"),
                      ),
                    );
                  },
                ),
                Text("total :${d!.total}"),
                Text("skip :${d!.skip}"),
                Text("limit :${d!.limit}"),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator()),
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

class dummy {
  List<Quotes>? quotes;
  int? total;
  int? skip;
  int? limit;

  dummy({this.quotes, this.total, this.skip, this.limit});

  dummy.fromJson(Map<String, dynamic> json) {
    if (json['quotes'] != null) {
      quotes = <Quotes>[];
      json['quotes'].forEach((v) {
        quotes!.add(new Quotes.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.quotes != null) {
      data['quotes'] = this.quotes!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }
}

class Quotes {
  int? id;
  String? quote;
  String? author;

  Quotes({this.id, this.quote, this.author});

  Quotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quote = json['quote'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quote'] = this.quote;
    data['author'] = this.author;
    return data;
  }
}
