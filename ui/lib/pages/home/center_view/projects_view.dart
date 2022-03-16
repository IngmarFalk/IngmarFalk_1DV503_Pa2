import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/main.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/pages/home/center_view/filter_options.dart';
import 'package:ui/pages/home/center_view/search_field.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/pages/projects/create_project.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';
import 'package:http/http.dart' as http;

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
                  // FilterButton(
                  //   filteringNotifier: _filteringNotifier,
                  // ),
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
          // filtering.filtering
          //     ? Positioned(
          //         top: 50,
          //         left: 0,
          //         child: FilterOptions(
          //             filteringNotifier: _filteringNotifier,
          //             options: const [
          //               {
          //                 "name": "Creation Date",
          //                 "options": [
          //                   "last 30 days",
          //                   "last 3 months",
          //                   "last 6 months",
          //                   "last year",
          //                   "all time"
          //                 ]
          //               },
          //               {
          //                 "name": "Status",
          //                 "options": [
          //                   "active",
          //                   "production",
          //                   "planning",
          //                   "development"
          //                 ]
          //               },
          //               {
          //                 "name": "Field",
          //                 "options": [
          //                   "tech",
          //                   "car",
          //                   "entertainment",
          //                 ]
          //               },
          //             ]),
          //       )
          //     : const SizedBox(),
          DynamicCreateButton(
            filteringNotifier: _filteringNotifier,
            choice: choice,
          ),
          Container(
            margin: const EdgeInsets.only(top: 52),
            child: CenterViewTile(
              teController: teController,
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
  bool _userJoinedOrg = false;
  bool _open = false;

  bool get userJoinedOrg => _userJoinedOrg;
  bool get open => _open;

  set open(bool val) {
    _open = val;
    notifyListeners();
  }

  set userJoinedOrg(bool val) {
    _userJoinedOrg = val;
    notifyListeners();
  }

  Future<void> isPartOfOrg(
      Map<String?, dynamic>? userData, String orgName) async {
    final jsonData = json.encode(
      {
        "user_data": userData,
        "org_name": orgName,
      },
    );
    final resp = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/${userData!['email']}'),
      body: jsonData,
    );

    final String msg = json.decode(resp.body)["msg"];

    if (msg == "") {
      _userJoinedOrg = true;
      return;
    }

    _userJoinedOrg = false;
  }
}

class CenterViewTile extends ConsumerWidget {
  final SideBarChoiceNotifier choice;
  final TextEditingController teController;
  final double height;
  final double width;
  final EdgeInsets? padding, margin;
  final Color textColor, backgroundColor;
  final Color? accentColor;
  const CenterViewTile({
    required this.choice,
    required this.teController,
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

    if (items == null) {
      return const SizedBox();
    } else {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int idx) {
          Map<String, dynamic> data = {};
          if (choice.choice == SideBarChoice.projects) {
            try {
              data = {
                "id": items![idx][0],
                "name": items[idx][1],
                "description": items[idx][2],
                "dueData": items[idx][3],
                "creationDate": items[idx][4],
                "status": items[idx][5],
                "developers": items[idx][6],
              };
            } catch (e) {
              data = {};
            }
          } else if (choice.choice == SideBarChoice.orgs) {
            try {
              data = {
                "name": items![idx][0],
                "field": items[idx][1],
                "description": items[idx][2],
                "developers": items[idx][3],
              };
            } catch (e) {
              data = {};
            }
          }
          return Tile(data: data, choice: choice);
        },
      );
    }
  }
}

class Tile extends ConsumerWidget {
  Tile({
    Key? key,
    required this.data,
    required this.choice,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final SideBarChoiceNotifier choice;
  final _toggleDescriptionProvider =
      ChangeNotifierProvider<DescriptionToggleNotifier>(
    (ref) => DescriptionToggleNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(_toggleDescriptionProvider);
    final userD = InheritedLoginProvider.of(context).userData;

    if (userD != null && data != {}) {
      status.isPartOfOrg(userD, data["name"]);
    }

    List<Widget> descriptionItems = List.generate(10, (idx) => Container());

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
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kcDarkBlue,
                ),
              ),
              SelectableText(
                e.value == null ? "No Data" : e.value.toString(),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: status.open ? 200 : 100,
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
                        status.open = !status.open;
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
                  child: JoinLeaveBtn(
                    status: status,
                    choice: choice,
                    userD: userD,
                    data: data,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.only(right: 20, top: 7),
                    child: SideBarItem(
                      onTap: () async {
                        if (InheritedLoginProvider.of(context).isLoggedIn ==
                            false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ErrorPopUp(
                                  msg: "You need to be logged in");
                            },
                          );
                          return;
                        }

                        var resp;
                        if (choice.choice == SideBarChoice.projects) {
                          resp = await http.post(
                            Uri.parse(
                                'http://127.0.0.1:8000/delete_project/?email=${userD!['email']}&project_id=${data['id']}'),
                            // body: jsonData,
                          );
                        } else if (choice.choice == SideBarChoice.orgs) {
                          resp = await http.post(
                            Uri.parse(
                                'http://127.0.0.1:8000/delete_org/?email=${userD!['email']}&org_name=${data['name']}'),
                          );
                        }
                        final body = json.decode(resp.body);

                        if (body["msg"] == "") {
                          status.userJoinedOrg = true;
                          InheritedLoginProvider.of(context).update();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorPopUp(msg: body["msg"]);
                            },
                          );
                        }
                      },
                      text: "D E L E T E",
                      fontSize: 10,
                      color: kcDarkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          status.open
              ? Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [...descriptionItems],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class JoinLeaveBtn extends StatelessWidget {
  const JoinLeaveBtn({
    Key? key,
    required this.status,
    required this.choice,
    required this.userD,
    required this.data,
  }) : super(key: key);

  final DescriptionToggleNotifier status;
  final SideBarChoiceNotifier choice;
  final Map<String?, dynamic>? userD;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(right: 20.0, top: 7),
      child: SideBarItem(
        text: status.userJoinedOrg ? "L E A V E" : "J O I N",
        onTap: () async {
          if (InheritedLoginProvider.of(context).isLoggedIn == false) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ErrorPopUp(msg: "You need to be logged in");
              },
            );
            return;
          }

          var resp;
          if (choice.choice == SideBarChoice.projects) {
            resp = await http.post(
              Uri.parse(
                  'http://127.0.0.1:8000/add_developer/?email=${userD!['email']}&project_id=${data['id']}'),
              // body: jsonData,
            );
          } else if (choice.choice == SideBarChoice.orgs) {
            resp = await http.post(
              Uri.parse(
                  'http://127.0.0.1:8000/add_employee/?email=${userD!['email']}&org_name=${data['name']}'),
            );
          }
          final msg = json.decode(resp.body)["msg"];

          if (msg == "") {
            status.userJoinedOrg = true;
            InheritedLoginProvider.of(context).update();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ErrorPopUp(
                  msg: "Couldnt add user to" +
                      (choice.choice == SideBarChoice.orgs
                          ? "organization"
                          : choice.choice == SideBarChoice.projects
                              ? "project"
                              : "task"),
                );
              },
            );
          }
        },
        fontSize: 10,
      ),
    );
  }
}
