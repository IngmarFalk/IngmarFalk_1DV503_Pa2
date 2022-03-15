import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ui/pages/home/home.dart';

Future<void> fetch({
  required SideBarChoiceNotifier choice,
  required TextEditingController teController,
}) async {
  Uri url;
  String jsonData;
  if (choice.choice == SideBarChoice.projects) {
    url = Uri.parse('http://127.0.0.1:8000/projects/');
    jsonData = json.encode({"project_name": teController.text});
  } else if (choice.choice == SideBarChoice.orgs) {
    url = Uri.parse('http://127.0.0.1:8000/orgs/');
    jsonData = json.encode({"org_name": teController.text});
  } else {
    return;
  }
  // var url = choice.choice == SideBarChoice.projects
  //     ? Uri.parse('http://127.0.0.1:8000/projects/')
  //     : Uri.parse('http://127.0.0.1:8000/orgs/');
  // String jsonData = choice.choice == SideBarChoice.projects
  //     ? json.encode({"project_name": teController.text})
  //     : json.encode({"org_name": teController.text});

  var resp = await http.post(
    url,
    body: jsonData,
    headers: {"Content-type": "application/json"},
  );

  // await Future.delayed(Duration(milliseconds: 2000));

  choice.rs = json.decode(resp.body);
  // for (var i = 0; i < choice.rs["msg"].length; i++) {
  //   print(choice.rs["msg"][i]);
  // }
}
