--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: check_events_end_of_joining_phase(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_events_end_of_joining_phase() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		schedule_day DATE;
	BEGIN
		SELECT daily_schedules.schedule_day INTO schedule_day FROM events
		JOIN time_blocks ON events.time_block_id = NEW.time_block_id
		JOIN daily_schedules ON time_blocks.daily_schedule_id = daily_schedules.daily_schedule_id;
		
		
		IF (schedule_day <= NEW.end_of_joining_phase::date) THEN
			RAISE EXCEPTION 'end_of_joining_phase has to be earlier than the day when event is organised';
		END IF;
		
		RETURN NEW;
	END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: daily_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_schedules (
    daily_schedule_id integer NOT NULL,
    schedule_day date NOT NULL,
    sport_object_id integer NOT NULL
);


--
-- Name: daily_schedules_daily_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_schedules_daily_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_schedules_daily_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_schedules_daily_schedule_id_seq OWNED BY public.daily_schedules.daily_schedule_id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    event_id integer NOT NULL,
    min_num_of_participants integer NOT NULL,
    max_num_of_participants integer NOT NULL,
    end_of_joining_phase timestamp without time zone NOT NULL,
    time_block_id integer NOT NULL,
    CONSTRAINT max_num_of_particip_bigger_or_equal_min_num_of_particip CHECK ((max_num_of_participants >= min_num_of_participants)),
    CONSTRAINT min_num_of_participants_bigger_than_0 CHECK ((min_num_of_participants > 0))
);


--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events.event_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: sport_complexes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sport_complexes (
    sport_complex_id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: sport_complexes_sport_complex_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sport_complexes_sport_complex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sport_complexes_sport_complex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sport_complexes_sport_complex_id_seq OWNED BY public.sport_complexes.sport_complex_id;


--
-- Name: sport_objects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sport_objects (
    sport_object_id integer NOT NULL,
    name character varying(100) NOT NULL,
    longitude numeric(9,6) NOT NULL,
    latitude numeric(8,6) NOT NULL,
    sport_complex_id integer NOT NULL
);


--
-- Name: sport_objects_sport_object_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sport_objects_sport_object_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sport_objects_sport_object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sport_objects_sport_object_id_seq OWNED BY public.sport_objects.sport_object_id;


--
-- Name: time_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_blocks (
    time_block_id integer NOT NULL,
    start_hour time without time zone NOT NULL,
    end_hour time without time zone NOT NULL,
    daily_schedule_id integer NOT NULL,
    CONSTRAINT end_hour_is_later_than_start_hour CHECK ((end_hour > start_hour))
);


--
-- Name: time_blocks_time_block_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_blocks_time_block_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_blocks_time_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_blocks_time_block_id_seq OWNED BY public.time_blocks.time_block_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL
);


--
-- Name: users_in_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_in_events (
    user_id integer NOT NULL,
    event_id integer NOT NULL,
    is_user_events_owner boolean NOT NULL
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: daily_schedules daily_schedule_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_schedules ALTER COLUMN daily_schedule_id SET DEFAULT nextval('public.daily_schedules_daily_schedule_id_seq'::regclass);


--
-- Name: events event_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: sport_complexes sport_complex_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_complexes ALTER COLUMN sport_complex_id SET DEFAULT nextval('public.sport_complexes_sport_complex_id_seq'::regclass);


--
-- Name: sport_objects sport_object_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_objects ALTER COLUMN sport_object_id SET DEFAULT nextval('public.sport_objects_sport_object_id_seq'::regclass);


--
-- Name: time_blocks time_block_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_blocks ALTER COLUMN time_block_id SET DEFAULT nextval('public.time_blocks_time_block_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: sport_objects coordinates_uk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_objects
    ADD CONSTRAINT coordinates_uk UNIQUE (longitude, latitude);


--
-- Name: daily_schedules daily_schedules_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_schedules
    ADD CONSTRAINT daily_schedules_pk PRIMARY KEY (daily_schedule_id);


--
-- Name: events events_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pk PRIMARY KEY (event_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sport_complexes sport_complex_name_uk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_complexes
    ADD CONSTRAINT sport_complex_name_uk UNIQUE (name);


--
-- Name: sport_complexes sport_complexes_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_complexes
    ADD CONSTRAINT sport_complexes_pk PRIMARY KEY (sport_complex_id);


--
-- Name: sport_objects sport_object_name_uk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_objects
    ADD CONSTRAINT sport_object_name_uk UNIQUE (name);


--
-- Name: sport_objects sport_objects_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_objects
    ADD CONSTRAINT sport_objects_pk PRIMARY KEY (sport_object_id);


--
-- Name: time_blocks time_blocks_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_blocks
    ADD CONSTRAINT time_blocks_pk PRIMARY KEY (time_block_id);


--
-- Name: users_in_events users_in_events_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_in_events
    ADD CONSTRAINT users_in_events_pk PRIMARY KEY (user_id, event_id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (user_id);


--
-- Name: users users_uk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_uk UNIQUE (last_name);


--
-- Name: daily_schedule_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX daily_schedule_id_idx ON public.time_blocks USING btree (daily_schedule_id);


--
-- Name: event_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX event_id_idx ON public.users_in_events USING btree (event_id);


--
-- Name: schedule_day_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX schedule_day_idx ON public.daily_schedules USING btree (schedule_day);


--
-- Name: sport_complex_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sport_complex_id_idx ON public.sport_objects USING btree (sport_complex_id);


--
-- Name: sport_object_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sport_object_id_idx ON public.daily_schedules USING btree (sport_object_id);


--
-- Name: events check_events_end_of_joining_phase_when_inserted; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER check_events_end_of_joining_phase_when_inserted BEFORE INSERT ON public.events FOR EACH ROW EXECUTE PROCEDURE public.check_events_end_of_joining_phase();


--
-- Name: events check_events_end_of_joining_phase_when_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER check_events_end_of_joining_phase_when_updated BEFORE UPDATE ON public.events FOR EACH ROW WHEN ((new.end_of_joining_phase IS DISTINCT FROM old.end_of_joining_phase)) EXECUTE PROCEDURE public.check_events_end_of_joining_phase();


--
-- Name: daily_schedules daily_schedules_sport_objects; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_schedules
    ADD CONSTRAINT daily_schedules_sport_objects FOREIGN KEY (sport_object_id) REFERENCES public.sport_objects(sport_object_id);


--
-- Name: users_in_events event_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_in_events
    ADD CONSTRAINT event_id_fk FOREIGN KEY (event_id) REFERENCES public.events(event_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sport_objects sport_objects_sport_complexes; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sport_objects
    ADD CONSTRAINT sport_objects_sport_complexes FOREIGN KEY (sport_complex_id) REFERENCES public.sport_complexes(sport_complex_id);


--
-- Name: events time_block_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT time_block_id_fk FOREIGN KEY (time_block_id) REFERENCES public.time_blocks(time_block_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: time_blocks time_blocks_daily_schedules; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_blocks
    ADD CONSTRAINT time_blocks_daily_schedules FOREIGN KEY (daily_schedule_id) REFERENCES public.daily_schedules(daily_schedule_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_in_events users_in_events_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_in_events
    ADD CONSTRAINT users_in_events_users FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20180310214342), (20180311174203), (20180315185055);

