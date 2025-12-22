#!/bin/bash


dnf install -y ansible


#for this, create a another repo of ansible roles folder and replace the host with localhost for all
ansible-pull -U <git repository url> -i localhost, <path to $1.yaml file>