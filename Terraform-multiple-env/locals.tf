locals{
    common_name= "${var.project}-${lookup(var.environment,terraform.workspace,"default")}"
    common_tags= {
        project= var.project,
        terraform = "true"
    }
}