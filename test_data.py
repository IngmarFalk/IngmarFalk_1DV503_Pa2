from typing import Any
import datetime as dt


tusers: list[dict[str, Any]] = [
    {
        "username": "Jeff",
        "password": "Jeff12345",
        "email": "jeff@ffej.com",
        "firstname": "jeff",
        "lastname": "jeffo",
    },
    {
        "username": "Bob",
        "password": "Bob123554",
        "email": "bob@bob.com",
        "firstname": "bob",
        "lastname": "bobbbo",
    },
    {
        "username": "Frank",
        "password": "Frank123554",
        "email": "frank@frank.com",
        "firstname": "frank",
        "lastname": "frankodot",
    },
    {
        "username": "Karl",
        "password": "Karl123554",
        "email": "karl@karl.com",
        "firstname": "karl",
        "lastname": "karlolotto",
    },
    {
        "username": "Sabine",
        "password": "Sabine123554",
        "email": "sabine@sabine.com",
        "firstname": "sabine",
        "lastname": "sabineineida",
    },
    {
        "username": "Anna",
        "password": "Anna123554",
        "email": "anna@anna.com",
        "firstname": "anna",
        "lastname": "Annanananna",
    },
    {
        "username": "Lisa",
        "password": "Lisa123342",
        "email": "lisa@lisa.com",
        "firstname": "lisa",
        "lastname": "Australisa",
    },
    {
        "username": "Lena",
        "password": "Lena123554",
        "email": "lena@lena.com",
        "firstname": "lena",
        "lastname": "lenarabia",
    },
    {
        "username": "Celine",
        "password": "Celine123554",
        "email": "celine@celine.com",
        "firstname": "celine",
        "lastname": "celeineaij",
    },
    {
        "username": "Robert",
        "password": "Robert123554",
        "email": "robert@robert.com",
        "firstname": "roberto",
        "lastname": "charlos",
    },
    {
        "username": "Christiano",
        "password": "BestFootballer123554",
        "email": "christiano@ronaldo.com",
        "firstname": "christiano",
        "lastname": "ronaldo",
    },
]

torgs: list[dict[str, Any]] = [
    {"name": "Apple", "field": "tech", "description": "Apple"},
    {"name": "Microsoft", "field": "tech", "description": "Microsoft"},
    {"name": "Amazon", "field": "tech", "description": "Amazon"},
    {"name": "BMW", "field": "car", "description": "BMW"},
    {"name": "VW", "field": "car", "description": "VW"},
    {"name": "Tesla", "field": "tech", "description": "Tesla"},
    {"name": "Spotify", "field": "music", "description": "Spotify"},
    {"name": "Netflix", "field": "entertainment", "description": "Netflix"},
    {"name": "Google", "field": "tech", "description": "Google"},
    {"name": "Samsung", "field": "tech", "description": "Samsung"},
    {"name": "Gazprom", "field": "gas & oil", "description": "Gazprom"},
]

tprojects: list[dict[str, Any]] = [
    {
        "id": 1,
        "name": "GoogleProject1",
        "organization": "Google",
        "status": "initial",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 2,
        "name": "GoogleProject2",
        "organization": "Google",
        "status": "finishing_stage",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 3,
        "name": "GoogleProject3",
        "organization": "Google",
        "status": "production",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 4,
        "name": "AmazonProject1",
        "organization": "Amazon",
        "status": "production",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 5,
        "name": "AmazonProject2",
        "organization": "Amazon",
        "status": "planning",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 6,
        "name": "AmazonProject3",
        "organization": "Amazon",
        "status": "development",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 7,
        "name": "VWProject1",
        "organization": "VW",
        "status": "development",
        "creation_date": dt.datetime.now(),
    },
    {
        "id": 8,
        "name": "VWProject2",
        "organization": "VW",
        "status": "production",
        "creation_date": dt.datetime.now(),
    },
]


def main():
    pass


if __name__ == "__main__":
    main()
