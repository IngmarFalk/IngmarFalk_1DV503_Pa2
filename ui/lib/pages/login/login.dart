import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/pages/register/register.dart';
import 'package:ui/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:ui/widgets/widgets.dart';

const url = '194.47.188.32';

class LoginScreen extends ConsumerWidget {
  static const String id = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kcIceBlue.withOpacity(.17),
        body: Center(
          child: SizedBox(
            width: 450,
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends HookWidget {
  LoginForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _saveAndValidate() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
  }

  List<Widget> buildLoginTextFields({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return [
      CustomTextField(
        inputType: TextInputType.emailAddress,
        hintText: "email",
        controller: emailController,
        prefixIcon: const Icon(Icons.email),
      ),
      const SizedBox(height: 20),
      CustomTextField(
        inputType: TextInputType.text,
        hintText: "password",
        controller: passwordController,
        prefixIcon: const Icon(Icons.key),
        suffixIcon: const Icon(Icons.visibility),
        obscureText: true,
      )
    ];
  }

  List<Widget> buildLoginButtons({
    required BuildContext context,
    required Map<String, String> loginData,
  }) {
    return [
      CustomTextButton(
        borderRadius: BorderRadius.circular(0),
        onTap: () async {
          String jsonData = json.encode(loginData);
          await _saveAndValidate();

          var rs = await http.post(
            Uri.parse('http://127.0.0.1:8000/login/'),
            body: jsonData,
            headers: {"Content-type": "application/json"},
          );

          if (json.decode(rs.body)["msg"] == "") {
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const LoginErrorPopUp();
              },
            );
          }
        },
        text: "S I G N   I N", // "L O G I N"
      ),
      const SizedBox(height: 10),
      CustomTextButton(
        borderRadius: BorderRadius.circular(0),
        onTap: () {
          Navigator.pushNamed(context, RegisterScreen.id);
        },
        text: "R E G I S T E R",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final email = useState<String>('');
    final pw = useState<String>('');

    useEffect(
      () {
        emailController.addListener(() {
          email.value = emailController.text;
        });
        passwordController.addListener(() {
          pw.value = passwordController.text;
        });
        return null;
      },
      [emailController, passwordController],
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...buildLoginTextFields(
            emailController: emailController,
            passwordController: passwordController,
          ),
          const SizedBox(height: 40),
          ...buildLoginButtons(
            context: context,
            loginData: {"email": email.value, "password": pw.value},
          ),
        ],
      ),
    );
  }
}

class LoginErrorPopUp extends StatelessWidget {
  const LoginErrorPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Failed!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text('No such user exists.'),
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
