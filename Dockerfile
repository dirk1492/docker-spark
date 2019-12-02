FROM docker.io/bitnami/spark:2.4.4-debian-9-r68

COPY run.sh /run.sh
COPY libspark.sh /libspark.sh
COPY hive-site.xml /opt/bitnami/spark/conf/hive-site.xml
COPY kube-external-ip /usr/bin

USER root
RUN chmod a+x /usr/bin/kube-external-ip
USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]