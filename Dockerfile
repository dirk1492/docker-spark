FROM docker.io/bitnami/spark:2.4.4-debian-9-r0

COPY run.sh /run.sh
COPY libspark.sh /libspark.sh
COPY hive-site.xml /opt/bitnami/spark/conf/hive-site.xml

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]