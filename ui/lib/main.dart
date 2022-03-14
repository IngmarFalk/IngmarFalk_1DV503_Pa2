import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui/pages/home/center_view/projects_view.dart';
import 'package:ui/pages/home/home.dart';
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

class InheritedLoginProviderWrapper extends StatefulWidget {
  final Widget child;
  InheritedLoginProviderWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<InheritedLoginProviderWrapper> createState() =>
      _InheritedLoginProviderWrapperState();
}

class _InheritedLoginProviderWrapperState
    extends State<InheritedLoginProviderWrapper> {
  Map<String, dynamic> userData = {};
  bool isLoggedIn = false;

  void setIsLoggedIn(bool val, Map<String?, dynamic> userData) {
    setState(() {
      isLoggedIn = val;
      userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedLoginProvider(
      child: widget.child,
      data: this,
      isLoggedIn: isLoggedIn,
    );
  }
}

class InheritedLoginProvider extends InheritedWidget {
  final bool isLoggedIn;
  final Widget child;
  final _InheritedLoginProviderWrapperState data;

  const InheritedLoginProvider({
    required this.data,
    required this.isLoggedIn,
    required this.child,
    Key? key,
  }) : super(key: key, child: child);

  static _InheritedLoginProviderWrapperState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedLoginProvider>()!
        .data;
  }

  @override
  bool updateShouldNotify(covariant InheritedLoginProvider oldWidget) {
    return isLoggedIn != oldWidget.isLoggedIn;
  }
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InheritedLoginProviderWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          Home.id: (context) => Home(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          CreateProjectPage.id: (context) => const CreateProjectPage(),
        },
        initialRoute: Home.id,
      ),
    );
  }
}
