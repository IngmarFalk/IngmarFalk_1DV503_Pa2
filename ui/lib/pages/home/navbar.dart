import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/theme/colors.dart';

class NavBar extends ConsumerWidget {
  final double height;
  final double width;

  const NavBar({
    this.height = 100,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF009dae),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
