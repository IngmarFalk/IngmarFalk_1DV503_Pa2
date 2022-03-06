import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/theme/colors.dart';

class ProjectsView extends ConsumerWidget {
  final double height;
  final double width;
  const ProjectsView({
    this.height = 500,
    this.width = 500,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kcLightBlue,
      ),
      child: const ProjectTile(),
    );
  }
}

class ProjectTile extends ConsumerWidget {
  final List<Project>? projects;
  final double height;
  final double width;
  final EdgeInsets? padding, margin;
  final Color textColor, backgroundColor;
  final Color? accentColor;
  const ProjectTile({
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
    return const CreatePrjectButton();
  }
}

class CreatePrjectButton extends StatelessWidget {
  const CreatePrjectButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.add_box),
          const SizedBox(height: 5),
          Text(
            "C R E A T E   P R O J E C T",
            style: GoogleFonts.montserrat(
              fontSize: 10,
            ),
          )
        ],
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
  final List<User> developers;
  final String name;
  final String description;
  final String dueDate;
  final Status status;
  Task({
    required this.developers,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  Task copyWith({
    List<User>? developers,
    String? name,
    String? description,
    String? dueDate,
    Status? status,
  }) {
    return Task(
      developers: developers ?? this.developers,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'developers': developers.map((x) => x.toMap()).toList(),
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
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

  @override
  String toString() {
    return 'Task(developers: $developers, name: $name, description: $description, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Task &&
        listEquals(other.developers, developers) &&
        other.name == name &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.status == status;
  }

  @override
  int get hashCode {
    return developers.hashCode ^
        name.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        status.hashCode;
  }
}

class User {
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final Organization organization;
  final List<Project> projects;
  User({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.organization,
    required this.projects,
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
      'organization': organization.toMap(),
      'projects': projects.map((x) => x.toMap()).toList(),
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

  @override
  String toString() {
    return 'User(username: $username, firstname: $firstname, lastname: $lastname, email: $email, organization: $organization, projects: $projects)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is User &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.organization == organization &&
        listEquals(other.projects, projects);
  }

  @override
  int get hashCode {
    return username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        organization.hashCode ^
        projects.hashCode;
  }
}

class Organization {
  final String name;
  final List<User> users;
  final List<User> developers;
  final List<User> administrators;
  Organization({
    required this.name,
    required this.users,
    required this.developers,
    required this.administrators,
  });

  Organization copyWith({
    String? name,
    List<User>? users,
    List<User>? developers,
    List<User>? administrators,
  }) {
    return Organization(
      name: name ?? this.name,
      users: users ?? this.users,
      developers: developers ?? this.developers,
      administrators: administrators ?? this.administrators,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'users': users.map((x) => x.toMap()).toList(),
      'developers': developers.map((x) => x.toMap()).toList(),
      'administrators': administrators.map((x) => x.toMap()).toList(),
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      name: map['name'] ?? '',
      users: List<User>.from(map['users']?.map((x) => User.fromMap(x))),
      developers:
          List<User>.from(map['developers']?.map((x) => User.fromMap(x))),
      administrators:
          List<User>.from(map['administrators']?.map((x) => User.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) =>
      Organization.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Organization(name: $name, users: $users, developers: $developers, administrators: $administrators)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Organization &&
        other.name == name &&
        listEquals(other.users, users) &&
        listEquals(other.developers, developers) &&
        listEquals(other.administrators, administrators);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        users.hashCode ^
        developers.hashCode ^
        administrators.hashCode;
  }
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

  static fromMap(x) {}

  toMap() {}
}
