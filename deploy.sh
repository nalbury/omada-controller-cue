#!/bin/bash

cue print > out/$(basename $PWD).yaml
aws s3 sync out/ s3://kubernickys-manifests/$(basename $PWD)/
flux reconcile source bucket kubernickys-manifests
flux reconcile ks -n omada-controller omada-controller
