[
  {
    "name": "grafana",
    "image": "${grafana_image}",
    "essential": true,
    "cpu": ${application_cpu},
    "memory": ${application_memory},
    "user": "root",
    "dependsOn": [
    ],
    "mountPoints": [
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "GF_SERVER_DOMAIN",
        "value": "${grafana_domain}"
      },
      {
        "name": "GF_DATABASE_TYPE",
        "value": "postgres"
      },
      {
        "name": "GF_DATABASE_HOST",
        "value": "${database_host}"
      },
      {
        "name": "GF_DATABASE_NAME",
        "value": "${database_name}"
      },
      {
        "name": "GF_DATABASE_USER",
        "value": "${database_user}"
      },
     {
       "name": "GF_SECURITY_ADMIN_USER",
       "value": "${grafana_admin}"
     },
     {
        "name": "GF_LOG_MODE",
        "value": "console"
      },
      {
        "name": "GF_LOG_CONSOLE_LEVEL",
        "value": "info"
      },
      {
        "name": "GF_LOG_CONSOLE_FORMAT",
        "value": "json"
      },
      {
        "name": "CJSE_INFRA_ENVNAME",
        "value": "${environment}"
      },
      {
        "name": "CJSE_INFRA_DOMAIN",
        "value": "${domain}"
      }
    ],
    "environmentFiles": [],
    "secrets": [
      {
        "name": "GF_DATABASE_PASSWORD",
        "valueFrom": "${database_password_arn}"
      },
      {
        "name": "GF_SECURITY_ADMIN_PASSWORD",
        "valueFrom": "${grafana_admin_password_arn}"
      },
      {
        "name": "GF_SECURITY_SECRET_KEY",
        "valueFrom": "${grafana_secret_key_arn}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${exporter_log_stream_prefix}"
      }
    }
  }
]
