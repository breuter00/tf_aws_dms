#source connection string
#TODO: SSL and tags
resource "aws_dms_endpoint" "source" {
  certificate_arn             = "" 
  database_name               = ""
  endpoint_id                 = "${var.dms_instance_name}-${var.source_schema}-src"
  endpoint_type               = "source"
  engine_name                 = "aurora"
  extra_connection_attributes = ""
  kms_key_arn                 = "${var.dms_instance_key_arn}"
  password                    = "${var.source_password}"
  port                        = 3306
  server_name                 = "${var.source_url}"
  ssl_mode                    = "none"
/*
  tags {
    Name = "test"
  }
*/
  username = "${var.source_username}"
}
resource "aws_dms_endpoint" "target" {
  certificate_arn             = ""
  database_name               = ""
  endpoint_id                 = "${var.dms_instance_name}-${var.source_schema}-tgt"
  endpoint_type               = "target"
  engine_name                 = "aurora"
  extra_connection_attributes = ""
  kms_key_arn                 = "${var.dms_instance_key_arn}"
  password                    = "${var.target_password}"
  port                        = 3306
  server_name                 = "${var.target_url}"
  ssl_mode                    = "none"
/*
  tags {
    Name = "test"
  }
*/
  username = "${var.target_username}"
}

resource "aws_dms_replication_task" "task" {
  cdc_start_time            = "${var.cdc_start_time}"
  migration_type            = "full-load-and-cdc"
  replication_instance_arn  = "${var.dms_instance_arn}"
  replication_task_id       = "${var.dms_instance_name}-${var.source_schema}-full-load-and-cdc"
  source_endpoint_arn       = "${aws_dms_endpoint.source.endpoint_arn}"
  target_endpoint_arn       = "${aws_dms_endpoint.target.endpoint_arn}"
  replication_task_settings = "{${var.task_setting_target},${var.task_setting_full_load},${var.task_setting_log_components},${var.task_setting_control},${var.task_setting_ddl},${var.task_setting_error},${var.task_setting_change_tuning}}"
  table_mappings            = "${var.task_transform_rule_a}${var.source_schema}${var.task_transform_rule_b}"
  tags {
    Name = "test"
  }


}

