import datetime
from typing import Any
import mysql.connector as mycon
import logging as log


class DBManager:
    """
    This class automatically connects to the database on initialization and
    closes the connection once it falls out of scope. It also provides a method
    to execute SQL queries and to check wether the database exists.

    The query_result contains the result of the last executed query
    """

    query_result: list[Any] = []

    """
    Initializing all the database connection information with default arguments
    which might be overridden by the user.
    """

    def __init__(
        self,
        host: str = "localhost",
        db: str = "falkii",
        user: str = "manu",
        password: str = "Immanuel2021!",
    ) -> None:
        try:
            self.cnx = mycon.connect(
                host=host,
                user=user,
                password=password,
            )

            log.log(
                level=log.INFO,
                msg="Database connection established: "
                + host
                + ":"
                + user
                + ":"
                + password,
            )

            """Creating the connection and cursor"""
            self.csr = self.cnx.cursor()
            self.db = db

        except mycon.Error as e:
            log.log(level=log.ERROR, msg=f"Connection failed: ")
            print("Error connecting to MySQL database: ", e)

    def exists(self) -> bool | None:
        """Checking wether a database with the required name exists"""
        try:
            self.csr.execute("SHOW DATABASES LIKE '%s';" % self.db)
            result = str(self.csr.fetchone()).strip("(),''")
            return result == self.db
        except mycon.Error as e:
            print("Error database does not exist:", e)

    def query(self, query: str, *params) -> None:
        """Takes in a Sql statement as well as the arguments it needs and tries to execute it."""
        print(query)
        try:
            log.info(
                "Called query:\t"
                + query
                + " at "
                + str(datetime.datetime.now())
                + " with params:\t"
                + str(params)
            )

            """ Executing query, storing results in query_result and committing changes. """
            self.csr.execute(query, *params)
            self.query_result = self.csr.fetchall()
            self.cnx.commit()
            log.info("Query executed:\t" + query)

        except mycon.Error as e:
            log.log(level=log.ERROR, msg=f"ERROR executing query: {query}\nError: {e}")

    def display_query_rlt(self) -> None:
        """Iterates over the last query result and displays it nicely."""
        for row in self.query_result:
            print("-" * 52)
            for item in row:
                print(f"|{str(item):^50}|")
            print("-" * 52)

    def __del__(self) -> None:
        """When the class falls out of scope, it automatically closes the connection and cursor."""
        self.cnx.close()
        self.csr.close()


def main():
    pass


if __name__ == "__main__":
    main()
