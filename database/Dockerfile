FROM postgres:11
ENV POSTGRES_DB ""
ENV POSTGRES_USER ""
ENV POSTGRES_PASSWORD ""

COPY data/ /var/lib/pgsql/data/
COPY sql/ /docker-entrypoint-initdb.d/
