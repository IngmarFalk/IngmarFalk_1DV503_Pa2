#! venv/bin/python

import json
from typing import Any
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from models.base import Database, Table, Val, VARCHAR, INT, FLOAT, DOUBLE
from app import init_db, ProjM

app = FastAPI()

# origins = [
#     "http://localhost",
#     "https://localhost:8008",
#     "http://localhost:8000",
#     "http://localhost:8080",
#     "http://127.0.0.1:8000",
#     "http://194.47.188.32",
#     "http://194.47.188.32",
#     "http://194.47.188.32/login",
# ]

app.add_middleware(
    CORSMiddleware,
    # allow_credentials=True,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

ROUTES = {
    "home": "/",
    "login": "/login/",
    "register": "/register/",
    "delete_user": "/delete_user/",
    "user": "/user/",
    "projects": "/user/{username}/projects/",
    "create_project": "/user/{username}/create_project/",
    "alter_project": "/alter_project/",
    "delete_project": "/delete_project/",
    "user_part_of_project": "user/{email}/",
    "add_developer": "/add_developer/",
    "get_projects": "/projects/",
    "create_org": "/user/{username}/create_org",
    "delete_org": "/user/{username}/delete_org",
    "get_orgs": "/orgs/",
    "user_part_of_org": "/user/{email}/",
    "add_employee": "/add_employee/",
}

DB_MANAGER = init_db()

"++++++++++++++++++++User Table Apis+++++++++++++++++++"


async def check_for_user(user_data: dict[Any, Any]) -> bool:
    """Check if there exists a user with the provided credentials and returns a boolean"""
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""
SELECT * 
FROM users 
WHERE email = '{user_data['email']}' 
AND username IN (
    SELECT username 
    FROM users 
    WHERE email = '{user_data['email']}');"""
    )

    """
    If there is a result, that means there is a user with the provided credentials,
    which then returns 'True', otherwise if they response is 'null', that means there is
    no such user and the function returns 'True'
    """
    if len(DB_MANAGER.query_result) == 0:
        return False
    return True


"-------------Login-------------"


@app.post(ROUTES["login"])
async def post_login(loginData: dict[Any, Any]) -> dict[Any, Any]:
    return {"msg": await validate(loginData)}


async def validate(login_data: dict[Any, Any]) -> str:
    "Uses the Login Data to check wether such a user exists and wether the password is correct"

    if not await check_for_user(login_data):
        return "No such user exists"

    if len(login_data["password"]) < 8:
        return "Password must be at least 8 characters"

    """
    It is a terrible idea to store user passwords in plain text, but for this project
    it should be fine. If I am to extend this app, this is definetely something I have
    to change. But I think it shouldnt be to hard to fix that, maybe just hash the paswords
    and then insert the hashed values into the database.
    """

    DB_MANAGER.use()
    DB_MANAGER.query(
        f"SELECT * FROM users WHERE email = '{login_data['email']}' AND password = '{login_data['password']}'"
    )
    if len(DB_MANAGER.query_result) == 0:
        return "Invalid Password"

    return ""


"-------------Register-------------"


@app.post(ROUTES["register"])
async def register(register_data: dict[Any, Any]) -> dict[Any, Any]:
    """
    TODO : implement a post request that takes in an email, username and password
    and checks wether there is no duplicate in the database
    """

    if len(register_data["password"]) < 8:
        return {"msg": "Password must be at least 8 characters"}

    "Validating that there are no existing users with the same email and username"
    if not await check_for_user(register_data):
        print("Does not exist")
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().users.insert(register_data), *register_data.values())
        return {"msg": ""}
    else:
        return {"msg": "User already exists"}


@app.post(ROUTES["delete_user"])
async def delete_user(user_data: dict[Any, Any], tables: list[str]) -> str:
    "Deletes a user from ALL the tables in the database where he/she exists"

    if "users" in tables:
        tables.remove("users")

    DB_MANAGER.use()

    "This works"
    "delete from users where username = 'imanu';"

    q = f"""DELETE users, {', '.join([table for table in tables])} FROM users"""
    for table in tables:
        q += " INNER JOIN " + table + " ON " + table + ".email = users.email\n"
    q += f" WHERE users.email = '{str(user_data['email'])}';"
    DB_MANAGER.query(q)

    print(DB_MANAGER.query_result)
    return ""


# @app.post(ROUTES["delete_user"])
# async def delete_user(userData: dict[Any, Any], tables: list[Table]) -> dict[Any, Any]:
#     "Deletes a user from the database"
#     return {}


#     q = f"""DELETE FROM {', '.join([repr(table) for table in tables])} WHERE """
#     conds = [repr(table) + ".userid = users.id" for table in tables]
#     q += " and ".join(conds)
#     print(q)
# )
# return {}

# DB_MANAGER.use()
# DB_MANAGER.query(
# f"""DELETE FROM users, developers as devs, projectleaders as pls, admins
# INNER JOIN admins
# ON users.username = admins.name
# WHERE users.username = {userData['username']}
# INNER JOIN developers as devs
# ON devs.name = users.username
# WHERE users.username = {userData['username']}
# INNER JOIN projectleaders as pls
# ON pls.name = users.username
# WHERE users.username = {userData['username']};"""


"++++++++++++++++++++Project Table Apis+++++++++++++++++++"


@app.post(ROUTES["get_projects"])
async def get_projects(project_name: dict[str, Any]) -> dict[str, Any]:
    """"""
    await create_all_projects_view()
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""
    SELECT * 
    FROM all_projects 
    WHERE name LIKE '{project_name['project_name']}%';"""
    )

    return {"msg": DB_MANAGER.query_result}


async def create_all_projects_view() -> None:
    """Create a view of all the projects within the database"""
    DB_MANAGER.use()
    DB_MANAGER.query(
        """CREATE OR REPLACE VIEW all_projects 
    AS SELECT 
        id, 
        name, 
        description, 
        due_date, 
        creation_date, 
        status, 
        (SELECT COUNT(*) 
            FROM developers 
            WHERE developers.project_id = projects.id) 
        FROM projects 
        LEFT JOIN developers devs 
        ON devs.project_id = projects.id;"""
    )


async def check_for_project(project_data: dict[Any, Any]) -> bool:
    """
    Checks in the database if a project for this exact organization exists.
    This is done because it is allowed for different organizations to have a
    project with the same name. It is not allowed within the organization howerever.
    """
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""SELECT * FROM projects
        WHERE organization = '{project_data['organization']}'
        AND name = '{project_data['name']}';"""
    )
    if len(DB_MANAGER.query_result) == 0:
        return False
    return True


