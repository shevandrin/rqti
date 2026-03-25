#!/bin/sh
set -eu

OPENOLAT_HOME=${OPENOLAT_HOME:-/opt/openolat}
DB_HOST=${DB_HOST:-db}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-oodb}
DB_USER=${DB_USER:-oodbu}
DB_PASSWORD=${DB_PASSWORD:-oodbpasswd}
SERVER_DOMAINNAME=${SERVER_DOMAINNAME:-localhost}
SERVER_PORT=${SERVER_PORT:-8080}
SERVER_PORT_SSL=${SERVER_PORT_SSL:-0}
SMTP_HOST=${SMTP_HOST:-disabled}
TOMCAT_ID=${TOMCAT_ID:-1}
WAIT_FOR_DB_TIMEOUT=${WAIT_FOR_DB_TIMEOUT:-120}
AUTO_INIT_DB=${AUTO_INIT_DB:-true}

export OPENOLAT_HOME DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD \
  SERVER_DOMAINNAME SERVER_PORT SERVER_PORT_SSL SMTP_HOST TOMCAT_ID

mkdir -p "$OPENOLAT_HOME/conf/Catalina/localhost" "$OPENOLAT_HOME/logs" "$OPENOLAT_HOME/run" "$OPENOLAT_HOME/olatdata"

envsubst_vars='${OPENOLAT_HOME} ${DB_HOST} ${DB_PORT} ${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${SERVER_DOMAINNAME} ${SERVER_PORT} ${SERVER_PORT_SSL} ${SMTP_HOST} ${TOMCAT_ID}'
sed \
  -e "s|\${OPENOLAT_HOME}|$OPENOLAT_HOME|g" \
  -e "s|\${DB_HOST}|$DB_HOST|g" \
  -e "s|\${DB_PORT}|$DB_PORT|g" \
  -e "s|\${DB_NAME}|$DB_NAME|g" \
  -e "s|\${DB_USER}|$DB_USER|g" \
  -e "s|\${DB_PASSWORD}|$DB_PASSWORD|g" \
  -e "s|\${SERVER_DOMAINNAME}|$SERVER_DOMAINNAME|g" \
  -e "s|\${SERVER_PORT}|$SERVER_PORT|g" \
  -e "s|\${SERVER_PORT_SSL}|$SERVER_PORT_SSL|g" \
  -e "s|\${SMTP_HOST}|$SMTP_HOST|g" \
  -e "s|\${TOMCAT_ID}|$TOMCAT_ID|g" \
  "$OPENOLAT_HOME/lib/olat.local.properties.template" > "$OPENOLAT_HOME/lib/olat.local.properties"

sed \
  -e "s|\${OPENOLAT_HOME}|$OPENOLAT_HOME|g" \
  -e "s|\${DB_HOST}|$DB_HOST|g" \
  -e "s|\${DB_PORT}|$DB_PORT|g" \
  -e "s|\${DB_NAME}|$DB_NAME|g" \
  -e "s|\${DB_USER}|$DB_USER|g" \
  -e "s|\${DB_PASSWORD}|$DB_PASSWORD|g" \
  "$OPENOLAT_HOME/conf/ROOT.xml.template" > "$OPENOLAT_HOME/conf/Catalina/localhost/ROOT.xml"

if [ "${1:-run}" = "run" ]; then
  echo "Waiting for PostgreSQL at ${DB_HOST}:${DB_PORT}..."
  start_ts=$(date +%s)
  while ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1; do
    now=$(date +%s)
    if [ $((now - start_ts)) -ge "$WAIT_FOR_DB_TIMEOUT" ]; then
      echo "Database did not become ready within ${WAIT_FOR_DB_TIMEOUT}s" >&2
      exit 1
    fi
    sleep 2
  done

  if [ "$AUTO_INIT_DB" = "true" ]; then
    has_tables=$(psql "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" -Atqc "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';")
    if [ "${has_tables:-0}" = "0" ]; then
      echo "Database is empty; initializing OpenOlat schema..."
      schema_tmp=$(mktemp)
      if [ -f "$OPENOLAT_HOME/webapp/WEB-INF/classes/database/postgresql/setupDatabase.sql" ]; then
        cp "$OPENOLAT_HOME/webapp/WEB-INF/classes/database/postgresql/setupDatabase.sql" "$schema_tmp"
      else
        lms_jar=$(find "$OPENOLAT_HOME/webapp/WEB-INF/lib" -maxdepth 1 -type f -name 'openolat-lms*.jar' | head -n 1 || true)
        if [ -z "$lms_jar" ]; then
          echo "Could not find OpenOlat schema file." >&2
          exit 1
        fi
        unzip -p "$lms_jar" database/postgresql/setupDatabase.sql > "$schema_tmp"
      fi
      psql "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" -v ON_ERROR_STOP=1 -f "$schema_tmp"
      rm -f "$schema_tmp"
    fi
  fi

  exec "$CATALINA_HOME/bin/catalina.sh" run
fi

exec "$@"
