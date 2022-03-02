from abc import ABC, abstractmethod
from types import NoneType
from typing import Any, List


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
        self.nullable = nullable
        self.primary_key = primary_key
        self.foreign_key = foreign_key
        #! Important, value has to be declared before size and auto_increment
        self.value = value
        self.size = size
        self.auto_increment = auto_increment

    @property
    def __name__(self) -> str:
        return str(self.__class__.__name__)

    def get_keys(self) -> List[str]:
        return [key.strip("_") for key in self.__dict__]

    @abstractmethod
    def __str__(self) -> str:

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

    def __repr__(self):
        return "".join([f"{key} : {val}\n" for key, val in vars(self).items()])

    @property
    def nullable(self) -> bool:
        return self._nullabe

    @nullable.setter
    def nullable(self, val: bool) -> None:
        self._nullabe = val

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
        self._value = val

    @property
    def auto_increment(self) -> bool:
        return self._auto_increment

    @auto_increment.setter
    def auto_increment(self, val: bool) -> None:
        if self.value and self.value is int:
            self._auto_increment = val
        else:
            self._auto_increment = False

    @property
    def size(self) -> int:
        return self._size

    @size.setter
    def size(self, val: int) -> None:
        if self.value and self.value is str and val:
            self._size = val
        else:
            self._size = 0


class BIGINT(Val):
    def __init__(self, **kwargs) -> None:
        value: type = int
        kwargs["value"] = value
        return super().__init__(**kwargs)

    def __str__(self) -> str:
        return super().__str__().replace("int", "bigint")


class INT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = int
        return super().__init__(**kwargs)


class FLOAT(Val):
    def __init__(self, **kwargs) -> None:
        kwargs["value"] = float
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


class Base(ABC):

    # @property
    # @abstractmethod
    # def slots(self) -> list[str]:
    #     pass

    # @slots.setter
    # @abstractmethod
    # def slots(self, slots) -> None:
    #     pass

    @abstractmethod
    def get_params(self) -> list[str]:
        return [attr for attr in self.__class__.__dict__.items()]

    @abstractmethod
    def querify(self) -> str:
        pass


class Table(Base):
    # name: str = ""
    # age: int = 0
    # city: str = ""
    # tnone: str = ""

    # def __new__(cls, name, age, city, tnone)

    def __init__(
        self,
        name="",
        age=0,
        city="",
        tnone=None,
    ) -> None:
        self.name = name
        self.age = age
        self.city = city
        self.tnone = tnone

    def get_params(self) -> List[str]:
        return super().get_params()

    def querify(self) -> str:
        return ""


class T:
    firstname: VARCHAR = VARCHAR(
        size=255,
        nullable=True,
        foreign_key=True,
    )
    lastname: VARCHAR = VARCHAR(
        size=255,
        nullable=True,
        primary_key=True,
        auto_increment=True,
    )
    age: INT = INT(
        primary_key=True,
        auto_increment=True,
    )

    def __cols__(self):
        return self.__annotations__


def main():
    t1 = T()
    print(str(t1.age))
    print(str(t1.firstname))
    print(str(t1.lastname))
    # print(t1.age)
    # print(t1.age.value.__name__)
    # print(t1.name.value.__name__)
    # print(t1.nan.value.__name__)


if __name__ == "__main__":
    main()
