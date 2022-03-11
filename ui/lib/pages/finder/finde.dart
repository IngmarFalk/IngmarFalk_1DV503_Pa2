import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinderScreen extends ConsumerWidget {
  static const String id = "/finder_screen";
  const FinderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Finder."),
        ),
      ),
    );
  }
}
