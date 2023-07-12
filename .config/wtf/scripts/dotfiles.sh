#! /usr/bin/env bash

logs=$(yadm log -n 10 --format="%h • %ar • %s")

echo "$logs"
