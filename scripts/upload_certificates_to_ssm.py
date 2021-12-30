#!/usr/bin/env python3

import boto3
import os
import base64

"""
Uploads pre-generated certificates to SSM for the ci to consume

example
WORKSPACE=dev-next ENVIRONMENT=sandbox aws-vault exec sandbox-shared -- make upload-certificates
"""


class UploadCertificates(object):
    ssm_client = None
    environment = None
    workspace = None

    def __init__(self):
        self.ssm_client = boto3.client('ssm')
        self.environment = os.getenv("ENVIRONMENT", "sandbox")
        self.workspace = os.getenv("WORKSPACE", "dev-next")

    def upload_file(self, file_name):
        print("Uploading {} to /ci/certs/{}/{}".format(file_name, self.workspace, file_name))
        file = open("terraform/shared_account_{}_infra/VpnCerts/{}/{}".format(
            self.environment,
            self.workspace,
            file_name
        ))
        contents = file.read()
        contents = base64.b64encode(contents.encode())
        file.close()
        self.ssm_client.put_parameter(
            Name="/ci/certs/{}/{}".format(self.workspace, file_name),
            Value=contents.decode(),
            Type="SecureString",
            Overwrite=True,
            Tier="Advanced"
        )

    def run(self):
        self.__init__()
        path = "terraform/shared_account_{}_infra/VpnCerts/{}".format(
            self.environment,
            self.workspace
        )
        if os.path.isdir(path):
            self.upload_file(file_name="ca.crt")
            self.upload_file(file_name="client1.domain.tld.crt")
            self.upload_file(file_name="client1.domain.tld.key")
            self.upload_file(file_name="server.crt")
            self.upload_file(file_name="server.key")
        else:
            print(
                "No certificates exist in {}, please see make generate-certificates to create them!".format(
                    path
                )
            )


if __name__ == "__main__":
    uploader = UploadCertificates()
    uploader.run()
