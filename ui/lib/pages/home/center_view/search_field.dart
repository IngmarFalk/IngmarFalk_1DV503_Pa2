import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class SearchField extends HookWidget {
  final SideBarChoiceNotifier choice;
  const SearchField({
    required this.choice,
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final TextEditingController teController = useTextEditingController();

    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0, color: kcMedBlue),
        ),
      ),
      child: Form(
        onChanged: () async {
          var url = choice.choice == SideBarChoice.projects
              ? Uri.parse('http://127.0.0.1:8000/projects/')
              : Uri.parse('http://127.0.0.1:8000/orgs/');
          String jsonData = choice.choice == SideBarChoice.projects
              ? json.encode({"project_name": teController.text})
              : json.encode({"org_name": teController.text});

          var resp = await http.post(
            url,
            body: jsonData,
            headers: {"Content-type": "application/json"},
          );

          var msg = json.decode(resp.body);
          print(msg);
        },
        child: CustomTextField(
          controller: teController,
          margin: const EdgeInsets.all(0),
          hintText: "search",
          isShadow: false,
          height: 50,
          width: size.width - 700,
        ),
      ),
    );
  }
}

class SearchButton extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  const SearchButton({
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
            // Call Query and pass in the filters
            filtering.openFilter(false);
          },
          text: "S E A R C H",
        ),
      ),
    );
  }
}
