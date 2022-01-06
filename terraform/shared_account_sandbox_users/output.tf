
output "admin_users" {
  description = "A list of admin users"
  sensitive   = true
  value = sort([
    aws_iam_user.ben_pirt.name,
    aws_iam_user.simon_oldham.name,
    aws_iam_user.brett_minnie.name,
    aws_iam_user.emad_karamad.name,
    aws_iam_user.jamie_davies.name,
    aws_iam_user.mihai_popa_matai.name,
    aws_iam_user.jazz_sarkaria.name
  ])
}

output "readonly_users" {
  description = "A list of read-only users"
  sensitive   = true
  value = sort([])
}
