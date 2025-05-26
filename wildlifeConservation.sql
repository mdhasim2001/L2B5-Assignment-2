-- Active: 1747420620804@@127.0.0.1@5432@conservation_db

-- table create --

CREATE Table rangers (
    ranger_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    region TEXT NOT NULL
);

CREATE Table species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) UNIQUE NOT NULL,
    scientific_name VARCHAR(100) UNIQUE NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(100) NOT NULL
);

CREATE Table sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id) NOT NULL,
    species_id INT REFERENCES species (species_id) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    "location" VARCHAR(100) NOT NULL,
    notes TEXT
);

-- date insert in table --

INSERT INTO
    rangers (full_name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    )

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        ranger_id,
        species_id,
        "location",
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ) (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;

-- problem 1 --
INSERT INTO
    rangers (full_name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- problem 2 --
SELECT count(DISTINCT species_id) as unique_species_count
FROM sightings;

-- problem 3 --
SELECT * FROM sightings WHERE "location" ILIKE '%pass%';

-- problem 4 --
SELECT full_name, count(*) as total_sightings
from sightings
    JOIN rangers on sightings.species_id = rangers.ranger_id
GROUP BY
    full_name;

-- problem 5 --
SELECT common_name
FROM species
    LEFT JOIN sightings on species.species_id = sightings.species_id
WHERE
    sighting_id IS NULL;

-- problem 6 --
SELECT common_name, sighting_time
FROM sightings
    JOIN species on sightings.species_id = species.species_id
ORDER BY sighting_time DESC
LIMIT 2;

-- problem 7 --
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- problem 8 --
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) >= 12
        AND EXTRACT(
            HOUR
            FROM sighting_time
        ) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings
ORDER BY sighting_id;

-- problem 9 --
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );
