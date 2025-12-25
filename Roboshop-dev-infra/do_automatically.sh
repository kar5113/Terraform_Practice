#!/bin/bash

# in terraform infra dev folder, move into all the folders and run terraform apply -auto-approve
 
host = $1
 for dir in $(ls -d */); do
       if [ "$dir" == "40-databases/" ] || [ "$dir" == "60-catalogue/" ]; then
               if [ "$host" == "mac" ]; then
                       echo "Skipping directory: $dir"
                       
                else
                  echo "Processing directory: $dir"
                  cd $dir
                  terraform apply -auto-approve
                  cd ..   
               fi

        else 
              echo "Entering into directory: $dir"
              cd $dir
              terraform apply -auto-approve
              cd ..

        fi
 done
    echo "Terraform applied in all directories successfully"

