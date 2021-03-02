import os
from openstack import connection

projectId = os.getenv('CDN_PROJECTID')
cloud = os.getenv('CDN_CLOUD')
region = os.getenv('CDN_REGION')
AK = os.getenv('CDN_AK')
SK = os.getenv('CDN_SK')
refresh_urls = os.getenv('CDN_REFRESH_URLS')
refresh_type = os.getenv('CDN_REFRESH_TYPE')
cdn_endpoint = os.getenv('CDN_ENDPOINT')

os.environ.setdefault('OS_CDN_ENDPOINT_OVERRIDE', cdn_endpoint)

conn = connection.Connection(
    project_id=projectId,
    cloud=cloud,
    region=region,
    ak=AK,
    sk=SK)

def refresh_create(_refresh_task):
    task = conn.cdn.create_refresh_task(**_refresh_task)
    print(task)


if __name__ == "__main__":
    refresh_dir_task = {
        "type": refresh_type,
        "urls": [refresh_urls]
    }
    print(refresh_dir_task)
    refresh_create(refresh_dir_task)
