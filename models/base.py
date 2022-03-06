#! venv/bin/python

from abc import ABC, abstractmethod
import json
from types import NoneType
from typing import Any


class Val:
    @abstractmethod
    def __init__(
        self,
        nullable: bool = False,
        primary_key: bool = False,
        foreign_key: bool = False,
        auto_increment: bool = False,
        size: int = 0,
        value: type = NoneType,
    ) -> None:
        self.primary_key = primary_key
        self.foreign_key = foreign_key
        #! Important, value has to be declared before size and auto_increment
        self.value = value
        self.size = size
        self.auto_increment = auto_increment
        self.nullable = nullable

    @property
    def __name__(self) -> str:
        return str(self.__class__.__name__)

    @abstractmethod
    def asSql(self) -> str:

        out = self.__name__

        if self.__name__ == "VARCHAR":
            out += f"({self.size})"

        if not self.nullable:
            out += " NOT NULL"

        if self.auto_increment:
            out += " AUTO_INCREMENT"

        if self.primary_key:
            out += " PRIMARY KEY"
        else:
            if self.foreign_key:
                out += " FOREIGN KEY"

        return out

    def __repr__(self) -> str:
        return self.__name__

    def toJson(self) -> Any:
        return 0 if self.value == int or self.value == float else ""

    "--------------------------------P R O P E R T I E S--------------------------------"

    @property
    def attrs(self) -> dict[str, dict[str, type]]:
        return {self.__name__: self.__dict__}
        # return {
        #     self.__name__: {
        #         k: v
        #         for k, v in self.__dict__.items()
        #         if not k.startswith("_") and not callable(getattr(self, k))
        #     },
        # }

    @property
    def nullable(self) -> bool:
        return self.nullabe

    @nullable.setter
    def nullable(self, val: bool) -> None:
        if val and self.primary_key:
            raise PrimaryKeyNotNullableError(
                msg="A primary key has to uniquely identify every other item in the set, so it cannot be null."
            )
        self.nullabe = val

    @property
    def primary_key(self) -> bool:
        return self._primary_key

    @primary_key.setter
    def primary_key(self, val: bool) -> None:
        self._primary_key = val

    @property
    def foreign_key(self) -> bool:
        return self._foreign_key

    @foreign_key.setter
    def foreign_key(self, val: bool) -> None:
        self._foreign_key = val

    @property
    def value(self) -> type:
        return self._value

    @value.setter
    def value(self, val: type) -> None:
        if not val:
            raise ValueForColumnCannotBeNullError(
                msg="A column cannot contain only null values."
            )
        self._value = val

    @property
    def auto_increment(self) -> bool:
        return self._auto_increment

    @auto_increment.setter
    def auto_increment(self, val: bool) -> None:
        if val and self.value != int:
            raise TriedMakingNoneIntegerAutoincrement(
                msg="A non-integer item cannot also be auto_increment."
            )
        self._auto_increment = val

    @property
    def size(self) -> int:
        return self._size

    @size.setter
    def size(self, val: int) -> None:
        if val and self.__name__.lower() not in ["varchar", "char"]:
            raise TriedGivingInvalidTypeSizeError(
                msg="A non-varchar item cannot also be have a size."
            )
        self._size = val


"--------------------------------S Q L   T Y P E S--------------------------------"
" This is not complete, but it is enough for this project"


class SMALLINT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = int
        return super().__init__(**kwargs)


class INT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = int
        return super().__init__(**kwargs)


class BIGINT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = int
        return super().__init__(**kwargs)


class FLOAT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = float
        return super().__init__(**kwargs)


