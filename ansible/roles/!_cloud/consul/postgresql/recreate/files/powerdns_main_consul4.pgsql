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
30	16	SOA-EDIT-API	INCEPTION-INCREMENT
32	17	SOA-EDIT-API	INCEPTION-INCREMENT
36	19	SOA-EDIT-API	INCEPTION-INCREMENT
\.


--
-- Name: domainmetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domainmetadata_id_seq', 36, true);


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY domains (id, name, master, last_check, type, notified_serial, account) FROM stdin;
1	woinc.space	\N	\N	MASTER	2017031901	\N
10	vavoom.ru		\N	MASTER	2017031906	
11	teplobloki.com		\N	MASTER	2017031906	
2	76.163.95.in-addr.arpa		\N	MASTER	2017031986	
3	67.163.95.in-addr.arpa		\N	MASTER	2017031922	
4	djokonda.ru		\N	MASTER	2017031905	
12	dom-legenda-tsvetnogo.ru		\N	MASTER	2017031909	
13	smetacalc.ru		\N	MASTER	2017031903	
5	vortex.com		\N	MASTER	2017031912	
14	nasturciya.ru		\N	MASTER	2017031903	
15	maxihom.ru		\N	MASTER	2017031903	
6	artedolce.ru		\N	MASTER	2017031919	
7	a114games.com		\N	MASTER	2017031903	
16	it-button.ru		\N	MASTER	2017031907	
17	incomstone.ru		\N	MASTER	2017031903	
9	zapchastina.su		\N	MASTER	2017031903	
8	bagetiv.ru		\N	MASTER	2017031921	
19	dreads.me		\N	MASTER	2017032113	
\.


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domains_id_seq', 19, true);


