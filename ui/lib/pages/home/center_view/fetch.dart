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
  } else if (choice.choice == SideBarChoice.tasks) {
    url = Uri.parse('http://127.0.0.1:8000/tasks/');
    jsonData = json.encode({"title": teController.text});
  } else {
    return;
  }

  var resp = await http.post(
    url,
    body: jsonData,
    headers: {"Content-type": "application/json"},
  );

  choice.rs = json.decode(resp.body);
}
