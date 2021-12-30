#!/usr/bin/env python3

import os
import argparse
import shutil
import subprocess

"""
Class that will run terraform init in a specific subdirectory or all subdirectories it finds under the path

If a subdirectory is specified, only that directory will be inited

examples:

Init an entire directory tree

python scripts/init_terraform.py modules

Init an entire directory tree with backend=false

python scripts/init_terraform.py modules -skip_backend=True

Init a single directory

python scripts/init_terraform.py terraform -sub_directory=monitoring -skip_backend=True

"""


class TerraformInit(object):

    def __init__(self):
        self._sub_dirs = []

    def run(self):
        self._parse_arguments()
        self.find_sub_directories()
        self._sub_dirs.sort()
        self.clean_and_init_directory()

    def _parse_arguments(self):
        parser = argparse.ArgumentParser()
        parser.add_argument(
            'parent_directory',
            type=str,
            help="The terraform directory we want to init"
        )
        parser.add_argument(
            '-sub_directory',
            type=str,
            help="Are we initialising a single directory",
            required=False
        )
        parser.add_argument(
            '-skip_backend',
            type=str,
            default="false",
            help="Do we want to run this init with '-backend=false'?",
            nargs="?"
        )
        self._args = parser.parse_args()

    @staticmethod
    def _check_directory_exists(path):
        try:
            os.chdir(path)
        except FileNotFoundError:
            print("Could not change to the {} directory".format(
                path
            ))
            exit(1)

    def find_sub_directories(self):
        if self._args.sub_directory is None:
            self._check_directory_exists(self._args.parent_directory)
            for item in os.listdir():
                if os.path.isdir(item):
                    self._sub_dirs.append(item)
        else:
            path = "{}{}{}".format(
                self._args.parent_directory,
                os.path.sep,
                self._args.sub_directory
            )
            self._check_directory_exists(path)
            self._sub_dirs.append(path)

    @staticmethod
    def _clean_directory(path):
        '''
        Removes old terraform locks and initialisation dirs
        :param path:
        :return:
        '''
        print("Cleaning out {}".format(path))
        cur_dir = os.getcwd()
        os.chdir(path)
        try:
            shutil.rmtree(".terraform")
        except FileNotFoundError:
            pass
        try:
            os.unlink(".terraform.lock.hcl")
        except FileNotFoundError:
            pass
        os.chdir(cur_dir)

    def _init_directory(self, path):
        """
        Will run terraform init if the directory is not empty
        :param path:
        :return:
        """
        if os.listdir(path):
            print("Running terraform init in {}".format(path))
            cur_dir = os.getcwd()
            os.chdir(path)
            try:
                if self._args.skip_backend:
                    subprocess.run(args=["terraform", "init", "-backend=false"])
                else:
                    subprocess.run(args=["terraform", "init"])
            except subprocess.CalledProcessError as e:
                print(e.output)
                exit(1)
            os.chdir(cur_dir)
        else:
            print("Path {} is empty. Skipping".format(path))

    def clean_and_init_directory(self):
        for directory in self._sub_dirs:
            self._clean_directory(directory)
            self._init_directory(directory)


if __name__ == "__main__":
    init = TerraformInit()
    init.run()
