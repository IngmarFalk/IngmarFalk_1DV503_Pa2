import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
              String name = "";
              if (choice.choice == SideBarChoice.projects) {
                // int id = items[idx][0];
                name = items![idx][1];
                // String description = items[idx][2];
                // String dueDate = items[idx][3];
                // String creationDate = items[idx][4];
                // String status = items[idx][5];
                // int nrOfDevs = items[idx][6];
              } else if (choice.choice == SideBarChoice.orgs) {
                // fetch(choice: choice, teController: teController)
                name = items![idx][0];
              }
              return Container(
                height: 100,
                width: 500,
                margin: const EdgeInsets.all(5),
                color: kcLightBlue.withOpacity(.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "D E S C R I P T I O N",
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: kcDarkBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: kcLightBlue.withOpacity(.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: Center(
                          child: Text(
                            name,
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
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Join"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );

    //           return Container();
    //         },
    //       );
    // return const CreateButton();
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
            Text(
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
