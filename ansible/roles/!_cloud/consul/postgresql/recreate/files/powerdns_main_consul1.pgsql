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
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE comments (
    id integer NOT NULL,
    domain_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(10) NOT NULL,
    modified_at integer NOT NULL,
    account character varying(40) DEFAULT NULL::character varying,
    comment character varying(65535) NOT NULL,
    CONSTRAINT c_lowercase_name CHECK (((name)::text = lower((name)::text)))
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: cryptokeys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cryptokeys (
    id integer NOT NULL,
    domain_id integer,
    flags integer NOT NULL,
    active boolean,
    content text
);


ALTER TABLE cryptokeys OWNER TO postgres;

--
-- Name: cryptokeys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cryptokeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cryptokeys_id_seq OWNER TO postgres;

--
-- Name: cryptokeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cryptokeys_id_seq OWNED BY cryptokeys.id;


--
-- Name: domainmetadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE domainmetadata (
    id integer NOT NULL,
    domain_id integer,
    kind character varying(32),
    content text
);


ALTER TABLE domainmetadata OWNER TO postgres;

--
-- Name: domainmetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domainmetadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domainmetadata_id_seq OWNER TO postgres;

--
-- Name: domainmetadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domainmetadata_id_seq OWNED BY domainmetadata.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE domains (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    master character varying(128) DEFAULT NULL::character varying,
    last_check integer,
    type character varying(6) NOT NULL,
    notified_serial integer,
    account character varying(40) DEFAULT NULL::character varying,
    CONSTRAINT c_lowercase_name CHECK (((name)::text = lower((name)::text)))
);


ALTER TABLE domains OWNER TO postgres;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domains_id_seq OWNER TO postgres;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE records (
    id integer NOT NULL,
    domain_id integer,
    name character varying(255) DEFAULT NULL::character varying,
    type character varying(10) DEFAULT NULL::character varying,
    content character varying(65535) DEFAULT NULL::character varying,
    ttl integer,
    prio integer,
    change_date integer,
    disabled boolean DEFAULT false,
    ordername character varying(255),
    auth boolean DEFAULT true,
    CONSTRAINT c_lowercase_name CHECK (((name)::text = lower((name)::text)))
);


ALTER TABLE records OWNER TO postgres;

--
-- Name: records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE records_id_seq OWNER TO postgres;

--
-- Name: records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE records_id_seq OWNED BY records.id;


--
-- Name: supermasters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE supermasters (
    ip inet NOT NULL,
    nameserver character varying(255) NOT NULL,
    account character varying(40) NOT NULL
);


ALTER TABLE supermasters OWNER TO postgres;

--
-- Name: tsigkeys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tsigkeys (
    id integer NOT NULL,
    name character varying(255),
    algorithm character varying(50),
    secret character varying(255),
    CONSTRAINT c_lowercase_name CHECK (((name)::text = lower((name)::text)))
);


ALTER TABLE tsigkeys OWNER TO postgres;

--
-- Name: tsigkeys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tsigkeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tsigkeys_id_seq OWNER TO postgres;

--
-- Name: tsigkeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tsigkeys_id_seq OWNED BY tsigkeys.id;


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: cryptokeys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cryptokeys ALTER COLUMN id SET DEFAULT nextval('cryptokeys_id_seq'::regclass);


--
-- Name: domainmetadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domainmetadata ALTER COLUMN id SET DEFAULT nextval('domainmetadata_id_seq'::regclass);


--
-- Name: domains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY records ALTER COLUMN id SET DEFAULT nextval('records_id_seq'::regclass);


--
-- Name: tsigkeys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tsigkeys ALTER COLUMN id SET DEFAULT nextval('tsigkeys_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comments (id, domain_id, name, type, modified_at, account, comment) FROM stdin;
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comments_id_seq', 1, false);


--
-- Data for Name: cryptokeys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cryptokeys (id, domain_id, flags, active, content) FROM stdin;
\.


--
-- Name: cryptokeys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cryptokeys_id_seq', 1, false);


--
-- Data for Name: domainmetadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domainmetadata (id, domain_id, kind, content) FROM stdin;
2	2	SOA-EDIT-API	INCEPTION-INCREMENT
4	3	SOA-EDIT-API	INCEPTION-INCREMENT
6	4	SOA-EDIT-API	INCEPTION-INCREMENT
8	5	SOA-EDIT-API	INCEPTION-INCREMENT
10	6	SOA-EDIT-API	INCEPTION-INCREMENT
12	7	SOA-EDIT-API	INCEPTION-INCREMENT
14	8	SOA-EDIT-API	INCEPTION-INCREMENT
16	9	SOA-EDIT-API	INCEPTION-INCREMENT
18	10	SOA-EDIT-API	INCEPTION-INCREMENT
20	11	SOA-EDIT-API	INCEPTION-INCREMENT
22	12	SOA-EDIT-API	INCEPTION-INCREMENT
24	13	SOA-EDIT-API	INCEPTION-INCREMENT
26	14	SOA-EDIT-API	INCEPTION-INCREMENT
28	15	SOA-EDIT-API	INCEPTION-INCREMENT
\.


--
-- Name: domainmetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domainmetadata_id_seq', 30, true);


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domains (id, name, master, last_check, type, notified_serial, account) FROM stdin;
1	woinc.space	\N	\N	MASTER	2017031901	\N
10	smetacalc.ru		\N	MASTER	2017031903	
2	djokonda.ru		\N	MASTER	2017031905	
11	dom-legenda-tsvetnogo.ru		\N	MASTER	2017031908	
3	vortex.com		\N	MASTER	2017031909	
12	nasturciya.ru		\N	MASTER	2017031903	
5	artedolce.ru		\N	MASTER	2017031918	
13	maxihom.ru		\N	MASTER	2017031923	
4	a114games.com		\N	MASTER	2017031909	
7	zapchastina.su		\N	MASTER	2017031903	
15	incomstone.ru		\N	MASTER	2017031903	
14	it-button.ru		\N	MASTER	2017031907	
6	bagetiv.ru		\N	MASTER	2017031931	
8	vavoom.ru		\N	MASTER	2017031903	
9	teplobloki.com		\N	MASTER	2017031905	
\.


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domains_id_seq', 16, true);


--
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY records (id, domain_id, name, type, content, ttl, prio, change_date, disabled, ordername, auth) FROM stdin;
1	1	woinc.space	SOA	consul1.woinc.space hostmaster.woinc.space 2017031901 10800 3600 604800 300	300	0	\N	f	\N	t
2	1	@	NS	consul3	300	0	\N	f	\N	t
3	1	consul3	A	95.163.76.61	300	0	\N	f	\N	t
4	1	cloud-consul3.cloud	A	95.163.76.61	300	0	\N	f	\N	t
5	1	@	A	95.163.76.61	300	0	\N	f	\N	t
6	1	www	A	95.163.76.61	300	0	\N	f	\N	t
7	1	consul	A	95.163.76.61	300	0	\N	f	\N	t
8	1	ns.cloud	A	95.163.76.61	300	0	\N	f	\N	t
9	1	teamcity	A	95.163.76.61	300	0	\N	f	\N	t
10	1	powerdns	A	95.163.76.61	300	0	\N	f	\N	t
11	1	@	NS	consul2	300	0	\N	f	\N	t
12	1	consul2	A	95.163.76.60	300	0	\N	f	\N	t
13	1	cloud-consul2.cloud	A	95.163.76.60	300	0	\N	f	\N	t
14	1	@	A	95.163.76.60	300	0	\N	f	\N	t
15	1	www	A	95.163.76.60	300	0	\N	f	\N	t
16	1	consul	A	95.163.76.60	300	0	\N	f	\N	t
17	1	ns.cloud	A	95.163.76.60	300	0	\N	f	\N	t
18	1	teamcity	A	95.163.76.60	300	0	\N	f	\N	t
19	1	powerdns	A	95.163.76.60	300	0	\N	f	\N	t
20	1	@	NS	consul1	300	0	\N	f	\N	t
21	1	consul1	A	95.163.76.59	300	0	\N	f	\N	t
22	1	cloud-consul1.cloud	A	95.163.76.59	300	0	\N	f	\N	t
23	1	@	A	95.163.76.59	300	0	\N	f	\N	t
24	1	www	A	95.163.76.59	300	0	\N	f	\N	t
25	1	consul	A	95.163.76.59	300	0	\N	f	\N	t
26	1	ns.cloud	A	95.163.76.59	300	0	\N	f	\N	t
27	1	teamcity	A	95.163.76.59	300	0	\N	f	\N	t
28	1	powerdns	A	95.163.76.59	300	0	\N	f	\N	t
29	1	@	NS	consul5	300	0	\N	f	\N	t
30	1	consul5	A	95.163.76.57	300	0	\N	f	\N	t
31	1	cloud-consul5.cloud	A	95.163.76.57	300	0	\N	f	\N	t
32	1	@	A	95.163.76.57	300	0	\N	f	\N	t
33	1	www	A	95.163.76.57	300	0	\N	f	\N	t
34	1	consul	A	95.163.76.57	300	0	\N	f	\N	t
35	1	ns.cloud	A	95.163.76.57	300	0	\N	f	\N	t
36	1	teamcity	A	95.163.76.57	300	0	\N	f	\N	t
37	1	powerdns	A	95.163.76.57	300	0	\N	f	\N	t
38	1	@	NS	consul4	300	0	\N	f	\N	t
39	1	consul4	A	95.163.67.45	300	0	\N	f	\N	t
40	1	cloud-consul4.cloud	A	95.163.67.45	300	0	\N	f	\N	t
41	1	@	A	95.163.67.45	300	0	\N	f	\N	t
42	1	www	A	95.163.67.45	300	0	\N	f	\N	t
43	1	consul	A	95.163.67.45	300	0	\N	f	\N	t
44	1	ns.cloud	A	95.163.67.45	300	0	\N	f	\N	t
45	1	teamcity	A	95.163.67.45	300	0	\N	f	\N	t
46	1	powerdns	A	95.163.67.45	300	0	\N	f	\N	t
47	1	cloud-consul1.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
48	1	cloud-consul2.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
49	1	cloud-consul3.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
50	1	cloud-consul4.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
51	1	cloud-consul5.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
52	1	consul.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
53	1	consul.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
54	1	consul.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
55	1	consul.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
56	1	consul.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
57	1	consul1.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
58	1	consul2.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
59	1	consul3.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
60	1	consul4.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
61	1	consul5.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
62	1	ns.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
63	1	ns.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
64	1	ns.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
65	1	ns.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
66	1	ns.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
67	1	powerdns.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
68	1	powerdns.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
69	1	powerdns.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
70	1	powerdns.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
71	1	powerdns.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
72	1	teamcity.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
73	1	teamcity.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
74	1	teamcity.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
75	1	teamcity.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
76	1	teamcity.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
77	1	woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
78	1	woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
79	1	woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
80	1	woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
81	1	woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
82	1	woinc.space	NS	consul2	300	0	\N	f	\N	t
83	1	woinc.space	NS	consul4	300	0	\N	f	\N	t
84	1	woinc.space	NS	consul5	300	0	\N	f	\N	t
85	1	woinc.space	NS	consul1	300	0	\N	f	\N	t
86	1	woinc.space	NS	consul3	300	0	\N	f	\N	t
87	1	www.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
88	1	www.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
89	1	www.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
90	1	www.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
91	1	www.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
314	4	a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
315	4	a114games.com	MX	mail.a114games.com	300	10	\N	f	\N	t
316	4	a114games.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
317	4	a114games.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
318	4	a114games.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
319	4	a114games.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
320	4	a114games.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
321	4	a114games.com	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
322	4	mail.a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
323	4	www.a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
324	4	a114games.com	SOA	consul1.woinc.space hostmaster.a114games.com 2017031909 10800 3600 604800 3600	3600	0	\N	f	\N	t
110	2	djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
111	2	djokonda.ru	MX	mx.yandex.ru	300	10	\N	f	\N	t
112	2	djokonda.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
113	2	djokonda.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
114	2	djokonda.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
115	2	djokonda.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
116	2	djokonda.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
117	2	djokonda.ru	TXT	"v=spf1 mx include:spf.mailigen.com ~all"	300	0	\N	f	\N	t
118	2	djokonda.ru	TXT	"mailru-verification: 3b4ed83efdbba132"	300	0	\N	f	\N	t
119	2	djokonda.ru	TXT	"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."	300	0	\N	f	\N	t
120	2	djokonda.ru	TXT	"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"	300	0	\N	f	\N	t
121	2	m.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
122	2	mg._domainkey.djokonda.ru	TXT	"v=DKIM1; g=*; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl3Ju9fsWggJqzUZfaEjMjYZiNBJOtC6tZ+UZnYHiNV8rWYvfH/qaOzwD9q8jivC7zk4GJuXh9cECd3MAb3sw+Qet10E5RkeLzDw+0zKecYQWKCXWSGKOeHDfyP9VqrlL2Bi1KieM8Q0KsFFwC5eoZqil/PwDhGlkFcNYae3TrWwIDAQAB"	300	0	\N	f	\N	t
123	2	shop.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
124	2	www.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
125	2	djokonda.ru	SOA	consul1.woinc.space hostmaster.djokonda.ru 2017031905 10800 3600 604800 3600	3600	0	\N	f	\N	t
335	7	_domainkey.zapchastina.su	TXT	"v=dkim1"	300	0	\N	f	\N	t
336	7	default._domainkey.zapchastina.su	TXT	"v=dkim1"	300	0	\N	f	\N	t
337	7	mail.zapchastina.su	CNAME	domain.mail.yandex.net	300	0	\N	f	\N	t
338	7	www.zapchastina.su	A	95.163.89.237	300	0	\N	f	\N	t
339	7	zapchastina.su	A	95.163.89.237	300	0	\N	f	\N	t
340	7	zapchastina.su	MX	mx.yandex.ru	300	10	\N	f	\N	t
341	7	zapchastina.su	NS	consul5.woinc.space	300	0	\N	f	\N	t
342	7	zapchastina.su	NS	consul4.woinc.space	300	0	\N	f	\N	t
343	7	zapchastina.su	NS	consul3.woinc.space	300	0	\N	f	\N	t
344	7	zapchastina.su	NS	consul2.woinc.space	300	0	\N	f	\N	t
345	7	zapchastina.su	NS	consul1.woinc.space	300	0	\N	f	\N	t
346	7	zapchastina.su	TXT	"v=spf1 redirect=_spf.yandex.net"	300	0	\N	f	\N	t
265	5	artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
266	5	artedolce.ru	MX	mail.artedolce.ru	300	10	\N	f	\N	t
267	5	artedolce.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
170	3	cp.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
171	3	mail.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
172	3	node0.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
173	3	node1.vortex.com	A	95.163.89.237	300	0	\N	f	\N	t
174	3	node2.vortex.com	A	95.163.67.43	300	0	\N	f	\N	t
175	3	vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
176	3	vortex.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
177	3	vortex.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
178	3	vortex.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
179	3	vortex.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
180	3	vortex.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
181	3	www.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
182	3	vortex.com	SOA	consul1.woinc.space hostmaster.vortex.com 2017031909 10800 3600 604800 3600	3600	0	\N	f	\N	t
268	5	artedolce.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
269	5	artedolce.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
270	5	artedolce.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
271	5	artedolce.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
272	5	artedolce.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
273	5	default._domainkey.artedolce.ru	TXT	"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq15gcaX3PT0iIBNDYfb0MLlvY+7j4eaBDppI2lJeR5eLI1eu9jw1P2nGdwmjpjYv6Po/Nk5UJM9tYXAuI+yvUhbO3Hh1dYcfItN5ye+yGzJJNxvmQmrQIxvQFxO4yTKK9+mTOl30Q8+agBiBBkhKfTeDc0wOwbX5yDe4LVW8hv5dG4Y1UFiFZ1XgkDRLl4XTUMY"	300	0	\N	f	\N	t
274	5	mail.artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
275	5	www.artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
276	5	artedolce.ru	SOA	consul1.woinc.space hostmaster.artedolce.ru 2017031918 10800 3600 604800 3600	3600	0	\N	f	\N	t
347	7	zapchastina.su	SOA	consul1.woinc.space hostmaster.zapchastina.su 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
590	12	mail.nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
591	12	nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
592	12	nasturciya.ru	MX	mail.nasturciya.ru	300	10	\N	f	\N	t
593	12	nasturciya.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
594	12	nasturciya.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
595	12	nasturciya.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
596	12	nasturciya.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
597	12	nasturciya.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
598	12	www.nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
599	12	nasturciya.ru	SOA	consul1.woinc.space hostmaster.nasturciya.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
491	6	bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
492	6	bagetiv.ru	MX	mail.bagetiv.ru	300	10	\N	f	\N	t
493	6	bagetiv.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
494	6	bagetiv.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
495	6	bagetiv.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
496	6	bagetiv.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
497	6	bagetiv.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
498	6	bagetiv.ru	TXT	"v=spf1 ip4:37.200.67.100 a mx ~all"	300	0	\N	f	\N	t
499	6	mail.bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
500	6	www.bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
501	6	bagetiv.ru	SOA	consul1.woinc.space hostmaster.bagetiv.ru 2017031931 10800 3600 604800 3600	3600	0	\N	f	\N	t
504	8	mail.vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
505	8	vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
506	8	vavoom.ru	MX	mail.vavoom.ru	300	10	\N	f	\N	t
507	8	vavoom.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
508	8	vavoom.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
509	8	vavoom.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
510	8	vavoom.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
511	8	vavoom.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
512	8	www.vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
513	8	vavoom.ru	SOA	consul1.woinc.space hostmaster.vavoom.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
529	9	default._domainkey.teplobloki.com	TXT	"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmDYTjzMoXPrlwOrw37qJEXq17OWEKNmVayFLurjiEI4Hg3sITOIfoxNcc5c71gopnMMI6e326hAkU7TJxNBgmR3LJm+UzICK/6J0PAiirYKr7/My4yBJbzeJQvxHQFbwnXncLfM8SBWDWJpH57yopo4B/kFq46FaCIaS0doe7jQIDAQAB"	300	0	\N	f	\N	t
530	9	teplobloki.com	A	95.163.76.46	300	0	\N	f	\N	t
531	9	teplobloki.com	MX	mx.yandex.net	300	10	\N	f	\N	t
532	9	teplobloki.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
533	9	teplobloki.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
534	9	teplobloki.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
535	9	teplobloki.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
536	9	teplobloki.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
537	9	teplobloki.com	TXT	"v=spf1 +mx +a:mx.yandex.net ?all"	300	0	\N	f	\N	t
538	9	teplobloki.com	TXT	"v=spf2.0/pra +mx +a:mx.yandex.net ?all"	300	0	\N	f	\N	t
539	9	yamail-ec9bcf9c3be4.teplobloki.com	CNAME	mx.yandex.net	300	0	\N	f	\N	t
540	9	teplobloki.com	SOA	consul1.woinc.space hostmaster.teplobloki.com 2017031905 10800 3600 604800 3600	3600	0	\N	f	\N	t
544	10	smetacalc.ru	A	95.163.76.41	300	0	\N	f	\N	t
545	10	smetacalc.ru	MX	mail.yandex.ru	300	10	\N	f	\N	t
546	10	smetacalc.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
547	10	smetacalc.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
548	10	smetacalc.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
549	10	smetacalc.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
550	10	smetacalc.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
551	10	www.smetacalc.ru	A	95.163.76.41	300	0	\N	f	\N	t
552	10	yamail-cef47934913a.smetacalc.ru	CNAME	mail.yandex.ru	300	0	\N	f	\N	t
553	10	smetacalc.ru	SOA	consul1.woinc.space hostmaster.smetacalc.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
576	11	default._domainkey.dom-legenda-tsvetnogo.ru	TXT	"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0WSGwJIWd+i4fJ5Z19kgfIidePGOLAUPNsKTr1TjWpqJYRiMee9klAG1SOOm8t8hqn784nfXJcIQ7I3SL90dO2LlwD9KkWGouQLUdMLsnIMo73O3zY7SP3DbMs/GpYTPUYJLe5AAAx0JIdp4pdva3QWOgY4+hTkQ+qXpEbFLKVsb31okO+OxFTcuKDSqhnTgU+3"	300	0	\N	f	\N	t
577	11	dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
578	11	dom-legenda-tsvetnogo.ru	MX	mail.dom-legenda-tsvetnogo.ru	300	10	\N	f	\N	t
579	11	dom-legenda-tsvetnogo.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
580	11	dom-legenda-tsvetnogo.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
581	11	dom-legenda-tsvetnogo.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
582	11	dom-legenda-tsvetnogo.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
583	11	dom-legenda-tsvetnogo.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
584	11	dom-legenda-tsvetnogo.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
585	11	mail.dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
586	11	www.dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
587	11	dom-legenda-tsvetnogo.ru	SOA	consul1.woinc.space hostmaster.dom-legenda-tsvetnogo.ru 2017031908 10800 3600 604800 3600	3600	0	\N	f	\N	t
767	13	default1466233057._domainkey.maxihom.ru	TXT	"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUoWNXNPq8PXAonivBodJiMBEGBrth0vEFRO68QQ+mYYG+R4mEhph1dE9ACfA96xDlXw4CbhXHQigCSZBxwPdsKqHgYHUyhxX986oY3yzI1nRZu4nEdU3xvyFJ3aQowkjJMRC/BtE7fS/NM3EgumXYJ6UT8xhgc4t4A8IN5xTIOQIDAQAB"	300	0	\N	f	\N	t
768	13	mail.maxihom.ru	A	95.163.89.234	300	0	\N	f	\N	t
769	13	maxihom.ru	A	95.163.66.79	300	0	\N	f	\N	t
770	13	maxihom.ru	MX	mail.maxihom.ru	300	10	\N	f	\N	t
771	13	maxihom.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
772	13	maxihom.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
773	13	maxihom.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
774	13	maxihom.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
775	13	maxihom.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
776	13	maxihom.ru	TXT	"v=spf1 ip4:95.163.89.234 include:_spf.google.com ~all"	300	0	\N	f	\N	t
777	13	www.maxihom.ru	A	95.163.66.79	300	0	\N	f	\N	t
778	13	maxihom.ru	SOA	consul1.woinc.space hostmaster.maxihom.ru 2017031923 10800 3600 604800 3600	3600	0	\N	f	\N	t
789	15	incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
790	15	incomstone.ru	MX	mx.yandex.net	300	10	\N	f	\N	t
791	15	incomstone.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
792	15	incomstone.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
793	15	incomstone.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
794	15	incomstone.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
795	15	incomstone.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
796	15	incomstone.ru	TXT	"yandex-verification: 7601705cfa541602"	300	0	\N	f	\N	t
797	15	incomstone.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
798	15	mail.incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
799	15	www.incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
800	15	incomstone.ru	SOA	consul1.woinc.space hostmaster.incomstone.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
813	14	it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
814	14	it-button.ru	MX	it-button.ru	300	10	\N	f	\N	t
815	14	it-button.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
816	14	it-button.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
817	14	it-button.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
818	14	it-button.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
819	14	it-button.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
820	14	mail.it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
821	14	www.it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
822	14	it-button.ru	SOA	consul1.woinc.space hostmaster.it-button.ru 2017031907 10800 3600 604800 3600	3600	0	\N	f	\N	t
\.


--
-- Name: records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('records_id_seq', 854, true);


--
-- Data for Name: supermasters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY supermasters (ip, nameserver, account) FROM stdin;
95.163.76.61	consul3.woinc.space	master
95.163.76.60	consul2.woinc.space	master
95.163.76.59	consul1.woinc.space	master
95.163.76.57	consul5.woinc.space	master
95.163.67.45	consul4.woinc.space	master
\.


--
-- Data for Name: tsigkeys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tsigkeys (id, name, algorithm, secret) FROM stdin;
\.


--
-- Name: tsigkeys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tsigkeys_id_seq', 1, false);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: cryptokeys cryptokeys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cryptokeys
    ADD CONSTRAINT cryptokeys_pkey PRIMARY KEY (id);


--
-- Name: domainmetadata domainmetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domainmetadata
    ADD CONSTRAINT domainmetadata_pkey PRIMARY KEY (id);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY records
    ADD CONSTRAINT records_pkey PRIMARY KEY (id);


--
-- Name: supermasters supermasters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY supermasters
    ADD CONSTRAINT supermasters_pkey PRIMARY KEY (ip, nameserver);


--
-- Name: tsigkeys tsigkeys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tsigkeys
    ADD CONSTRAINT tsigkeys_pkey PRIMARY KEY (id);


--
-- Name: comments_domain_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_domain_id_idx ON comments USING btree (domain_id);


--
-- Name: comments_name_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_name_type_idx ON comments USING btree (name, type);


--
-- Name: comments_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_order_idx ON comments USING btree (domain_id, modified_at);


--
-- Name: domain_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX domain_id ON records USING btree (domain_id);


--
-- Name: domainidindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX domainidindex ON cryptokeys USING btree (domain_id);


--
-- Name: domainidmetaindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX domainidmetaindex ON domainmetadata USING btree (domain_id);


--
-- Name: name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX name_index ON domains USING btree (name);


--
-- Name: namealgoindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX namealgoindex ON tsigkeys USING btree (name, algorithm);


--
-- Name: nametype_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nametype_index ON records USING btree (name, type);


--
-- Name: rec_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rec_name_index ON records USING btree (name);


--
-- Name: recordorder; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recordorder ON records USING btree (domain_id, ordername text_pattern_ops);


--
-- Name: cryptokeys cryptokeys_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cryptokeys
    ADD CONSTRAINT cryptokeys_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE;


--
-- Name: records domain_exists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY records
    ADD CONSTRAINT domain_exists FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE;


--
-- Name: comments domain_exists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT domain_exists FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE;


--
-- Name: domainmetadata domainmetadata_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY domainmetadata
    ADD CONSTRAINT domainmetadata_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

