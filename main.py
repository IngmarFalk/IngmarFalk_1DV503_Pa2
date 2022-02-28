import logging

import fastapi
from db.db_manager import DBManager
import db.queries as queries
import db.tables as tables

LOGIN_DATA = {
    "host": "localhost",
    "user": "manu",
    "password": "Immanuel2021!",
}

DB = "falkii"

app = fastapi.FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/items/{id}")
async def get_item(id):
    return {"item_id": id}


# def main():

# db = DBManager()

# logging.basicConfig(level=logging.INFO, filename="info.log")

# if not db.exists():
#     db.query(queries.create_db(db.db))
#     db.query("USE " + db.db)
#     db.query(queries.create_table("users", *tables.get_users_cols()))
#     db.query(queries.create_table("user_info", *tables.get_user_info()))
#     db.query(
#         queries.create_table("organizations", *tables.get_organizations_cols())
#     )
#     db.query(queries.create_table("projects", *tables.get_project_cols()))
#     db.query(queries.create_table("project_leaders", *tables.get_project_leaders()))
#     db.query(queries.create_table("tasks", *tables.get_tasks_cols()))
#     db.query


# if __name__ == "__main__":
#     main()