--
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY records (id, domain_id, name, type, content, ttl, prio, change_date, disabled, ordername, auth) FROM stdin;
1	1	woinc.space	SOA	consul4.woinc.space hostmaster.woinc.space 2017031901 10800 3600 604800 300	300	0	\N	f	\N	t
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
870	16	it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
871	16	it-button.ru	MX	mail.it-button.ru	300	10	\N	f	\N	t
872	16	it-button.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
873	16	it-button.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
874	16	it-button.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
875	16	it-button.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
876	16	it-button.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
877	16	mail.it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
878	16	www.it-button.ru	A	95.163.89.234	300	0	\N	f	\N	t
370	2	57.76.163.95.in-addr.arpa	PTR	ns.cloud.woinc.space	300	0	\N	f	\N	t
374	2	60.76.163.95.in-addr.arpa	PTR	ns.cloud.woinc.space	300	0	\N	f	\N	t
378	3	45.67.163.95.in-addr.arpa	PTR	ns.cloud.woinc.space	300	0	\N	f	\N	t
379	3	67.163.95.in-addr.arpa	SOA	consul4.woinc.space hostmaster.67.163.95.in-addr.arpa 2017031922 10800 3600 604800 3600	3600	0	\N	f	\N	t
398	4	djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
399	4	djokonda.ru	MX	mx.yandex.ru	300	10	\N	f	\N	t
400	4	djokonda.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
401	4	djokonda.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
402	4	djokonda.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
403	4	djokonda.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
404	4	djokonda.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
405	4	djokonda.ru	TXT	"v=spf1 mx include:spf.mailigen.com ~all"	300	0	\N	f	\N	t
406	4	djokonda.ru	TXT	"mailru-verification: 3b4ed83efdbba132"	300	0	\N	f	\N	t
407	4	djokonda.ru	TXT	"Please note: This is a generic record that will cover most cases. Your setup may require a slightly different entry. As long as include:spf.mailigen.com is present, this domain will be covered for Mailigen."	300	0	\N	f	\N	t
408	4	djokonda.ru	TXT	"google-site-verification=gH3hI_Z1p4BtM4YMkNKd2sruaJdLl_tDHIZfDRwhifc"	300	0	\N	f	\N	t
409	4	m.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
410	4	mg._domainkey.djokonda.ru	TXT	"v=DKIM1; g=*; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl3Ju9fsWggJqzUZfaEjMjYZiNBJOtC6tZ+UZnYHiNV8rWYvfH/qaOzwD9q8jivC7zk4GJuXh9cECd3MAb3sw+Qet10E5RkeLzDw+0zKecYQWKCXWSGKOeHDfyP9VqrlL2Bi1KieM8Q0KsFFwC5eoZqil/PwDhGlkFcNYae3TrWwIDAQAB"	300	0	\N	f	\N	t
411	4	shop.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
412	4	www.djokonda.ru	A	95.163.93.4	300	0	\N	f	\N	t
413	4	djokonda.ru	SOA	consul4.woinc.space hostmaster.djokonda.ru 2017031905 10800 3600 604800 3600	3600	0	\N	f	\N	t
645	9	_domainkey.zapchastina.su	TXT	"v=dkim1"	300	0	\N	f	\N	t
646	9	default._domainkey.zapchastina.su	TXT	"v=dkim1"	300	0	\N	f	\N	t
647	9	mail.zapchastina.su	CNAME	domain.mail.yandex.net	300	0	\N	f	\N	t
648	9	www.zapchastina.su	A	95.163.89.237	300	0	\N	f	\N	t
190	1	cloud-consul1.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
191	1	cloud-consul1.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
192	1	cloud-consul2.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
193	1	cloud-consul2.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
194	1	cloud-consul3.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
195	1	cloud-consul3.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
196	1	cloud-consul4.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
197	1	cloud-consul4.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
198	1	cloud-consul5.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
199	1	cloud-consul5.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
200	1	consul.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
201	1	consul.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
202	1	consul.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
203	1	consul.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
204	1	consul.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
205	1	consul.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
206	1	consul.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
207	1	consul.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
208	1	consul.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
209	1	consul.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
210	1	consul1.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
211	1	consul1.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
212	1	consul2.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
213	1	consul2.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
214	1	consul3.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
215	1	consul3.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
216	1	consul4.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
217	1	consul4.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
218	1	consul5.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
219	1	consul5.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
220	1	ns.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
221	1	ns.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
222	1	ns.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
223	1	ns.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
224	1	ns.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
225	1	ns.cloud.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
226	1	ns.cloud.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
227	1	ns.cloud.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
228	1	ns.cloud.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
229	1	ns.cloud.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
230	1	powerdns.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
231	1	powerdns.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
232	1	powerdns.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
233	1	powerdns.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
234	1	powerdns.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
235	1	powerdns.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
236	1	powerdns.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
237	1	powerdns.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
238	1	powerdns.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
239	1	powerdns.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
240	1	teamcity.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
241	1	teamcity.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
242	1	teamcity.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
243	1	teamcity.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
244	1	teamcity.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
245	1	teamcity.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
246	1	teamcity.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
247	1	teamcity.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
248	1	teamcity.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
249	1	teamcity.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
250	1	woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
251	1	woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
252	1	woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
253	1	woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
254	1	woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
255	1	woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
256	1	woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
257	1	woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
258	1	woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
259	1	woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
260	1	woinc.space	NS	consul1	300	0	\N	f	\N	t
261	1	woinc.space	NS	consul5	300	0	\N	f	\N	t
262	1	woinc.space	NS	consul4	300	0	\N	f	\N	t
263	1	woinc.space	NS	consul2	300	0	\N	f	\N	t
264	1	woinc.space	NS	consul3	300	0	\N	f	\N	t
265	1	woinc.space	NS	consul2	300	0	\N	f	\N	t
266	1	woinc.space	NS	consul5	300	0	\N	f	\N	t
267	1	woinc.space	NS	consul3	300	0	\N	f	\N	t
268	1	woinc.space	NS	consul4	300	0	\N	f	\N	t
269	1	woinc.space	NS	consul1	300	0	\N	f	\N	t
270	1	www.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
271	1	www.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
272	1	www.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
273	1	www.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
274	1	www.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
275	1	www.woinc.space	A	95.163.76.59	300	0	\N	f	\N	t
276	1	www.woinc.space	A	95.163.76.61	300	0	\N	f	\N	t
277	1	www.woinc.space	A	95.163.67.45	300	0	\N	f	\N	t
278	1	www.woinc.space	A	95.163.76.60	300	0	\N	f	\N	t
279	1	www.woinc.space	A	95.163.76.57	300	0	\N	f	\N	t
649	9	zapchastina.su	A	95.163.89.237	300	0	\N	f	\N	t
650	9	zapchastina.su	MX	mx.yandex.ru	300	10	\N	f	\N	t
651	9	zapchastina.su	NS	consul1.woinc.space	300	0	\N	f	\N	t
652	9	zapchastina.su	NS	consul2.woinc.space	300	0	\N	f	\N	t
653	9	zapchastina.su	NS	consul3.woinc.space	300	0	\N	f	\N	t
654	9	zapchastina.su	NS	consul4.woinc.space	300	0	\N	f	\N	t
655	9	zapchastina.su	NS	consul5.woinc.space	300	0	\N	f	\N	t
656	9	zapchastina.su	TXT	"v=spf1 redirect=_spf.yandex.net"	300	0	\N	f	\N	t
657	9	zapchastina.su	SOA	consul4.woinc.space hostmaster.zapchastina.su 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
813	13	smetacalc.ru	A	95.163.76.41	300	0	\N	f	\N	t
814	13	smetacalc.ru	MX	mail.yandex.ru	300	10	\N	f	\N	t
815	13	smetacalc.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
816	13	smetacalc.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
817	13	smetacalc.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
818	13	smetacalc.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
819	13	smetacalc.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
820	13	www.smetacalc.ru	A	95.163.76.41	300	0	\N	f	\N	t
821	13	yamail-cef47934913a.smetacalc.ru	CNAME	mail.yandex.ru	300	0	\N	f	\N	t
822	13	smetacalc.ru	SOA	consul4.woinc.space hostmaster.smetacalc.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
825	14	mail.nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
557	6	artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
558	6	artedolce.ru	MX	mail.artedolche.ru	300	10	\N	f	\N	t
559	6	artedolce.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
560	6	artedolce.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
561	6	artedolce.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
562	6	artedolce.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
563	6	artedolce.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
564	6	artedolce.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
565	6	default._domainkey.artedolce.ru	TXT	"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq15gcaX3PT0iIBNDYfb0MLlvY+7j4eaBDppI2lJeR5eLI1eu9jw1P2nGdwmjpjYv6Po/Nk5UJM9tYXAuI+yvUhbO3Hh1dYcfItN5ye+yGzJJNxvmQmrQIxvQFxO4yTKK9+mTOl30Q8+agBiBBkhKfTeDc0wOwbX5yDe4LVW8hv5dG4Y1UFiFZ1XgkDRLl4XTUMY"	300	0	\N	f	\N	t
566	6	mail.artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
567	6	www.artedolce.ru	A	95.163.89.234	300	0	\N	f	\N	t
568	6	artedolce.ru	SOA	consul4.woinc.space hostmaster.artedolce.ru 2017031919 10800 3600 604800 3600	3600	0	\N	f	\N	t
571	7	a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
572	7	a114games.com	MX	mail.a114games.com	300	10	\N	f	\N	t
372	2	61.76.163.95.in-addr.arpa	PTR	ns.cloud.woinc.space	300	0	\N	f	\N	t
460	5	cp.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
376	2	59.76.163.95.in-addr.arpa	PTR	ns.cloud.woinc.space	300	0	\N	f	\N	t
377	2	76.163.95.in-addr.arpa	SOA	consul4.woinc.space hostmaster.76.163.95.in-addr.arpa 2017031986 10800 3600 604800 3600	3600	0	\N	f	\N	t
461	5	default1424342387._domainkey.vortex.com	TXT	"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDtDAqzFSULOPOfqEgk2YCWzzkE0T2+CtLI4ELucmSMsGC7XqzQWNbNGu/NjWSN/Gk79sFGCrAh5gaofuIYniJphMEzpoDqwWHdzlzu9Xz4V+n8TmoyPnNpOuxYkasF5hGqBjVzq3cxdUV0mQT0sGIGVvf3ISiHfZLXZMtYPwQ7yQIDAQAB"	300	0	\N	f	\N	t
462	5	mail.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
463	5	node0.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
464	5	node1.vortex.com	A	95.163.89.237	300	0	\N	f	\N	t
465	5	node2.vortex.com	A	95.163.67.43	300	0	\N	f	\N	t
466	5	vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
467	5	vortex.com	MX	mail.vortex.com	300	10	\N	f	\N	t
468	5	vortex.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
469	5	vortex.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
470	5	vortex.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
471	5	vortex.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
472	5	vortex.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
473	5	vortex.com	TXT	"v=spf1 ip4:95.163.89.234 ip4:95.163.89.237 ~all"	300	0	\N	f	\N	t
474	5	www.vortex.com	A	95.163.89.234	300	0	\N	f	\N	t
475	5	vortex.com	SOA	consul4.woinc.space hostmaster.vortex.com 2017031912 10800 3600 604800 3600	3600	0	\N	f	\N	t
573	7	a114games.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
574	7	a114games.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
575	7	a114games.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
576	7	a114games.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
577	7	a114games.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
578	7	a114games.com	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
579	7	mail.a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
580	7	www.a114games.com	A	95.163.93.8	300	0	\N	f	\N	t
581	7	a114games.com	SOA	consul4.woinc.space hostmaster.a114games.com 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
826	14	nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
827	14	nasturciya.ru	MX	mail.nasturciya.ru	300	10	\N	f	\N	t
828	14	nasturciya.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
829	14	nasturciya.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
830	14	nasturciya.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
831	14	nasturciya.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
832	14	nasturciya.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
833	14	www.nasturciya.ru	A	95.163.89.234	300	0	\N	f	\N	t
834	14	nasturciya.ru	SOA	consul4.woinc.space hostmaster.nasturciya.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
837	15	default1466233057._domainkey.maxihom.ru	TXT	"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUoWNXNPq8PXAonivBodJiMBEGBrth0vEFRO68QQ+mYYG+R4mEhph1dE9ACfA96xDlXw4CbhXHQigCSZBxwPdsKqHgYHUyhxX986oY3yzI1nRZu4nEdU3xvyFJ3aQowkjJMRC/BtE7fS/NM3EgumXYJ6UT8xhgc4t4A8IN5xTIOQIDAQAB"	300	0	\N	f	\N	t
838	15	mail.maxihom.ru	A	95.163.89.234	300	0	\N	f	\N	t
695	8	bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
696	8	bagetiv.ru	MX	mail.bagetiv.ru	300	10	\N	f	\N	t
697	8	bagetiv.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
698	8	bagetiv.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
699	8	bagetiv.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
700	8	bagetiv.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
701	8	bagetiv.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
702	8	bagetiv.ru	TXT	"v=spf1 ip4:37.200.67.100 a mx ~all"	300	0	\N	f	\N	t
703	8	mail.bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
704	8	www.bagetiv.ru	A	37.200.67.100	300	0	\N	f	\N	t
705	8	bagetiv.ru	SOA	consul4.woinc.space hostmaster.bagetiv.ru 2017031921 10800 3600 604800 3600	3600	0	\N	f	\N	t
839	15	maxihom.ru	A	95.163.66.79	300	0	\N	f	\N	t
840	15	maxihom.ru	MX	mail.maxihom.ru	300	10	\N	f	\N	t
841	15	maxihom.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
842	15	maxihom.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
843	15	maxihom.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
844	15	maxihom.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
845	15	maxihom.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
846	15	maxihom.ru	TXT	"v=spf1 ip4:95.163.89.234 include:_spf.google.com ~all"	300	0	\N	f	\N	t
847	15	www.maxihom.ru	A	95.163.66.79	300	0	\N	f	\N	t
848	15	maxihom.ru	SOA	consul4.woinc.space hostmaster.maxihom.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
727	10	mail.vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
728	10	vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
729	10	vavoom.ru	MX	mail.vavoom.ru	300	10	\N	f	\N	t
730	10	vavoom.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
731	10	vavoom.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
732	10	vavoom.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
733	10	vavoom.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
734	10	vavoom.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
735	10	www.vavoom.ru	A	95.163.89.234	300	0	\N	f	\N	t
736	10	vavoom.ru	SOA	consul4.woinc.space hostmaster.vavoom.ru 2017031906 10800 3600 604800 3600	3600	0	\N	f	\N	t
753	11	default._domainkey.teplobloki.com	TXT	"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmDYTjzMoXPrlwOrw37qJEXq17OWEKNmVayFLurjiEI4Hg3sITOIfoxNcc5c71gopnMMI6e326hAkU7TJxNBgmR3LJm+UzICK/6J0PAiirYKr7/My4yBJbzeJQvxHQFbwnXncLfM8SBWDWJpH57yopo4B/kFq46FaCIaS0doe7jQIDAQAB"	3600	0	\N	f	\N	t
754	11	teplobloki.com	A	95.163.76.46	300	0	\N	f	\N	t
755	11	teplobloki.com	MX	mx.yandex.net	300	10	\N	f	\N	t
756	11	teplobloki.com	NS	consul5.woinc.space	300	0	\N	f	\N	t
757	11	teplobloki.com	NS	consul4.woinc.space	300	0	\N	f	\N	t
758	11	teplobloki.com	NS	consul3.woinc.space	300	0	\N	f	\N	t
759	11	teplobloki.com	NS	consul2.woinc.space	300	0	\N	f	\N	t
760	11	teplobloki.com	NS	consul1.woinc.space	300	0	\N	f	\N	t
761	11	teplobloki.com	TXT	"v=spf2.0/pra +mx +a:mx.yandex.net ?all"	300	0	\N	f	\N	t
762	11	teplobloki.com	TXT	"v=spf1 +mx +a:mx.yandex.net ?all"	300	0	\N	f	\N	t
763	11	yamail-ec9bcf9c3be4.teplobloki.com	CNAME	mx.yandex.net	300	0	\N	f	\N	t
764	11	teplobloki.com	SOA	consul4.woinc.space hostmaster.teplobloki.com 2017031906 10800 3600 604800 3600	3600	0	\N	f	\N	t
800	12	default._domainkey.dom-legenda-tsvetnogo.ru	TXT	"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0WSGwJIWd+i4fJ5Z19kgfIidePGOLAUPNsKTr1TjWpqJYRiMee9klAG1SOOm8t8hqn784nfXJcIQ7I3SL90dO2LlwD9KkWGouQLUdMLsnIMo73O3zY7SP3DbMs/GpYTPUYJLe5AAAx0JIdp4pdva3QWOgY4+hTkQ+qXpEbFLKVsb31okO+OxFTcuKDSqhnTgU+3"	300	0	\N	f	\N	t
801	12	dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
802	12	dom-legenda-tsvetnogo.ru	MX	mail.dom-legenda-tsvetnogo.ru	300	10	\N	f	\N	t
803	12	dom-legenda-tsvetnogo.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
804	12	dom-legenda-tsvetnogo.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
805	12	dom-legenda-tsvetnogo.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
806	12	dom-legenda-tsvetnogo.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
807	12	dom-legenda-tsvetnogo.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
808	12	dom-legenda-tsvetnogo.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
809	12	mail.dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
810	12	www.dom-legenda-tsvetnogo.ru	A	95.163.89.234	300	0	\N	f	\N	t
811	12	dom-legenda-tsvetnogo.ru	SOA	consul4.woinc.space hostmaster.dom-legenda-tsvetnogo.ru 2017031909 10800 3600 604800 3600	3600	0	\N	f	\N	t
879	16	it-button.ru	SOA	consul4.woinc.space hostmaster.it-button.ru 2017031907 10800 3600 604800 3600	3600	0	\N	f	\N	t
881	17	incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
882	17	incomstone.ru	MX	mx.yandex.net	300	10	\N	f	\N	t
883	17	incomstone.ru	NS	consul1.woinc.space	300	0	\N	f	\N	t
884	17	incomstone.ru	NS	consul2.woinc.space	300	0	\N	f	\N	t
885	17	incomstone.ru	NS	consul3.woinc.space	300	0	\N	f	\N	t
886	17	incomstone.ru	NS	consul4.woinc.space	300	0	\N	f	\N	t
887	17	incomstone.ru	NS	consul5.woinc.space	300	0	\N	f	\N	t
888	17	incomstone.ru	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
889	17	incomstone.ru	TXT	"yandex-verification: 7601705cfa541602"	300	0	\N	f	\N	t
890	17	mail.incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
891	17	www.incomstone.ru	A	95.163.76.45	300	0	\N	f	\N	t
892	17	incomstone.ru	SOA	consul4.woinc.space hostmaster.incomstone.ru 2017031903 10800 3600 604800 3600	3600	0	\N	f	\N	t
978	19	dreads.me	A	95.163.89.234	300	0	\N	f	\N	t
979	19	dreads.me	MX	mail.dreads.me	300	10	\N	f	\N	t
980	19	dreads.me	NS	consul5.woinc.space	300	0	\N	f	\N	t
981	19	dreads.me	NS	consul4.woinc.space	300	0	\N	f	\N	t
982	19	dreads.me	NS	consul3.woinc.space	300	0	\N	f	\N	t
983	19	dreads.me	NS	consul2.woinc.space	300	0	\N	f	\N	t
984	19	dreads.me	NS	consul1.woinc.space	300	0	\N	f	\N	t
985	19	dreads.me	TXT	"v=spf1 mx a ~all"	300	0	\N	f	\N	t
986	19	mail.dreads.me	A	95.163.89.234	300	0	\N	f	\N	t
987	19	www.dreads.me	A	95.163.89.234	300	0	\N	f	\N	t
988	19	dreads.me	SOA	consul4.woinc.space hostmaster.dreads.me 2017032113 10800 3600 604800 3600	3600	0	\N	f	\N	t
\.


--
-- Name: records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('records_id_seq', 988, true);


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

