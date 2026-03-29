#!/usr/bin/env bash

check_root(){
    if [[ ! $USER == "root" ]]; then
        echo "ERROR: not root"
        exit 1
    fi
}

check_root