@app.post(ROUTES["add_developer"])
async def add_developer(
    email: str,
    project_id: int,
) -> dict[Any, Any]:
    """"""

    DB_MANAGER.use()

    DB_MANAGER.query(
        f"""SELECT * 
        FROM developers 
        WHERE email = '{email}'
        AND project_id = '{project_id}'"""
    )

    if len(DB_MANAGER.query_result) != 0:
        return {"msg": "developer already in project"}

    DB_MANAGER.query(
        ProjM().developers.insert(
            {
                "email": email,
                "project_id": project_id,
            }
        )
    )

    return {"msg": ""}


@app.post(ROUTES["create_project"])
async def create_project(project_data: dict[Any, Any], username: str) -> dict[Any, Any]:
    """
    Takes the project data as input and initializes a new project with that data after
    ensuring there doesnt exists a project with the same name for this exact same
    organization. But it also takes the username of the user that created the project
    initiales him as the initial project leader.
    """

    if not await check_for_project(project_data):
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().projects.insert(project_data), *project_data.values())
        DB_MANAGER.query(
            ProjM().projectleaders.insert(
                {
                    "username": username,
                    "project": project_data["name"],
                    "organization": project_data["organization"],
                },
            ),
            *[username, project_data["name"], project_data["organization"]],
        )
        return {"msg": ""}

    return {"msg": "Project already exists"}


@app.post(ROUTES["delete_project"])
async def delete_project(email: str, project_id: int) -> dict[Any, Any]:
    """
    Takes in the information about the project to be deleted as well as
    the user who initiated the action. Then it calls a query to check wether
    the user has the authority to actually delete it, if so, the function will
    call the appropriate query. After that this function will delete the project
    itself as well as all the project_leaders for this particular project.
    Furthermore it will alos remove all tasks for this project.
    """
    DB_MANAGER.use()

    "First we need to check wether user has the authority to delete project"
    auth = check_user_authority(email, project_id)
    if not auth["projectleader"] and not auth["admin"]:  # type: ignore
        return {"msg": "You are not authorized to delete this project"}

    DB_MANAGER.query(f"DELETE FROM projects WHERE id = {project_id};")
    DB_MANAGER.query(f"DELETE FROM projectleaders WHERE project_id = {project_id};")
    DB_MANAGER.query(f"DELETE FROM developers WHERE project_id = {project_id};")

    return {"msg": ""}


"++++++++++++++++++++Organization/Project Table Apis+++++++++++++++++++"


