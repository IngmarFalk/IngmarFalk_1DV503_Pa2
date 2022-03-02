import fastapi
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi import FastAPI, Depends, Request
from sqlalchemy.orm import Session
from fastapi.responses import HTMLResponse


app = fastapi.FastAPI()

ROUTES = {
    "home": "/",
    "index": "/index",
    "tasks": "/tasks",
}

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get(ROUTES["index"], response_class=HTMLResponse)
async def get_item(
    req: Request,
):
    return templates.TemplateResponse("index.html", {"requser": req})


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
    return templates.TemplateResponse(
        "tasks.html",
        {
            "request": req,
            "name": name,
            "params": params,
        },
    )
