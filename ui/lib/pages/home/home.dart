import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/pages/home/center_view/projects_view.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

const double navBarHeight = 100;
const double sideBarWidth = 200;
const double margin = 10;

enum SideBarChoice { orgs, projects, tasks }

class SideBarChoiceNotifier extends ChangeNotifier {
  SideBarChoice _choice = SideBarChoice.projects;
  var _rs = "";

  SideBarChoice get choice => _choice;
  get rs => _rs;

  set choice(SideBarChoice choice) {
    _choice = choice;
    notifyListeners();
  }

  set rs(var newRs) {
    _rs = newRs;
    notifyListeners();
  }
}

class Home extends ConsumerWidget {
  static const String id = "/";
  Home({Key? key}) : super(key: key);

  final _choiceNotifier = ChangeNotifierProvider<SideBarChoiceNotifier>(
    (ref) => SideBarChoiceNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choice = ref.watch(_choiceNotifier);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          color: kcIceBlue.withOpacity(1),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: NavBar(
                  pageName: "H O M E",
                  // color: kcIceBlue.withOpacity(.1),
                  height: navBarHeight,
                  width: size.width - margin * 2,
                ),
              ),
              Positioned(
                top: navBarHeight + margin,
                left: 0,
                child: SideBar(
                  choice: choice,
                  color: kcIceBlue.withOpacity(.1),
                  width: sideBarWidth,
                  height: size.height - navBarHeight - margin * 3,
                ),
              ),
              Positioned(
                bottom: 0,
                right: sideBarWidth + margin,
                child: CenterView(
                  choice: choice,
                  width: size.width - (sideBarWidth + margin * 3) * 2,
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