class DOUBLE(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = float
        return super().__init__(**kwargs)


class DATETIME(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = str
        return super().__init__(**kwargs)


class CHAR(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = str
        kwargs["size"] = 1
        super().__init__(**kwargs)


class VARCHAR(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = str
        return super().__init__(**kwargs)


class TEXT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = str
        return super().__init__(**kwargs)


class BOOLEAN(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = bool
        return super().__init__(**kwargs)


"--------------------------------S Q L   D A T A S T R U C T U R E S--------------------------------"


class Base(ABC):
    @abstractmethod
    def __str__(self):
        pass

    def get_items(self) -> dict[str, Any]:
        return {
            k: v
            for k, v in self.__class__.__dict__.items()
            if not k.startswith("_") and not callable(getattr(self, k))
        }

    def __repr__(self):
        return self.__class__.__name__.lower()


class Table(Base):
    def __str__(self) -> str:
        return self.__repr__()

    def asSql(self) -> str:
        if not self.check_none_or_one_primary_key():
            raise TooManyPrimaryKeysError(msg="A table can only have one primary key")
        return (
            f"CREATE TABLE IF NOT EXISTS {self.__repr__()} ("
            + ", ".join([f"{k} {v.asSql()}" for k, v in self.columns.items()])
            + ");"
        )

    @property
    def columns(self) -> dict[str, Val]:
        return super().get_items()

    def check_none_or_one_primary_key(self) -> bool:
        primary_key_counter = len(
            [attr for attr in self.columns if "PRIMARY KEY" in attr]
        )
        return True if primary_key_counter <= 1 else False

    def get(self, *args) -> str:
        "Unimplemented"  # TODO
        return ""

    def insert(self, *args) -> str:
        return (
            "INSERT INTO "
            + self.__repr__()
            + " VALUES ("
            + ", ".join(["%s" for _ in range(len(args))])
            + ");"
        )

    def update(self, *args) -> str:
        "Unimplemented"  # TODO
        return ""

    def delete(self, *args) -> str:
        "Unimplemented"  # TODO
        return ""

    def toJson(self) -> str:
        return json.dumps(
            {col: val.toJson() for col, val in self.columns.items()},
            indent=4,
            sort_keys=True,
        )


class Database(Base):
    def asSql(self) -> str:
        return f"CREATE DATABASE IF NOT EXISTS {self.__repr__()};"

    def __str__(self) -> str:
        return str(self.__class__.__name__)

    @property
    def tables(self) -> dict[str, Table]:
        return super().get_items()

    def alter_table(self, table: Table, columns_to_alter: dict[str, dict[str, Val]]):
        """This function could be called like this:
        Maybe:
        # alter_table(
        #     table = t1,
        #     columns_to_alter = {
        #         username: {
        #             user_id: INT(
        #                 auto_increment = True,
        #                 primary_key = True,
        #             )
        #         },
        #     }
        # )
        This would then change the column username to user_id and its type to int.
        If the column to be changed is empty, a new column will be created.
        """

    def add_table(self, table: Table) -> str:
        "Takes in a new table and calls its 'asSql' method to add it to the database"
        return table.asSql()

    def remove_table(self, table: Table) -> str:
        "Takes in a table and removes it from the database"
        return "DROP TABLE IF EXISTS %s;" % str(table)

    def toJson(self) -> str:
        return json.dumps(
            {table: table for table in self.tables}, indent=4, sort_keys=True
        )
        # return (
        #     "{\n    "
        #     + ",\n    ".join(f'"{table}": ' + table for table in self.tables)
        #     + "\n}"
        # )

    def display(self) -> None:
        for table_name, table in self.tables.items():
            print("  ", table_name, ":", table)
            for col, col_val in table.columns.items():
                print("\t", col, ":", col_val)
                for type, keywords in col_val.attrs.items():
                    print("\t  ", type, ":", keywords)
                    # TODO : still displays the class variables with underscores in fron of them


"--------------------------------E X C E P T I O N S--------------------------------"


class SQLError(Exception):
    "Base SQL Error class"

    def __init__(self, msg: str, **kwargs):
        super().__init__(msg, **kwargs)


class TriedMakingNoneIntegerAutoincrement(SQLError):
    """
    Is going to be raised if user tries to create a table column
    that contains for VARCHAR's or other non-INTEGER types that
    also has auto_increment set to true.
    """


class TriedGivingInvalidTypeSizeError(SQLError):
    "Is going to be raised if user tries to give a non-VARCHAR type a size"


class TooManyPrimaryKeysError(SQLError):
    "Is going to be raised if user tries to create a table with multiple primary keys"


class PrimaryKeyNotNullableError(SQLError):
    "Is going to be raised if user tries to create a nullable primary key column"


class ValueForColumnCannotBeNullError(SQLError):
    "Is going to be raised if user tries to create a column with no value specified"


"--------------------------------T E S T I N G  /  D E B U G G I N G--------------------------------"


class T1(Table):
    username: VARCHAR = VARCHAR(
        size=255,
        primary_key=True,
    )
    firstname: VARCHAR = VARCHAR(
        size=255,
    )
    lastname: VARCHAR = VARCHAR(
        size=255,
    )
    credits: FLOAT = FLOAT()


class T2(Table):
    city: VARCHAR = VARCHAR(
        size=255,
    )
    street: VARCHAR = VARCHAR(
        size=255,
    )
    zip_code: INT = INT(
        nullable=True,
    )
    user: VARCHAR = VARCHAR(
        size=255,
        foreign_key=True,
    )


class D1(Database):
    t1: Table = T1()
    t2: Table = T2()


def main():

    # D1().display()
    print(D1().toJson())
    print(D1().asSql())
    print(D1().t1.toJson())
    print(D1().t2.toJson())
    print(D1().t1.asSql())
    print(D1().t2.asSql())


if __name__ == "__main__":
    main()
