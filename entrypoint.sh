#!/bin/sh

set -e

if [ -z "$CDN_CLOUD" ]; then
  echo "CDN_CLOUD is not set. Default to myhuaweicloud.com."
  export CDN_CLOUD=myhuaweicloud.com
fi

if [ -z "$CDN_REGION" ]; then
  echo "CDN_REGION is not set. Default to cn-north-1."
  export CDN_REGION=cn-north-1
fi

if [ -z "$CDN_ENDPOINT" ]; then
  echo "CDN_ENDPOINT is not set. Default to https://cdn.myhuaweicloud.com/v1.0/."
  export CDN_ENDPOINT=https://cdn.myhuaweicloud.com/v1.0/
fi

if [ -z "$CDN_PROJECTID" ]; then
  echo "CDN_PROJECTID is not set. Default to null."
  export CDN_PROJECTID=""
fi

if [ -z "$CDN_AK" ]; then
  echo "CDN_AK is not set. Quitting."
  exit 1
fi

if [ -z "$CDN_SK" ]; then
  echo "CDN_SK is not set. Quitting."
  exit 1
fi

if [ -z "$CDN_REFRESH_URLS" ]; then
  echo "CDN_REFRESH_URLS is not set. Quitting."
  exit 1
fi

if [ -z "$CDN_REFRESH_TYPE" ]; then
  echo "CDN_REFRESH_TYPE is not set. Quitting."
  exit 1
fi

cat > main.py <<EOF
# -*- coding:utf-8 -*-
import os
from openstack import connection

cdn_projectId = os.getenv('CDN_PROJECTID')
cdn_cloud = os.getenv('CDN_CLOUD')
cdn_region = os.getenv('CDN_REGION')
cdn_ak = os.getenv('CDN_AK')
cdn_sk = os.getenv('CDN_SK')
cdn_refresh_urls = os.getenv('CDN_REFRESH_URLS')
cdn_refresh_type = os.getenv('CDN_REFRESH_TYPE')
cdn_endpoint = os.getenv('CDN_ENDPOINT')

os.environ.setdefault('OS_CDN_ENDPOINT_OVERRIDE', cdn_endpoint)

conn = connection.Connection(
    project_id=cdn_projectId,
    cloud=cdn_cloud,
    region=cdn_region,
    ak=cdn_ak,
    sk=cdn_sk)

def refresh_create(_refresh_task):
    task = conn.cdn.create_refresh_task(**_refresh_task)
    print(task)


if __name__ == "__main__":
    refresh_dir_task = {
        "type": cdn_refresh_type,
        "urls": [cdn_refresh_urls]
    }
    print(refresh_dir_task)
    refresh_create(refresh_dir_task)
EOF

python main.py
