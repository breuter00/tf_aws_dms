
#~~~~~REQUIRED VARS - Instance~~~~
variable "dms_instance_arn" {
    description = "feed output from the dms_instance module "
}
variable "dms_instance_name" {
    description = "feed output from the dms_instance module.  will be used a prefix of endpoints and tasks"
}
variable "dms_instance_key_arn" {
    description = "feed output from the dms_instance module.  will secure the enpoints with same key"
}

#~~~~~REQUIRED VARS - Source Endpoint~~~~
variable "source_schema" {
    description = "The SOURCE database schema name.  This will be used in endpoint names as well as the task definition"
    default = "tick"
}
variable "source_url" {
    description = "The SOURCE database connection string jdbc://."
    default = "jdbc://source.com"
}
variable "source_username" {
    default = "test"
}
variable "source_password" {
      default = "test"
}
#~~~~~REQUIRED VARS - Target Endpoint~~~~
variable "target_url" {
    description = "The TARGET database connection string."
    default = "jdbc://target.com"

}
variable "target_username" {
      default = "test"
}

variable "target_password" {
      default = "test"
}



#~~~~~OPTIONAL VARS - Task Behavior~~~~
variable "cdc_start_time" {
    default = 0
    description = "used if we want to start cdc from a point relative to the unix epoch"
}
#task_transform_rule_a and b are concatenated with var.source_schema to filter the source schema to be targated by the replication task"
variable "task_transform_rule_a" {
    default = "{\n\t\"rules\": [\n\t\t{\n\t\t\t\"rule-type\": \"selection\",\n\t\t\t\"rule-id\": \"1\",\n\t\t\t\"rule-name\": \"1\",\n\t\t\t\"object-locator\": {\n\t\t\t\t\"schema-name\": \""
}
variable "task_transform_rule_b" {
    default = "\",\n\t\t\t\t\"table-name\": \"%\"\n\t\t\t},\n\t\t\t\"rule-action\": \"include\"\n\t\t},\n\t\t{\n\t\t\t\"rule-type\": \"transformation\",\n\t\t\t\"rule-id\": \"2\",\n\t\t\t\"rule-name\": \"2\",\n\t\t\t\"rule-target\": \"schema\",\n\t\t\t\"object-locator\": {\n\t\t\t\t\"schema-name\": \"%\"\n\t\t\t},\n\t\t\t\"rule-action\": \"add-prefix\",\n\t\t\t\"value\": \"src_\"\n\t\t}\n\t]\n}"
    description = ""
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.FullLoad.html
variable "task_setting_target" {
    default = "\"TargetMetadata\": {\n        \"TargetSchema\": \"\",\n        \"SupportLobs\": true,\n        \"FullLobMode\": true,\n        \"LobChunkSize\": 64,\n        \"LimitedSizeLobMode\": false,\n        \"LobMaxSize\": 0,\n        \"LoadMaxFileSize\": 0,\n        \"ParallelLoadThreads\": 0,\n        \"ParallelLoadBufferSize\": 0,\n        \"BatchApplyEnabled\": false\n    }" 
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.FullLoad.html
variable "task_setting_full_load" {
    default = "    \"FullLoadSettings\": {\n        \"TargetTablePrepMode\": \"DROP_AND_CREATE\",\n        \"CreatePkAfterFullLoad\": false,\n        \"StopTaskCachedChangesApplied\": false,\n        \"StopTaskCachedChangesNotApplied\": false,\n        \"MaxFullLoadSubTasks\": 8,\n        \"TransactionConsistencyTimeout\": 600,\n        \"CommitRate\": 10000\n    }"
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.Logging.html
variable "task_setting_log_components" {
    default = "\"Logging\": {\n        \"EnableLogging\": true, \n        \"LogComponents\": [\n            {\n                \"Id\": \"SOURCE_UNLOAD\",\n                \"Severity\": \"LOGGER_SEVERITY_DEFAULT\"\n            },\n            {\n                \"Id\": \"SOURCE_CAPTURE\",\n                \"Severity\": \"LOGGER_SEVERITY_DEFAULT\"\n            },\n            {\n                \"Id\": \"TARGET_LOAD\",\n                \"Severity\": \"LOGGER_SEVERITY_DEFAULT\"\n            },\n            {\n                \"Id\": \"TARGET_APPLY\",\n                \"Severity\": \"LOGGER_SEVERITY_DEFAULT\"\n            },\n            {\n                \"Id\": \"TASK_MANAGER\",\n                \"Severity\": \"LOGGER_SEVERITY_DEFAULT\"\n            }\n        ]\n    }"
}

#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.ControlTable.html
variable "task_setting_control" {
    default = "\"ControlTablesSettings\": {\n        \"historyTimeslotInMinutes\": 5,\n        \"ControlSchema\": \"aws_dms_control\",\n        \"HistoryTimeslotInMinutes\": 5,\n        \"HistoryTableEnabled\": true,\n        \"SuspendedTablesTableEnabled\": true,\n        \"StatusTableEnabled\": true\n    }"
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.StreamBuffer.html
variable "task_setting_stream_buffer" {
    default = " \"StreamBufferSettings\": {\n        \"StreamBufferCount\": 3,\n        \"StreamBufferSizeInMB\": 8,\n        \"CtrlStreamBufferSizeInMB\": 5\n    }"
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.DDLHandling.html
variable "task_setting_ddl" {
    default = "\"ChangeProcessingDdlHandlingPolicy\": {\n        \"HandleSourceTableDropped\": true,\n        \"HandleSourceTableTruncated\": true,\n        \"HandleSourceTableAltered\": true\n    }"
}
#http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.ErrorHandling.html
variable "task_setting_error" {
    default =  "\"ErrorBehavior\": {\n        \"DataErrorPolicy\": \"STOP_TASK\",\n        \"DataTruncationErrorPolicy\": \"STOP_TASK\",\n        \"DataErrorEscalationPolicy\": \"STOP_TASK\",\n        \"DataErrorEscalationCount\": 0,\n        \"TableErrorPolicy\": \"STOP_TASK\",\n        \"TableErrorEscalationPolicy\": \"STOP_TASK\",\n        \"TableErrorEscalationCount\": 0,\n        \"RecoverableErrorCount\": -1,\n        \"RecoverableErrorInterval\": 30,\n        \"RecoverableErrorThrottling\": true,\n        \"RecoverableErrorThrottlingMax\": 1800,\n        \"ApplyErrorDeletePolicy\": \"STOP_TASK\",\n        \"ApplyErrorInsertPolicy\": \"STOP_TASK\",\n        \"ApplyErrorUpdatePolicy\": \"STOP_TASK\",\n        \"ApplyErrorEscalationPolicy\": \"STOP_TASK\",\n        \"ApplyErrorEscalationCount\": 0,\n        \"ApplyErrorFailOnTruncationDdl\": false,\n        \"FullLoadIgnoreConflicts\": true,\n        \"FailOnTransactionConsistencyBreached\": false\n    }"
}
variable "task_setting_change_tuning" {
    default = "\"ChangeProcessingTuning\": {\n        \"BatchApplyPreserveTransaction\": true,\n        \"BatchApplyTimeoutMin\": 1,\n        \"BatchApplyTimeoutMax\": 30,\n        \"BatchApplyMemoryLimit\": 500,\n        \"BatchSplitSize\": 0,\n        \"MinTransactionSize\": 1000,\n        \"CommitTimeout\": 1,\n        \"MemoryLimitTotal\": 1024,\n        \"MemoryKeepTime\": 60,\n        \"StatementCacheSize\": 50\n    }"
}


