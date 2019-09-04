#!/bin/bash  
exec ssh -o "StrictHostKeyChecking=no" -i "/home/ubuntu/.ssh/codecommit_key" $1 $2 