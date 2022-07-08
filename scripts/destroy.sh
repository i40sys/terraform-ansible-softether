#!/bin/bash
source ../config/keys.conf
source ../config/DO.conf

terraform destroy -var "do_token=${DO_PAT}" -var "pvt_key=${PRIVATE_KEY}" -var "pub_key=${PUBLIC_KEY}"
