#!/bin/bash

# Provides json output for ansible '--list' request
if [ "$1" = "--list" ]; then
  cat ./inventory.json
fi
