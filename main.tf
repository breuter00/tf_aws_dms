#create a dms instance from module
module "dms_instance" {
    source = "./modules/dms_instance"
    dms_instance_id = "dms-repl-n-staging"
    #dms_instance_az
    #dms_instance_multi_az

}

#create a task to replicate source schema
module "dms_task_tick" {
    source = "./modules/dms_task"
    source_schema           = "tick"
    dms_instance_arn        = "${module.dms_instance.dms_instance_arn}"
    dms_instance_name       = "${module.dms_instance.dms_instance_name}"
    dms_instance_key_arn    = "${module.dms_instance.dms_key_arn}"
    source_url              = "jdbc://somesource"
    source_username         = "src_user"
    source_password         = "src_pass"
    target_url              = "jdbc://somesource"
    target_username         = "tgt_user"
    target_password         = "tgt_pass"
}

#create a second task to replicate, another source schema
module "dms_task_tock" {
    source = "./modules/dms_task"
    source_schema           = "tock"
    dms_instance_arn        = "${module.dms_instance.dms_instance_arn}"
    dms_instance_name       = "${module.dms_instance.dms_instance_name}"
    dms_instance_key_arn    = "${module.dms_instance.dms_key_arn}"
    source_url              = "jdbc://somesource"
    source_username         = "src_user"
    source_password         = "src_pass"
    target_url              = "jdbc://somesource"
    target_username         = "tgt_user"
    target_password         = "tgt_pass"
}


