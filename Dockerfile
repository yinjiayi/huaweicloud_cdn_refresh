FROM python

RUN pip install huaweicloud-sdk-python
ADD entrypoint.py /entrypoint.py
ENTRYPOINT ["python /entrypoint.py"]
