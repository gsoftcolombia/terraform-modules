module "dbcluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  allow_major_version_upgrade                   = false
  apply_immediately                             = true
  auto_minor_version_upgrade                    = false
  autoscaling_enabled                           = false
  backup_retention_period                       = var.backup_retention_period
  cloudwatch_log_group_retention_in_days        = var.cloudwatch_log_group_retention_in_days
  cluster_performance_insights_enabled          = var.cluster_performance_insights_enabled
  cluster_performance_insights_retention_period = var.cluster_performance_insights_retention_period
  create_cloudwatch_log_group                   = true
  create_db_cluster_parameter_group             = true
  create_db_parameter_group                     = false
  create_security_group                         = true
  db_cluster_parameter_group_family             = "aurora-mysql8.0"
  db_subnet_group_name                          = var.database_subnet_group_name
  deletion_protection                           = var.deletion_protection
  enabled_cloudwatch_logs_exports               = var.enabled_cloudwatch_logs_exports

  engine                                                 = "aurora-mysql"
  engine_mode                                            = var.engine_mode
  engine_version                                         = var.engine_version
  instances                                              = var.instances
  manage_master_user_password                            = true
  manage_master_user_password_rotation                   = true
  master_user_password_rotation_automatically_after_days = 30
  master_username                                        = "root"
  monitoring_interval                                    = 0

  name                                  = "${var.environment}-${var.app_name}"
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  preferred_maintenance_window          = "sun:05:00-sun:06:00"
  publicly_accessible                   = var.publicly_accessible

  security_group_rules = var.security_group_rules
  storage_encrypted    = true
  vpc_id               = var.vpc_id

}
