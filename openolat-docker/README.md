# OpenOlat Docker image based on the official installation guide

This setup translates the official OpenOlat installation guide into a Docker build and a Docker Compose stack:

- Java 17
- Tomcat 10.1
- PostgreSQL
- exploded OpenOlat WAR
- `olat.local.properties`
- Tomcat `ROOT.xml` datasource descriptor
- `log4j2.xml`
- optional first-start schema initialization

## Files

- `Dockerfile` - builds the application image
- `docker/docker-entrypoint.sh` - renders config and starts Tomcat
- `docker-compose.yml` - app + PostgreSQL stack
- `.env.example` - build-time variables

## Quick start

2. In .env Replace `OPENOLAT_WAR_URL` with the direct URL of your OpenOlat WAR
3. Build and start:

```bash
docker compose build --no-cache
docker compose up -d
```

4. Follow logs:

```bash
docker compose logs -f openolat
```

5. Open:

```text
http://localhost:8080
```

Default credentials in the guide are:

- username: `administrator`
- password: `openolat`

## Notes

- The official guide uses `/home/openolat`; this container uses `/opt/openolat`.
- The official guide example listens on port `8088`; this container maps Tomcat to `8080`.
- The guide shows the datasource pointing at `localhost`; in Compose it points at the `db` service.
- For newer OpenOlat releases, the schema SQL may be inside `WEB-INF/lib/openolat-lms-*.jar`. The entrypoint handles both the loose-file and packaged cases.
- This is intended as a practical containerization of the guide, not an official OpenOlat image.

## Manual schema import

If you want to disable auto-init, set `AUTO_INIT_DB=false` and import manually:

```bash
docker compose exec openolat sh -lc 'unzip -p /opt/openolat/webapp/WEB-INF/lib/openolat-lms*.jar database/postgresql/setupDatabase.sql' \
  | docker compose exec -T db psql -U oodbu -d oodb
```

## Customization

You can override at runtime:

- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `SERVER_DOMAINNAME`, `SERVER_PORT`, `SERVER_PORT_SSL`
- `OPENOLAT_TIMEZONE`
- `JAVA_XMS`, `JAVA_XMX`, `JAVA_MAX_METASPACE`
- `AUTO_INIT_DB`
