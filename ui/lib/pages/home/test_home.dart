import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const url = 'localhost:8000';
const url = '127.0.0.1:8000';

class TestHome extends StatefulWidget {
  const TestHome({Key? key}) : super(key: key);

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  String resp = "Hello";

  static Future<T?> getJson<T>(String url) {
    return http
        .get(Uri.http(url, ""))
        .timeout(const Duration(milliseconds: 100))
        .then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      }
      log('Status Code : ${response.statusCode}...');
      return null;
    }).catchError((err) {
      log('$url ${err.toString()}');
      return null;
    });
  }

  FutureOr<Map<String, dynamic>?> fetch() async {
    await getJson<Map<String, dynamic>>(url).then((response) {
      setState(() {
        resp = (response != null) ? response['f'] : null;
      });
    }).whenComplete(() {
      log('Fetching done!....');
      return null;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                resp,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.deepPurple[500],
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () async {
                  await fetch();
                },
                child: const Text("G E T"),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {},
                child: const Text("P O S T"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
