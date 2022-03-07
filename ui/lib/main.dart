import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/pages/home/projects_view.dart';
import 'package:ui/pages/login/login.dart';
import 'package:ui/pages/register/register.dart';

// const url = 'localhost:8000';
// const url = 'http://192.168.1.136:8000/';
// const url = 'http://127.0.0.1:8888';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        Home.id: (context) => const Home(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        CreateProjectPage.id: (context) => const CreateProjectPage(),
      },
      initialRoute: LoginScreen.id,
    );
  }
}
