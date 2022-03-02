#! venv/bin/python


def create_db(db_name: str) -> str:
    return "CREATE DATABASE IF NOT EXISTS " + db_name


def create_table(table_name: str, *cols) -> str:
    return f"CREATE TABLE IF NOT EXISTS {table_name}(" + ", ".join(cols) + ");"


def main():
    pass


if __name__ == "__main__":
    main()
