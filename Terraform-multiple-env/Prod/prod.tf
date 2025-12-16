    bucket    = "kardev-remote-state-prod"
    key       = "remoteState-demo"
    region    = "us-east-1"
    use_lockfile = true
    encrypt= true
      #terraform init -backend-config=dev/backend.tf -reconfigure us this command
       # when switchig env, redo this command