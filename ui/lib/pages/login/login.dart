import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/pages/login/login_notifier.dart';
import 'package:ui/pages/register/register.dart';
import 'package:ui/theme/colors.dart';
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
            child: CustomForm(
              type: FormType.login,
              fields: {
                "email": CustomTextField(
                  hintText: "email",
                  prefixIcon: const Icon(Icons.email),
                ),
                "password": CustomTextField(
                  hintText: "password",
                  prefixIcon: const Icon(Icons.key),
                  obscureText: true,
                ),
              },
              buttonTexts: const ["L O G I N"],
              urls: const ['http://127.0.0.1:8000/login/'],
              buttons: [
                CustomTextButton(
                    text: "R E G I S T E R",
                    onTap: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
