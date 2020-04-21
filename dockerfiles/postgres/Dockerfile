FROM postgres:11.1-alpine

COPY pg_hba.conf /opt/pg_hba.conf

COPY postgresql.conf /opt/postgresql.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY updateConfig.sh /docker-entrypoint-initdb.d/updateConfig.sh