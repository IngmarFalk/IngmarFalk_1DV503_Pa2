import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/theme/colors.dart';
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
            child: CustomForm(
              type: FormType.register,
              fields: {
                "username": CustomTextField(
                  autofillHints: AutofillHints.username,
                  hintText: "username",
                  prefixIcon: const Icon(Icons.app_registration_sharp),
                ),
                "firstname": CustomTextField(
                  hintText: "first name",
                  prefixIcon: const Icon(Icons.person),
                ),
                "lastname": CustomTextField(
                  hintText: "second name",
                  prefixIcon: const Icon(Icons.person),
                ),
                "email": CustomTextField(
                  autofillHints: AutofillHints.email,
                  hintText: "email",
                  prefixIcon: const Icon(Icons.email),
                ),
                "password": CustomTextField(
                  autofillHints: AutofillHints.password,
                  hintText: "password",
                  prefixIcon: const Icon(Icons.key),
                  obscureText: true,
                ),
              },
              buttonTexts: const ["R E G I S T E R"],
              urls: const ["http://127.0.0.1:8000/register/"],
            ),
          ),
        ),
      ),
    );
  }
}
