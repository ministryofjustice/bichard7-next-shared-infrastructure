[
  {
      "name": "scanning_results",
      "image": "${scanning_results_portal_image}",
      "essential": true,
      "cpu":${scanning_cpu_units},
      "memory":${scanning_memory_units},
      "user": "root",
      "dependsOn": [],
      "mountPoints": [],
      "portMappings": [
        {
          "containerPort": 443,
          "hostPort": 443,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "S3_BUCKET_NAME",
          "value": "${bucket_name}"
        }
      ],
      "environmentFiles": [],
      "secrets": [
        {
          "name": "HTPASSWD",
          "valueFrom": "${htpasswd_arn}"
        },
        {
          "name": "AWS_ACCESS_KEY_ID",
          "valueFrom": "${access_key_arn}"
        },
        {
          "name": "AWS_SECRET_ACCESS_KEY",
          "valueFrom": "${secret_key_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "${log_stream_prefix}"
        }
      }
   }
]
