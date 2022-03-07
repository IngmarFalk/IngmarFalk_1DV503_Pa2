part of widgets;

class CreateProjectForm extends HookWidget {
  final Map<String, CustomTextField> fields;
  final List<String> urls;
  final List<String> buttonTexts;
  final List<CustomTextButton>? buttons;
  CreateProjectForm({
    required this.urls,
    required this.buttonTexts,
    required this.fields,
    this.buttons,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _saveAndValidate() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
  }

  List<Widget> buildLoginTextFields({
    required List<CustomTextField> fields,
    required List<TextEditingController> controllers,
  }) {
    return List.generate(controllers.length, (idx) {
      fields[idx].controller = controllers[idx];
      return fields[idx];
    });
  }

  List<Widget> buildLoginButtons({
    required BuildContext context,
    required Map<String?, String> data,
    required List<String> urls,
    required List<String> texts,
    List<CustomTextButton>? buttons,
  }) {
    return [
      ...List.generate(
        texts.length,
        (idx) => CustomTextButton(
          borderRadius: BorderRadius.circular(0),
          onTap: () async {
            String jsonData = json.encode(data);
            await _saveAndValidate();

            await http.post(
              Uri.parse(urls[idx]),
              body: jsonData,
              headers: {"Content-type": "application/json"},
            );

            // TODO : Implement a check in python that validates the input
            // TODO : and returns a boolean if the process was successful.
            // If validation is successful, it should navigate to the home page.
            Navigator.pop(context);
          },
          text: texts[idx],
        ),
      ),
      ...?buttons,
    ];
  }

  @override
  Widget build(BuildContext context) {
    int nrc = fields.length;
    List<TextEditingController> _controllers = List.generate(
      nrc,
      (_) => useTextEditingController(),
    );
    List<ValueNotifier<String>> _notifiers = List.generate(
      nrc,
      (_) => useState(''),
    );

    useEffect(
      () {
        for (int i = 0; i < _controllers.length; i++) {
          _controllers[i].addListener(() {
            _notifiers[i].value = _controllers[i].text;
          });
        }
        return null;
      },
      [..._controllers],
    );
    Map<int, String> keys = fields.entries.map((e) => e.key).toList().asMap();

    Map<String?, String> data = {};
    for (int i = 0; i < fields.length; i++) {
      data[keys[i]] = _notifiers[i].value;
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...buildLoginTextFields(
            fields: fields.entries.map((e) => e.value).toList(),
            controllers: _controllers,
          ),
          const SizedBox(height: 40),
          ...buildLoginButtons(
            texts: buttonTexts,
            urls: urls,
            context: context,
            data: data,
          ),
        ],
      ),
    );
  }
}
