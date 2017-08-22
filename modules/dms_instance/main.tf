#find the subnets that contain database endpoints
data "aws_subnet_ids" "default_subnets" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
  /*
  TODO: flter the source and target database subnets the dms replication instance should access
  tags {
    Tier = "Private"
  }
  */
}

#create a new key for the instance to encyrpte the connection strings
resource "aws_kms_key" "dms_conn_string_key" {
  description = "Used to encrypt/decript connection strings assocated with DMS instance: ${var.dms_instance_id}"
  deletion_window_in_days = 15
  is_enabled = true
  enable_key_rotation = false
}

#friendly alias to find the key
resource "aws_kms_alias" "dms_conn_string_key_alias" {
  name          = "alias/dms/${var.dms_instance_id}"
  target_key_id = "${aws_kms_key.dms_conn_string_key.key_id}"
}

resource "aws_dms_replication_subnet_group" "dms_subnet" {
  replication_subnet_group_description = "${var.dms_instance_id} replication subnet group"
  replication_subnet_group_id          = "${var.dms_instance_id}-subnet-group"
  subnet_ids = ["${data.aws_subnet_ids.default_subnets.ids}"]
}

resource "aws_dms_replication_instance" "dms_instance" {
  allocated_storage            = 50
  apply_immediately            = true
  auto_minor_version_upgrade   = false
  availability_zone            = "${var.dms_instance_az}"
  engine_version               = "1.9.0" #pin to a version so we can control upgrade lifecycle
  kms_key_arn                  = "${aws_kms_key.dms_conn_string_key.arn}"
  multi_az                     = "${var.dms_instance_multi_az}"
  preferred_maintenance_window = "tue:00:30-tue:08:30"
  publicly_accessible          =  false
  replication_instance_class   = "dms.t2.micro" 
  replication_instance_id      = "${var.dms_instance_id}"
  replication_subnet_group_id  = "${aws_dms_replication_subnet_group.dms_subnet.id}"
/*
  tags {
    Name = "test"
  }

#TODO: VPC Security group(s)
#The replication instance is created in a VPC. If your source database is in a VPC, select the VPC security group that provides access to the DB instance where the database resides.
  vpc_security_group_ids = [
    "sg-12345678",
  ]
*/
}

/*
TODO: Add a cloudwatch module and grant instance access to publish logs
resource "aws_cloudwatch_log_group" "dms_cloudwatch_group" {
  name = "Yada"

  tags {
    Environment = "production"
    Application = "serviceA"
  }
}
*/