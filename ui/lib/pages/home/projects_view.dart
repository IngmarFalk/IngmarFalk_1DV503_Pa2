import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/pages/home/home.dart';
import 'package:ui/theme/colors.dart';
import 'package:ui/widgets/widgets.dart';

class CenterView extends ConsumerWidget {
  final double height;
  final double width;
  CenterView({
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
                  SearchField(size: size),
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
                        "Date",
                        "Name",
                        "Organization",
                      ]),
                )
              : const SizedBox(),
          const SearchButton(),
          const CenterViewTile(),
        ],
      ),
    );
  }
}

class FilterButtonNotifier extends ChangeNotifier {
  bool _filtering = false;

  bool get filtering => _filtering;

  set filtering(bool value) {
    _filtering = value;
    notifyListeners();
  }

  void onTap(bool val) {
    _filtering = val;
    notifyListeners();
  }
}

class FilterButton extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  const FilterButton({
    required this.filteringNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtering = ref.watch(filteringNotifier);
    return CustomTextButton(
      margin: const EdgeInsets.all(0),
      height: 90,
      width: 60,
      onTap: () {
        filtering.onTap(!filtering.filtering);
      },
      text: "",
      icon: const Icon(
        Icons.menu_sharp,
        color: kcDarkBlue,
      ),
    );
  }
}

class FilterOptions extends ConsumerWidget {
  final ChangeNotifierProvider<FilterButtonNotifier> filteringNotifier;
  // TODO : Change it to map, so I can use it to create
  // TODO : dropdownmenus for each filter option
  final List<String> options;
  const FilterOptions({
    required this.filteringNotifier,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtering = ref.watch(filteringNotifier);
    return SizedBox(
      height: options.length * 34,
      width: 200,
      child: ListView.builder(
        itemCount: options.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int idx) => Container(
          // margin: const EdgeInsets.symmetric(vertical: 1),
          height: 30,
          width: 200,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: kcMedBlue, width: .5),
              right: BorderSide(color: kcMedBlue, width: .5),
              left: BorderSide(color: kcMedBlue, width: .5),
            ),
            color: Colors.white,
          ),
          child: TextButton(
            onPressed: () {
              filtering.onTap(false);
            },
            child: Text(options[idx],
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kcDarkBlue,
                )),
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0, color: kcMedBlue),
        ),
      ),
      child: Form(
        child: CustomTextField(
          margin: const EdgeInsets.all(0),
          hintText: "search",
          isShadow: false,
          height: 50,
          width: size.width - 700,
        ),
        onChanged: () {},
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 50,
        width: 200,
        child: CustomTextButton(
          height: 70,
          width: 300,
          margin: const EdgeInsets.all(0),
          onTap: () {},
          text: "S E A R C H",
        ),
      ),
    );
  }
}

