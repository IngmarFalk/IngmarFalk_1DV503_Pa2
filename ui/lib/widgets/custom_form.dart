part of widgets;

enum FormType {
  login,
  register,
  createProject,
  createOrganization,
  search,
}

class CustomForm extends HookConsumerWidget {
  final FormType type;
  final Map<String, CustomTextField> fields;
  final List<String> urls;
  final List<String> buttonTexts;
  final List<CustomTextButton>? buttons;
  CustomForm({
    Key? key,
    required this.type,
    required this.urls,
    required this.buttonTexts,
    required this.fields,
    this.buttons,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _loginProvider = ChangeNotifierProvider<LoginNotifier>(
    (ref) => LoginNotifier(),
  );

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
    required LoginNotifier lnNotifier,
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

            var resp = await http.post(
              Uri.parse(urls[idx]),
              body: jsonData,
              headers: {"Content-type": "application/json"},
            );
            String msg = json.decode(resp.body)["msg"];

            if (msg == "") {
              if (type == FormType.login) {
                InheritedLoginProvider.of(context).setIsLoggedIn(true);
              }
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ErrorPopUp(
                    msg: msg,
                  );
                },
              );
            }
          },
          text: texts[idx],
        ),
      ),
      ...?buttons,
      CustomTextButton(
        text: "C A N C E L",
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(_loginProvider);
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
            lnNotifier: loggedIn,
            texts: buttonTexts,
            urls: urls,
            context: context,
            data: data,
            buttons: buttons,
          ),
        ],
      ),
    );
  }
}

class ErrorPopUp extends StatelessWidget {
  final String msg;

  const ErrorPopUp({
    required this.msg,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: const Text('Login Failed!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(msg),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
