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


def main():
    pass


if __name__ == "__main__":
    main()
