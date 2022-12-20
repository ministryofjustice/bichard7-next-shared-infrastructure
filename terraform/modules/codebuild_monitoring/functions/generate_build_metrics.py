#! /usr/bin/python3

import boto3
from enum import IntEnum

excluded_projects = [
    "apply-dev-sgs-to-load-test",
    "deploy-integration-baseline-load-test",
    "destroy-integration-baseline-load-test",
    "destroy-integration-baseline-e2e-test",
    "destroy-integration-next-e2e-test",
    "destroy-qsolution-preprod",
    "destroy-qsolution-production",
    "restart-load-test-pnc-emulator-container",
    "restart-load-test-migrations",
    "run-load-test",
    "run-load-test-migrations",
    "remove-dev-sgs-from-load-test"
]


class BuildStatus(IntEnum):
    """
    Basic enum class that we can use to display a RAG status on a dashboard
    """
    FAILED = 0  # Red
    PASSED = 1  # Green
    BUILDING = 2  # Yellow
    UNKNOWN = 3  # Grey


class Project(object):
    """
    Data class for our project objects
    """

    def __init__(self, name=None):
        self.project_name = name
        self.build_number = None
        self.build_status = BuildStatus.UNKNOWN

    @property
    def project_name(self):
        return self._project_name

    @project_name.setter
    def project_name(self, value):
        self._project_name = value

    @property
    def build_number(self):
        return self._build_number

    @build_number.setter
    def build_number(self, value):
        self._build_number = value

    @property
    def build_status(self):
        return self._build_status

    @build_status.setter
    def build_status(self, value):
        if value == "SUCCEEDED":
            self._build_status = BuildStatus.PASSED
        elif value == "IN_PROGRESS":
            self._build_status = BuildStatus.BUILDING
        elif value == "FAILED":
            self._build_status = BuildStatus.FAILED
        else:
            self._build_status = BuildStatus.UNKNOWN


class CodebuildMetrics(object):
    """
    Class that finds the last build and extracts the relevant bits of information on the
    last build per project
    """

    def __init__(self):
        self._client = boto3.client('codebuild')
        self._projects = []

    def _get_projects(self):
        for project_name in self._client.list_projects()['projects']:
            if project_name in excluded_projects:
                continue
            project = Project()
            project.project_name = project_name
            self._projects.append(project)

    def _get_project_last_build(self, project):
        builds = self._client.list_builds_for_project(
            projectName=project.project_name
        )

        if builds['ids'] and len(builds['ids']):
            project.build_number = builds['ids'][0]
        return project

    def _get_last_build_status(self, project):
        if project.build_number:
            status = self._client.batch_get_builds(
                ids=[project.build_number]
            )

            if status['builds'] and len(status['builds']):
                project.build_status = status['builds'][0]['buildStatus']

    def get_last_build_status(self):
        self._get_projects()
        metrics = CloudWatchMetric()
        for project in self._projects:
            self._get_last_build_status(
                self._get_project_last_build(project)
            )
            metrics.put_data(project)


class CloudWatchMetric(object):
    """
    Class that will inject our metrics into cloudwatch
    """

    def __init__(self):
        self._client = boto3.client('cloudwatch')

    def put_data(self, project):
        namespace = 'Codebuild'
        metric_data = [
            {
                'MetricName': 'last_build_status',
                'Dimensions': [
                    {
                        'Name': 'project',
                        'Value': project.project_name
                    },
                ],
                'Value': int(project.build_status),
                'Unit': 'None'
            }
        ]

        print(metric_data)

        try:
            self._client.put_metric_data(
                Namespace=namespace,
                MetricData=metric_data
            )
        except Exception:
            pass


def lambda_handler(event, context):
    init = CodebuildMetrics()
    init.get_last_build_status()


if __name__ == "__main__":
    init = CodebuildMetrics()
    init.get_last_build_status()
