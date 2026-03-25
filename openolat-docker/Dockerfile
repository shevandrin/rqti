FROM eclipse-temurin:17-jre-jammy

ARG TOMCAT_VERSION=10.1.43
ARG OPENOLAT_WAR_URL
ARG OPENOLAT_WAR_FILE=openolat.war
ARG POSTGRES_JDBC_VERSION=42.7.7

ENV OPENOLAT_HOME=/opt/openolat \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_BASE=/opt/openolat \
    JRE_HOME=/opt/java/openjdk \
    CATALINA_PID=/opt/openolat/run/openolat.pid \
    CATALINA_TMPDIR=/tmp/openolat \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl ca-certificates unzip postgresql-client procps netcat-openbsd; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r openolat && useradd -r -g openolat -d ${OPENOLAT_HOME} -s /bin/bash openolat; \
    mkdir -p /opt /tmp/openolat; \
    curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tgz; \
    tar -xzf /tmp/tomcat.tgz -C /opt; \
    mv "/opt/apache-tomcat-${TOMCAT_VERSION}" /opt/tomcat; \
    rm /tmp/tomcat.tgz; \
    curl -fsSL "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_JDBC_VERSION}.jar" -o /opt/tomcat/lib/postgresql.jar; \
    mkdir -p ${OPENOLAT_HOME}; \
    mkdir -p ${OPENOLAT_HOME}/bin; \
    mkdir -p ${OPENOLAT_HOME}/conf; \
    mkdir -p ${OPENOLAT_HOME}/lib; \
    mkdir -p ${OPENOLAT_HOME}/logs; \
    mkdir -p ${OPENOLAT_HOME}/run; \
    mkdir -p ${OPENOLAT_HOME}/olatdata; \
    mkdir -p ${OPENOLAT_HOME}/webapp; \
    ln -s ${CATALINA_HOME}/conf/web.xml ${OPENOLAT_HOME}/conf/web.xml; \
    ln -s ${CATALINA_HOME}/bin/catalina.sh ${OPENOLAT_HOME}/bin/catalina.sh; \
    if [ -n "${OPENOLAT_WAR_URL:-}" ]; then curl -fsSL "$OPENOLAT_WAR_URL" -o /tmp/${OPENOLAT_WAR_FILE}; fi; \
    test -f /tmp/${OPENOLAT_WAR_FILE}; \
    unzip -q /tmp/${OPENOLAT_WAR_FILE} -d ${OPENOLAT_HOME}/webapp; \
    rm /tmp/${OPENOLAT_WAR_FILE}; \
    chown -R openolat:openolat ${OPENOLAT_HOME} /opt/tomcat /tmp/openolat

COPY --chown=openolat:openolat docker/setenv.sh ${OPENOLAT_HOME}/bin/setenv.sh
COPY --chown=openolat:openolat docker/server.xml ${OPENOLAT_HOME}/conf/server.xml
COPY --chown=openolat:openolat docker/olat.local.properties.template ${OPENOLAT_HOME}/lib/olat.local.properties.template
COPY --chown=openolat:openolat docker/log4j2.xml ${OPENOLAT_HOME}/lib/log4j2.xml
COPY --chown=openolat:openolat docker/ROOT.xml.template ${OPENOLAT_HOME}/conf/ROOT.xml.template
COPY --chown=openolat:openolat docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh ${OPENOLAT_HOME}/bin/setenv.sh

USER openolat
WORKDIR ${OPENOLAT_HOME}

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["run"]
