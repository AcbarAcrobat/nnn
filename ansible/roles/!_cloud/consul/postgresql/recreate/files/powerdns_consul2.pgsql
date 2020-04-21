--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: domain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE domain (
    id integer NOT NULL,
    name character varying(255),
    master character varying(128),
    type character varying(6) NOT NULL,
    serial integer,
    notified_serial integer,
    last_check integer,
    dnssec integer
);


ALTER TABLE domain OWNER TO postgres;

--
-- Name: domain_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domain_id_seq OWNER TO postgres;

--
-- Name: domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_id_seq OWNED BY domain.id;


--
-- Name: domain_setting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE domain_setting (
    id integer NOT NULL,
    domain_id integer,
    setting character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE domain_setting OWNER TO postgres;

--
-- Name: domain_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domain_setting_id_seq OWNER TO postgres;

--
-- Name: domain_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_setting_id_seq OWNED BY domain_setting.id;


--
-- Name: domain_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE domain_user (
    id integer NOT NULL,
    domain_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE domain_user OWNER TO postgres;

--
-- Name: domain_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domain_user_id_seq OWNER TO postgres;

--
-- Name: domain_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_user_id_seq OWNED BY domain_user.id;


--
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE history (
    id integer NOT NULL,
    msg character varying(256),
    detail text,
    created_by character varying(128),
    created_on timestamp without time zone
);


ALTER TABLE history OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE history_id_seq OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE history_id_seq OWNED BY history.id;


--
-- Name: migrate_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE migrate_version (
    repository_id character varying(250) NOT NULL,
    repository_path text,
    version integer
);


ALTER TABLE migrate_version OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE role (
    id integer NOT NULL,
    name character varying(64),
    description character varying(128)
);


ALTER TABLE role OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_id_seq OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role_id_seq OWNED BY role.id;


--
-- Name: setting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE setting (
    id integer NOT NULL,
    name character varying(64),
    value character varying(256)
);


ALTER TABLE setting OWNER TO postgres;

--
-- Name: setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setting_id_seq OWNER TO postgres;

--
-- Name: setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE setting_id_seq OWNED BY setting.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "user" (
    id integer NOT NULL,
    username character varying(64),
    password character varying(64),
    firstname character varying(64),
    lastname character varying(64),
    email character varying(128),
    avatar character varying(128),
    otp_secret character varying(16),
    role_id integer
);


ALTER TABLE "user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: domain id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain ALTER COLUMN id SET DEFAULT nextval('domain_id_seq'::regclass);


--
-- Name: domain_setting id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_setting ALTER COLUMN id SET DEFAULT nextval('domain_setting_id_seq'::regclass);


--
-- Name: domain_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_user ALTER COLUMN id SET DEFAULT nextval('domain_user_id_seq'::regclass);


--
-- Name: history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- Name: setting id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setting ALTER COLUMN id SET DEFAULT nextval('setting_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Data for Name: domain; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domain (id, name, master, type, serial, notified_serial, last_check, dnssec) FROM stdin;
1	woinc.space	[]	Master	2017031901	2017031901	0	0
2	djokonda.ru	[]	Master	2017031915	2017031915	0	0
3	vortex.com	[]	Master	2017031903	2017031903	0	0
4	artedolce.ru	[]	Master	2017031909	2017031909	0	0
5	a114games.com	[]	Master	2017031903	2017031903	0	0
7	zapchastina.su	[]	Master	2017031903	2017031903	0	0
6	bagetiv.ru	[]	Master	2017031921	2017031921	0	0
8	vavoom.ru	[]	Master	2017031903	2017031903	0	0
9	teplobloki.com	[]	Master	2017031903	2017031903	0	0
11	smetacalc.ru	[]	Master	2017031903	2017031903	0	0
10	dom-legenda-tsvetnogo.ru	[]	Master	2017031909	2017031909	0	0
12	nasturciya.ru	[]	Master	2017031903	2017031903	0	0
13	maxihom.ru	[]	Master	2017031907	2017031907	0	0
14	it-button.ru	[]	Master	2017031907	2017031907	0	0
15	incomstone.ru	[]	Master	2017031903	2017031903	0	0
17	dreads.me	[]	Master	2017032107	2017032107	0	0
\.


--
-- Name: domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domain_id_seq', 17, true);


--
-- Data for Name: domain_setting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domain_setting (id, domain_id, setting, value) FROM stdin;
\.


--
-- Name: domain_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domain_setting_id_seq', 1, false);


--
-- Data for Name: domain_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domain_user (id, domain_id, user_id) FROM stdin;
\.


--
-- Name: domain_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domain_user_id_seq', 1, false);


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY history (id, msg, detail, created_by, created_on) FROM stdin;
1	Apply record changes to domain woinc.space	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cloud-consul1.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cloud-consul2.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cloud-consul3.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cloud-consul4.cloud', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cloud-consul5.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul1', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul2', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul3', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul4', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'consul5', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'ns.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'ns.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'ns.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'ns.cloud', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'ns.cloud', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'powerdns', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'powerdns', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'powerdns', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'powerdns', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'powerdns', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'teamcity', u'record_status': u'Active', u'record_data': u'95.163.76.59'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'teamcity', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'teamcity', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'teamcity', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'teamcity', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.67.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.60'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.57'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.61'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.59'}]	route53master	2017-03-19 04:39:57.38294
2	Add domain djokonda.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 05:04:37.825266
3	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}]	route53master	2017-03-19 05:07:22.268375
4	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}]	route53master	2017-03-19 05:08:55.833999
5	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}]	route53master	2017-03-19 05:08:56.470621
6	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}]	route53master	2017-03-19 05:09:32.277681
7	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}]	route53master	2017-03-19 05:09:32.921011
8	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}]	route53master	2017-03-19 05:09:33.442555
9	Apply record changes to domain djokonda.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'mg._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; g=*; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl3Ju9fsWggJqzUZfaEjMjYZiNBJOtC6tZ+UZnYHiNV8rWYvfH/qaOzwD9q8jivC7zk4GJuXh9cECd3MAb3sw+Qet10E5RkeLzDw+0zKecYQWKCXWSGKOeHDfyP9VqrlL2Bi1KieM8Q0KsFFwC5eoZqil/PwDhGlkFcNYae3TrWwIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"mailru-verification: 3b4ed83efdbba132"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx include:spf.mailigen.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'm', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'shop', u'record_status': u'Active', u'record_data': u'95.163.93.4'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.4'}]	route53master	2017-03-19 08:06:01.106231
10	Add domain vortex.com	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 08:11:43.732469
11	Apply record changes to domain vortex.com	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:95.163.89.234 ip4:95.163.89.237 ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.vortex.com.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'cp', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default1424342387._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDtDAqzFSULOPOfqEgk2YCWzzkE0T2+CtLI4ELucmSMsGC7XqzQWNbNGu/NjWSN/Gk79sFGCrAh5gaofuIYniJphMEzpoDqwWHdzlzu9Xz4V+n8TmoyPnNpOuxYkasF5hGqBjVzq3cxdUV0mQT0sGIGVvf3ISiHfZLXZMtYPwQ7yQIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'node0', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'node1', u'record_status': u'Active', u'record_data': u'95.163.89.237'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'node2', u'record_status': u'Active', u'record_data': u'95.163.67.43'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-19 08:16:30.017671
12	Add domain artedolce.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 09:58:35.698022
13	Apply record changes to domain artedolce.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}]	route53master	2017-03-19 11:18:20.769095
14	Apply record changes to domain artedolce.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.artedolce.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}]	route53master	2017-03-19 11:25:45.910766
15	Apply record changes to domain artedolce.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq15gcaX3PT0iIBNDYfb0MLlvY+7j4eaBDppI2lJeR5eLI1eu9jw1P2nGdwmjpjYv6Po/Nk5UJM9tYXAuI+yvUhbO3Hh1dYcfItN5ye+yGzJJNxvmQmrQIxvQFxO4yTKK9+mTOl30Q8+agBiBBkhKfTeDc0wOwbX5yDe4LVW8hv5dG4Y1UFiFZ1XgkDRLl4XTUMY"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.artedolce.ru.'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 11:28:58.644076
16	Apply record changes to domain artedolce.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq15gcaX3PT0iIBNDYfb0MLlvY+7j4eaBDppI2lJeR5eLI1eu9jw1P2nGdwmjpjYv6Po/Nk5UJM9tYXAuI+yvUhbO3Hh1dYcfItN5ye+yGzJJNxvmQmrQIxvQFxO4yTKK9+mTOl30Q8+agBiBBkhKfTeDc0wOwbX5yDe4LVW8hv5dG4Y1UFiFZ1XgkDRLl4XTUMY"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.artedolce.ru.'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 11:28:59.129797
17	Add domain a114games.com	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 11:30:13.894323
18	Apply record changes to domain a114games.com	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.8'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.8'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.93.8'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.a114games.com'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}]	route53master	2017-03-19 11:35:42.202671
19	Add domain bagetiv.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 11:49:29.57474
20	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}]	route53master	2017-03-19 12:07:40.695279
21	Add domain zapchastina.su	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 12:17:44.864651
22	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:22:09.34503
23	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:22:09.878701
24	Apply record changes to domain zapchastina.su	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.237'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.ru'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 redirect=_spf.yandex.net"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'_domainkey', u'record_status': u'Active', u'record_data': u'"v=dkim1"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=dkim1"'}, {u'record_ttl': u'300', u'record_type': u'CNAME', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'domain.mail.yandex.net'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.237'}]	route53master	2017-03-19 12:23:43.62788
25	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:25:15.316051
26	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:25:15.840648
27	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:25:16.435223
28	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:37.200.67.100 a mx ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:36:11.29087
29	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:37.200.67.100 a mx ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:36:12.044094
30	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:37.200.67.100 a mx ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:36:12.601984
31	Apply record changes to domain bagetiv.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:37.200.67.100 a mx ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.bagetiv.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'37.200.67.100'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'37.200.67.100'}]	route53master	2017-03-19 12:36:13.211127
32	Add domain vavoom.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 12:51:21.87563
33	Apply record changes to domain vavoom.ru	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.vavoom.ru'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-19 13:01:02.123189
34	Add domain teplobloki.com	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 13:18:20.986944
35	Apply record changes to domain teplobloki.com	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf2.0/pra +mx +a:mx.yandex.net ?all"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 +mx +a:mx.yandex.net ?all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.net'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.46'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmDYTjzMoXPrlwOrw37qJEXq17OWEKNmVayFLurjiEI4Hg3sITOIfoxNcc5c71gopnMMI6e326hAkU7TJxNBgmR3LJm+UzICK/6J0PAiirYKr7/My4yBJbzeJQvxHQFbwnXncLfM8SBWDWJpH57yopo4B/kFq46FaCIaS0doe7jQIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'CNAME', u'record_name': u'yamail-ec9bcf9c3be4', u'record_status': u'Active', u'record_data': u'mx.yandex.net'}]	route53master	2017-03-19 14:28:49.226842
36	Add domain dom-legenda-tsvetnogo.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 14:58:03.237326
37	Add domain smetacalc.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 15:02:24.868198
38	Apply record changes to domain dom-legenda-tsvetnogo.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}]	route53master	2017-03-19 15:03:21.90816
39	Apply record changes to domain smetacalc.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.yandex.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.41'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.41'}, {u'record_ttl': u'300', u'record_type': u'CNAME', u'record_name': u'yamail-cef47934913a', u'record_status': u'Active', u'record_data': u'mail.yandex.ru'}]	route53master	2017-03-19 15:38:13.045953
40	Apply record changes to domain dom-legenda-tsvetnogo.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0WSGwJIWd+i4fJ5Z19kgfIidePGOLAUPNsKTr1TjWpqJYRiMee9klAG1SOOm8t8hqn784nfXJcIQ7I3SL90dO2LlwD9KkWGouQLUdMLsnIMo73O3zY7SP3DbMs/GpYTPUYJLe5AAAx0JIdp4pdva3QWOgY4+hTkQ+qXpEbFLKVsb31okO+OxFTcuKDSqhnTgU+3"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 15:42:56.436352
41	Apply record changes to domain dom-legenda-tsvetnogo.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.dom-legenda-tsvetnogo.ru.'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0WSGwJIWd+i4fJ5Z19kgfIidePGOLAUPNsKTr1TjWpqJYRiMee9klAG1SOOm8t8hqn784nfXJcIQ7I3SL90dO2LlwD9KkWGouQLUdMLsnIMo73O3zY7SP3DbMs/GpYTPUYJLe5AAAx0JIdp4pdva3QWOgY4+hTkQ+qXpEbFLKVsb31okO+OxFTcuKDSqhnTgU+3"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 15:43:41.412549
42	Apply record changes to domain dom-legenda-tsvetnogo.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.dom-legenda-tsvetnogo.ru.'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0WSGwJIWd+i4fJ5Z19kgfIidePGOLAUPNsKTr1TjWpqJYRiMee9klAG1SOOm8t8hqn784nfXJcIQ7I3SL90dO2LlwD9KkWGouQLUdMLsnIMo73O3zY7SP3DbMs/GpYTPUYJLe5AAAx0JIdp4pdva3QWOgY4+hTkQ+qXpEbFLKVsb31okO+OxFTcuKDSqhnTgU+3"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 15:43:42.121829
43	Add domain nasturciya.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 15:55:48.669859
44	Apply record changes to domain nasturciya.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.nasturciya.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-19 16:01:58.93565
45	Add domain maxihom.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 16:13:32.519916
46	Apply record changes to domain maxihom.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:95.163.89.234 include:_spf.google.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.maxihom.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.66.79'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default1466233057._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUoWNXNPq8PXAonivBodJiMBEGBrth0vEFRO68QQ+mYYG+R4mEhph1dE9ACfA96xDlXw4CbhXHQigCSZBxwPdsKqHgYHUyhxX986oY3yzI1nRZu4nEdU3xvyFJ3aQowkjJMRC/BtE7fS/NM3EgumXYJ6UT8xhgc4t4A8IN5xTIOQIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.66.79'}]	route53master	2017-03-19 16:31:40.262971
47	Apply record changes to domain maxihom.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:95.163.89.234 include:_spf.google.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.maxihom.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.66.79'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default1466233057._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUoWNXNPq8PXAonivBodJiMBEGBrth0vEFRO68QQ+mYYG+R4mEhph1dE9ACfA96xDlXw4CbhXHQigCSZBxwPdsKqHgYHUyhxX986oY3yzI1nRZu4nEdU3xvyFJ3aQowkjJMRC/BtE7fS/NM3EgumXYJ6UT8xhgc4t4A8IN5xTIOQIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.66.79'}]	route53master	2017-03-19 16:31:40.820529
48	Apply record changes to domain maxihom.ru	[{u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 ip4:95.163.89.234 include:_spf.google.com ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.maxihom.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.66.79'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'default1466233057._domainkey', u'record_status': u'Active', u'record_data': u'"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUoWNXNPq8PXAonivBodJiMBEGBrth0vEFRO68QQ+mYYG+R4mEhph1dE9ACfA96xDlXw4CbhXHQigCSZBxwPdsKqHgYHUyhxX986oY3yzI1nRZu4nEdU3xvyFJ3aQowkjJMRC/BtE7fS/NM3EgumXYJ6UT8xhgc4t4A8IN5xTIOQIDAQAB"'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.66.79'}]	route53master	2017-03-19 16:31:41.376611
49	Add domain it-button.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 16:59:08.740975
50	Add domain incomstone.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 17:01:27.81557
51	Apply record changes to domain it-button.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}]	route53master	2017-03-19 17:05:24.086112
52	Apply record changes to domain it-button.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.it-button.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-19 17:20:19.468621
53	Apply record changes to domain it-button.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.it-button.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-19 17:20:20.055504
54	Apply record changes to domain incomstone.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mx.yandex.net'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.76.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.76.45'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.76.45'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"yandex-verification: 7601705cfa541602"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}]	route53master	2017-03-19 17:24:03.372676
55	Add domain iboostcs.ru	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-19 17:49:22.829791
56	Apply record changes to domain iboostcs.ru	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.iboostcs.ru'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.6'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.93.6'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.6'}]	route53master	2017-03-19 18:06:58.372944
57	Apply record changes to domain iboostcs.ru	[{u'record_ttl': u'300', u'record_type': u'MX', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'10 mail.iboostcs.ru.'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.93.6'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.93.6'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.93.6'}, {u'record_ttl': u'300', u'record_type': u'TXT', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'"v=spf1 mx a ~all"'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space.'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space.'}]	route53master	2017-03-19 18:14:48.573016
58	Delete domain iboostcs.ru	\N	route53master	2017-03-19 18:19:11.064201
59	Add domain dreads.me	{'domain_type': u'master', 'domain_master_ips': []}	route53master	2017-03-21 21:18:51.797663
60	Apply record changes to domain dreads.me	[{u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}]	route53master	2017-03-21 21:21:25.198534
61	Apply record changes to domain dreads.me	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-21 21:26:01.089354
62	Apply record changes to domain dreads.me	[{u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul5.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul4.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul3.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul2.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'NS', u'record_name': u'@', u'record_status': u'Active', u'record_data': u'consul1.woinc.space'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'mail', u'record_status': u'Active', u'record_data': u'95.163.89.234'}, {u'record_ttl': u'300', u'record_type': u'A', u'record_name': u'www', u'record_status': u'Active', u'record_data': u'95.163.89.234'}]	route53master	2017-03-21 21:26:01.648688
\.


--
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('history_id_seq', 62, true);


--
-- Data for Name: migrate_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY migrate_version (repository_id, repository_path, version) FROM stdin;
database repository	/app/src/powerdnsadmin/db_repository	1
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY role (id, name, description) FROM stdin;
1	Administrator	Administrator
2	User	User
\.


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_id_seq', 2, true);


--
-- Data for Name: setting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY setting (id, name, value) FROM stdin;
1	maintenance	False
2	fullscreen_layout	True
3	record_helper	True
4	login_ldap_first	True
5	default_record_table_size	15
6	default_domain_table_size	10
7	auto_ptr	False
\.


--
-- Name: setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('setting_id_seq', 7, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, username, password, firstname, lastname, email, avatar, otp_secret, role_id) FROM stdin;
1	route53master	$2b$12$XFyG0mvGSRx.E2q71E5lB.pl/y0X1o3TdRFHConKu6PMyxu7XrcZO	Administrator	Route53	\N	\N	\N	1
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 1, true);


--
-- Name: domain domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (id);


--
-- Name: domain_setting domain_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_setting
    ADD CONSTRAINT domain_setting_pkey PRIMARY KEY (id);


--
-- Name: domain_user domain_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_user
    ADD CONSTRAINT domain_user_pkey PRIMARY KEY (id);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: migrate_version migrate_version_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY migrate_version
    ADD CONSTRAINT migrate_version_pkey PRIMARY KEY (repository_id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_domain_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_domain_name ON domain USING btree (name);


--
-- Name: ix_role_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_role_name ON role USING btree (name);


--
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_user_username ON "user" USING btree (username);


--
-- Name: domain_setting domain_setting_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_setting
    ADD CONSTRAINT domain_setting_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domain(id);


--
-- Name: domain_user domain_user_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_user
    ADD CONSTRAINT domain_user_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domain(id);


--
-- Name: domain_user domain_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domain_user
    ADD CONSTRAINT domain_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: user user_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_role_id_fkey FOREIGN KEY (role_id) REFERENCES role(id);


--
-- PostgreSQL database dump complete
--

