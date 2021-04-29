CREATE TABLE user_registration
    (
    id integer NOT NULL,
    "timestamp" timestamp without time zone,
    payload json,
    CONSTRAINT user_registration_pkey PRIMARY KEY (id)
    );
ALTER TABLE user_registration
    ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY ( MINVALUE 1 );