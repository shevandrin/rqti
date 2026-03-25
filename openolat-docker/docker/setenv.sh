#!/bin/sh
CATALINA_HOME=${CATALINA_HOME:-/opt/tomcat}
CATALINA_BASE=${CATALINA_BASE:-/opt/openolat}
JRE_HOME=${JRE_HOME:-/opt/java/openjdk}
CATALINA_PID=${CATALINA_PID:-/opt/openolat/run/openolat.pid}
CATALINA_TMPDIR=${CATALINA_TMPDIR:-/tmp/openolat}
mkdir -p "$CATALINA_TMPDIR"
JAVA_XMS=${JAVA_XMS:-512m}
JAVA_XMX=${JAVA_XMX:-1024m}
JAVA_MAX_METASPACE=${JAVA_MAX_METASPACE:-512m}
OPENOLAT_TIMEZONE=${OPENOLAT_TIMEZONE:-Europe/Berlin}
SPRING_PROFILE=${SPRING_PROFILE:-docker}
CATALINA_OPTS=" \
-Xmx${JAVA_XMX} -Xms${JAVA_XMS} -XX:MaxMetaspaceSize=${JAVA_MAX_METASPACE} \
-Duser.name=openolat \
-Duser.timezone=${OPENOLAT_TIMEZONE} \
-Dspring.profiles.active=${SPRING_PROFILE} \
-Djava.awt.headless=true \
-Djava.net.preferIPv4Stack=true \
-Djava.security.egd=file:/dev/urandom \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=${CATALINA_BASE} \
${EXTRA_CATALINA_OPTS}"
export CATALINA_HOME CATALINA_BASE JRE_HOME CATALINA_PID CATALINA_TMPDIR CATALINA_OPTS
