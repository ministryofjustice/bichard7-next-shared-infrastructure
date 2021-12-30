{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetHostedZoneCount",
        "route53:ListHostedZonesByName"
      ],
      "Resource": "arn:aws:route53:::hostedzone/${zone_id}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetChange"
       ],
       "Resource": "arn:aws:route53:::change/*"
    }
  ]
}
