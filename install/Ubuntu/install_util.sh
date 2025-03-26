#!/bin/bash

sudo apt update

sudo apt install net-tools -y
netstat --version

sudo apt install locate -y
locate --v
