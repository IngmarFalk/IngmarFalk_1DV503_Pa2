import 'dart:convert';

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
