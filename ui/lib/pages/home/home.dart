import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/pages/home/navbar.dart';
import 'package:ui/pages/home/projects_view.dart';
import 'package:ui/pages/home/sidebar.dart';
import 'package:ui/theme/colors.dart';

const double navBarHeight = 100;
const double sideBarWidth = 200;
const double margin = 10;

class Home extends ConsumerWidget {
  static const String id = "/";
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          color: kcIceBlue.withOpacity(.5),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: NavBar(
                  height: navBarHeight,
                  width: size.width - margin * 2,
                ),
              ),
              Positioned(
                top: navBarHeight + margin,
                left: 0,
                child: SideBar(
                  width: sideBarWidth,
                  height: size.height - navBarHeight - margin * 3,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: ProjectsView(
                  width: size.width - sideBarWidth - margin * 3,
                  height: size.height - navBarHeight - margin * 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
