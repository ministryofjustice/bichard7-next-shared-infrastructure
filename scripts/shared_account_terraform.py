#!/usr/bin/env python3

import os
import subprocess
import argparse
import shutil

"""
Class to wrap terraform commands for shared account infrastructure

examples
### Provision infrastructure
aws-vault exec bichard7-sandbox -- scripts/shared_account_terraform.py sandbox infra

### destroy infrastructure
aws-vault exec bichard7-sandbox -- scripts/shared_account_terraform.py sandbox infra destroy
"""


class TerraformRunner(object):
    _account_name = None
    _user_type = None

    _state_buckets = {
        "sandbox": "cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate",
        "pathtolive": "cjse-bichard7-default-pathtolive-bootstrap-tfstate"
    }

    _state_files = {
        "infra": "tfstatefile",
        "infra_ci": "ci/tfstatefile",
        "users": "users/tfstatefile"
    }

    _lock_table_region = "eu-west-2"
    _args = None

    def _set_state_file(self):
        self._statefile = self._state_files.get(self._args.module, "tfstatefile")

    def _parse_arguments(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('environment', type=str, help="The environment ")
        parser.add_argument('module', type=str, help="The terraform module we want to run")
        parser.add_argument('action', type=str, default='apply', help="The terraform action we want to perform",
                            nargs="?")
        self._args = parser.parse_args()

    def _get_bucket(self):
        return self._state_buckets.get(self._args.environment, "cjse-bichard7-default-sharedaccount-sandbox-bootstrap-tfstate")

    @staticmethod
    def _generate_command(action="apply", extra_args=[]):
        return " ".join(["terraform", action] + extra_args)

    def _init_args(self):
        return [
            '-backend-config "bucket={}"'.format(self._get_bucket()),
            '-backend-config "dynamodb_table={}-lock"'.format(self._get_bucket()),
            '-backend-config "key={}"'.format(self._statefile),
            '-backend-config "region={}"'.format(self._lock_table_region)
        ]

    def _run_command(self, action="apply", extra_args=[]):
        command = self._generate_command(action=action, extra_args=extra_args)
        running_env = os.environ.copy()
        try:
            subprocess.run(args=command, env=running_env, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(e.output)
            exit(1)

    def run(self):
        self._parse_arguments()
        self._set_state_file()
        try:
            os.chdir(
                os.path.join(
                    "shared_account_{}_{}".format(
                        self._args.environment,
                        self._args.module
                    )
                )
            )
        except FileNotFoundError:
            print("Invalid target directory specified")
            exit(-1)

        try:
            shutil.rmtree(".terraform")
            os.unlink(".terraform.lock.hcl")
        except FileNotFoundError:
            pass

        self._run_command(action="init", extra_args=self._init_args())
        self._run_command(action=self._args.action,
                          extra_args=["-auto-approve" if os.getenv("AUTO_APPROVE") == "true" else ""])


if __name__ == "__main__":
    runner = TerraformRunner()
    runner.run()
