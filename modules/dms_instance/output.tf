output "dms_instance_arn" {
    value = "${aws_dms_replication_instance.dms_instance.replication_instance_arn}"
}
output "dms_instance_name" {
    value = "${aws_dms_replication_instance.dms_instance.replication_instance_id}"
}
output "dms_key_arn" { 
    value = "${aws_kms_key.dms_conn_string_key.arn}"
}
output "dms_key_id" {
    value = "${aws_kms_key.dms_conn_string_key.key_id}"
}
output "dms_key_alias" {
    value = "${aws_kms_alias.dms_conn_string_key_alias.name}"
}
