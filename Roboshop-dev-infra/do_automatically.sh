#!/bin/bash

# in terraform infra dev folder, move into all the folders and run terraform apply -auto-approve
 

 for dir in $(ls -d */); do
        echo "Entering into directory: $dir"
        cd $dir
        terraform apply -auto-approve
        cd ..
 done
    echo "Terraform applied in all directories successfully"

