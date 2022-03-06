#! venv/bin/python

# from models.base import *
# from db.db_manager import DBManager


# def main():
#     login_data = {
#         "user": "root",
#         "password": "Almuschka2021!",
#         "db": repr(ProjM),
#     }
#     db = DBManager()

#     if not db.exists():
#         db.query(ProjM().asSql())


# class Users(Table):
#     id: INT = INT(primary_key=True, auto_increment=True)
#     email: VARCHAR = VARCHAR(size=255)
#     username: VARCHAR = VARCHAR(size=255)
#     firstname: VARCHAR = VARCHAR(size=255)
#     lastname: VARCHAR = VARCHAR(size=255)


# class Projects(Table):
#     id: INT = INT(primary_key=True, auto_increment=True)
#     name: VARCHAR = VARCHAR(size=255)
#     organization: VARCHAR = VARCHAR(size=255, nullable=True)
#     description: TEXT = TEXT()
#     due_date: DATETIME = DATETIME()
#     status: VARCHAR = VARCHAR(size=255)


# class Tasks(Table):
#     id: INT = INT(primary_key=True, auto_increment=True)
#     title: VARCHAR = VARCHAR(size=255)
#     description: TEXT = TEXT()
#     developer: VARCHAR = VARCHAR(size=255, nullable=True, foreign_key=True)
#     project: VARCHAR = VARCHAR(size=255, nullable=True, foreign_key=True)
#     organization: VARCHAR = VARCHAR(size=255, nullable=True, foreign_key=True)
#     due_date: DATETIME = DATETIME()
#     status: VARCHAR = VARCHAR(size=255)


# class Organizations(Table):
#     name: VARCHAR = VARCHAR(size=255)


# class Admins(Table):
#     name: VARCHAR = VARCHAR(size=255, foreign_key=True)
#     organization: VARCHAR = VARCHAR(size=255, foreign_key=True)


# class Developers(Table):
#     name: VARCHAR = VARCHAR(size=255, foreign_key=True)
#     organization: VARCHAR = VARCHAR(size=255, foreign_key=True)


# class ProjectLeaders(Table):
#     name: VARCHAR = VARCHAR(size=255, foreign_key=True)
#     project: VARCHAR = VARCHAR(size=255, foreign_key=True)
#     organization: VARCHAR = VARCHAR(size=255, foreign=True)


# class ProjM(Database):
#     users = Users()
#     projects = Projects()
#     organizations = Organizations()
#     tasks = Tasks()
#     admins = Admins()
#     developers = Developers()
#     project_leaders = ProjectLeaders()


def main():
    pass


if __name__ == "__main__":
    main()

"-----"


"-----"


"-----"


"-----"


def get_tasks_cols() -> tuple:
    return (
        "id INT NOT NULL AUTO_INCREMENT",
        "name TEXT",
        "description TEXT",
        "status TEXT",
        "deadline DATETIME",
        "project_id INT",
        "organization_id INT",
        "assignee_id INT",
        "PRIMARY KEY (id)",
    )


def get_users_cols() -> tuple:
    return (
        "id INT NOT NULL AUTO_INCREMENT",
        "first_name TEXT",
        "last_name TEXT",
        "organization_id INT",
        "PRIMARY KEY (id)",
    )


def get_organizations_cols() -> tuple:
    return (
        "id INT NOT NULL AUTO_INCREMENT",
        "name TEXT",
        "PRIMARY KEY (id)",
    )


def get_project_cols() -> tuple:
    return (
        "id INT NOT NULL AUTO_INCREMENT",
        "name TEXT",
        "description TEXT",
        "organization_id INT",
        "deadline DATETIME",
        "status TEXT",
        "PRIMARY KEY (id)",
    )


def get_user_info() -> tuple:
    return (
        "user_id INT NOT NULL",
        "email TEXT",
        "phone TEXT",
        "github TEXT",
    )


def get_project_leaders() -> tuple:
    return (
        "user_id INT NOT NULL",
        "project_id INT NOT NULL",
    )
