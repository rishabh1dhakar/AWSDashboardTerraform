/*-------------------------------
This file creates a Secrets Manager value for the redshift password, generates a random value and
uploads it to the entry, creates and uses a KMS key which is encrypting the value itself
*/

resource "aws_kms_key" "secrets_manager_key" {
  description         = "Redshift password secrets manager encryption key"
  enable_key_rotation = true
  count               = var.main_redshift_cluster ? 1 : 0

  tags = merge(
    {
      Name = var.redshift_secret_name
    },
    var.tags
  )

  policy = templatefile("./policies/secrets_manager_kms_policy.json", {
    account_id = local.account_id
    org_id     = local.org_id
  })
}

resource "aws_kms_alias" "sm_key_alias" {
  count         = var.main_redshift_cluster ? 1 : 0
  target_key_id = aws_kms_key.secrets_manager_key[0].id
  name          = "alias/${var.redshift_secret_name}"
}

resource "aws_secretsmanager_secret" "redshift_secret" {
  description = "Redshift password secret"
  count       = var.main_redshift_cluster ? 1 : 0
  name        = var.redshift_secret_name
  kms_key_id  = aws_kms_key.secrets_manager_key[0].id

  policy = templatefile("./policies/secret_manager_policy.json", {
    account_id = local.account_id
    org_id     = local.org_id
  })
  tags = merge(
    {
      Name = var.redshift_secret_name
    },
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "redshift_secret_version" {
  count         = var.main_redshift_cluster ? 1 : 0
  secret_id     = aws_secretsmanager_secret.redshift_secret[0].id
  secret_string = random_password.redshift_initial_secret[0].result
}

resource "random_password" "redshift_initial_secret" {
  count            = var.main_redshift_cluster ? 1 : 0
  length           = 32
  special          = true
  override_special = "#$%&*()-_=+{}<>:?" # redshift doesn't accept the following special chars: [/@"' ]
}