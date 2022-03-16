#! venv/bin/python

from typing import Any
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from init_database import init_db, ProjM

app = FastAPI()


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
    "create_project": "/create_project/",
    "delete_project": "/delete_project/",
    "user_part_of_project": "/userpop/",
    "add_developer": "/add_developer/",
    "get_projects": "/projects/",
    "create_org": "/create_org/",
    "delete_org": "/delete_org/",
    "get_orgs": "/orgs/",
    "user_part_of_org": "/userpoo/{email}/{org_name}/",
    "add_employee": "/add_employee/",
    "get_tasks": "/tasks/",
    "create_task": "/create_task/",
    "delete_task": "/delete_task/",
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
    """
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
        f"""
        SELECT * 
        FROM users 
        WHERE email = '{login_data['email']}' 
        AND password = '{login_data['password']}'
        """
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
        """
    CREATE OR REPLACE VIEW all_projects 
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
        ),
        *(email, project_id),
    )

    return {"msg": ""}


@app.post(ROUTES["create_project"])
async def create_project(project_data: dict[Any, Any], email: str) -> dict[Any, Any]:
    """
    Takes the project data as input and initializes a new project with that data after
    ensuring there doesnt exists a project with the same name for this exact same
    organization. But it also takes the username of the user that created the project
    initiales him as the initial project leader.
    """

    try:
        _ = project_data["status"]
    except KeyError:
        project_data["status"] = "initial"

    print(project_data)

    if not await check_for_project(project_data):
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().projects.insert(project_data), *project_data.values())
        print(DB_MANAGER.query_result)
        org_exists = await check_for_org({"name": project_data["organization"]})
        if not org_exists:
            await create_org(
                org_data={"name": project_data["organization"], "field": ""},
                email=email,
            )
        DB_MANAGER.query(
            f"""
            SELECT id 
            FROM projects 
            WHERE name = '{project_data["name"]}' 
            AND organization = '{project_data["organization"]}';
            """
        )
        try:
            print(DB_MANAGER.query_result)
            id: int = DB_MANAGER.query_result[0][0]
        except KeyError:
            return {"msg": "Failed to create Project"}
        DB_MANAGER.query(
            ProjM().projectleaders.insert(
                {
                    "email": email,
                    "project_id": id,
                    "organization": project_data["organization"],
                },
            ),
            *[
                email,
                id,
                project_data["organization"],
            ],
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
    auth: dict[str, bool] = await check_user_authority(email, project_id)
    if not auth["projectleader"] and not auth["admin"] and not auth["root"]:
        return {"msg": "You are not authorized to delete this project"}

    DB_MANAGER.query(
        f"""
        DELETE pjl, projects, dev, tasks
        FROM projects
        LEFT JOIN projectleaders pjl
        ON pjl.project_id = projects.id
        LEFT JOIN developers dev
        ON dev.project_id = projects.id
        LEFT JOIN tasks
        ON tasks.project_id = projects.id
        WHERE projects.id = {project_id};
        """
    )

    return {"msg": ""}


"++++++++++++++++++++Organization/Project Table Apis+++++++++++++++++++"


async def check_user_authority(
    email: str,
    project_id: Any = None,
    org_name: Any = None,
) -> dict[str, bool]:
    resp: dict[str, Any] = {
        "admin": False,
        "projectleader": False,
        "root": False,
    }
    DB_MANAGER.use()

    if email == "root@root":
        resp["root"] = True
        resp["projectleader"] = True
        resp["admin"] = True
        return resp

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
async def user_part_of_org(email: str, org_name: str) -> dict[str, Any]:
    """"""
    DB_MANAGER.use()
    print(email, org_name)
    DB_MANAGER.query(
        f"""
        SELECT emp.email
        FROM employees emp
        WHERE emp.organization = '{org_name}' 
        AND emp.email = '{email}';
    """
    )
    print(DB_MANAGER.query_result)
    try:
        if email == DB_MANAGER.query_result[0][0]:
            print("returned True")
            return {"msg": ""}
    except IndexError as e:
        return {"msg": "Error"}
    return {"msg": "Error"}


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
async def create_org(org_data: dict[Any, Any], email: str) -> dict[Any, Any]:
    """"""
    if not await check_for_org(org_data):
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().organizations.insert(org_data), *org_data.values())
        DB_MANAGER.query(
            ProjM().admins.insert(
                {
                    "email": email,
                    "organization": org_data["name"],
                }
            ),
            *(email, org_data["name"]),
        )
    return {"msg": ""}


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
    auth: dict[str, bool] = await check_user_authority(email, org_name=org_name)
    print(email)

    if not auth["admin"] and not auth["root"]:
        return {"msg": "You are not authorized to delete this organization"}

    DB_MANAGER.query(
        f"""
    DELETE emp, tasks, projects, dev, org, pjl, admins 
    FROM organizations org
    LEFT JOIN tasks
    ON tasks.organization = org.name
    LEFT JOIN employees emp
    ON emp.organization = org.name
    LEFT JOIN projects
    ON projects.organization = org.name
    LEFT JOIN developers dev
    ON dev.project_id = projects.id
    LEFT JOIN admins
    ON admins.organization = org.name
    LEFT JOIN projectleaders pjl
    ON pjl.organization = org.name
    WHERE org.name = '{org_name}';
    """
    )

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


"+++++++++++++++++Tasks+++++++++++++++++"


@app.post(ROUTES["create_task"])
async def create_task(task_data: dict[Any, Any]) -> dict[Any, Any]:
    """"""
    try:
        _ = task_data["status"]
    except KeyError:
        task_data["status"] = "initial"

    DB_MANAGER.use()
    DB_MANAGER.query(ProjM().tasks.insert(task_data), *task_data.values())
    return {"msg": ""}


@app.post(ROUTES["get_tasks"])
async def get_tasks(task_title: dict[Any, Any]) -> dict[Any, Any]:
    """"""
    await create_all_tasks_view()
    print("Created all tasks")
    DB_MANAGER.use()
    DB_MANAGER.query(
        f"""
        SELECT *
        FROM all_tasks
        WHERE title LIKE '%{task_title['title']}'
        """
    )
    return {"msg": DB_MANAGER.query_result}


async def create_all_tasks_view() -> None:
    """Create a view of all the tasks within the database"""
    DB_MANAGER.use()
    q = """
    CREATE OR REPLACE VIEW all_tasks 
    AS SELECT 
        id,
        title, 
        description, 
        developer,
        project_id,
        organization,
        due_date,
        status
    FROM tasks;
    """
    DB_MANAGER.query(q)


@app.post(ROUTES["delete_task"])
async def delete_task(email: str, task_id: int) -> dict[Any, Any]:
    """"""
    DB_MANAGER.use()

    "First we need to check wether user has the authority to delete project"

    DB_MANAGER.query(
        f"""
        SELECT *
        FROM tasks
        WHERE developer = '{email}'
        AND id = '{task_id}';
        """
    )

    if DB_MANAGER.query_result == 0:
        return {"msg": "You are not authorized to delete this organization"}

    DB_MANAGER.query(f"DELETE FROM tasks WHERE id = '{task_id}'")

    return {"msg": ""}
