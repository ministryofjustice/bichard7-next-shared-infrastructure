## Brett Minnie
data "aws_ssm_parameter" "brett_minnie" {
  name = "/users/brett_minnie"
}

resource "aws_iam_user" "brett_minnie" {
  name = data.aws_ssm_parameter.brett_minnie.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "brett_minnie" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.brett_minnie.name
}

## Simon Oldham
data "aws_ssm_parameter" "simon_oldham" {
  name = "/users/simon_oldham"
}

resource "aws_iam_user" "simon_oldham" {
  name = data.aws_ssm_parameter.simon_oldham.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "simon_oldham" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.simon_oldham.name
}

##Ben Pirt
data "aws_ssm_parameter" "ben_pirt" {
  name = "/users/ben_pirt"
}

resource "aws_iam_user" "ben_pirt" {
  name = data.aws_ssm_parameter.ben_pirt.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "ben_pirt" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.ben_pirt.name
}

## Emad Karamad
data "aws_ssm_parameter" "emad_karamad" {
  name = "/users/emad_karamad"
}

resource "aws_iam_user" "emad_karamad" {
  name = data.aws_ssm_parameter.emad_karamad.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "emad_karamad" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.emad_karamad.name
}

# Jamie Davies
data "aws_ssm_parameter" "jamie_davies" {
  name = "/users/jamie_davies"
}

resource "aws_iam_user" "jamie_davies" {
  name = data.aws_ssm_parameter.jamie_davies.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "jamie_davies" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.jamie_davies.name
}

#Mihai Popa Matai
data "aws_ssm_parameter" "mihai_popa_matai" {
  name = "/users/mihai_popa_matai"
}

resource "aws_iam_user" "mihai_popa_matai" {
  name = data.aws_ssm_parameter.mihai_popa_matai.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "mihai_popa_matai" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.mihai_popa_matai.name
}

#Jazz Sarkaria
data "aws_ssm_parameter" "jazz_sarkaria" {
  name = "/users/jazz_sarkaria"
}

resource "aws_iam_user" "jazz_sarkaria" {
  name = data.aws_ssm_parameter.jazz_sarkaria.value

  tags = merge(
    module.label.tags,
    {
      "user-role" = "operations"
    }
  )
}

resource "aws_iam_user_group_membership" "jazz_sarkaria" {
  groups = [
    data.aws_iam_group.admin_group.group_name,
    data.aws_iam_group.mfa_group.group_name
  ]
  user = aws_iam_user.jazz_sarkaria.name
}
