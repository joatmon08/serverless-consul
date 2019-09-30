---
CREATE TABLE halloween (
    id VARCHAR(255) PRIMARY KEY,
    agency VARCHAR(255) DEFAULT '',
    complaint VARCHAR(255) DEFAULT '',
    descriptor VARCHAR(255) DEFAULT '',
    street VARCHAR(255) DEFAULT '',
    borough VARCHAR(255) DEFAULT ''
);

COPY halloween FROM '/var/lib/pgsql/data/halloween.csv' DELIMITERS ',' CSV HEADER;