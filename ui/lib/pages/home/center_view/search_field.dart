import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ui/pages/home/center_view/fetch.dart';
import 'package:ui/pages/home/center_view/filter_button_notifier.dart';
import 'package:ui/pages/home/home.dart';
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
    // var url = choice.choice == SideBarChoice.projects
    //     ? Uri.parse('http://127.0.0.1:8000/projects/')
    //     : Uri.parse('http://127.0.0.1:8000/orgs/');
    // String jsonData = choice.choice == SideBarChoice.projects
    //     ? json.encode({"project_name": teController.text})
    //     : json.encode({"org_name": teController.text});

    var resp = await http.post(
      url,
      body: jsonData,
      headers: {"Content-type": "application/json"},
    );

    // await Future.delayed(Duration(milliseconds: 2000));

    choice.rs = json.decode(resp.body);
    // for (var i = 0; i < choice.rs["msg"].length; i++) {
    //   print(choice.rs["msg"][i]);
    // }
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
    // final TextEditingController teController = useTextEditingController();
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

// class SearchField extends HookConsumerWidget {
//   final SideBarChoiceNotifier choice;
//   final Size size;
//   SearchField({
//     required this.choice,
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final TextEditingController teController = useTextEditingController();

//     return Container(
//       decoration: const BoxDecoration(
//         border: Border.symmetric(
//           horizontal: BorderSide(width: 1.0, color: kcMedBlue),
//         ),
//       ),
//       child: Form(
//         onChanged: () async {
//           print("FormCalledMe");
//           var url = choice.choice == SideBarChoice.projects
//               ? Uri.parse('http://127.0.0.1:8000/projects/')
//               : Uri.parse('http://127.0.0.1:8000/orgs/');
//           String jsonData = choice.choice == SideBarChoice.projects
//               ? json.encode({"project_name": teController.text})
//               : json.encode({"org_name": teController.text});

//           var resp = await http.post(
//             url,
//             body: jsonData,
//             headers: {"Content-type": "application/json"},
//           );

//           choice.rs = json.decode(resp.body);
//         },
//         child: CustomTextField(
//           controller: teController,
//           margin: const EdgeInsets.all(0),
//           hintText: "search",
//           isShadow: false,
//           height: 50,
//           width: size.width - 700,
//         ),
//       ),
//     );
//   }
// }

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
