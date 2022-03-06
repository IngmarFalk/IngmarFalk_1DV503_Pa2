#! venv/bin/python

from typing import Any
import fastapi
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi import FastAPI, Depends, Request
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
from models.base import Database, Table, Val, VARCHAR, INT, FLOAT, DOUBLE

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
    "create_project": "/create_project/",
    "user": "/user/",
    "organizations": "/organizations/",
    "projects": "/organisations/id/projects/",
    "tasks": "/user/tasks/",
}


@app.get(ROUTES["home"])
async def root():
    return {"f": "Hello World"}


" -------------Login-------------"


# @app.get(ROUTES["login"])
# async def get_login():
#     "TODO : Not sure what this is for right now, but we are probably gonna need it"
#     pass


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


" -------------Register-------------"


@app.post(ROUTES["register"])
async def register(registerData: dict[Any, Any]) -> dict[Any, Any]:
    """TODO : implement a post request that takes in an email, username and password
    and checks wether there is no duplicate in the database"""

    return registerData


async def validate(loginData: dict[str, str]) -> bool:
    "Check loginData in database"
    return False


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
