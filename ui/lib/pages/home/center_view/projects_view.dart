import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/main.dart';
import 'package:ui/pages/home/center_view/fetch.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/pages/home/center_view/filter_options.dart';
import 'package:ui/pages/home/center_view/search_field.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class CenterView extends ConsumerWidget {
  final double height;
  final double width;
  final SideBarChoiceNotifier choice;
  final TextEditingController teController;
  CenterView({
    required this.teController,
    required this.choice,
    this.height = 500,
    this.width = 500,
    Key? key,
  }) : super(key: key);

  final _filteringNotifier = ChangeNotifierProvider<FilterButtonNotifier>(
    (ref) => FilterButtonNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final TextEditingController _teController = useTextEditingController();
    Size size = MediaQuery.of(context).size;
    final filtering = ref.watch(_filteringNotifier);

    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: kcLightBlue,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  FilterButton(
                    filteringNotifier: _filteringNotifier,
                  ),
                  Expanded(
                    child: SearchField2(
                      teController: teController,
                      choice: choice,
                      size: size,
                    ),
                  ),
                ],
              ),
            ),
          ),
          filtering.filtering
              ? Positioned(
                  top: 50,
                  left: 0,
                  child: FilterOptions(
                      filteringNotifier: _filteringNotifier,
                      options: const [
                        {
                          "name": "Creation Date",
                          "options": [
                            "last 30 days",
                            "last 3 months",
                            "last 6 months",
                            "last year",
                            "all time"
                          ]
                        },
                        {
                          "name": "Status",
                          "options": [
                            "active",
                            "production",
                            "planning",
                            "development"
                          ]
                        },
                        {
                          "name": "Field",
                          "options": [
                            "tech",
                            "car",
                            "entertainment",
                          ]
                        },
                      ]),
                )
              : const SizedBox(),
          // SearchButton(
          //   filteringNotifier: _filteringNotifier,
          // ),
          Container(
            margin: const EdgeInsets.only(top: 52),
            child: CenterViewTile(
              choice: choice,
            ),
          ),
          // CenterViewTile(
          //   choice: choice,
          // ),
        ],
      ),
    );
  }
}

class DescriptionToggleNotifier extends ChangeNotifier {
  bool _open = false;

  bool get open => _open;

  set open(bool val) {
    _open = val;
    notifyListeners();
  }
}

class CenterViewTile extends ConsumerWidget {
  final SideBarChoiceNotifier choice;
  final double height;
  final double width;
  final EdgeInsets? padding, margin;
  final Color textColor, backgroundColor;
  final Color? accentColor;
  const CenterViewTile({
    required this.choice,
    this.height = 500,
    this.width = 500,
    this.padding,
    this.margin,
    this.textColor = kcDarkBlue,
    this.backgroundColor = Colors.white,
    this.accentColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int itemCount = 0;
    List<dynamic>? items = [];
    if (choice.rs != null) {
      itemCount = choice.rs["msg"].length;
      items = choice.rs["msg"];
    }

    return items == null
        ? const SizedBox()
        : ListView.builder(
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int idx) {
              Map<String, dynamic> data = {};
              if (choice.choice == SideBarChoice.projects) {
                data = {
                  "id": items![idx][0],
                  "name": items[idx][1],
                  "description": items[idx][2],
                  "dueData": items[idx][3],
                  "creationDate": items[idx][4],
                  "status": items[idx][5],
                  "developers": items[idx][6],
                };
              } else if (choice.choice == SideBarChoice.orgs) {
                data = {
                  "name": items![idx][0],
                  "field": items[idx][1],
                  "description": items[idx][2],
                  "developers": items[idx][3],
                };
              }
              return Tile(data: data);
            },
          );
  }
}

class Tile extends ConsumerWidget {
  Tile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final _toggleDescriptionProvider =
      ChangeNotifierProvider<DescriptionToggleNotifier>(
    (ref) => DescriptionToggleNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDescriptionOpen = ref.watch(_toggleDescriptionProvider);

    List<Widget> descriptionItems = [];

    for (MapEntry e in data.entries) {
      descriptionItems.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(
                e.key.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: kcDarkBlue,
                ),
              ),
              SelectableText(
                e.value.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: kcDarkBlue,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<bool> isPartOfOrg(Map<String?, dynamic> userData) async {
      // Send Query

      return false;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: isDescriptionOpen.open ? 200 : 100,
      width: 500,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: kcIceBlue.withOpacity(.1),
        border: Border.all(
          style: BorderStyle.solid,
          color: kcMedBlue,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.only(left: 20.0, top: 7),
                    child: SideBarItem(
                      text: "D E S C R I P T I O N",
                      onTap: () {
                        isDescriptionOpen.open = !isDescriptionOpen.open;
                      },
                      fontSize: 10,
                      color: kcLightBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: Center(
                      child: Text(
                        data["name"],
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.only(right: 20.0, top: 7),
                    child: SideBarItem(
                      text: "J O I N",
                      onTap: () {
                        if (InheritedLoginProvider.of(context).isLoggedIn ==
                            false) {
                          // Show ErrorPopUp dialog
                          return;
                        }

                        // Else send query to backend to add user to organization
                        // wait for response and if the action was successful,
                        // turn J O I N button to L E A V E button.
                      },
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isDescriptionOpen.open
              ? Expanded(
                  flex: 1,
                  child: Wrap(
                    children: [...descriptionItems],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class CreateButton extends ConsumerWidget {
  final Duration duration;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  const CreateButton({
    Key? key,
    this.duration = const Duration(milliseconds: 200),
    this.backgroundColor = kcIceBlue,
    this.padding = const EdgeInsets.all(5),
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: InkWell(
        hoverColor: kcMedBlue,
        onTap: () {
          Navigator.pushNamed(context, CreateProjectPage.id);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: duration,
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.add_box),
            ),
            const SizedBox(height: 5),
            SelectableText(
              "C R E A T E   P R O J E C T",
              style: GoogleFonts.montserrat(
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateProjectPage extends ConsumerWidget {
  static const String id = Home.id + "/create_project";

  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kcIceBlue.withOpacity(.17),
        body: Center(
          child: SizedBox(
            width: 550,
            child: CustomForm(
              type: FormType.createProject,
              fields: {
                "project_name": CustomTextField(
                  hintText: "project name",
                  prefixIcon: const Icon(Icons.house),
                ),
                "due_date": CustomTextField(
                  hintText: "due data: YYYY-MM-DD",
                  prefixIcon: const Icon(Icons.date_range),
                ),
                "description": CustomTextField(
                  height: 200,
                  hintText: "description",
                  prefixIcon: const Icon(Icons.padding_outlined),
                  maxLines: 7,
                ),
              },
              urls: const ['http://127.0.0.1:8000/create_project/'],
              buttonTexts: const ["C R E A T E"],
            ),
          ),
        ),
      ),
    );
  }
}
