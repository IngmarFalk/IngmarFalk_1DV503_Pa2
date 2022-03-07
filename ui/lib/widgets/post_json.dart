part of widgets;

Future<void> postJson(
  Map<String, dynamic> data,
  String url,
) async {
  String jsonData = json.encode(data);

  await http.post(
    Uri.parse(url),
    body: jsonData,
    headers: {"Content-type": "application/json"},
  );

  // TODO : Implement a check in python that validates the input
  // TODO : and returns a boolean if the process was successful.
}
