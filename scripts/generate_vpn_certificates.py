#!/usr/bin/env python3

import os
import pathlib
import subprocess
"""
Generates certificates to upload to SSM for the ci to consume

example
WORKSPACE=dev-next ENVIRONMENT=sandbox aws-vault exec sandbox-shared -- make generate-certificates
"""


class GenerateCertificates(object):
    def __init__(self):
        self.environment = os.getenv("ENVIRONMENT", "sandbox")
        self.workspace = os.getenv("WORKSPACE", "dev-next")
        self.cwd = os.getcwd()
        self.certificate_directory = "terraform/shared_account_{}_infra/VpnCerts/{}/".format(
            self.environment,
            self.workspace
        )

    def make_cert_directory(self):
        pathlib.Path(self.certificate_directory).mkdir(parents=True, exist_ok=True)

    def check_pki_exists(self):
        file = os.path.join(self.certificate_directory, "ca.crt")
        print("Checking for existance of {}".format(file))
        return os.path.isfile(file)

    def generate_certs(self):
        running_env = os.environ.copy()
        prefix = "EASYRSA_BATCH=1 easyrsa --pki-dir={}".format(self.certificate_directory)

        # Generate PKI
        suffix = "init-pki --force"
        command = "{} {}".format(prefix, suffix)
        subprocess.run(args=command, env=running_env, shell=True, check=True)

        # Generate CA
        suffix = "--req-cn=test-next build-ca nopass"
        command = "{} {}".format(prefix, suffix)
        subprocess.run(args=command, env=running_env, shell=True, check=True)

        # Generate Server Certificate
        suffix ="build-server-full server nopass"
        command = "{} {}".format(prefix, suffix)
        subprocess.run(args=command, env=running_env, shell=True, check=True)

        # Generate client certificate and key
        suffix = "build-client-full client1.domain.tld nopass"
        command = "{} {}".format(prefix, suffix)
        subprocess.run(args=command, env=running_env, shell=True, check=True)

    def move_certs(self):
        print("Moving certificates")
        os.rename(
            os.path.join(self.certificate_directory, "issued/server.crt"),
            os.path.join(self.certificate_directory, "server.crt"),
        )
        os.rename(
            os.path.join(self.certificate_directory, "issued/client1.domain.tld.crt"),
            os.path.join(self.certificate_directory, "client1.domain.tld.crt"),
        )
        os.rename(
            os.path.join(self.certificate_directory, "private/server.key"),
            os.path.join(self.certificate_directory, "server.key"),
        )
        os.rename(
            os.path.join(self.certificate_directory, "private/client1.domain.tld.key"),
            os.path.join(self.certificate_directory, "client1.domain.tld.key"),
        )

    def run(self):
        self.__init__()
        self.make_cert_directory()
        print(os.getenv("FORCE"))
        pki_exists = self.check_pki_exists()
        if (pki_exists and os.getenv("FORCE", "0") == "1") or pki_exists is False:
            self.generate_certs()
            self.move_certs()
        else:
            print("The PKI exists and FORCE was not set")


if __name__ == "__main__":
    generator = GenerateCertificates()
    generator.run()
