FROM python

RUN pip install huaweicloud-sdk-python
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