async def check_user_authority(
    email: str, project_id: Any = None, org_name: Any = None
) -> dict[str, Any]:
    resp: dict[str, Any] = {
        "admin": False,
        "projectleader": False,
    }
    DB_MANAGER.use()
    "First, check if user is admin for organization"
    if org_name:
        DB_MANAGER.query(
            f"""
        SELECT * 
        FROM admins
        WHERE admins.email = '{email}'
        AND admins.name = '{org_name}';"""
        )

    if len(DB_MANAGER.query_result) != 0:
        resp["admin"] = True

    if project_id:
        DB_MANAGER.query(
            f"""
        SELECT * 
        FROM projectleaders pjl
        WHERE pjl.email = '{email}'
        AND pjl.project_id = '{project_id}';"""
        )
        if len(DB_MANAGER.query_result) != 0:
            resp["projectleader"] = True

        if not org_name:
            DB_MANAGER.query(
                f"""
        SELECT * 
        FROM projects pj, admins 
        WHERE pj.id = 3 
        AND admins.email = '{email}' 
        AND pj.organization = admins.organization;"""
            )

        if len(DB_MANAGER.query_result) != 0:
            resp["admin"] = True

    return resp


"++++++++++++++++++++Organization Table Apis+++++++++++++++++++"


@app.post(ROUTES["get_orgs"])
async def get_orgs(org_name: dict[str, Any]) -> dict[str, Any]:
    """"""
    await create_all_orgs_view()
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""
    SELECT * 
    FROM all_orgs 
    WHERE name LIKE '{org_name['org_name']}%';"""
    )

    return {"msg": DB_MANAGER.query_result}


@app.post(ROUTES["user_part_of_org"])
async def user_part_of_org(user_data: dict[Any, Any], org_name: str) -> dict[str, bool]:
    """"""
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""
        SELECT users.email
        FROM developers devs
        INNER JOIN projects
        ON devs.project_id = projects.id
        LEFT JOIN users
        ON devs.email = users.email
        WHERE projects.organization = '{org_name}';
    """
    )
    if user_data["email"] == DB_MANAGER.query_result[0][0]:
        return {"msg": True}
    return {"msg": False}

    # (SELECT COUNT(employees.email)
    #     FROM developers devs
    #     INNER JOIN projects
    #     ON projects.id = devs.project_id
    #     WHERE projects.organization = orgs.name
    #     GROUP BY orgs.name) as devs


async def create_all_orgs_view() -> None:
    """Create a view of all the projects within the database"""
    DB_MANAGER.use()
    q = """
    CREATE OR REPLACE VIEW all_orgs 
    AS SELECT 
        name, 
        field, 
        description, 
        (SELECT COUNT(emps.email) 
            FROM employees emps
            WHERE emps.organization = orgs.name 
            GROUP BY orgs.name) as devs
    FROM organizations orgs;
    """
    DB_MANAGER.query(q)


async def check_for_org(org_data: dict[Any, Any]) -> bool:
    """Checks in the database if an organization with this name already exists."""
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""SELECT * FROM organizations
        WHERE name = '{org_data['name']}';"""
    )
    if len(DB_MANAGER.query_result) == 0:
        return False
    return True


@app.post(ROUTES["create_org"])
async def create_org(org_data: dict[Any, Any], username: str) -> dict[Any, Any]:
    """"""
    if not await check_for_org(org_data):
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().organizations.insert(org_data), *org_data.values())
        DB_MANAGER.query(
            ProjM().admins.insert(
                {
                    "username": username,
                    "organization": org_data["name"],
                }
            ),
            *(username, org_data["name"]),
        )
    return {}


@app.post(ROUTES["delete_org"])
async def delete_org(email: str, org_name: str) -> dict[Any, Any]:
    """
    Takes in the information about the organization to be deleted as well as
    the user who initiated the action. Then it calls a query to check wether
    the user has the authority to actually delete it, if so, the function will
    call the appropriate query. After that this function will delete the organization
    itself as well as all the project_leaders for this particular project.
    Furthermore it will alos remove all tasks for this project.
    """
    DB_MANAGER.use()

    "First we need to check wether user has the authority to delete project"
    auth = check_user_authority(email, org_name=org_name)
    if not auth["admins"] == True:  # type: ignore
        return {"msg": "You are not authorized to delete this organization"}

    DB_MANAGER.query(f"DELETE FROM organizations WHERE name = {org_name}")
    DB_MANAGER.query(f"DELETE FROM admins WHERE organization = {org_name}")
    DB_MANAGER.query(f"DELETE FROM projectleaders WHERE organization = {org_name}")

    return {"msg": ""}


@app.post(ROUTES["add_employee"])
async def add_employee(
    email: str,
    org_name: str,
) -> dict[Any, Any]:
    """"""

    DB_MANAGER.use()

    q = f"""SELECT * 
        FROM employees 
        WHERE email = '{email}'
        AND organization = '{org_name}'"""

    DB_MANAGER.query(q)

    if len(DB_MANAGER.query_result) != 0:
        return {"msg": "employee already exists"}

    DB_MANAGER.query(
        ProjM().employees.insert(
            {
                "email": email,
                "organization": org_name,
            }
        ),
        *(email, org_name),
    )

    return {"msg": ""}
