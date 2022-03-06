import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:ui/widgets/widgets.dart';

const url = '194.47.188.32';

class RegisterScreen extends ConsumerWidget {
  static const String id = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kcIceBlue.withOpacity(.17),
        body: Center(
          child: SizedBox(
            width: 550,
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends HookWidget {
  RegisterForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _saveAndValidate() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
  }

  List<Widget> buildLoginTextFields({
    required TextEditingController firstNameController,
    required TextEditingController secondNameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return [
      CustomTextField(
        hintText: "first name",
        controller: firstNameController,
        prefixIcon: const Icon(Icons.person),
      ),
      const SizedBox(height: 20),
      CustomTextField(
        hintText: "second name",
        controller: secondNameController,
        prefixIcon: const Icon(Icons.person),
      ),
      const SizedBox(height: 20),
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

          await http.post(
            Uri.parse('http://127.0.0.1:8000/login/'),
            body: jsonData,
            headers: {"Content-type": "application/json"},
          );

          // TODO : Implement a check in python that validates the input
          // TODO : and returns a boolean if the process was successful.
          // If validation is successful, it should navigate to the home page.
          Navigator.pop(context);
        },
        text: "R E G I S T E R",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final secondNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final firstName = useState<String>('');
    final secondName = useState<String>('');
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
        firstNameController.addListener((() {
          firstName.value = firstNameController.text;
        }));
        secondNameController.addListener((() {
          secondName.value = secondNameController.text;
        }));
        return null;
      },
      [
        firstNameController,
        secondNameController,
        emailController,
        passwordController
      ],
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...buildLoginTextFields(
            firstNameController: firstNameController,
            secondNameController: secondNameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
          const SizedBox(height: 40),
          ...buildLoginButtons(
            context: context,
            loginData: {email.value: pw.value},
          ),
        ],
      ),
    );
  }
}
