from models.base import *
from db.db_manager import DBManager


def init_db() -> DBManager:
    login_data = {
        "user": "manu",
        "password": "manu",
        "db": repr(ProjM()),
    }
    db = DBManager(**login_data)

    if not db.exists():
        print("Does not exist")
        db.query(ProjM().asSql())
        db.query("USE " + repr(ProjM()))
        for table in ProjM().tables.values():
            db.query(table.asSql())

    return db


class Users(Table):
    email: VARCHAR = VARCHAR(size=255)
    username: VARCHAR = VARCHAR(size=255)
    firstname: VARCHAR = VARCHAR(size=255)
    lastname: VARCHAR = VARCHAR(size=255)
    password: VARCHAR = VARCHAR(size=255)
    role: VARCHAR = VARCHAR(size=255)


class Projects(Table):
    id: INT = INT(primary_key=True, auto_increment=True)
    name: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255, nullable=True)
    description: TEXT = TEXT(nullable=True)
    due_date: DATETIME = DATETIME(nullable=True)
    status: VARCHAR = VARCHAR(size=255)


class Tasks(Table):
    id: INT = INT(primary_key=True, auto_increment=True)
    title: VARCHAR = VARCHAR(size=255)
    description: TEXT = TEXT(nullable=True)
    developer: VARCHAR = VARCHAR(size=255, nullable=True)
    project: VARCHAR = VARCHAR(size=255, nullable=True)
    organization: VARCHAR = VARCHAR(size=255, nullable=True)
    due_date: DATETIME = DATETIME()
    status: VARCHAR = VARCHAR(size=255)


class Organizations(Table):
    name: VARCHAR = VARCHAR(size=255)


class Admins(Table):
    username: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255)


class Developers(Table):
    username: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255)


class ProjectLeaders(Table):
    username: VARCHAR = VARCHAR(size=255)
    project: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255)


class ProjM(Database):
    users = Users()
    projects = Projects()
    organizations = Organizations()
    tasks = Tasks()
    admins = Admins()
    developers = Developers()
    project_leaders = ProjectLeaders()


if __name__ == "__main__":
    init_db()
