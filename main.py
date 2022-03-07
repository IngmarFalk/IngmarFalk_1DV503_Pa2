#! venv/bin/python

import json
from typing import Any
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
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
    "create_project": "/user/{username}/create_project/",
    "user": "/user/",
    "organizations": "/organizations/",
    "projects": "/organisations/id/projects/",
    "tasks": "/user/tasks/",
}

DB_MANAGER = init_db()


async def check_for_user(userData: dict[Any, Any]) -> bool:
    """Check if there exists a user with the provided credentials and returns a boolean"""

    DB_MANAGER.use()
    DB_MANAGER.query("SELECT * FROM users WHERE username LIKE %s", userData["username"])

    """
    If there is a result, that means there is a user with the provided credentials,
    which then returns 'True', otherwise if they response is 'null', that means there is
    no such user and the function returns 'True'
    """
    if len(DB_MANAGER.query_result) == 0:
        return False
    return True


" -------------Login-------------"


@app.post(ROUTES["login"])
async def post_login(loginData: dict[Any, Any]) -> dict[Any, Any]:
    """TODO :
    implement a post request that takes in a
        [X] username and password and
        [] validates it
    """

    """ TODO
    if validation(user) == userAlreadyExists:
        raise fastApi.HTTPException(status=409, detail="User already exists)
   
    database.insert_into(users, user) OR database.users.add(user)
    """

    return loginData


async def validate(loginData: dict[str, str]) -> str | None:
    "Check loginData in database"

    if not check_for_user(loginData):
        return "No such user exists"

    """
    It is a terrible idea to store user passwords in plain text, but for this project
    it should be fine. If I am to extend this app, this is definetely something I have
    to change.
    """
    DB_MANAGER.use()
    DB_MANAGER.query(
        "SELECT * FROM users WHERE username = '%s' AND password = '%s'"
        % loginData.values()
    )
    if len(DB_MANAGER.query_result) == 0:
        return "Invalid Password"

    return None


" -------------Register-------------"


@app.post(ROUTES["register"])
async def register(registerData: dict[Any, Any]) -> dict[Any, Any]:
    """TODO : implement a post request that takes in an email, username and password
    and checks wether there is no duplicate in the database"""

    "Validating that there are no existing users with the same email and username"
    if not await check_for_user(registerData):
        print("Does not exist")
        DB_MANAGER.use()
        DB_MANAGER.query(ProjM().users.insert(registerData), *registerData.values())
        return {"msg": ""}
    else:
        return {"msg": "User already exists"}


@app.get(ROUTES["register"])
async def user_already_exists() -> str:
    "Is called when a user already exists in the database"
    return json.dumps({"exists": True})


# @app.get(ROUTES["home"], response_class=HTMLResponse)
# async def root(req: Request):
#     return templates.TemplateResponse(
#         "home.html",
#         {
#             "request": req,
#         }
#     )


# @app.get(ROUTES["register"])
# async def register(req: Request):
#     return {"register": 123}


@app.get(ROUTES["user"])
async def user(
    req: Request,
):
    return {"user": 123}


@app.get(ROUTES["tasks"], response_class=HTMLResponse)
async def get_book(
    req: Request,
    name: str = "Max",
    params: list = [
        "Clean Dishes",
        "Bring out garbage",
        "Make Salad",
        "Feed Lamas",
        "Spill the beans",
        "Talk to Putin",
    ],
):
    return {"tasks": params}
