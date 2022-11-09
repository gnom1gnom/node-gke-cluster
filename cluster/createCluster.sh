#!/usr/bin/env bash

gcloud container --project "diacovidbot" clusters create "dev-cluster" \
    --zone "us-central1-c" \
    --release-channel "regular" \
    --machine-type "e2-small" \
    --image-type "COS_CONTAINERD" \
    --disk-type "pd-ssd" \
    --disk-size "10" \
    --enable-ip-alias \
    --preemptible --num-nodes "3" \
    --enable-autoscaling --min-nodes "3" --max-nodes "5" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,NodeLocalDNS \
    --enable-autoupgrade \
    --enable-autorepair \
    --max-surge-upgrade 1 \
    --max-unavailable-upgrade 0 \
    --autoscaling-profile optimize-utilization \
    --enable-shielded-nodes \
    --shielded-integrity-monitoring \
    --shielded-secure-boot
