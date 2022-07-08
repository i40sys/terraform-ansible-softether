#!/bin/bash
source ../config/keys.conf
source ../config/DO.conf
# debug
export TF_LOG=0

terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=${PRIVATE_KEY}" -var "pub_key=${PUBLIC_KEY}"