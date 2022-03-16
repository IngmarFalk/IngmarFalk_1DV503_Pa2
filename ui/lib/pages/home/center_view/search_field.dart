import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ui/pages/home/center_view/fetch.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/pages/home/center_view/projects_view.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/pages/org/create_org.dart';
import 'package:ui/pages/projects/create_project.dart';
import 'package:ui/pages/tasks/create_task.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class SearchField2 extends StatefulHookConsumerWidget {
  final Size size;
  final SideBarChoiceNotifier choice;
  final TextEditingController teController;
  const SearchField2({
    required this.teController,
    required this.choice,
    required this.size,
    Key? key,
  }) : super(key: key);

  static Future<void> fetch({
    required SideBarChoiceNotifier choice,
    required TextEditingController teController,
  }) async {
    Uri url;
    String jsonData;
    if (choice.choice == SideBarChoice.projects) {
      url = Uri.parse('http://127.0.0.1:8000/projects/');
      jsonData = json.encode({"project_name": teController.text});
    } else if (choice.choice == SideBarChoice.orgs) {
      url = Uri.parse('http://127.0.0.1:8000/orgs/');
      jsonData = json.encode({"org_name": teController.text});
    } else {
      return;
    }

    var resp = await http.post(
      url,
      body: jsonData,
      headers: {"Content-type": "application/json"},
    );

    choice.rs = json.decode(resp.body);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchField2State();
}

class _SearchField2State extends ConsumerState<SearchField2> {
  late Future<void> _future;

  @override
  void initState() {
    _future = fetch(
      choice: widget.choice,
      teController: widget.teController,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final choice = widget.choice;

    return FutureBuilder(
      future: _future,
      builder: (
        BuildContext context,
        AsyncSnapshot? snapshot,
      ) =>
          Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: kcMedBlue),
            left: BorderSide(width: 1.0, color: kcMedBlue),
            top: BorderSide(width: 1.0, color: kcMedBlue),
            right: BorderSide(width: 1.0, color: kcMedBlue),
            // horizontal: BorderSide(width: 1.0, color: kcMedBlue),
          ),
        ),
        child: Form(
          onChanged: () => fetch(
            teController: widget.teController,
            choice: choice,
          ),
          child: CustomTextField(
            controller: widget.teController,
            margin: const EdgeInsets.all(0),
            hintText: "search",
            isShadow: false,
            height: 50,
          ),
        ),
      ),
    );
  }
}

class DynamicCreateButton extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  final SideBarChoiceNotifier choice;
  const DynamicCreateButton({
    required this.choice,
    required this.filteringNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtering = ref.watch(filteringNotifier);
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 50,
        width: 200,
        child: CustomTextButton(
          height: 70,
          width: 300,
          margin: const EdgeInsets.all(0),
          onTap: () {
            switch (choice.choice) {
              case SideBarChoice.orgs:
                Navigator.pushNamed(context, CreateOrgPage.id);
                break;
              case SideBarChoice.projects:
                Navigator.pushNamed(context, CreateProjectPage.id);
                break;
              case SideBarChoice.tasks:
                Navigator.pushNamed(context, CreateTaskPage.id);
                break;
            }
          },
          text: "C R E A T E",
        ),
      ),
    );
  }
}
