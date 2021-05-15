/*-------------------------------
This file is used for the creation of the Redshift Cluster and the KMS key us for encrypting the cluster,
the file also contains a resource for creating a iam role and policies as well as security group
*/

############################################### KMS key for redshift cluster encryption

resource "aws_kms_key" "redshift_kms_key" {
  description         = "KMS key to encrypt redshift cluster"
  enable_key_rotation = true
  count               = var.main_redshift_cluster ? 1 : 0

  tags = merge(
    {
      Name = local.redshift_cluster_name
    },
    var.tags
  )

  policy = templatefile("./policies/redshift_kms_policy.json", {
    account_id = local.account_id
    org_id     = local.org_id
  })
}

resource "aws_kms_alias" "redshift_kms_alias" {
  count         = var.main_redshift_cluster ? 1 : 0
  target_key_id = aws_kms_key.redshift_kms_key[0].id
  name          = "alias/${local.redshift_cluster_name}"
}

################################################ Redshift cluster creation code

resource "aws_redshift_cluster" "default" {
  count = var.main_redshift_cluster ? 1 : 0

  cluster_identifier = local.redshift_cluster_name
  database_name      = var.redshift_database_name
  master_username    = var.redshift_username
  # Un-comment this for new redshift deployments or re-deployments
  master_password           = random_password.redshift_initial_secret[0].result
  encrypted                 = "true"
  kms_key_id                = aws_kms_key.redshift_kms_key[0].arn
  node_type                 = "dc2.large"
  cluster_type              = "multi-node"
  number_of_nodes           = "2"
  skip_final_snapshot       = "true"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group[0].id
  vpc_security_group_ids    = [aws_security_group.redshift_sg[0].id]
  iam_roles                 = [aws_iam_role.redshift_cluster_role[0].arn]

  tags = merge(
    {
      Name = var.redshift_database_name
    },
    var.tags
  )
}

resource "aws_iam_role" "redshift_cluster_role" {
  count              = var.main_redshift_cluster ? 1 : 0
  name               = "${local.redshift_cluster_name}-iam-role"
  description        = "Allows Redshift clusters to call AWS services on your behalf."
  assume_role_policy = templatefile("./policies/redshift_assume_policy.json", {})
  tags = merge(
    {
      Name = "${local.redshift_cluster_name}-iam-role"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "redshift_cluster_policy_attachment" {
  count      = var.main_redshift_cluster ? 1 : 0
  role       = aws_iam_role.redshift_cluster_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  description = "RedShift Cluster Subnet group for ${local.redshift_cluster_name}"
  count       = var.main_redshift_cluster ? 1 : 0
  name        = "${local.redshift_cluster_name}-cluster-subnet-group"
  subnet_ids  = data.aws_subnet_ids.redshift_subnets[0].ids

  tags = merge(
    {
      Name = "${local.redshift_cluster_name}-cluster-subnet-group"
    },
    var.tags
  )
}

resource "aws_security_group" "redshift_sg" {
  count       = var.main_redshift_cluster ? 1 : 0
  name        = "${local.redshift_cluster_name}-sg"
  description = "Security group to provide access to the redshift cluster - ${local.redshift_cluster_name}"
  vpc_id      = data.aws_vpc.redshift_vpc[0].id
  tags = merge(
    {
      Name = "${local.redshift_cluster_name}-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "redshift_ingress_firehose" {
  count             = var.main_redshift_cluster ? 1 : 0
  description       = "Grant access from FireHose to RedShift"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.firehose_ips_by_region
  security_group_id = aws_security_group.redshift_sg[0].id
}

resource "aws_security_group_rule" "redshift_egress_all" {
  count             = var.main_redshift_cluster ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redshift_sg[0].id
}