output "source_endpoint_arn" {
    value = "${aws_dms_endpoint.source.endpoint_arn}"
} 
output "target_endpoint_arn" {
    value = "${aws_dms_endpoint.target.endpoint_arn}"
} 
