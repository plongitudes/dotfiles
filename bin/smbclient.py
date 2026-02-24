#!/usr/bin/env python

import pathlib

import dotenv
import smbclient

env = dotenv.dotenv_values(dotenv.find_dotenv())
HOST = env.get("host")
USER = env.get("user")
AUTH = env.get("auth")
PATH = env.get("path")

smbclient.ClientConfig(HOST, USER, AUTH)


def main():
    files = []
    smbpath = pathlib.Path.joinpath(HOST, PATH)

    # Get all files in a director/folder
    contents = smbclient.listdir(smbpath)

    for file in contents:
        files.append(file)
        print(file)


if __name__ == "__main__":
    main()
