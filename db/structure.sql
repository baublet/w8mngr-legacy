--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: food_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE food_entries (
    id integer NOT NULL,
    description text NOT NULL,
    calories bigint DEFAULT 0 NOT NULL,
    fat integer,
    carbs integer,
    protein integer,
    day integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: food_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE food_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: food_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE food_entries_id_seq OWNED BY food_entries.id;


--
-- Name: foods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foods (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    ndbno text,
    upc text,
    popularity integer DEFAULT 0,
    likes integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: foods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE foods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foods_id_seq OWNED BY foods.id;


--
-- Name: measurements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE measurements (
    id integer NOT NULL,
    amount text NOT NULL,
    unit text NOT NULL,
    calories integer NOT NULL,
    fat integer NOT NULL,
    carbs integer NOT NULL,
    protein integer NOT NULL,
    popularity integer DEFAULT 0,
    food_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: measurements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE measurements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE measurements_id_seq OWNED BY measurements.id;


--
-- Name: option_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE option_values (
    id integer NOT NULL,
    user_id integer,
    option_id integer,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: option_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE option_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: option_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE option_values_id_seq OWNED BY option_values.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id integer NOT NULL,
    name character varying(32),
    kind character varying(1) DEFAULT 's'::character varying,
    "values" text,
    default_value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE options_id_seq OWNED BY options.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying,
    reset_digest character varying,
    reset_sent_at timestamp without time zone,
    role integer DEFAULT 0,
    preferences hstore
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_entries ALTER COLUMN id SET DEFAULT nextval('food_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foods ALTER COLUMN id SET DEFAULT nextval('foods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY measurements ALTER COLUMN id SET DEFAULT nextval('measurements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_values ALTER COLUMN id SET DEFAULT nextval('option_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY options ALTER COLUMN id SET DEFAULT nextval('options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: food_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY food_entries
    ADD CONSTRAINT food_entries_pkey PRIMARY KEY (id);


--
-- Name: foods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (id);


--
-- Name: measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (id);


--
-- Name: option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_food_entries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_food_entries_on_user_id ON food_entries USING btree (user_id);


--
-- Name: index_food_entries_on_user_id_and_day_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_food_entries_on_user_id_and_day_and_created_at ON food_entries USING btree (user_id, day, created_at);


--
-- Name: index_foods_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_foods_on_name ON foods USING btree (name);


--
-- Name: index_foods_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_foods_on_user_id ON foods USING btree (user_id);


--
-- Name: index_measurements_on_food_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_measurements_on_food_id ON measurements USING btree (food_id);


--
-- Name: index_option_values_on_option_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_option_values_on_option_id ON option_values USING btree (option_id);


--
-- Name: index_option_values_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_option_values_on_user_id ON option_values USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_541e2e5c7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foods
    ADD CONSTRAINT fk_rails_541e2e5c7b FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_7b58b92d9c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_entries
    ADD CONSTRAINT fk_rails_7b58b92d9c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_97fac6dfa2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_values
    ADD CONSTRAINT fk_rails_97fac6dfa2 FOREIGN KEY (option_id) REFERENCES options(id);


--
-- Name: fk_rails_b2b913cb51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT fk_rails_b2b913cb51 FOREIGN KEY (food_id) REFERENCES foods(id);


--
-- Name: fk_rails_c27abaa436; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_values
    ADD CONSTRAINT fk_rails_c27abaa436 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160120201433');

INSERT INTO schema_migrations (version) VALUES ('20160121164056');

INSERT INTO schema_migrations (version) VALUES ('20160123202743');

INSERT INTO schema_migrations (version) VALUES ('20160124175941');

INSERT INTO schema_migrations (version) VALUES ('20160125152242');

INSERT INTO schema_migrations (version) VALUES ('20160205233210');

INSERT INTO schema_migrations (version) VALUES ('20160207180145');

INSERT INTO schema_migrations (version) VALUES ('20160211144205');

INSERT INTO schema_migrations (version) VALUES ('20160217175911');

INSERT INTO schema_migrations (version) VALUES ('20160217180103');

INSERT INTO schema_migrations (version) VALUES ('20160217180630');

INSERT INTO schema_migrations (version) VALUES ('20160220002659');

