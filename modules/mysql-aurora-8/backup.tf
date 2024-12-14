resource "aws_backup_plan" "this" {
  name = "${var.environment}-${var.app_name}"

  rule {
    rule_name                    = "${var.environment}-${var.app_name}-daily"
    target_vault_name            = aws_backup_vault.this.name
    schedule                     = "cron(0 5 * * ? *)" # Midnight Bogota Time
    schedule_expression_timezone = "Etc/UTC"

    lifecycle {
      delete_after = 7
    }
  }
  rule {
    rule_name                    = "${var.environment}-${var.app_name}-weekly"
    target_vault_name            = aws_backup_vault.this.name
    schedule                     = "cron(0 5 ? * MON *)" # Midnight Bogota Time
    schedule_expression_timezone = "Etc/UTC"

    lifecycle {
      delete_after = 4
    }
  }
  rule {
    rule_name                    = "${var.environment}-${var.app_name}-monthly"
    target_vault_name            = aws_backup_vault.this.name
    schedule                     = "cron(0 5 1 * ? *)" # Midnight Bogota Time
    schedule_expression_timezone = "Etc/UTC"

    lifecycle {
      delete_after = 12
    }
  }
  rule {
    rule_name                    = "${var.environment}-${var.app_name}-yearly"
    target_vault_name            = aws_backup_vault.this.name
    schedule                     = "cron(0 5 1 1 ? *)" # Midnight Bogota Time
    schedule_expression_timezone = "Etc/UTC"

    lifecycle {
      delete_after = 3
    }
  }

}

resource "aws_backup_vault" "this" {
  name = "${var.environment}-${var.app_name}-vault"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.environment}-${var.app_name}-awsbackup"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.this.name
}

resource "aws_backup_selection" "this" {
  iam_role_arn = aws_iam_role.this.arn
  name         = "${var.environment}-${var.app_name}-backupselection"
  plan_id      = aws_backup_plan.this.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "RDS_Name"
    value = "${var.environment}-${var.app_name}"
  }
}