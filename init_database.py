from models.base import *
from db.db_manager import DBManager
import test_data as td
import random as rd


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

        " TODO : Create roles "

        for proj in td.tprojects:
            db.query(ProjM().projects.insert(proj), *proj.values())

        for usr in td.tusers:
            db.query(ProjM().users.insert(usr), *usr.values())

        for org in td.torgs:
            db.query(ProjM().organizations.insert(org), *org.values())

        for admin in td.tusers[:4]:
            db.query(
                ProjM().admins.insert(
                    {
                        "email": "",
                        "organization": "",
                    }
                ),
                *(admin["email"], rd.choice(td.torgs)["name"])
            )

        for pl in td.tusers[:6]:
            db.query(
                ProjM().projectleaders.insert(
                    {
                        "email": "",
                        "project_id": "",
                        "organization": "",
                    }
                ),
                *(
                    pl["email"],
                    rd.choice(td.tprojects)["id"],
                    rd.choice(td.torgs)["name"],
                )
            )

        for dev in td.tusers[6:]:
            db.query(
                ProjM().developers.insert(
                    {
                        "email": "",
                        "project_id": "",
                    }
                ),
                *(dev["email"], rd.choice(td.tprojects)["id"])
            )

        db.query(
            ProjM().users.insert(
                {
                    "email": "root@root",
                    "username": "root",
                    "firstname": "root",
                    "lastname": "root",
                    "password": "root",
                }
            ),
            *("root@root", "root", "root", "root", "root")
        )

    return db


class Users(Table):
    email: VARCHAR = VARCHAR(size=255)
    username: VARCHAR = VARCHAR(size=255)
    firstname: VARCHAR = VARCHAR(size=255)
    lastname: VARCHAR = VARCHAR(size=255)
    password: VARCHAR = VARCHAR(size=255)


class Projects(Table):
    id: INT = INT(primary_key=True, auto_increment=True)
    name: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255, nullable=True)
    description: TEXT = TEXT(nullable=True)
    due_date: DATETIME = DATETIME(nullable=True)
    creation_date: DATETIME = DATETIME(nullable=True)
    status: VARCHAR = VARCHAR(size=255)


class Tasks(Table):
    id: INT = INT(primary_key=True, auto_increment=True)
    title: VARCHAR = VARCHAR(size=255)
    description: TEXT = TEXT(nullable=True)
    developer: VARCHAR = VARCHAR(size=255, nullable=True)
    project_id: INT = INT(nullable=True)
    organization: VARCHAR = VARCHAR(size=255, nullable=True)
    due_date: DATETIME = DATETIME()
    status: VARCHAR = VARCHAR(size=255)


class Organizations(Table):
    name: VARCHAR = VARCHAR(size=255)
    field: VARCHAR = VARCHAR(size=255)
    description: TEXT = TEXT(nullable=True)


class Admins(Table):
    email: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255)


class Developers(Table):
    email: VARCHAR = VARCHAR(size=255)
    project_id: INT = INT()


class Employees(Table):
    email: VARCHAR = VARCHAR(size=255)
    organization: VARCHAR = VARCHAR(size=255)


class ProjectLeaders(Table):
    email: VARCHAR = VARCHAR(size=255)
    project_id: INT = INT()
    organization: VARCHAR = VARCHAR(size=255)


class ProjM(Database):
    users = Users()
    projects = Projects()
    organizations = Organizations()
    tasks = Tasks()
    admins = Admins()
    developers = Developers()
    employees = Employees()
    projectleaders = ProjectLeaders()


if __name__ == "__main__":
    init_db()