class CenterViewTile extends ConsumerWidget {
  final List<Project>? projects;
  final double height;
  final double width;
  final EdgeInsets? padding, margin;
  final Color textColor, backgroundColor;
  final Color? accentColor;
  const CenterViewTile({
    this.projects,
    this.height = 50,
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
    return const CreateButton();
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
                  hintText: "due data",
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

enum Status {
  initialized,
  notStarted,
  finished,
  failed,
  paused,
  planningPhase,
  production,
  development,
  finishingState,
  earlyState,
}

class Task {
  final List<User>? developers;
  final String name;
  final String? description;
  final String? dueDate;
  final Status status;
  final Project project;
  final int id;
  Task({
    required this.name,
    required this.project,
    required this.id,
    this.developers,
    this.description,
    this.dueDate,
    this.status = Status.initialized,
  });

  Task copyWith({
    List<User>? developers,
    String? name,
    String? description,
    String? dueDate,
    Status? status,
  }) {
    return Task(
      project: project,
      id: id,
      developers: developers ?? this.developers,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'id': id,
      'developers': developers?.map((x) => x.toMap()).toList() ?? [],
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      project: map['project'],
      id: map['id'],
      developers:
          List<User>.from(map['developers']?.map((x) => User.fromMap(x))),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? Status.initialized,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}

class User {
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final Organization? organization;
  final List<Project>? projects;
  final List<Task>? tasks;
  User({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.organization,
    this.projects,
    this.tasks,
  });

  User copyWith({
    String? username,
    String? firstname,
    String? lastname,
    String? email,
    Organization? organization,
    List<Project>? projects,
  }) {
    return User(
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      organization: organization ?? this.organization,
      projects: projects ?? this.projects,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'organization': organization?.toMap(),
      'projects': projects?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      organization: Organization.fromMap(map['organization']),
      projects:
          List<Project>.from(map['projects']?.map((x) => Project.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class Organization {
  final String name;
  final List<User> developers, administrators;
  final List<Project>? projects;
  Organization({
    required this.name,
    required this.developers,
    required this.administrators,
    this.projects,
  });

  Organization copyWith({
    String? name,
    List<User>? users,
    List<User>? developers,
    List<User>? administrators,
    List<Project>? projects,
  }) {
    return Organization(
      name: name ?? this.name,
      developers: developers ?? this.developers,
      administrators: administrators ?? this.administrators,
      projects: projects ?? this.projects,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'developers': developers.map((x) => x.toMap()).toList(),
      'administrators': administrators.map((x) => x.toMap()).toList(),
      'projects': projects?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      name: map['name'] ?? '',
      developers:
          List<User>.from(map['developers']?.map((x) => User.fromMap(x))),
      administrators:
          List<User>.from(map['administrators']?.map((x) => User.fromMap(x))),
      projects:
          List<Project>.from(map['projects']?.map((x) => Project.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) =>
      Organization.fromMap(json.decode(source));
}

class Project {
  final String name;
  final String descripton;
  final String dueDate;
  final Status status;
  final Organization organization;
  final List<Organization> partners;
  final User projectLeader;
  final List<User> projectManagers;
  final List<User> developers;
  final List<Task> tasks;

  Project({
    required this.name,
    required this.descripton,
    required this.dueDate,
    required this.status,
    required this.organization,
    required this.partners,
    required this.projectLeader,
    required this.projectManagers,
    required this.developers,
    required this.tasks,
  });

  Project copyWith({
    String? name,
    String? descripton,
    String? dueDate,
    Status? status,
    Organization? organization,
    List<Organization>? partners,
    User? projectLeader,
    List<User>? projectManagers,
    List<User>? developers,
    List<Task>? tasks,
  }) {
    return Project(
      name: name ?? this.name,
      descripton: descripton ?? this.descripton,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      organization: organization ?? this.organization,
      partners: partners ?? this.partners,
      projectLeader: projectLeader ?? this.projectLeader,
      projectManagers: projectManagers ?? this.projectManagers,
      developers: developers ?? this.developers,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'descripton': descripton,
      'dueDate': dueDate,
      'status': status,
      'organization': organization.toMap(),
      'partners': partners.map((x) => x.toMap()).toList(),
      'projectLeader': projectLeader.toMap(),
      'projectManagers': projectManagers.map((x) => x.toMap()).toList(),
      'developers': developers.map((x) => x.toMap()).toList(),
      'tasks': tasks.map((x) => x.toMap()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      name: map['name'] ?? '',
      descripton: map['descripton'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? Status.initialized,
      organization: Organization.fromMap(map['organization']),
      partners: List<Organization>.from(
          map['partners']?.map((x) => Organization.fromMap(x))),
      projectLeader: User.fromMap(map['projectLeader']),
      projectManagers:
          List<User>.from(map['projectManagers']?.map((x) => User.fromMap(x))),
      developers:
          List<User>.from(map['developers']?.map((x) => User.fromMap(x))),
      tasks: List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) =>
      Project.fromMap(json.decode(source));
}
