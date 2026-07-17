--
-- PostgreSQL database dump
--

\restrict 206K1gJRhGezMwkxlQ9fXxW8z3AlSXb4ygDEN37Lr9W6obpJGt0Y3JrAftWyZWx

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.budgets (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    category_id bigint NOT NULL,
    amount numeric(12,2) NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT budgets_month_check CHECK (((month >= 1) AND (month <= 12)))
);


ALTER TABLE public.budgets OWNER TO fintrack;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budgets_id_seq OWNER TO fintrack;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO fintrack;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO fintrack;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO fintrack;

--
-- Name: global_category_rules; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.global_category_rules (
    id bigint NOT NULL,
    keyword character varying(255) NOT NULL,
    category_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.global_category_rules OWNER TO fintrack;

--
-- Name: global_category_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.global_category_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.global_category_rules_id_seq OWNER TO fintrack;

--
-- Name: global_category_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.global_category_rules_id_seq OWNED BY public.global_category_rules.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    category_id bigint,
    amount numeric(12,2) NOT NULL,
    description character varying(500),
    counterpart character varying(255),
    transaction_date date NOT NULL,
    hash character varying(64) NOT NULL,
    is_anomaly boolean DEFAULT false NOT NULL,
    gemini_used boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transactions OWNER TO fintrack;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO fintrack;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: user_category_rules; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.user_category_rules (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    category_id bigint NOT NULL,
    keyword character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_category_rules OWNER TO fintrack;

--
-- Name: user_category_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.user_category_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_category_rules_id_seq OWNER TO fintrack;

--
-- Name: user_category_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.user_category_rules_id_seq OWNED BY public.user_category_rules.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: fintrack
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO fintrack;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: fintrack
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO fintrack;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fintrack
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: global_category_rules id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.global_category_rules ALTER COLUMN id SET DEFAULT nextval('public.global_category_rules_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: user_category_rules id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.user_category_rules ALTER COLUMN id SET DEFAULT nextval('public.user_category_rules_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.budgets (id, user_id, category_id, amount, month, year, created_at) FROM stdin;
1	1	1	200.00	1	2026	2026-07-02 02:29:25.76676
2	1	1	200.00	7	2026	2026-07-02 02:29:45.57224
4	1	1	200.00	6	2026	2026-07-02 02:30:32.716067
5	1	3	100.00	1	2026	2026-07-02 02:35:51.659656
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.categories (id, name, user_id, created_at) FROM stdin;
1	Groceries	1	2026-06-27 02:06:54.698907
2	Restaurants	1	2026-06-27 02:06:54.706151
3	Transport	1	2026-06-27 02:06:54.708025
4	Subscriptions	1	2026-06-27 02:06:54.70976
5	Health	1	2026-06-27 02:06:54.713046
6	Shopping	1	2026-06-27 02:06:54.715956
7	Rent & Utilities	1	2026-06-27 02:06:54.718932
8	Entertainment	1	2026-06-27 02:06:54.721296
9	Donations	1	2026-06-27 02:06:54.723559
10	University	1	2026-06-27 02:06:54.725764
11	Transfers	1	2026-06-27 02:06:54.727701
12	Other	1	2026-06-27 02:06:54.729982
13	Groceries	2	2026-07-02 00:01:22.335607
14	Restaurants	2	2026-07-02 00:01:22.357519
15	Transport	2	2026-07-02 00:01:22.360088
16	Subscriptions	2	2026-07-02 00:01:22.362999
17	Health	2	2026-07-02 00:01:22.365003
18	Shopping	2	2026-07-02 00:01:22.368983
19	Rent & Utilities	2	2026-07-02 00:01:22.371795
20	Entertainment	2	2026-07-02 00:01:22.375499
21	Donations	2	2026-07-02 00:01:22.378132
22	University	2	2026-07-02 00:01:22.380487
23	Transfers	2	2026-07-02 00:01:22.383239
24	Other	2	2026-07-02 00:01:22.386312
37	Groceries	4	2026-07-14 22:00:53.492623
38	Restaurants	4	2026-07-14 22:00:53.497583
39	Transport	4	2026-07-14 22:00:53.499322
40	Subscriptions	4	2026-07-14 22:00:53.500769
41	Health	4	2026-07-14 22:00:53.502502
42	Shopping	4	2026-07-14 22:00:53.504621
43	Rent & Utilities	4	2026-07-14 22:00:53.506494
44	Entertainment	4	2026-07-14 22:00:53.508406
45	Donations	4	2026-07-14 22:00:53.510302
46	University	4	2026-07-14 22:00:53.511789
47	Transfers	4	2026-07-14 22:00:53.51403
48	Other	4	2026-07-14 22:00:53.515539
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create users table	SQL	V1__create_users_table.sql	-2016097856	fintrack	2026-06-27 02:05:24.382707	19	t
2	2	create categories table	SQL	V2__create_categories_table.sql	976071985	fintrack	2026-06-27 02:05:24.424272	7	t
3	3	create transactions table	SQL	V3__create_transactions_table.sql	-1793857807	fintrack	2026-06-27 02:05:24.440238	19	t
4	4	create budgets table	SQL	V4__create_budgets_table.sql	1302620387	fintrack	2026-06-27 02:05:24.469651	10	t
5	5	create global category rules table	SQL	V5__create_global_category_rules_table.sql	-602384835	fintrack	2026-06-27 02:05:24.491256	13	t
6	6	create user category rules table	SQL	V6__create_user_category_rules_table.sql	-1827844276	fintrack	2026-06-27 02:05:24.514226	7	t
\.


--
-- Data for Name: global_category_rules; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.global_category_rules (id, keyword, category_name, created_at) FROM stdin;
1	rewe	Groceries	2026-06-27 02:05:24.495983
2	edeka	Groceries	2026-06-27 02:05:24.495983
3	aldi	Groceries	2026-06-27 02:05:24.495983
4	lidl	Groceries	2026-06-27 02:05:24.495983
5	kaufland	Groceries	2026-06-27 02:05:24.495983
6	penny	Groceries	2026-06-27 02:05:24.495983
7	netto	Groceries	2026-06-27 02:05:24.495983
8	tegut	Groceries	2026-06-27 02:05:24.495983
9	alnatura	Groceries	2026-06-27 02:05:24.495983
10	rossmann	Groceries	2026-06-27 02:05:24.495983
11	dm markt	Groceries	2026-06-27 02:05:24.495983
12	backfactory	Restaurants	2026-06-27 02:05:24.495983
13	backwerk	Restaurants	2026-06-27 02:05:24.495983
14	mcdonalds	Restaurants	2026-06-27 02:05:24.495983
15	burger king	Restaurants	2026-06-27 02:05:24.495983
16	subway	Restaurants	2026-06-27 02:05:24.495983
17	lieferando	Restaurants	2026-06-27 02:05:24.495983
18	wolt	Restaurants	2026-06-27 02:05:24.495983
19	starbucks	Restaurants	2026-06-27 02:05:24.495983
20	nordsee	Restaurants	2026-06-27 02:05:24.495983
21	vapiano	Restaurants	2026-06-27 02:05:24.495983
22	restaurant	Restaurants	2026-06-27 02:05:24.495983
23	cafe	Restaurants	2026-06-27 02:05:24.495983
24	pizzeria	Restaurants	2026-06-27 02:05:24.495983
25	kebab	Restaurants	2026-06-27 02:05:24.495983
26	yormas	Restaurants	2026-06-27 02:05:24.495983
27	deutsche bahn	Transport	2026-06-27 02:05:24.495983
28	db bahn	Transport	2026-06-27 02:05:24.495983
29	flixbus	Transport	2026-06-27 02:05:24.495983
30	uber	Transport	2026-06-27 02:05:24.495983
31	bolt	Transport	2026-06-27 02:05:24.495983
32	free now	Transport	2026-06-27 02:05:24.495983
33	bvg	Transport	2026-06-27 02:05:24.495983
34	mvg	Transport	2026-06-27 02:05:24.495983
35	hvv	Transport	2026-06-27 02:05:24.495983
36	rmv	Transport	2026-06-27 02:05:24.495983
37	vrn	Transport	2026-06-27 02:05:24.495983
38	rnv	Transport	2026-06-27 02:05:24.495983
39	ryanair	Transport	2026-06-27 02:05:24.495983
40	lufthansa	Transport	2026-06-27 02:05:24.495983
41	eurowings	Transport	2026-06-27 02:05:24.495983
42	easyjet	Transport	2026-06-27 02:05:24.495983
43	shell	Transport	2026-06-27 02:05:24.495983
44	aral	Transport	2026-06-27 02:05:24.495983
45	tankstelle	Transport	2026-06-27 02:05:24.495983
46	adac	Transport	2026-06-27 02:05:24.495983
47	spotify	Subscriptions	2026-06-27 02:05:24.495983
48	netflix	Subscriptions	2026-06-27 02:05:24.495983
49	amazon prime	Subscriptions	2026-06-27 02:05:24.495983
50	disney	Subscriptions	2026-06-27 02:05:24.495983
51	dazn	Subscriptions	2026-06-27 02:05:24.495983
52	microsoft	Subscriptions	2026-06-27 02:05:24.495983
53	adobe	Subscriptions	2026-06-27 02:05:24.495983
54	github	Subscriptions	2026-06-27 02:05:24.495983
55	chatgpt	Subscriptions	2026-06-27 02:05:24.495983
56	openai	Subscriptions	2026-06-27 02:05:24.495983
57	notion	Subscriptions	2026-06-27 02:05:24.495983
58	audible	Subscriptions	2026-06-27 02:05:24.495983
59	telefonica	Subscriptions	2026-06-27 02:05:24.495983
60	telekom	Subscriptions	2026-06-27 02:05:24.495983
61	vodafone	Subscriptions	2026-06-27 02:05:24.495983
62	o2	Subscriptions	2026-06-27 02:05:24.495983
63	techniker krankenkasse	Health	2026-06-27 02:05:24.495983
64	barmer	Health	2026-06-27 02:05:24.495983
65	aok	Health	2026-06-27 02:05:24.495983
66	dak	Health	2026-06-27 02:05:24.495983
67	bkk	Health	2026-06-27 02:05:24.495983
68	hek	Health	2026-06-27 02:05:24.495983
69	knappschaft	Health	2026-06-27 02:05:24.495983
70	debeka	Health	2026-06-27 02:05:24.495983
71	apotheke	Health	2026-06-27 02:05:24.495983
72	zahnarzt	Health	2026-06-27 02:05:24.495983
73	krankenhaus	Health	2026-06-27 02:05:24.495983
74	klinik	Health	2026-06-27 02:05:24.495983
75	amazon	Shopping	2026-06-27 02:05:24.495983
76	zalando	Shopping	2026-06-27 02:05:24.495983
77	zara	Shopping	2026-06-27 02:05:24.495983
78	h&m	Shopping	2026-06-27 02:05:24.495983
79	primark	Shopping	2026-06-27 02:05:24.495983
80	about you	Shopping	2026-06-27 02:05:24.495983
81	otto	Shopping	2026-06-27 02:05:24.495983
82	saturn	Shopping	2026-06-27 02:05:24.495983
83	mediamarkt	Shopping	2026-06-27 02:05:24.495983
84	ikea	Shopping	2026-06-27 02:05:24.495983
85	ebay	Shopping	2026-06-27 02:05:24.495983
86	muji	Shopping	2026-06-27 02:05:24.495983
87	deichmann	Shopping	2026-06-27 02:05:24.495983
88	snipes	Shopping	2026-06-27 02:05:24.495983
89	miete	Rent & Utilities	2026-06-27 02:05:24.495983
90	bauverein	Rent & Utilities	2026-06-27 02:05:24.495983
91	vonovia	Rent & Utilities	2026-06-27 02:05:24.495983
92	deutsche wohnen	Rent & Utilities	2026-06-27 02:05:24.495983
93	vattenfall	Rent & Utilities	2026-06-27 02:05:24.495983
94	eon	Rent & Utilities	2026-06-27 02:05:24.495983
95	rwe	Rent & Utilities	2026-06-27 02:05:24.495983
96	mainova	Rent & Utilities	2026-06-27 02:05:24.495983
97	stadtwerke	Rent & Utilities	2026-06-27 02:05:24.495983
98	wasserwerke	Rent & Utilities	2026-06-27 02:05:24.495983
99	cinemaxx	Entertainment	2026-06-27 02:05:24.495983
100	cinestar	Entertainment	2026-06-27 02:05:24.495983
101	steam	Entertainment	2026-06-27 02:05:24.495983
102	eventim	Entertainment	2026-06-27 02:05:24.495983
103	ticketmaster	Entertainment	2026-06-27 02:05:24.495983
104	mcfit	Entertainment	2026-06-27 02:05:24.495983
105	clever fit	Entertainment	2026-06-27 02:05:24.495983
106	jumpers	Entertainment	2026-06-27 02:05:24.495983
107	lotterie	Entertainment	2026-06-27 02:05:24.495983
108	fitness	Entertainment	2026-06-27 02:05:24.495983
109	unicef	Donations	2026-06-27 02:05:24.495983
110	sos kinderdorf	Donations	2026-06-27 02:05:24.495983
111	rotes kreuz	Donations	2026-06-27 02:05:24.495983
112	greenpeace	Donations	2026-06-27 02:05:24.495983
113	wwf	Donations	2026-06-27 02:05:24.495983
114	caritas	Donations	2026-06-27 02:05:24.495983
115	spende	Donations	2026-06-27 02:05:24.495983
116	studierendenwerk	University	2026-06-27 02:05:24.495983
117	studentenwerk	University	2026-06-27 02:05:24.495983
118	mensa	University	2026-06-27 02:05:24.495983
119	semesterbeitrag	University	2026-06-27 02:05:24.495983
120	hochschule	University	2026-06-27 02:05:24.495983
121	fachhochschule	University	2026-06-27 02:05:24.495983
122	tu darmstadt	University	2026-06-27 02:05:24.495983
123	tu berlin	University	2026-06-27 02:05:24.495983
124	tu münchen	University	2026-06-27 02:05:24.495983
125	rwth	University	2026-06-27 02:05:24.495983
126	tu dresden	University	2026-06-27 02:05:24.495983
127	kit karlsruhe	University	2026-06-27 02:05:24.495983
128	revolut	Transfers	2026-06-27 02:05:24.495983
129	wise	Transfers	2026-06-27 02:05:24.495983
130	paypal	Transfers	2026-06-27 02:05:24.495983
131	überweisung	Transfers	2026-06-27 02:05:24.495983
132	dauerauftrag	Transfers	2026-06-27 02:05:24.495983
133	Echtzeitüberweisung	Transfers	2026-06-27 02:05:24.495983
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.transactions (id, user_id, category_id, amount, description, counterpart, transaction_date, hash, is_anomaly, gemini_used, created_at) FROM stdin;
1	1	12	1237.13	SEPA Echtzeitüberweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 01/26	Bantschow Services GmbH	2026-02-02	9023ddc7eb5d65991a0a9262e1203d8ba79e96b8219f9e949aebf2522386ce4f	f	t	2026-06-27 02:10:52.33187
2	1	5	-9.90	SEPA Lastschrifteinzug von Muenchener VEREIN Krankenversicherung a. Verwendungszweck/ Kundenreferenz Kundennummer 25Y187 KV1001 9,90 25Y187/3 01022026 01-99999920320509 Gläubiger-ID DE76ZZZ00000035752 Mand-ID KD-25Y187-KV-0039387149 RCUR Wiederholungslastschrift	Muenchener VEREIN Krankenversicherung a.	2026-02-02	7082573a4d2a42584b1dcaff087b466f9350f198174baecbde5d1d8dd93307c7	f	t	2026-06-27 02:10:53.873949
3	1	8	-24.95	SEPA Lastschrifteinzug von A.I. Fitness Sued GmbH Verwendungszweck/ Kundenreferenz DA1--0113-0000645 DA1-643384 Studenten ULTRA 24.95 EUR 01.02.26-28.02.26 DA1--0113-0000645 Gläubiger-ID DE79ZZZ00002353513 Mand-ID MLREFDA102606 RCUR Wiederholungslastschrift	A.I. Fitness Sued GmbH	2026-02-02	67c6d168a27e3e95bc3645b441995b03d5e0f71863ad8e1e55fa140fe4fdd4a0	f	f	2026-06-27 02:10:53.905008
4	1	3	-36.49	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047925229122. Uber, Ihr Einkauf bei Uber 1047925229122 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-02	38fad93521b03ad34a8250b20ec2e7e8be8e95309c327f077851cfa7660c9470	f	f	2026-06-27 02:10:53.922565
5	1	3	-5.40	Kartenzahlung Verwendungszweck/ Kundenreferenz TANKSTELLE CALPAM//Darmstadt/DE 29-01-2026 T16:50:38 Kartennr. 5356999999992427	TANKSTELLE CALPAM	2026-02-02	282595dfce821cb94bd437e61948ddc6d8907937ec5314301b6a658370af1edb	f	t	2026-06-27 02:10:55.205827
6	1	6	-9.35	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 29-01-2026T19:29:00 Kartennr. 5356999999992427	TEDI	2026-02-02	42ed03188b9a8a29b3166ec709dc296099ebf95ce19aa16dca7f4dc597f90dd1	f	t	2026-06-27 02:10:58.008609
7	1	1	-10.41	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 29-01-2026 T19:39:37 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-02-02	6d8b475a1d6a26a7b16b4c4d2a63834e1921f534d8f7b2df887c1959d95ae49e	f	f	2026-06-27 02:10:58.043565
9	1	1	-13.49	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 2464//Darmstadt/DE 31-01-2026T18:23:57 Kartennr. 5356999999992427	Tegut Filiale 2464	2026-02-03	a77c9ac75ceaef0265b01f56a60ecd7f44cccfe8866269372443e4e885a191da	f	f	2026-06-27 02:11:01.17017
10	1	1	-16.63	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 30-01-2026 T12:53:11 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-02-03	ccdf82b1f15168d1c52049bf5deec0a94698ea07fdd192fdadea89a456cc9a2d	f	f	2026-06-27 02:11:01.187461
11	1	9	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048030544568. SOS-Kinderdorfer weltweit, Ihr Einkauf bei SOS-Kinderdorfer weltweit 1048030544568 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-04	7ff3b6d129410aeab76439087a7ffbd5a43bd4aadf5f21a70e7c7f20242e8177	f	f	2026-06-27 02:11:01.204307
12	1	8	-14.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048034575888 PP.5065.PP. www.steampowered.com , Ihr Einkauf bei www.steampowered.com 1048034575888 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-04	121a648f2b6143a42a1c23092b60a4cb7b3d9782ca0ac00f294c400324a71766	f	f	2026-06-27 02:11:01.222885
13	1	4	-3.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 02-02-2026T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-02-04	390c15c0358ff0823df4f759ec66cd45dfb29380ed3ade14acacb8c2ab88801e	f	t	2026-06-27 02:11:13.172343
14	1	6	-11.00	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 02-02-2026T15:28:57 Kartennr. 5356999999992427	TEDI	2026-02-04	6353bc62f67f11e1513bb19eeed17c5653f257dcb5e0d60dc0d7c29cab8af07e	f	t	2026-06-27 02:11:15.991386
15	1	6	-17.00	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 02-02-2026T13:57:29 Kartennr. 5356999999992427	TEDI	2026-02-04	02b35d27847344c0d5a8319a694aabdaa2244cbcea596bc17a910be0162a2a3b	f	t	2026-06-27 02:11:19.174468
16	1	11	32.58	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 01/26 7603702363-0000003 SALA Lohn/Gehalt	Bantschow Services GmbH	2026-02-06	1d9515d08750a3748f9b74d5c9466e0424aa5b06daf38c058832496fdadb7c83	f	t	2026-06-27 02:11:24.80971
17	1	4	-46.00	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6099197040, Rg-Nr.: 1476138314/8, Ihr Ratenplan 3502829543830001476138314008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006099197040 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-02-06	74ca96391591f83c68b791625a5bba0d3b76b6bcaa4a32ce289794402c541da2	f	f	2026-06-27 02:11:24.837647
18	1	11	-40.00	SEPA Überweisung an Omid tavassoli IBAN LU043442040006234134 BIC ADVZLULLXXX	Omid tavassoli	2026-02-06	d44f63eb090311edc2f966c53f4ba6a8e4bccb106ff5068ac339cb4c41e51115	f	t	2026-06-27 02:11:27.259849
20	1	11	-2.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048171431468 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1048171431468 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-10	08702628b98a2a064fed44621164fffa1891b826a0522b240f2e8a1938e330c8	f	f	2026-06-27 02:11:30.73787
21	1	11	-5.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048172073993 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1048172073993 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-10	445e5ece642dc3c196c89b40bf0e85f49aa47aa7acf1c953f974bb5dce67f21b	f	f	2026-06-27 02:11:30.765132
22	1	1	-1.97	Kartenzahlung Verwendungszweck/ Kundenreferenz GO ASIA DEUTSCHLAND//DARMSTADT/DE 06-02-2026T17:45:33 Kartennr. 5356999999992427	GO ASIA DEUTSCHLAND	2026-02-10	f76dfb1fa9bdce5a483088ff2a0fba1e32f4bd26977c46f56f602468629ab9bd	f	t	2026-06-27 02:11:33.109633
23	1	6	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 07-02-2026T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-02-10	b2b165e059e918ac0374b0c51a4cade2c5831155ba25d7cf0cb0a3e0862380ad	f	t	2026-06-27 02:11:52.55131
49	1	11	1000.00	SEPA Überweisung von Dr. Krummenast, Seyyede Robabeh ABWA Dr. Krummenast, Seyyede Robabeh	Dr. Krummenast, Seyyede Robabeh	2026-02-23	e325e9e06e694997e9d4eeb433f9951e98425d4773aefebff3ea47b1997167a0	f	t	2026-06-27 02:12:30.544884
8	1	12	-26.00	SEPA Echtzeitüberweisung an Iman jahanpanah IBAN DE70380601864941788012 BIC GENODED1BRS	Iman jahanpanah	2026-02-03	6919e0402ec491c7b669c9a070b6a0f3bc5affbfaf1ae634f9ad963d7846a575	f	t	2026-06-27 02:11:01.150792
24	1	1	-4.92	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 06-02-2026 T17:40:00 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-02-10	16d2a90338f5e4b093b4519d96d9bc44339dc1468473344e5f460e115f177a4d	f	f	2026-06-27 02:11:52.577015
25	1	6	-14.98	Kartenzahlung Verwendungszweck/ Kundenreferenz NEW YORKER S.D JEANS-//DARMSTADT/DE 06-02-2026T18:05:47 Kartennr. 535699999999992427	NEW YORKER S.D JEANS	2026-02-10	8704284941923d17183c4f33c61f808ad74409f9b709f464baa7f57a0a54e2d1	f	t	2026-06-27 02:11:53.884256
26	1	1	-44.31	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Michael Weisbrod//Darmstadt/DE 09-02-2026 T21:01:42 Kartennr. 5356999999992427	REWE Michael Weisbrod	2026-02-11	0634278140ef8648d67905c3b1613937b913fbda7f199532a196c71d9a643b63	f	f	2026-06-27 02:11:53.916228
27	1	11	120.00	SEPA Echtzeitüberweisung von Minh Ngoc Nguyen Verwendungszweck/ Kundenreferenz MOB.042.EE.POS00125405	Minh Ngoc Nguyen	2026-02-11	0b1b8fe02668d6c6c06bd187c9657b11337711befcab47bc5ee5f1a3b27260f4	f	t	2026-06-27 02:11:58.761823
28	1	1	-16.02	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 2464//Darmstadt/DE 10-02-2026T20:05:31 Kartennr. 5356999999992427	Tegut Filiale 2464	2026-02-12	a6d915165aa38ab86f7a228f759383b782fc0fefd552ee61500ef264bd72322a	f	f	2026-06-27 02:11:58.790825
29	1	11	54.00	SEPA Echtzeitüberweisung von Omid Tavassoli Verwendungszweck/ Kundenreferenz Sent from Revolut	Omid Tavassoli	2026-02-13	b0a13f377b9553f6d184ca9e12c7dbc82cf6923ba37082a5b0d5ce4e0e290e07	f	f	2026-06-27 02:11:58.820342
30	1	9	-5.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048220360201. SOS-Kinderdorfer weltweit, Ihr Einkauf bei SOS-Kinderdorfer weltweit 1048220360201 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-13	31a92e95b30f175d8b5753cabf7a3ee872b28f8ad625fd19c72d7022fe13e696	f	f	2026-06-27 02:11:58.844995
31	1	1	-18.88	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Michael Weisbrod//Darmstadt/DE 11-02-2026 T18:46:43 Kartennr. 5356999999992427	REWE Michael Weisbrod	2026-02-13	7e5128766646b4854bc154f0d61c7dbaf0f76b8d6c81f5c092eb4f5f5bfbef32	f	f	2026-06-27 02:11:58.869163
32	1	5	-146.29	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck/ Kundenreferenz TK-BuchNr 01108587642 Monat 01/26 E859914122 Beitraege 1108587642 Gläubiger-ID DE51TK100000031158 Mand-ID MD120082384 RCUR Wiederholungslastschrift	Techniker Krankenkasse	2026-02-16	33a9d52a3ee2472ae68e5098934d45a65e3cd115a7a14d04671f680dc0b63c0d	f	t	2026-06-27 02:12:00.429213
33	1	4	-11.99	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ Kundenreferenz Purchase at Microsoft RTE-166932055 Gläubiger-ID SE71ZZZ5567370431 Mand-ID FA38CCDE4C9042CA91981A25A9EF3533 RCUR Wiederholungslastschrift	Klarna Bank AB	2026-02-17	8eefb40b0ac84ac57579ca64b09b2714ac6d8780851a2740d3a068398b2054a9	f	f	2026-06-27 02:12:00.453127
34	1	6	-7.00	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 14-02-2026T19:13:27 Kartennr. 5356999999992427	TEDI	2026-02-17	ecb82a97308583bb9096d8081132e5e138edf4b375521398eaa82cf4200905ed	f	t	2026-06-27 02:12:03.003478
35	1	4	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 13-02-2026T23:40:53 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-02-17	aa637fea4e7aabdeeea29674c453d2982c4b469d5d2cb8f88da15e444beffe72	f	t	2026-06-27 02:12:07.194191
36	1	1	-20.11	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 14-02-2026 T19:00:33 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-02-17	f6095dd2f63426bde52e6aad6cff3f87933d6efa62950f6d4fe10981a872b981	f	f	2026-06-27 02:12:07.216527
38	1	6	-1.50	Kartenzahlung Verwendungszweck/ Kundenreferenz NYA.Hering Sanikonzept//Frankfurt am/DE 16-02-2026 T16:04:09 Kartennr. 5356999999992427	NYA.Hering Sanikonzept	2026-02-18	447586870c25b4a3da503238def4f57c3dd73fdfdd6e5c6dde8605864903eb6b	f	t	2026-06-27 02:12:13.438092
39	1	1	-31.22	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 16-02-2026T18:09:18 Kartennr. 535699999999992427	ALDI SUED	2026-02-18	20a23aa2e86e8800d9e67230b25220436fb5093089f9511ac8e49aa15b4afd18	f	f	2026-06-27 02:12:13.464936
40	1	3	-1.00	Kartenzahlung Verwendungszweck/ Kundenreferenz HBF Darmstadt 1008-281//Darmstadt/DE 17-02-2026 T13:56:59 Kartennr. 5356999999992427	HBF Darmstadt 1008-281	2026-02-19	5d31d29470009d3bdedc103cd727343aa00f50ae5892e384d0d22cd71e30bfb7	f	t	2026-06-27 02:12:15.485507
41	1	2	-2.00	Kartenzahlung Verwendungszweck/ Kundenreferenz YORMAS AG//DARMSTADT/DE 17-02-2026T10:56:34 Kartennr. 5356999999992427	YORMAS AG	2026-02-19	87f6c23e7650df9ea3cbc6d3aad864d6997d635d69e4a8dcdae185572b5bda6f	f	f	2026-06-27 02:12:15.508255
42	1	1	-2.68	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 17-02-2026 T16:16:42 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-02-19	6a7b3e184890b77061f0ac56e1d74a2a5c6492f170f5d1199ecf64d0ac62a937	f	f	2026-06-27 02:12:15.536817
43	1	1	-5.95	Kartenzahlung Verwendungszweck/ Kundenreferenz Panda Asia Markt//Darmstadt/DE 17-02-2026T15:49:06 Kartennr. 5356999999992427	Panda Asia Markt	2026-02-19	fa9eade5fadbb86966e244cbb99daa4332f0ac08f8ebe2a836d6b74f7a1f7a9b	f	t	2026-06-27 02:12:17.945581
44	1	1	-6.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Baeckerei Schaan Fil.//Frankfurt am/DE 17-02-2026 T12:56:35 Kartennr. 5356999999992427	Baeckerei Schaan Fil.	2026-02-19	959f485dabe97cd2628939a7c04ceee7b02f206d7f59b3e8cf138f4f7b4a081c	f	t	2026-06-27 02:12:20.402667
45	1	3	-7.68	Kartenzahlung Verwendungszweck/ Kundenreferenz GO ASIA DEUTSCHLAND//DARMSTADT/DE 17-02-2026T16:11:37 Kartennr. 5356999999992427	GO ASIA DEUTSCHLAND	2026-02-19	c8a28dd99f5667818a78cd5ba92d13571da7c9fefa5615c14ee8ce31126c4685	f	t	2026-06-27 02:12:23.885242
46	1	11	3207.95	SEPA Echtzeitüberweisung von Minh Ngoc Nguyen Verwendungszweck/ Kundenreferenz MOB.051.EE.POS00097685	Minh Ngoc Nguyen	2026-02-20	7a54b831d206a592f1ec4f99252fb8faa022f457467dd88f0e7a2d38e84941f2	f	t	2026-06-27 02:12:26.853869
47	1	4	-8.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1048381103583 PP.5065.PP. DisneyPlus, Ihr Einkauf bei DisneyPlus 1048381103583 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-02-20	05b3d700a4830bb4d683b780904c8cd7ba3e48a334a51b307eecb69ef1184fec	f	f	2026-06-27 02:12:26.879152
48	1	4	-43.48	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6088305020, Rg-Nr.: 1483237754/8, Ihre Tarifrechnung 3502835282550001483237754008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006088305020 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-02-20	dff8b74dddb273928c47dc52f339f83a0e5068b92a08f24209a10232a01ffed3	f	f	2026-06-27 02:12:26.903004
577	4	40	-9.99	SEPA Lastschrifteinzug von PayPal (Europe) 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-09-09	a534e2b247e88f67c5d1d1b887d8451173f6ae92acba2ead7e51a7681a30cfa5	f	f	2026-07-15 01:55:01.386782
50	1	11	-50.00	SEPA Echtzeitüberweisung an Minh Ngoc Nguyen IBAN DE58520400210266086800 BIC COBADEFFXXX	Minh Ngoc Nguyen	2026-02-22	9ef1119151e341299b7403d1249c9e1791ca8f048a5576e3e8d2806563070eb1	f	t	2026-06-27 02:12:32.919274
51	1	11	-50.00	SEPA Echtzeitüberweisung an Minh Ngoc Nguyen IBAN DE58520400210266086800 BIC COBADEFFXXX	Minh Ngoc Nguyen	2026-02-23	5e414539584da4b6d88128ff61dd62c543eef48a7148dafb40e9d6e773ad30c1	f	t	2026-06-27 02:12:35.560268
52	1	2	-2.00	Kartenzahlung Verwendungszweck/ Kundenreferenz YORMAS AG//DARMSTADT/DE 21-02-2026T09:56:27 Kartennr. 5356999999992427	YORMAS AG	2026-02-24	87d89bcdb29a3c7cdd7245f23d81a44a6868ec245345cc7e721ce841b2704aab	f	f	2026-06-27 02:12:35.59106
53	1	3	-2.45	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//none/NL 21-02-2026T09:59:58 Kartennr. 5356999999992427	Dott scooter ride	2026-02-24	26611a6c9dc0b0bb727afe2ddf33815a05017c5a864eba79348972437210f2e7	f	t	2026-06-27 02:12:37.718134
54	1	2	-3.40	Kartenzahlung Verwendungszweck/ Kundenreferenz LE CROBAG 5004//Frankfurt/DE 21-02-2026T12:39:18 Kartennr. 5356999999992427	LE CROBAG 5004	2026-02-24	fa51b9f41a454a136d539a75077df92a3901faf27739375eb5852c208b66ea8f	f	t	2026-06-27 02:12:40.26775
55	1	1	-23.66	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 597 Darmstadt Bah//Darmstadt/DE 22-02-2026 T18:04:55 Kartennr. 5356999999992427	REWE 597 Darmstadt Bah	2026-02-24	b90783e6fe2dd57346037fdd800f8f69ea5c9f4c18fae75e5f767e94f462b9ad	f	f	2026-06-27 02:12:40.294124
56	1	2	-32.80	Kartenzahlung Verwendungszweck/ Kundenreferenz CRISPYCOOP.DE//DARMSTADT/DE 20-02-2026 T14:31:08 Kartennr. 5356999999992427	CRISPYCOOP.DE	2026-02-24	15d5b3f0c3c7442900db095c4c242915f29c7c665f90f671f338d38e4c9761eb	f	t	2026-06-27 02:12:42.630445
57	1	1	-14.72	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Michael Weisbrod//Darmstadt/DE 23-02-2026 T12:45:48 Kartennr. 5356999999992427	REWE Michael Weisbrod	2026-02-25	ffcb5eb700e57842ba778e50d117553bfeb88b9177cb22dca8f2ebad881d86ad	f	f	2026-06-27 02:12:42.647186
59	1	11	1400.00	SEPA Echtzeitüberweisung von Minh Ngoc Nguyen Verwendungszweck/ Kundenreferenz MOB.056.EE.POS00151940	Minh Ngoc Nguyen	2026-02-25	e65e5c5b7f4f74aeb9d1b6e69e5795967d5be29a8490694f86b6806f9ba38606	f	t	2026-06-27 02:12:49.992961
60	1	11	-200.00	SEPA Echtzeitüberweisung an Marcela skenda IBAN DE43500700240047923800 BIC DEUTDEDBFRA	Marcela skenda	2026-02-26	4872a48627b021bfcde9f6fd27962736212b52cc89cef72613b62bd96610d7aa	f	t	2026-06-27 02:12:51.429301
61	1	11	-100.00	SEPA Echtzeitüberweisung an Minh Ngoc Nguyen IBAN DE58520400210266086800 BIC COBADEFFXXX	Minh Ngoc Nguyen	2026-02-27	bd9fa6a76c693db0409d00db833cf1e6faa75da73f16e958c361714d54cb2af8	f	t	2026-06-27 02:12:54.995806
37	1	1	-70.95	Kartenzahlung Verwendungszweck/ Kundenreferenz KAUFLAND WEITERSTADT 3//WEITERSTADT/DE 13-02-2026T00:00:00 Kartennr. 5356999999992427	KAUFLAND WEITERSTADT 3	2026-02-17	220f95a6c2f6a2e4c3d1cd90222d7e9ab704310791e089fd7d0361f7e408a302	t	t	2026-06-27 02:12:08.941492
19	1	6	-300.00	SEPA Echtzeitüberweisung an Marcela skenda IBAN DE43500700240047923800 BIC DEUTDEDBFRA Verwendungszweck/ Kundenreferenz Furniture :)	Marcela skenda	2026-02-08	e2a7237b69df42540914b6fecfc52517b5bbf61f0929812f2676cc5b5b8259ea	t	t	2026-06-27 02:11:30.705988
63	1	11	-10.00	SEPA Echtzeitüberweisung an\nIman jahanpanah\nIBAN DE70380601864941788012\nBIC GENODED1BRS	Iman jahanpanah	2026-01-02	f9fcb1af56470e87b34051f0f571ac7ade9ceaf981e054c0b4482c267e087564	f	t	2026-06-27 02:19:00.484388
65	1	5	-9.90	SEPA Lastschrifteinzug von\nMuenchener VEREIN Krankenversicherung a.\nVerwendungszweck/ Kundenreferenz\nKundennummer 25Y187\nKV1001 9,90\n25Y187/3 01012026 01-99999920933868\nGläubiger-ID DE76ZZZ00000035752\nMand-ID KD-25Y187-KV-0039387149\nRCUR Wiederholungslastschrift	Muenchener VEREIN Krankenversicherung a.	2026-01-02	07ad5ade40c9f857029e00ca43808d4fa889942f8cfd261f0218ea613cf84f69	f	t	2026-06-27 02:19:02.833077
66	1	4	-10.99	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047286140241 PP.5065.PP. DisneyPlus, Ihr Einkauf\nbei DisneyPlus\n1047286140241 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	DisneyPlus	2026-01-02	aa17e990a1600560053745e1a2276ee7b9e6ba3097b80c8719850b10e6f57028	f	f	2026-06-27 02:19:02.857403
67	1	8	-24.95	SEPA Lastschrifteinzug von\nA.I. Fitness Sued GmbH\nVerwendungszweck/ Kundenreferenz\nDA1--0109-0000788 DA1-643384 Studenten ULTRA\n24.95 EUR 01.01.26-31.01.26\nDA1--0109-0000788\nGläubiger-ID DE79ZZZ00002353513\nMand-ID MLREFDA102606\nRCUR Wiederholungslastschrift	A.I. Fitness Sued GmbH	2026-01-02	7ff2a66eedc13756bbb4b06aa5a7bed5bd2573a73e4e003e8c0032ee5ea8980d	f	f	2026-06-27 02:19:02.893622
68	1	6	-15.99	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nSATURN ELECTRO-HANDELS//FRANKFURT/DE\n30-12-2025T15:29:03 Kartennr. 5356999999992427	SATURN ELECTRO-HANDELS	2026-01-02	1c3e75a6bfa57c885e7bdd367b29fa6ad5b222f8945ddc7953686f7e4b2be8fd	f	f	2026-06-27 02:19:02.900465
69	1	6	-9.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nKIOSK AM WEISSEN TURM//DARMSTADT/DE\n31-12-2025T14:42:13 Kartennr. 5356999999992427	KIOSK AM WEISSEN TURM	2026-01-05	1f9f9511bf560db87daf4816fc153bcb042de64ba9265902671bb50abdb7af49	f	t	2026-06-27 02:19:06.008949
70	1	10	-20.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nULB2-EC AUFWERTER-DE//Darmstadt/DE 02-01-2026\nT12:29:19 Folgenr. 00 Verfalld. 1226	ULB2-EC AUFWERTER-DE	2026-01-05	0d6e1c72c173a8e9e846b900749ee4378bb9a1ea385bea5371fe7d8d69d96363	f	t	2026-06-27 02:19:08.777111
71	1	2	18.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-06	75e16554cb370c0a4066789620a6773904e4081c994f6cb44271dbec6ea8a198	f	t	2026-06-27 02:19:25.274686
72	1	11	-10.00	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047392131025 PP.5065.PP. Save the Children\nDeutschland e. V., Ihr Einkauf bei Save the Children\nDeutschland e.V.\n1047392131025 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Save the Children Deutschland e.V.	2026-01-06	b7636599fb3d319ecbb752ecc95716e529f846861ccdc7bc3b3f2fbad7e85f52	f	f	2026-06-27 02:19:25.294595
73	1	4	-3.99	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nAPPLE.COM.BILL//CORK/IE 02-01-2026T00:00:00\nKartennr. 5356999999992427	APPLE.COM.BILL	2026-01-06	0ef4d722b2da58abc9ed9822c2187e67171a4860de9a31ee6c6e568e68b9c183	f	t	2026-06-27 02:19:42.827558
74	1	2	-5.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nGrand Cafe - K+K//Darmstadt/DE 05-01-2026T13:59:35\nKartennr. 5356999999992427	Grand Cafe - K+K	2026-01-07	8082ac84019d8c753095f6f3344ccb4a1a842c0dd8174f0f3d0319405da3660f	f	f	2026-06-27 02:19:42.848712
64	1	7	-400.00	SEPA Echtzeitüberweisung an\nDhanush Narayana Reddy\nIBAN DE75100101785806194951\nBIC REVODEB2XXX	Dhanush Narayana Reddy	2026-01-02	04c9403427758e3a4742c606e8d4e7d239289ca77c1d654f5fb3eaed4121dc7b	t	t	2026-06-27 02:19:01.707657
76	1	1	-27.84	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 597 Darmstadt Bah//Darmstadt/DE 05-01-2026\nT16:18:41 Kartennr. 5356999999992427	REWE 597	2026-01-07	f9112cbeba896f16f8055bb076ce7739f5baf42d27e9930d85136c85d46344ef	f	f	2026-06-27 02:19:45.473156
77	1	11	-8.00	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047438833369 PP.5065.PP., Ihr Einkauf bei\n1047438833369 PP.5065.PP PAYPAL\nMand-ID 5Q222259BDFXC\nGläubiger-ID LU96ZZZ0000000000000000058\nRCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-01-08	88a0f148c9b584bcf4de210b8a9f582142e4731c9fe0370a70a2579ebb909063	f	f	2026-06-27 02:19:45.492977
78	1	11	223.32	SEPA Überweisung von\nBantschow Services GmbH\nVerwendungszweck/ Kundenreferenz\nLOHN/GEHALT\n12/25\n7600801209-0000003\nSALA Lohn/Gehalt	Bantschow Services GmbH	2026-01-09	c20f0445b8d46b4c9c6c1afa648bc29dd2cdb8ada686b92422b2fd380f751e85	f	t	2026-06-27 02:19:47.786269
79	1	3	-22.50	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047458813751. Uber, Ihr Einkauf bei Uber\n1047458813751 PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Uber	2026-01-09	623db27be31a1f1bc9e9de17b9423f6a5a6145b0441b5b5838cdc7c7e43fbf7e	f	f	2026-06-27 02:19:47.804998
80	1	4	-46.00	SEPA Lastschrifteinzug von\nTelefonica Germany GmbH + Co. OHG\nVerwendungszweck/ Kundenreferenz\nKd-Nr.: 6099197040, Rg-Nr.: 1449807142/8, Ihr\nRatenplan\n3502805255470001449807142008RCUR\nGläubiger-ID DE9700000000142462\nMand-ID T0010001B000006099197040\nRCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-01-09	7f2077960374ff3c711092261073aefb9d25ad826b8c6d7ee20d577bb77fadbc	f	f	2026-06-27 02:19:47.825212
81	1	4	-2.99	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nAPPLE.COM.BILL//CORK/IE 07-01-2026T00:00:00\nKartennr. 5356999999992427	APPLE.COM.BILL	2026-01-09	d406d8ef4d180702e86aa4d4d710f6677809b687fbf504af8dd3c01b00949501	f	t	2026-06-27 02:19:55.987081
82	1	1	-8.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nEisautomat Karlshof//Darmstadt/DE 08-01-2026\nT00:04:14 Kartennr. 5356999999992427	Eisautomat Karlshof	2026-01-09	169bc1b0c2bc1fde273d0079cc6756538a34a8f9c84178c23c61679872e87166	f	t	2026-06-27 02:20:01.094622
83	1	11	-50.00	SEPA Überweisung an\nOmid tavassoli\nIBAN LU043442040006234134\nBIC ADVZLULLXXX	Omid tavassoli	2026-01-09	246edb03c508fc8110ff35e5114aa7792d0d28ca1260e4eaff809c3c99424cbe	f	t	2026-06-27 02:20:02.635234
84	1	1	15.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-12	a2d61d515b1f70d0da54b771bff68973fe777c9c532f5b3c24ad58f246b0be75	f	t	2026-06-27 02:20:10.011921
85	1	11	17.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-12	69eaf29535d457cb907a518a46ce166a2189a9cc0a406829d90a9529583f6848	f	t	2026-06-27 02:20:18.797352
86	1	11	-2.99	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047490258241 PP.5065.PP. Apple Services, Ihr\nEinkauf bei Apple Services\n1047490258241 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Apple Services	2026-01-12	c48eb866013a4fe05a02a570597885b3e313559e61a603b3716fe9c5be09f16a	f	f	2026-06-27 02:20:18.821337
87	1	9	-5.00	SEPA Lastschrifteinzug von\nSave the Children Deutschland e.V.\nVerwendungszweck/ Kundenreferenz\nVielen Dank fuer Ihre Spende\n019964076547672540425\nGläubiger-ID DE82ZZZ00000093262\nMand-ID MDA1CSE000004YMPHMAK\nRCUR Wiederholungslastschrift	Save the Children Deutschland e.V.	2026-01-12	fba8e0a0a20c5364713c88d14d9de47d9b12ceb211dd5b26bedcfcd6320eef6c	f	f	2026-06-27 02:20:18.84138
88	1	11	-5.99	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047490934089 PP.5065.PP. Apple Services, Ihr\nEinkauf bei Apple Services\n1047490934089 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Apple Services	2026-01-12	bd1d383cacd412f84469b3519e4ab4b14bca0f28c8045eff0b702e9884749f2e	f	f	2026-06-27 02:20:18.852488
89	1	3	-30.50	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047549765291. Uber, Ihr Einkauf bei Uber\n1047549765291 PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Uber	2026-01-13	a54599114a2c91e93c4dfe066caba96970f70267f3cf0da13a9f22dcb9d39e4b	f	f	2026-06-27 02:20:18.859128
90	1	1	-12.93	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 597 Darmstadt Bah//Darmstadt/DE 11-01-2026\nT14:24:09 Kartennr. 5356999999992427	REWE 597	2026-01-13	762fb2363f4cb94a28e5bb6c80c0834b9d2baf9332589ba35eda1b54b8e41140	f	f	2026-06-27 02:20:18.865785
91	1	2	-16.80	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nSojubar Korean food//Frankfurt am/DE 10-01-2026\nT21:39:20 Kartennr. 5356999999992427	Sojubar Korean food	2026-01-13	7f439c67c0ddbfec521550d1a791078b237093ff4ca3519a1dd3f2cd51a8955b	f	t	2026-06-27 02:20:20.348403
92	1	1	-26.21	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nALDI SUED//Frankfurt/DE 10-01-2026T21:51:33\nKartennr. 5356999999992427	ALDI SUED	2026-01-13	24a17f5242063862e1e589db354da21701d282a830b6458fc139e3bfbd789b9f	f	f	2026-06-27 02:20:20.365546
93	1	1	-10.96	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 010 Darmstadt//Darmstadt/DE 12-01-2026\nT21:24:01 Kartennr. 5356999999992427	REWE 010	2026-01-14	98b5d4a176c6a4a9a7959bc5e0d3012cf20c055218c3e28a7aec933d5fdd7f88	f	f	2026-06-27 02:20:20.385229
94	1	5	-144.24	SEPA Lastschrifteinzug von\nTechniker Krankenkasse\nVerwendungszweck/ Kundenreferenz\nTK-BuchNr 08400968529 Monat 12/25 E859914122\nBeitraege\n8400968529\nGläubiger-ID DE51TK100000031158\nMand-ID MD120082384\nRCUR Wiederholungslastschrift	Techniker Krankenkasse	2026-01-15	7a38c1597631f877df16063c9bcaf61b1e2c14a75a4f5ec069f55318c3626437	f	t	2026-06-27 02:20:21.786268
95	1	4	-7.99	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nAPPLE.COM.BILL//CORK/IE 13-01-2026T00:00:00\nKartennr. 5356999999992427	APPLE.COM.BILL	2026-01-15	7534da713e567f5ef8354637252a42b15fe6f241b3e7def100cca4842bfa9893	f	t	2026-06-27 02:20:25.996968
96	1	6	-8.70	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nRossmann 2536//Darmstadt/DE 13-01-2026T18:25:28\nKartennr. 5356999999992427	Rossmann 2536	2026-01-15	a05f70eb62890ab9c730363c75542d52e91fc3cf8d85b00c7c6b92e2d6281f85	f	t	2026-06-27 02:20:28.847054
98	1	1	13.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-16	7786d007e7b987060474566b1a51cbcbead348ad7ed87fd8b40a95e29f581d23	f	t	2026-06-27 02:20:34.384031
123	1	10	-1.92	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nADSON.STUDIERENDENWER//DARMSTADT/DE\n22-01-2026T11:33:43 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-26	751ab46bd7b44e3386e0f38531d5b005758c61dad2e48f651bfcc53d0af53f23	f	t	2026-06-27 02:21:35.209497
97	1	2	-16.40	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nHOTALO//Darmstadt/DE 14-01-2026T13:47:39 Folgenr.\n00 Verfalld. 1226	HOTALO	2026-01-15	806e8d8b90d3a4a824ddfe5000ad37875265dc8031c5c0e62cfba71396c2684b	f	t	2026-06-27 02:20:31.204773
99	1	11	-4.99	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047637022494 PP.5065.PP. Apple Services, Ihr\nEinkauf bei Apple Services\n1047637022494 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Apple Services	2026-01-19	cd73dbccd244c0b383f22b10d2778efe0bce2bd540611208b780b35c119adc58	f	f	2026-06-27 02:20:34.395036
100	1	3	-22.90	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047631756847. Uber, Ihr Einkauf bei Uber\n1047631756847 PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Uber	2026-01-19	1b6278b3ff0aec55bf6b58c8195156344e89bcbd2db41d39d30d98addd5fc253	f	f	2026-06-27 02:20:34.404631
101	1	2	-19.80	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nPalmen Grill//Darmstadt/DE 15-01-2026T13:32:36\nKartennr. 5356999999992427	Palmen Grill	2026-01-19	3f720b008e92838e129b1f47fe2a20c0ea3f600467c983ad5c96f0bfe89438e0	f	t	2026-06-27 02:20:37.244068
102	1	12	-7.50	Verwendungszweck/ Kundenreferenz\nPreis für Zweitschrift	Postbank	2026-01-19	14723845e7a87f0d520c4d029f5d29325b89d53ce26e9de1c6fdeedf30da9535	f	t	2026-06-27 02:20:39.497311
103	1	9	-10.00	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047676506558. SOS-Kinderdorfer weltweit, Ihr Einkauf\nbei SOS-Kinderdorfer weltweit\n1047676506558 PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	SOS-Kinderdorfer weltweit	2026-01-20	4a107465ef6de471e5b1224b27105baefea2745189f7c1e2361dc367d8f075c3	f	f	2026-06-27 02:20:39.516785
104	1	11	-23.00	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047658475364 PP.5065.PP. OpenAl Ireland Limited,\nIhr Einkauf bei OpenAl Ireland Limited\n1047658475364 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	OpenAl Ireland Limited	2026-01-20	69668e89be0d24728b7314b940a2f7d1f4314dae004754dcbeb12b5f4ba32d87	f	f	2026-06-27 02:20:39.532997
105	1	2	-3.49	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nMCDONALDS 01224//DARMSTADT/DE 16-01-2026\nT19:44:31 Kartennr. 5356999999992427	MCDONALDS 01224	2026-01-20	3372afff9b7db35659ad01208548dedc2dc7b8773c6446dd793abf9ebfff1441	f	f	2026-06-27 02:20:39.548615
106	1	6	-4.75	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nDM-Drogerie Markt//Darmstadt/DE 17-01-2026T17:27:06\nKartennr. 5356999999992427	DM-Drogerie Markt	2026-01-20	84bf6b50db182215401ce92699ae9ae6353ba089430948f9c8818aa93a973efa	f	t	2026-06-27 02:20:42.632385
107	1	7	-750.00	SEPA Echtzeitüberweisung an\nMARCO ANTONIO MONDRAGON CASTILLO\nIBAN DE84100110012620671649\nBIC NTSBDEB1XXX\nVerwendungszweck/ Kundenreferenz\nKaution braunshardter weg 8 64293 darmstadt	MARCO ANTONIO MONDRAGON CASTILLO	2026-01-21	57ffa0985314f8dbd29b7d00cc2e0e6f99fb604923db86aecbaa470eec4ffe51	f	t	2026-06-27 02:20:45.315283
108	1	1	-1.54	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nTegut Filiale 3122//Darmstadt/DE 19-01-2026T14:01:32\nKartennr. 5356999999992427	Tegut Filiale 3122	2026-01-21	721108e0110fa08485c94a008e43954ffd01d56a23007c7c53b04e69e1458d69	f	f	2026-06-27 02:20:45.334161
109	1	1	-3.18	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 010 Darmstadt//Darmstadt/DE 19-01-2026\nT21:32:04 Kartennr. 5356999999992427	REWE 010	2026-01-21	715d7ebf1d67a252f361cd0c00acf09a8e9fc48e81d6b949478a2f7f1a28cc1c	f	f	2026-06-27 02:20:45.351465
110	1	6	-4.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nEisautomat Karlshof//Darmstadt/DE 19-01-2026\nT23:34:44 Kartennr. 5356999999992427	Eisautomat Karlshof	2026-01-21	0e150785d64934cfe15a5e5150637036aa09451335a5dddd94fd3b693fb64776	f	t	2026-06-27 02:20:52.191672
111	1	2	-6.90	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBackfactory 626//Darmstadt/DE 19-01-2026T13:33:07\nKartennr. 5356999999992427	Backfactory 626	2026-01-21	4b61325d6c7631d04e94ea6d461a38d513693f2db1e4fdef6564f1d67fce02f7	f	f	2026-06-27 02:20:52.210159
112	1	2	-20.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nKuh Bar//Darmstadt/DE 19-01-2026T21:08:15 Kartennr.\n5356999999992427	Kuh Bar	2026-01-21	241fd66718c3c415224acd84eed8cd805ab5abcd3b5da1271d63c0e88885f7af	f	t	2026-06-27 02:20:56.391925
113	1	2	32.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-22	5df3fcc6b504da341030f22f4c650c53fb44562223afccf724acab0ac407166f	f	t	2026-06-27 02:21:07.551323
114	1	4	-12.94	SEPA Lastschrifteinzug von\nKlarna Bank AB\nVerwendungszweck/ Kundenreferenz\nPurchase at Microsoft\nRTE-160006596\nGläubiger-ID SE71ZZZ5567370431\nMand-ID FA38CCDE4C9042CA91981A25A9EF3533\nRCUR Wiederholungslastschrift	Klarna Bank AB	2026-01-22	a82434308291f4207da647e1dfb8763a06ccc016c0502d21776bc1f63c8cc7de	f	f	2026-06-27 02:21:07.580285
115	1	4	-41.58	SEPA Lastschrifteinzug von\nTelefonica Germany GmbH + Co. OHG\nVerwendungszweck/ Kundenreferenz\nKd-Nr.: 6088305020, Rg-Nr.: 1457534746/8, Ihre\nTarifrechnung\n3502812177230001457534746008RCUR\nGläubiger-ID DE9700000000142462\nMand-ID T0010001B000006088305020\nRCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-01-22	686bc2e4a283e37491ec57972a41c3f471efa0c9619bd8470ff7f2764564342a	f	f	2026-06-27 02:21:07.590791
116	1	10	-1.92	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nADSON.STUDIERENDENWER//DARMSTADT/DE\n20-01-2026T15:39:20 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-22	f9fc7e810c9ad588165da5957e878f3d03f3fdeba6b3508bd7b0418351c09e35	f	t	2026-06-27 02:21:09.228339
117	1	3	-2.00	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047763671817 PP.5065.PP. Uber Payments BV, Ihr\nEinkauf bei Uber Payments BV\n1047763671817 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Uber Payments BV	2026-01-23	02212f6de3004c0c50ef60c230d3f3a307ba947221a3f1642e6ca47e0bc527b6	f	f	2026-06-27 02:21:09.248385
118	1	3	-32.50	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047762524527. Uber, Ihr Einkauf bei Uber\n1047762524527 PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	Uber	2026-01-23	7530974cc4b50647ba828e825130d44956afd8577b6f16fd856881774b3bc3e5	f	f	2026-06-27 02:21:09.265396
119	1	1	-3.30	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBormuth GmbH//Darmstadt/DE 21-01-2026T16:56:45\nKartennr. 5356999999992427	Bormuth GmbH	2026-01-23	3ebd80d2bb960071f02838168faa61d699df1b6e9c695097b846f1fc8570a875	f	t	2026-06-27 02:21:13.082335
121	1	6	5.00	SEPA Überweisung von\nMinh Ngoc Nguyen\nVerwendungszweck/ Kundenreferenz\nMOB.024.UE.POS00094428	Minh Ngoc Nguyen	2026-01-26	0d5a159e0f1ee13cbfa8e8200bfd7981b56423f5c3bf43203c043a6e5c530830	f	t	2026-06-27 02:21:26.627619
122	1	1	13.00	SEPA Überweisung von\nIman Jahanpanah\nVerwendungszweck/ Kundenreferenz\nEssen	Iman Jahanpanah	2026-01-26	da6b7598cc74f182f0844e8bb4de94494f94d69e1a3cbd68da2f793dd89c5d77	f	t	2026-06-27 02:21:32.352777
124	1	2	-3.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBackfactory 626//Darmstadt/DE 22-01-2026T09:18:18\nKartennr. 5356999999992427	Backfactory 626	2026-01-26	ef06e1b93a0766832e18d71b5c3f1f9a7f32ff2af7b6834b28c19df480961225	f	f	2026-06-27 02:21:35.230295
125	1	1	-3.44	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nTegut Filiale 3122//Darmstadt/DE 22-01-2026T18:51:15\nKartennr. 5356999999992427	Tegut Filiale 3122	2026-01-26	f43ca4af521b15fa3eb2e6d231586ad1b99b203b2963499568b0a4407e867c4f	f	f	2026-06-27 02:21:35.247866
126	1	2	-19.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nGASTRONOMIE DJANGO.S//Darmstadt/DE 20-01-2026\nT21:03:36 Kartennr. 5356999999992427	GASTRONOMIE DJANGO.S	2026-01-26	f57b65e9aaac5cee3e4208ca1865ee1df43f5fa6ea29dd0e9d2473718a46b067	f	t	2026-06-27 02:21:37.557173
127	1	11	-19.90	SEPA Lastschrifteinzug von\nPayPal (Europe) S.a r.l. et Cie, S.C.A.\nVerwendungszweck/ Kundenreferenz\n1047797772788 PP.5065.PP. SMP GmbH & Co. KG,\nIhr Einkauf bei SMP GmbH & Co. KG\n1047797772788 PP.5065.PP PAYPAL\nGläubiger-ID LU96ZZZ0000000000000000058\nMand-ID 5Q222259BDFXC\nRCUR Wiederholungslastschrift	SMP GmbH & Co. KG	2026-01-27	b7cbe95c90117828954569564596aba6353bbfa48452c376db70462a371195a4	f	f	2026-06-27 02:21:37.579637
128	1	1	-3.88	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE Darmstadt Luisenc//Darmstadt/DE 24-01-2026\nT13:44:10 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-01-27	546100b9eef0dc4dcac4c322e310c27debe88061ae54127f135c950494d8bf78	f	f	2026-06-27 02:21:37.607356
129	1	2	-6.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBackfactory 626//Darmstadt/DE 24-01-2026T13:09:34\nKartennr. 5356999999992427	Backfactory 626	2026-01-27	98e10e09709422dd17a81666d51972fd7d31cb5efd108cb7f391e7cef7601492	f	f	2026-06-27 02:21:37.629219
130	1	2	-10.80	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nSumUp.Fresh Bite Dar//Darmstadt/DE 24-01-2026\nT13:55:21 Kartennr. 5356999999992427	SumUp.Fresh Bite Dar	2026-01-27	a991ab05afddd36e95bdb42d821b3cce6a3ab7b340993053037cc56b038b7859	f	t	2026-06-27 02:21:40.30899
131	1	2	-13.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nKuh Bar//Darmstadt/DE 23-01-2026T21:55:58 Kartennr.\n5356999999992427	Kuh Bar	2026-01-27	fcb379b4eb9795dd3eeda30c17fcb4ab58edb3512ce62b010b060eec86687ca2	f	t	2026-06-27 02:21:50.488324
132	1	7	-450.00	SEPA Echtzeitüberweisung an\nMARCO ANTONIO MONDRAGON CASTILLO\nIBAN DE84100110012620671649\nBIC NTSBDEB1XXX\nVerwendungszweck/ Kundenreferenz\nMiete februer	MARCO ANTONIO MONDRAGON CASTILLO	2026-01-28	903bb687304411c6dcb76bd65da944d47c3bdd04e147fc3c99e7c454f5d0f824	f	f	2026-06-27 02:21:50.519003
133	1	1	-1.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nSumUp.My Back SB Bac//Darmstadt/DE 26-01-2026\nT12:07:28 Kartennr. 5356999999992427	SumUp.My Back SB Bac	2026-01-28	997946f950e4c2089508f4674adc7273a9e12653f85100faea6545f06df528bf	f	t	2026-06-27 02:21:55.095804
134	1	1	-1.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nTegut Filiale 2464//Darmstadt/DE 26-01-2026T15:41:08\nKartennr. 5356999999992427	Tegut Filiale 2464	2026-01-28	27426848a174f6debd3b760640a8b24aaa9b5c75cb9e1bff31ff4e7779c88d36	f	f	2026-06-27 02:21:55.117257
135	1	1	-2.23	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 010 Darmstadt//Darmstadt/DE 26-01-2026\nT11:50:44 Kartennr. 5356999999992427	REWE 010	2026-01-28	58514c996c9509c63ff20f0acdf9651d694955d4c3982de155b2ca5bc93106a9	f	f	2026-06-27 02:21:55.16693
136	1	1	-8.44	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 010 Darmstadt//Darmstadt/DE 26-01-2026\nT20:03:48 Kartennr. 5356999999992427	REWE 010	2026-01-28	8d9da59c55d73830b0c93c0104cc999364389b10627ce94f77d9d3eb08745a1c	f	f	2026-06-27 02:21:55.18046
137	1	2	-10.49	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBURGER KING 15024//DARMSTADT/DE 26-01-2026\nT14:42:34 Kartennr. 5356999999992427	BURGER KING 15024	2026-01-28	e8ef44020055565e24017b16cc0c2d5b550fa363339498feff0016c1afdf4e30	f	f	2026-06-27 02:21:55.191085
138	1	10	-1.92	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nADSON.STUDIERENDENWER//DARMSTADT/DE\n27-01-2026T12:25:10 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-29	452662c38a75a8429943a6e50c807f70fe415b07a3b0279f01a01cc854c1dfe0	f	t	2026-06-27 02:21:57.521696
139	1	1	-5.10	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nBormuth GmbH//Darmstadt/DE 26-01-2026T11:30:45\nKartennr. 5356999999992427	Bormuth GmbH	2026-01-29	8ce211c7c28b3ccbf156bc7d29c79bf29eb524664aff59921e4235466fac76a9	f	t	2026-06-27 02:21:58.54782
140	1	10	-7.73	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nADSON.STUDIERENDENWER//DARMSTADT/DE\n27-01-2026T11:58:35 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-29	c78b5fa7c4a32f8e08de1ce61ee853262573d7211444aa990425893ea2744dee	f	t	2026-06-27 02:22:01.0377
141	1	1	-8.15	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE 010 Darmstadt//Darmstadt/DE 27-01-2026\nT17:52:22 Kartennr. 5356999999992427	REWE 010	2026-01-29	9f5f8877b710d9ac28c1fe1bd0b3d8358e230af16c9f8c58719daa1918353918	f	f	2026-06-27 02:22:01.053871
143	1	6	-1.00	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nTEDI//Darmstadt/DE 28-01-2026T17:36:27 Kartennr.\n5356999999992427	TEDI	2026-01-30	7296a1c6e09de0a4f1e062ab1d7758bfaa6cef5cc92a5537decc1ac61a72e7b4	f	t	2026-06-27 02:22:06.189002
144	1	1	-1.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nAlaras Getraenkeshop//Darmstadt/DE 28-01-2026\nT12:28:15 Kartennr. 5356999999992427	Alaras Getraenkeshop	2026-01-30	d22bcbb7de4eb1175befce850231993add19fea5c778622f7039dcd121fc53bd	f	t	2026-06-27 02:22:09.016952
145	1	1	-6.98	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nREWE Darmstadt Luisenc//Darmstadt/DE 28-01-2026\nT17:12:38 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-01-30	69bafee1addcbaa757b6d7c8352012e92ce4f976ba1255b6cf04a0ea471fd796	f	f	2026-06-27 02:22:09.035932
146	1	1	-9.50	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nAlaras Getraenkeshop//Darmstadt/DE 28-01-2026\nT12:24:55 Kartennr. 5356999999992427	Alaras Getraenkeshop	2026-01-30	f7a87fcae9d5c6a9b18e31b1095fe34fcb0583123bbde0ac4b64294fabe18b87	f	t	2026-06-27 02:22:13.457084
147	1	2	-12.10	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nPalmen Grill//Darmstadt/DE 28-01-2026T16:05:07\nKartennr. 5356999999992427	Palmen Grill	2026-01-30	4a6f7673e273b01b9a72d4b66c254d949d9000c126987fc568605bb69ef776da	f	t	2026-06-27 02:22:15.321738
62	1	1	-60.29	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 25-02-2026T12:33:49 Kartennr. 5356999999992427	ALDI SUED	2026-02-27	12d3895c22eec534bec08ef45fd1364ea44ffb679709bae806bfba598224a6eb	t	f	2026-06-27 02:12:55.019781
148	1	11	-10.00	SEPA Echtzeitüberweisung an Iman jahanpanah IBAN DE70380601864941788012 BIC GENODED1BRS	Iman jahanpanah	2026-01-01	4e72f59a09bd8660420b38bd40d0ae9902907f130167dd551b9d97d83de12cd7	f	t	2026-07-01 13:28:09.767527
581	4	42	-2.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Schum EuroShop GmbH 	Schum EuroShop GmbH 9//Dettelbach/DE	2025-09-11	bf729697ec805ec4efdcaa4c8afbd246d179818d59d8a977c9edde0f04bdea06	f	t	2026-07-15 01:55:17.468862
142	1	11	-300.00	SEPA Echtzeitüberweisung an\nOmid tavassoli\nIBAN DE35100101780391592427\nBIC REVODEB2XXX	Omid tavassoli	2026-01-30	7d17dc14bdcff973fa9050e300d81b99b59295e12bc9279b8f68a84d64c8a12d	t	t	2026-06-27 02:22:03.702272
149	1	7	-400.00	SEPA Echtzeitüberweisung an Dhanush Narayana Reddy IBAN DE75100101785806194951 BIC REVODEB2XXX	Dhanush Narayana Reddy	2026-01-01	058d016b3c4071880526cd9192ad91eda1c00cedf6cedb0da9bbc6387a8b120a	t	t	2026-07-01 13:28:11.890225
150	1	5	-9.90	SEPA Lastschrifteinzug von Muenchener VEREIN Krankenversicherung a. Verwendungszweck/ Kundenreferenz Kundennummer 25Y187 KV1001 9,90 25Y187/3 0101202601-99999920933868 Gläubiger-ID DE76ZZZ00000035752 Mand-ID KD-25Y187-KV-0039387149 RCUR Wiederholungslastschrift	Muenchener VEREIN Krankenversicherung a.	2026-01-02	84e9d0a031f07ae7a631e80c67f1f778284cf195d28be8bf7c4c6073d71ea134	f	t	2026-07-01 13:28:13.800184
152	1	8	-24.95	SEPA Lastschrifteinzug von A.I. Fitness Sued GmbH Verwendungszweck/ Kundenreferenz DA1--0109-0000788 DA1-643384 Studenten ULTRA 24.95 EUR 01.01.26-31.01.26 DA1--0109-0000788 Gläubiger-ID DE79ZZZ00002353513 Mand-ID MLREFDA102606 RCUR Wiederholungslastschrift	A.I. Fitness Sued GmbH	2026-01-02	2a8e1e3e1552089fcfc873e0dbabbf278a7012076e42ddae684c235c7895814a	f	f	2026-07-01 13:28:13.857051
153	1	6	-15.99	Kartenzahlung Verwendungszweck/ Kundenreferenz SATURN ELECTRO-HANDELS//FRANKFURT/DE 30-12-2025T15:29:03 Kartennr. 5356999999992427	SATURN ELECTRO-HANDELS	2026-01-02	0e87086cd53e2b003ba9ac9f1563c6808ace75a38b9b050a623dc5721a7c5946	f	f	2026-07-01 13:28:13.882806
154	1	6	-9.50	Kartenzahlung Verwendungszweck/ Kundenreferenz KIOSK AM WEISSEN TURM//DARMSTADT/DE 31-12-2025T14:42:13 Kartennr. 5356999999992427	KIOSK AM WEISSEN TURM	2026-01-05	126c5a7ab0a73e7b97fa21e8901c4bc98ca4368f3a2cd096778699090cadaabd	f	t	2026-07-01 13:28:20.693748
155	1	10	-20.00	Kartenzahlung Verwendungszweck/ Kundenreferenz ULB2-EC AUFWERTER-DE//Darmstadt/DE 02-01-2026 T12:29:19 Folgenr. 00 Verfalld. 1226	ULB2-EC AUFWERTER-DE	2026-01-05	691425725e2be5db29949c04b0466d283bbdc58297fa558f76066d83219a5bbb	f	t	2026-07-01 13:28:23.378785
156	1	11	18.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-06	b6a22bf2621510aa20890ac05963885c2ba8ca8f878092104b3b8321fdb6b572	f	t	2026-07-01 13:28:32.224068
157	1	11	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047392131025 PP.5065.PP. Save the Children Deutschland e. V., Ihr Einkauf bei Save the Children Deutschland e.V. 1047392131025 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Save the Children Deutschland e. V.)	2026-01-06	1861d908a7e296ea7736d4d8baae2d12fcd00bd8668c6dd2120da8b4e06da714	f	f	2026-07-01 13:28:32.260082
158	1	4	-3.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 02-01-2026T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-01-06	f92e4448cc210f3f95264f644181e299db050cee47f388d1e8fe007475723af7	f	t	2026-07-01 13:28:40.213929
159	1	2	-5.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Grand Cafe - K+K//Darmstadt/DE 05-01-2026T13:59:35 Kartennr. 5356999999992427	Grand Cafe - K+K	2026-01-07	e1ed9e48dee993759b4b394121941309bf5335d5f1cb40e250a2f839f727f3c7	f	f	2026-07-01 13:28:40.24328
160	1	8	-19.80	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 06-01-2026T14:11:36 Folgenr. 00 Verfalld. 1226	HOTALO	2026-01-07	98e933210dfa44a9490fc3b23a853e93612a9b6372241d7f6cb9dfe12061f42b	f	t	2026-07-01 13:28:56.341273
161	1	1	-27.84	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 597 Darmstadt Bah//Darmstadt/DE 05-01-2026 T16:18:41 Kartennr. 5356999999992427	REWE 597	2026-01-07	2a8341246400ebf71a3c9ae9186aa5e327d7d4be7c878d9658cd2b51ac513ee9	f	f	2026-07-01 13:28:56.365699
162	1	11	-8.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047438833369 PP.5065.PP., Ihr Einkauf bei 1047438833369 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2026-01-08	c98780d74de5210b7c854188a54bb4f0b99221bb52372daaca346690f293a97e	f	f	2026-07-01 13:28:56.383183
164	1	3	-22.50	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047458813751. Uber, Ihr Einkauf bei Uber 1047458813751 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Uber)	2026-01-09	e6044fde56e755d0cf5c15914b9d05191ad77acc0269ebcf44fe7d8321f5a6dc	f	f	2026-07-01 13:29:00.451131
165	1	4	-46.00	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6099197040, Rg-Nr.: 1449807142/8, Ihr Ratenplan 3502805255470001449807142008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006099197040 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-01-09	ff8cb850624b9a5225b82f2a567d75d38809d2a0e0d8a4cb981522f9771d1be3	f	f	2026-07-01 13:29:00.467747
166	1	6	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 07-01-2026T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-01-09	9f3b4002e8f7564f77237ef1c3f27be5be609965df37594f99d18ba0d3120b0d	f	t	2026-07-01 13:29:05.690025
167	1	1	-8.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Eisautomat Karlshof//Darmstadt/DE 08-01-2026 T00:04:14 Kartennr. 5356999999992427	Eisautomat Karlshof	2026-01-09	0deee080521fd0056872269eae0368c79ed413c228febb0d1a577fdca26f2585	f	t	2026-07-01 13:29:09.220263
168	1	11	-50.00	SEPA Überweisung an Omid tavassoli IBAN LU043442040006234134 BIC ADVZLULLXXX	Omid tavassoli	2026-01-09	f1924f9b9a96d205afdbc6de93b6c424ccc122187ceb4f714b087f230643cc41	f	t	2026-07-01 13:29:12.58256
169	1	1	15.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-12	d1c3bcc3d983e76b8b7cf0c598f2e878f920f11ef893c9993c3f6c7b15b9c85b	f	t	2026-07-01 13:29:16.797455
170	1	11	17.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-12	8e18add14e84a033609a8d318034c95fd8d63c767e9c923fdb2fb08318a0032c	f	t	2026-07-01 13:29:28.33836
171	1	11	-2.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047490258241 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1047490258241 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Apple Services)	2026-01-12	a2ffe9c97bd289906d9a4e51844028498bf9c8dc2cec61c1c32ea085a9e4b36d	f	f	2026-07-01 13:29:28.373509
172	1	9	-5.00	SEPA Lastschrifteinzug von Save the Children Deutschland e.V. Verwendungszweck/ Kundenreferenz Vielen Dank fuer Ihre Spende 019964076547672540425 Gläubiger-ID DE82ZZZ00000093262 Mand-ID MDA1CSE000004YMPHMAK RCUR Wiederholungslastschrift	Save the Children Deutschland e.V.	2026-01-12	d8f4df836c110d43337ff50a35bcc242c71a55ed478e527a19c85bc127427fc7	f	f	2026-07-01 13:29:28.396335
578	4	40	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//ITUNES.COM/IE 07-09-2025 T00:00:00 Kartennr. 	APPLE.COM.BILL//ITUNES.COM/IE	2025-09-09	73686fb041e8a7d5adc3ea04716be105d09a5929e044f29cb9f19c1e0b9527bc	f	t	2026-07-15 01:55:15.165616
173	1	11	-5.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047490934089 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1047490934089 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Apple Services)	2026-01-12	3450addd8bed2809bab529ae4e9bd7dbe0f4d78e208234d4d49f6e487aa364ab	f	f	2026-07-01 13:29:28.413061
174	1	3	-30.50	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047549765291. Uber, Ihr Einkauf bei Uber 1047549765291 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Uber)	2026-01-13	2f28efff6b630e3680266cc38915fdb4c0720d28aa493e43d8a642c28caa65e1	f	f	2026-07-01 13:29:28.430938
175	1	1	-12.93	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 597 Darmstadt Bah//Darmstadt/DE 11-01-2026 T14:24:09 Kartennr. 5356999999992427	REWE 597	2026-01-13	2e7d9de6ca63968ec065e5d86e6bd8aae845db758987b1793d748132fa8e583a	f	f	2026-07-01 13:29:28.442924
176	1	2	-16.80	Kartenzahlung Verwendungszweck/ Kundenreferenz Sojubar Korean food//Frankfurt am/DE 10-01-2026 T21:39:20 Kartennr. 5356999999992427	Sojubar Korean food	2026-01-13	8f599912d2b85a7aff7c1b8feed4a14747411674011872ab1217e2886e2d9f7b	f	t	2026-07-01 13:29:31.472951
177	1	1	-26.21	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Frankfurt/DE 10-01-2026T21:51:33 Kartennr. 5356999999992427	ALDI SUED	2026-01-13	4c26bdf6fde028c97af5385bb0a26a254aa1a6ed5a0f2f2508f7854c48225117	f	f	2026-07-01 13:29:31.497606
178	1	1	-10.96	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 010 Darmstadt//Darmstadt/DE 12-01-2026 T21:24:01 Kartennr. 5356999999992427	REWE 010	2026-01-14	72d10294383b492b017b2750495c60765649166071c70f8541be89be4705a17b	f	f	2026-07-01 13:29:31.515184
179	1	5	-144.24	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck/ Kundenreferenz TK-BuchNr 08400968529 Monat 12/25 E859914122 Beitraege 8400968529 Gläubiger-ID DE51TK100000031158 Mand-ID MD120082384 RCUR Wiederholungslastschrift	Techniker Krankenkasse	2026-01-15	1cf89e72c6f0fc55aee9f7f8bb65d598a215a1462e7278e927c46f187ee9a926	f	t	2026-07-01 13:29:34.440662
180	1	4	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 13-01-2026T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2026-01-15	1b2e83b06161a54b09ae80422567df9d140041374e9ccb3a757c644016eaca88	f	t	2026-07-01 13:29:38.57947
181	1	6	-8.70	Kartenzahlung Verwendungszweck/ Kundenreferenz Rossmann 2536//Darmstadt/DE 13-01-2026T18:25:28 Kartennr. 5356999999992427	Rossmann 2536	2026-01-15	c1e89b005e2a2e517f4f8745534a926c76882ba79d59669e037afb7876a0e63b	f	t	2026-07-01 13:29:41.635936
183	1	11	13.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-16	3defea77f873ab637f3cc8b126d866cc2c3c82f3ad195a68503edca49e573120	f	t	2026-07-01 13:29:50.129386
184	1	11	-4.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047637022494 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1047637022494 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Apple Services)	2026-01-19	d36eddda210511d03437f0ce53f3a07e5447d6f366e8dbe34bf5ee1479e57491	f	f	2026-07-01 13:29:50.145073
185	1	3	-22.90	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047631756847. Uber, Ihr Einkauf bei Uber 1047631756847 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Uber)	2026-01-19	873fef62e236f00a73a2ce82b698698f73a5c174111a39e03e917b7432705f24	f	f	2026-07-01 13:29:50.159062
186	1	2	-19.80	Kartenzahlung Verwendungszweck/ Kundenreferenz Palmen Grill//Darmstadt/DE 15-01-2026T13:32:36 Kartennr. 5356999999992427	Palmen Grill	2026-01-19	370adefd6f278c0058fc177c9cea8b13a81aeb9203092787309dacc67bdf336f	f	t	2026-07-01 13:29:53.499448
187	1	12	-7.50	Verwendungszweck/ Kundenreferenz Preis für Zweitschrift	Unknown	2026-01-18	5b9b09265e216c663b8c193c8147df6085e3b57b2ebdd883e70d20d6d7f89fc2	f	t	2026-07-01 13:29:56.75909
188	1	9	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047676506558. SOS-Kinderdorfer weltweit, Ihr Einkauf bei SOS-Kinderdorfer weltweit 1047676506558 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for SOS-Kinderdorfer weltweit)	2026-01-20	d3ef76adbb74bdb22c1e8f7b7ae92ce795de8e5bb7b10ed366e30312635f4d84	f	f	2026-07-01 13:29:56.817943
189	1	4	-23.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047658475364 PP.5065.PP. OpenAI Ireland Limited, Ihr Einkauf bei OpenAI Ireland Limited 1047658475364 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for OpenAI Ireland Limited)	2026-01-20	552ffe5e939070a9469d8a4b3bd5ca6c8c0e59ec76344cbe082ef4bf105b22b1	f	f	2026-07-01 13:29:56.832214
190	1	2	-3.49	Kartenzahlung Verwendungszweck/ Kundenreferenz MCDONALDS 01224//DARMSTADT/DE 16-01-2026 T19:44:31 Kartennr. 5356999999992427	MCDONALDS 01224	2026-01-20	cc0f2f1b1bc145dbc9ea09eebd45ca4a0e8be9eab3f4d5dd84e5244273fdcd93	f	f	2026-07-01 13:29:56.84199
191	1	6	-4.75	Kartenzahlung Verwendungszweck/ Kundenreferenz DM-Drogerie Markt//Darmstadt/DE 17-01-2026T17:27:06 Kartennr. 5356999999992427	DM-Drogerie Markt	2026-01-20	04a63264ecdadd243905129a62243e7dfa46211225dd2cef702b76eba74ce0f2	f	t	2026-07-01 13:30:01.174101
192	1	7	-750.00	SEPA Echtzeitüberweisung an MARCO ANTONIO MONDRAGON CASTILLO IBAN DE84100110012620671649 BIC NTSBDEB1XXX Verwendungszweck/ Kundenreferenz Kaution braunshardter weg 8 64293 darmstadt	MARCO ANTONIO MONDRAGON CASTILLO	2026-01-20	4fe4317e1c1b5d743c811d6f16c83859b73e5b489cf5ca33826e70b2e9644c19	f	t	2026-07-01 13:30:03.422329
193	1	1	-1.54	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 19-01-2026T14:01:32 Kartennr. 5356999999992427	Tegut Filiale 3122	2026-01-21	56f41e0e1b82b4a072465786fae9b07a74e6cab31e8ca2e4b23d21aadc5b216b	f	f	2026-07-01 13:30:03.441463
194	1	1	-3.18	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 010 Darmstadt//Darmstadt/DE 19-01-2026 T21:32:04 Kartennr. 5356999999992427	REWE 010	2026-01-21	9063acb6c424e4e7d3c8e3387d192dd76e8e7bb87454cf2ecb0fb3bbeb7272d0	f	f	2026-07-01 13:30:03.457582
195	1	1	-4.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Eisautomat Karlshof//Darmstadt/DE 19-01-2026 T23:34:44 Kartennr. 5356999999992427	Eisautomat Karlshof	2026-01-21	83015c65a2b9dfbe7a3238bb6e2aae713c4d64e46501c5016f4546b6ef8384b2	f	t	2026-07-01 13:30:15.675856
196	1	2	-6.90	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 19-01-2026T13:33:07 Kartennr. 5356999999992427	Backfactory 626	2026-01-21	34191d7881afe4f34f012d65f1ed6110f042a95dce7b8662bf8478f3b931cd4d	f	f	2026-07-01 13:30:15.704457
197	1	8	-20.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Kuh Bar//Darmstadt/DE 19-01-2026T21:08:15 Kartennr. 5356999999992427	Kuh Bar	2026-01-21	77c3c99809739c49e72f9e654ce165bf8258c57872327bdfcd2679438daada25	f	t	2026-07-01 13:30:18.918299
198	1	1	32.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-22	cf2fc0713ff3d9955c31c07b1cfe66d8f0682f9d38f77f8b675bdb731d08fc62	f	t	2026-07-01 13:30:22.050674
199	1	4	-12.94	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ Kundenreferenz Purchase at Microsoft RTE-160006596 Gläubiger-ID SE71ZZZ5567370431 Mand-ID FA38CCDE4C9042CA91981A25A9EF3533 RCUR Wiederholungslastschrift	Klarna Bank AB (for Microsoft)	2026-01-22	90ef30ad22075fdec1458a70e3eb363552444d2412221b5c162195fd2623720b	f	f	2026-07-01 13:30:22.076904
200	1	4	-41.58	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6088305020, Rg-Nr.: 1457534746/8, Ihre Tarifrechnung 3502812177230001457534746008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006088305020 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2026-01-22	c075cef17fdd1ebac9869372a7e1583d185bcf4254305cd139b11deba110470a	f	f	2026-07-01 13:30:22.092338
201	1	10	-1.92	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 20-01-2026T15:39:20 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-22	7f66468fe9bb3bf62030f50901a33f8364eb3564c60b01680f82d35c416dce1c	f	t	2026-07-01 13:30:30.233045
202	1	3	-2.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047763671817 PP.5065.PP. Uber Payments BV, Ihr Einkauf bei Uber Payments BV 1047763671817 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Uber Payments BV)	2026-01-23	36973e4d33108aa0d403050fc3d277d7f0b37f5d55d7d045b69b345ccf8533dc	f	f	2026-07-01 13:30:30.255268
203	1	3	-32.50	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047762524527. Uber, Ihr Einkauf bei Uber 1047762524527 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for Uber)	2026-01-23	4a42d787e3e4c518dca532d076d495381b7a139ee5ad88bb3caeb06b26506a8d	f	f	2026-07-01 13:30:30.271044
204	1	1	-3.30	Kartenzahlung Verwendungszweck/ Kundenreferenz Bormuth GmbH//Darmstadt/DE 21-01-2026T16:56:45 Kartennr. 5356999999992427	Bormuth GmbH	2026-01-23	1e984df16914b68a18795eb7e96722e931c6960261cc7f3af135d9176f1811ab	f	t	2026-07-01 13:30:33.355482
205	1	12	-16.40	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 22-01-2026T13:45:23 Folgenr. 00 Verfalld. 1226	HOTALO	2026-01-23	fd92904a0e03af88cd9ce07cc409d8d7d371730cf2cca13dac87a89e21c59b33	f	t	2026-07-01 13:30:38.825474
206	1	11	5.00	SEPA Überweisung von Minh Ngoc Nguyen Verwendungszweck/ Kundenreferenz MOB.024.UE.POS00094428	Minh Ngoc Nguyen	2026-01-26	b24063406b51c4f451cfc88b394550f6750bc3c7e22452a0638834bf66e26612	f	t	2026-07-01 13:30:41.974626
207	1	1	13.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2026-01-26	8fd33e232f27319bedcb13f1d28110b2aa8295601dea0579a4fef405b07bfd95	f	t	2026-07-01 13:30:55.09789
208	1	10	-1.92	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 22-01-2026T11:33:43 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-26	aaefe99ccd26946e045be26a52058a752a4b8fb44747c86d21e615dd895f9af4	f	t	2026-07-01 13:31:01.938957
209	1	2	-3.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 22-01-2026T09:18:18 Kartennr. 5356999999992427	Backfactory 626	2026-01-26	ab1f0114956eff936679ca63f8c15eceb90a750d53226bf16c2e607117bca152	f	f	2026-07-01 13:31:01.971479
210	1	1	-3.44	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 22-01-2026T18:51:15 Kartennr. 5356999999992427	Tegut Filiale 3122	2026-01-26	c55d305141fe3c9ac4ccba094b3552b1f269e417c0f5fca49d36c4ae83258617	f	f	2026-07-01 13:31:01.985473
211	1	2	-19.00	Kartenzahlung Verwendungszweck/ Kundenreferenz GASTRONOMIE DJANGO.S//Darmstadt/DE 20-01-2026 T21:03:36 Kartennr. 5356999999992427	GASTRONOMIE DJANGO.S	2026-01-26	8b5b188edce8788ae5e6cd79984811eb42883c55360930f418102b0c95656a3e	f	t	2026-07-01 13:31:04.154376
212	1	11	-19.90	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047797772788 PP.5065.PP. SMP GmbH & Co. KG, Ihr Einkauf bei SMP GmbH & Co. KG 1047797772788 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for SMP GmbH & Co. KG)	2026-01-27	4a4fa648e64ccb7afde952a2853d89be7323c65d30f1d6599d86ae8cdbbf2441	f	f	2026-07-01 13:31:04.179313
213	1	1	-3.88	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 24-01-2026 T13:44:10 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-01-27	dc6bb35a3dbad5cf0d1d813c7bf28adbe4ee2077a589c837b46ec03d6185d6a7	f	f	2026-07-01 13:31:04.197694
214	1	2	-6.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 24-01-2026T13:09:34 Kartennr. 5356999999992427	Backfactory 626	2026-01-27	0eb234a84115038ceea9e3cc0254fcc8c6f1249d2a6eb4debb6f30a6cd54d3e1	f	f	2026-07-01 13:31:04.213019
215	1	2	-10.80	Kartenzahlung Verwendungszweck/ Kundenreferenz SumUp.Fresh Bite Dar//Darmstadt/DE 24-01-2026 T13:55:21 Kartennr. 5356999999992427	SumUp.Fresh Bite Dar	2026-01-27	8eaddf564d6c18d58a0f68894d6f8565173e0a8aa8589b5bbf5d6b5f8951bf20	f	t	2026-07-01 13:31:07.608976
216	1	8	-13.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Kuh Bar//Darmstadt/DE 23-01-2026T21:55:58 Kartennr. 5356999999992427	Kuh Bar	2026-01-27	67cc31768f7331bae443a84f6011a4aad935e7b8126496eb2345645d91645fad	f	t	2026-07-01 13:31:11.67408
217	1	7	-450.00	SEPA Echtzeitüberweisung an MARCO ANTONIO MONDRAGON CASTILLO IBAN DE84100110012620671649 BIC NTSBDEB1XXX Verwendungszweck/ Kundenreferenz Miete februer	MARCO ANTONIO MONDRAGON CASTILLO	2026-01-28	a8c6d43f21b22ac7734af6ab8d76a74c7a01678079057fc870d0b922c2a57a5a	f	f	2026-07-01 13:31:11.698344
218	1	12	-1.50	Kartenzahlung Verwendungszweck/ Kundenreferenz SumUp.My Back SB Bac//Darmstadt/DE 26-01-2026 T12:07:28 Kartennr. 5356999999992427	SumUp.My Back SB Bac	2026-01-28	266c1ad9a5155331164ddff5fd3cdbcf3516c07d4e7e1be96e049fb631eaef91	f	t	2026-07-01 13:31:16.450431
219	1	1	-1.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 2464//Darmstadt/DE 26-01-2026T15:41:08 Kartennr. 5356999999992427	Tegut Filiale 2464	2026-01-28	47b5aae538e39ff1a1a81c523b49ffc43e69d617576aeff3184ef0b396565011	f	f	2026-07-01 13:31:16.474544
220	1	1	-2.23	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 010 Darmstadt//Darmstadt/DE 26-01-2026 T11:50:44 Kartennr. 5356999999992427	REWE 010	2026-01-28	9bb4ba4882131ab476c3d0d640895dfc90f8783eb50d766737a23044a70bd4f6	f	f	2026-07-01 13:31:16.491569
221	1	1	-8.44	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 010 Darmstadt//Darmstadt/DE 26-01-2026 T20:03:48 Kartennr. 5356999999992427	REWE 010	2026-01-28	ecf9edde0a61768382e1b25ce007f3cc7aa0300b3f0bb300565b66622008ea1b	f	f	2026-07-01 13:31:16.508059
222	1	2	-10.49	Kartenzahlung Verwendungszweck/ Kundenreferenz BURGER KING 15024//DARMSTADT/DE 26-01-2026 T14:42:34 Kartennr. 5356999999992427	BURGER KING 15024	2026-01-28	eee96b796626744cd05bccc147214ef21c93386292f1c930ffdfca6aed80612c	f	f	2026-07-01 13:31:16.526648
223	1	10	-1.92	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 27-01-2026T12:25:10 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-29	f77e4ff4f693d70b870597ccfc83327445b330a875e5e99820df6d174c919da3	f	t	2026-07-01 13:31:21.938389
224	1	1	-5.10	Kartenzahlung Verwendungszweck/ Kundenreferenz Bormuth GmbH//Darmstadt/DE 26-01-2026T11:30:45 Kartennr. 5356999999992427	Bormuth GmbH	2026-01-29	38bcabc92527bbca319754b3352486d97588e005644e49cf71eda3104f3241f5	f	t	2026-07-01 13:31:27.073436
225	1	10	-7.73	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 27-01-2026T11:58:35 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2026-01-29	38b9d679fd39d92450ff779e65500272b93234b58dbfd2e9075cec1715b6bc71	f	t	2026-07-01 13:31:32.775589
226	1	1	-8.15	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE 010 Darmstadt//Darmstadt/DE 27-01-2026 T17:52:22 Kartennr. 5356999999992427	REWE 010	2026-01-29	8868b603141819f45e59745332040ccdcbeffac08a8d1f3c8664c2960e951b77	f	f	2026-07-01 13:31:32.809945
228	1	6	-1.00	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 28-01-2026T17:36:27 Kartennr. 5356999999992427	TEDI	2026-01-30	648e321fb72f087473a2ae2b77534cacfa7ab709de1f3cb310103cfcd314e879	f	t	2026-07-01 13:31:38.674802
229	1	1	-1.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Alaras Getraenkeshop//Darmstadt/DE 28-01-2026 T12:28:15 Kartennr. 5356999999992427	Alaras Getraenkeshop	2026-01-30	c334eb33b728b7fa17978bb4a8487ae40cf12187c27a42abad1e5c60c9ecee6e	f	t	2026-07-01 13:31:41.902665
230	1	1	-6.98	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 28-01-2026 T17:12:38 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2026-01-30	c6656531ebd4fdaf59e8d6c210570ecd06a21ddc63c72d62d562fed00a40c469	f	f	2026-07-01 13:31:41.965177
58	1	2	-35.51	Kartenzahlung Verwendungszweck/ Kundenreferenz JINS HAUS GIR 69220259//DARMSTADT/DE 24-02-2026T19:02:42 Folgenr. 000 Verfalld. 1226	JINS HAUS GIR 69220259	2026-02-25	52a8b1706ef6921fbda7798ca36aa25c204bd94986e95d8000630001c2b7342c	t	t	2026-06-27 02:12:45.390168
231	1	1	-9.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Alaras Getraenkeshop//Darmstadt/DE 28-01-2026 T12:24:55 Kartennr. 5356999999992427	Alaras Getraenkeshop	2026-01-30	739dd495b49a7b471c2893f9ff168beb0d9fc2d63780cd4d7954960bb5e45c32	f	t	2026-07-01 13:31:45.118741
232	1	2	-12.10	Kartenzahlung Verwendungszweck/ Kundenreferenz Palmen Grill//Darmstadt/DE 28-01-2026T16:05:07 Kartennr. 5356999999992427	Palmen Grill	2026-01-30	dfa0a176edd11c639a765590c6a0e8828ce431aa3b6c2927a0e826156dbc4a03	f	t	2026-07-01 13:31:49.208109
75	1	2	-19.80	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nHOTALO//Darmstadt/DE 06-01-2026T14:11:36 Folgenr.\n00 Verfalld. 1226	HOTALO	2026-01-07	e84b859870b2344d4f805085784e6c96c474dd6f787d5b2eda52ef64dac79147	f	t	2026-06-27 02:19:45.452875
120	1	2	-16.40	Kartenzahlung\nVerwendungszweck/ Kundenreferenz\nHOTALO//Darmstadt/DE 22-01-2026T13:45:23 Folgenr.\n00 Verfalld. 1226	HOTALO	2026-01-23	36f8fdc9da6d4c352558805d3783132873f383afcc58325734e54797240e8ede	f	t	2026-06-27 02:21:20.049411
182	1	2	-16.40	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 14-01-2026T13:47:39 Folgenr. 00 Verfalld. 1226	HOTALO	2026-01-15	18fee1be9dd40718bc253147862dc6d2f3d03c73b678134becba1554fed02340	f	t	2026-07-01 13:29:45.573503
227	1	11	-300.00	SEPA Echtzeitüberweisung an Omid tavassoli IBAN DE35100101780391592427 BIC REVODEB2XXX	Omid tavassoli	2026-01-29	a17467feabdda7d3d43963002774202e0235707241bdff28708de2964dc5d5ae	t	t	2026-07-01 13:31:35.313636
163	1	11	223.32	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN/GEHALT 12/25 7600801209-0000003 SALA Lohn/Gehalt	Bantschow Services GmbH	2026-01-09	280c0702aa9618b4ae92faad5903262259eeea7ae8d21f35b22cf407ebf5dfb4	f	t	2026-07-01 13:29:00.427701
269	1	6	-1.39	Kartenzahlung Verwendungszweck/ Kundenreferenz Rossmann 3575//Rossdorf/DE 05-12-2025T18:58:24 Kartennr. 5356999999992427	Rossmann 3575	2025-12-09	58fe009cc8e2048be9eed6d7a464aedb77383764cf5a3f61e7e4320f1170b8e8	f	t	2026-07-13 01:29:13.860569
579	4	47	-2.99	SEPA Lastschrifteinzug von PayPal (Europe) 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-09-10	8319e4e2283d1452b8f88a722f53b30dbf057418cb1256eb33a65282ccd8ac24	f	f	2026-07-15 01:55:15.208566
580	4	47	-5.99	SEPA Lastschrifteinzug von PayPal (Europe) 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-09-10	6442b96ba9473fe314ac85dd0d6d879832991b53a299773f6459c646f3df0a8d	f	f	2026-07-15 01:55:15.254495
243	1	5	-9.90	SEPA Lastschrifteinzug von Muenchener VEREIN Krankenversicherung a. Verwendungszweck/ Kundenreferenz Kundennummer 25Y187 KV1001 9,90 25Y187/3 0112202501-99999921595907 Gläubiger-ID DE76ZZZ00000035752 Mand-ID KD-25Y187-KV-0039387149 RCUR Wiederholungslastschrift	Muenchener VEREIN Krankenversicherung a.	2025-12-01	5fc05f66c7e4b51795529313e5d3ad966c44c3f45885ff577621d019e344cace	f	t	2026-07-13 01:28:20.406709
244	1	8	-24.95	SEPA Lastschrifteinzug von A.I. Fitness Sued GmbH Verwendungszweck/ Kundenreferenz DA1--0107-0000653 DA1-643384 Studenten ULTRA 24.95 EUR 01.12.25-31.12.25 DA1--0107-0000653 Gläubiger-ID DE79ZZZ00002353513 Mand-ID MLREFDA102606 RCUR Wiederholungslastschrift	A.I. Fitness Sued GmbH	2025-12-01	966cfd6dddbcbe31c422caa7c8f67c7cdb1f82cd22b98d3607b32fba1659770e	f	f	2026-07-13 01:28:20.431954
245	1	10	1.74	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 27-11-2025T10:05:34 Kartennr. 5356999999992427	ADSON.STUDIERENDENWER	2025-12-01	21964bc3bedcffd64ca5a9f0d6750ae1130612382aa98e70bb766559b6d0a630	f	t	2026-07-13 01:28:25.028938
246	1	2	-2.80	Kartenzahlung Verwendungszweck/ Kundenreferenz Ditsch Frankfurt Hbf.//Frankfurt/DE 27-11-2025T14:50:08 Kartennr. 5356999999992427	Ditsch Frankfurt Hbf.	2025-12-01	f6594fec11b551625b396066d68dde3c101b901e111f67459c1b5593d22dc259	f	t	2026-07-13 01:28:29.266805
247	1	3	-3.40	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 27-11-2025T17:58:20 Kartennr. 5356999999992427	Dott scooter ride	2025-12-01	beabe0398092b91a4d01e631acde4f455082777ae4f8bd707ffd2e0fd7e5fc17	f	t	2026-07-13 01:28:31.61672
248	1	2	-6.30	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 27-11-2025T11:03:38 Kartennr. 5356999999992427	Backfactory 626	2025-12-01	7dd9da9c76f24d392cdd29542b13aac69ff0e01c126d1adb5afc52128a19375f	f	f	2026-07-13 01:28:31.652815
249	1	1	-14.10	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 27-11-2025 T18:04:27 Kartennr. 5356999999992427	REWE Darmstadt Luisenc	2025-12-01	2fe9394ba16d469fa19980ecb15e1b09be3d7631f41fe0ef625063493eec1336	f	f	2026-07-13 01:28:31.664922
250	1	2	-24.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Restaurant Hani//Frankfurt am/DE 27-11-2025T14:38:57 Kartennr. 5356999999992427	Restaurant Hani	2025-12-01	713a5dd96c0d593257b800fa1093af24c63135596f2c17d65f9cdae35ec0ba96	f	t	2026-07-13 01:28:32.801242
252	1	11	250.00	SEPA Echtzeitüberweisung an Omid tavassoli IBAN DE35100101780391592427 BIC REVODEB2XXX	Omid tavassoli	2025-12-02	92a7b3d54754bc12fff4e3bc258a127e674c45a7567c21057c7190702bb0a4ee	f	t	2026-07-13 01:28:36.791218
253	1	3	-14.96	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1046581074910. Uber Payments BV, Ihr Einkauf bei Uber Payments BV 1046581074910 PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	Uber Payments BV	2025-12-02	a5aea631638c317494d51e9bf1064ab3b29aa2ff8613efc4bd9998008fd3b012	f	f	2026-07-13 01:28:36.822996
254	1	3	-2.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//none/NL 28-11-2025T14:27:37 Kartennr. 5356999999992427	Dott scooter ride	2025-12-02	7bb62bfafd8b1788eff118f8943c4b334e3db2b9808731caf5440c8c8745737c	f	t	2026-07-13 01:28:38.87146
255	1	1	-5.72	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 28-11-2025T20:55:19 Kartennr. 5356999999992427	Tegut Filiale 3122	2025-12-02	2ddcef613d1cc29d44d738d313728b9a6d4026eeef09edd752cd8d020f10cdea	f	f	2026-07-13 01:28:38.892004
256	1	2	14.74	Kartenzahlung Verwendungszweck/ Kundenreferenz BURGER KING 15024//DARMSTADT/DE 28-11-2025 T15:35:35 Kartennr. 5356999999992427	BURGER KING 15024	2025-12-02	93a798681cdf61dc007df37b892662bef93cdf05154f581f81328c464cf7c6c9	f	f	2026-07-13 01:28:38.904427
257	1	3	-3.40	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 01-12-2025T17:41:27 Kartennr. 5356999999992427	Dott scooter ride	2025-12-03	65d873088379e8a2a89ad048a5442b33581fe670186cf2d70bbae789540e2bd2	f	t	2026-07-13 01:28:40.267487
258	1	1	3.96	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 01-12-2025T14:51:33 Kartennr. 5356999999992427	ALDI SUED	2025-12-03	5c21d2c44ae26d6e4b606c1be01e19e52ff110abb374c5a3d6e3b19a752f83ef	f	f	2026-07-13 01:28:40.286902
259	1	1	-5.46	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 01-12-2025T18:12:34 Kartennr. 5356999999992427	Tegut Filiale 3122	2025-12-03	2361df0f24e051d42daa437889f9144df880d89bf2b6f524058d4b36c6e018fa	f	f	2026-07-13 01:28:40.311229
260	1	2	11.70	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 01-12-2025T14:23:01 Kartennr. 5356999999992427	Backfactory 626	2025-12-03	74233ed9875632459a441c7f40ed1ac0537fe01e9421a10a560f2f5fb0fce9ea	f	f	2026-07-13 01:28:40.327167
261	1	8	15.80	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 02-12-2025T18:20:59 Folgenr. 00 Verfalld. 1226	HOTALO	2025-12-03	534e36cc7d54081f429288ab01f43f686d7c9c54a3be7ca42a305bdeade68f1d	f	t	2026-07-13 01:28:47.484455
263	1	4	-3.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 02-12-2025T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2025-12-04	ba679180df27061a2e6d8412ed69fb918d1767a23609a960654fe49f12eb22de	f	t	2026-07-13 01:29:05.267339
264	1	4	-46.00	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6099197040, Rg-Nr.: 1423413369/8, Ihr Ratenplan 3502782191500001423413369008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006099197040 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2025-12-05	3266af651d0b678214e178e2f4cd881f32d52331f0c2a13cef48c3e4b77b9e39	f	f	2026-07-13 01:29:05.319817
265	1	3	-4.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 03-12-2025T17:13:59 Kartennr. 5356999999992427	Dott scooter ride	2025-12-05	ec7c27cb767d7b7093753e5c4d624a8912728a84b58e1c491ad3d25a7c6eb9f9	f	t	2026-07-13 01:29:06.387907
266	1	6	-7.74	Kartenzahlung Verwendungszweck/ Kundenreferenz BAUHAUS//Darmstadt/DE 03-12-2025T16:57:44 Kartennr. 5356999999992427	BAUHAUS	2025-12-05	d8a370e8f3718a5dcbef1969d123be8107465ceeb23ac82d4837cf572dd30a7b	f	t	2026-07-13 01:29:08.743853
267	1	7	100.00	SEPA Echtzeitüberweisung an Klaus Lemke IBAN DE14508900000003406300 BIC GENODEF1VBD Verwendungszweck/ Kundenreferenz Miete december	Klaus Lemke	2025-12-08	cd292177d6b7003822310ec419cf2b01ff6d6de9b4e27dbdafca9276a82bcae4	f	f	2026-07-13 01:29:08.763323
268	1	11	-25.00	SEPA Echtzeitüberweisung an Iman jahanpanah IBAN DE70380601864941788012 BIC GENODED1BRS	Iman jahanpanah	2025-12-08	ae54c2e69b6ffec73ccba9a9135fb167f8b914e22f661ccf8b45723723558ae0	f	t	2026-07-13 01:29:11.419527
588	4	40	-11.99	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ Kundenreferenz Purchase at Microsoft RTE-129574581 Gläubiger-ID 	Klarna Bank AB	2025-09-17	9a32f6f050dee5ee7e5a6cbca214abb1bacd9bf409e363ec8c43e0dab8a6dbc3	f	f	2026-07-15 01:55:42.627036
270	1	4	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 07-12-2025T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2025-12-09	dd9be98e5499071bc83249e909cc58d18ff2be01c58afaea63c691d2046b6fcd	f	t	2026-07-13 01:29:24.029303
271	1	6	-6.77	Kartenzahlung Verwendungszweck/ Kundenreferenz Rossmann 3575//Rossdorf/DE 05-12-2025T18:56:17 Kartennr. 5356999999992427	Rossmann 3575	2025-12-09	6fa37891c86f9b73390ef9db2c91e3e27f83ac419d5f7c3f474103d80fae4560	f	t	2026-07-13 01:29:27.189643
272	1	6	-7.05	Kartenzahlung Verwendungszweck/ Kundenreferenz DM-Drogerie Markt//Darmstadt/DE 06-12-2025T15:02:29 Kartennr. 5356999999992427	DM-Drogerie Markt	2025-12-09	7e318a07d126b4f4891527510f4cddbcfc534c476c42d4a2657f2889c7ac3ab2	f	t	2026-07-13 01:29:29.838411
273	1	5	-11.75	Kartenzahlung Verwendungszweck/ Kundenreferenz DM-Drogerie Markt//Darmstadt/DE 05-12-2025T16:08:25 Kartennr. 5356999999992427	DM-Drogerie Markt	2025-12-09	c10cf15ef246f1b198e637519ab84f0aba6288ca5419de3adbe150a05ca7f163	f	t	2026-07-13 01:29:33.190613
274	1	6	15.55	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 06-12-2025T15:16:51 Kartennr. 5356999999992427	TEDI	2025-12-09	5c638e7184dd2b4e863c688af3e1d75cebf7ca3de421e7eb90c981391aed8b51	f	t	2026-07-13 01:29:35.571686
275	1	11	-5.98	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1046790521895 PP.5065.PP. Apple Services, Ihr Einkauf bei Apple Services 1046790521895 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	Apple Services	2025-12-10	78a8a0fcc216e60928c7e0a111881485b4bc0a1c309d3d7b8ce8b6651777b3c3	f	f	2026-07-13 01:29:35.5937
276	1	1	-10.25	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 08-12-2025T18:39:33 Kartennr. 5356999999992427	Tegut Filiale 3122	2025-12-10	c6ac07841c950c2ea0d62877b760a9ed38197b01e26cf49a9962b989a677b7a4	f	f	2026-07-13 01:29:35.610757
277	1	6	-47.99	Kartenzahlung Verwendungszweck/ Kundenreferenz MEDIA MARKT//DARMSTADT/DE 08-12-2025T13:32:45 Kartennr. 5356999999992427	MEDIA MARKT	2025-12-10	2fc96c8699bca69635d1380d7301c0aa0f1ebf2a6be01b52b036ffae05abd925	f	t	2026-07-13 01:29:37.827678
278	1	11	-50.00	SEPA Überweisung an Omid tavassoli IBAN LU043442040006234134 BIC ADVZLULLXXX	Omid tavassoli	2025-12-10	31c3547118f731478adfbdccc8e1e135876054b4f0888bf074f7fada5721f8d0	f	t	2026-07-13 01:29:39.56574
279	1	6	-4.00	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 09-12-2025T18:22:24 Kartennr. 5356999999992427	TEDI	2025-12-11	7f4cad596694e0622b081381a4ed09a71b33d9ae8120898a854cb06c6381441e	f	t	2026-07-13 01:29:41.612894
280	1	12	91.30	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN/GEHALT 11/25 4584626346-0000003 SALA Lohn/Gehalt	Bantschow Services GmbH	2025-12-12	39acfdc352f34d2a94877de3b44fbb887043534e10df583e83677ad7298741fc	f	t	2026-07-13 01:29:53.933764
281	1	7	-225.00	SEPA Echtzeitüberweisung an Dhanush Narayana Reddy IBAN DE75100101785806194951 BIC REVODEB2XXX Verwendungszweck/ Kundenreferenz Miete december	Dhanush Narayana Reddy	2025-12-15	1e74ffb361a1aac295a6dfe6e365a1078ee128365dce9e04010b2f595f45e399	f	f	2026-07-13 01:29:53.954564
282	1	5	144.24	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck/ Kundenreferenz TK-BuchNr 06008244447 Monat 11/25 E859914122 Beitraege 6008244447 Gläubiger-ID DE51TK100000031158 Mand-ID MD120082384 RCUR Wiederholungslastschrift	Techniker Krankenkasse	2025-12-15	03ebc8e53a3c18f17bc8710099838e4b7a224b9271e4051d0245d288424c212e	f	t	2026-07-13 01:29:55.502805
283	1	3	-4.19	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 13-12-2025T07:56:49 Kartennr. 5356999999992427	Dott scooter ride	2025-12-16	dfa6def1a9c2bfef74185eadd152df0033080e310b38f5ed11de67ded1fafe20	f	t	2026-07-13 01:29:56.667797
284	1	4	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 13-12-2025T00:00:00 Kartennr. 5356999999992427	APPLE.COM.BILL	2025-12-16	a75e3e4962724597f7779bf038528892f38b0624058b84aedb129e87eec0df11	f	t	2026-07-13 01:30:02.724804
285	1	6	47.99	SEPA Überweisung von MEDIA MARKT SAGT DANKE. Verwendungszweck/ Kundenreferenz ELV65422634 15.12 14.42 ME0 65422634656670151225144246	MEDIA MARKT	2025-12-17	5378568937c5384d2b0d3de27821271551f2381ae7023b881268c9c3e8529a8d	f	t	2026-07-13 01:30:05.001764
286	1	11	-10.00	SEPA Echtzeitüberweisung an Iman jahanpanah IBAN DE70380601864941788012 BIC GENODED1BRS	Iman jahanpanah	2025-12-18	7b8eaaf112ff0d7ccc590058262e3b83b261ed31a083edc9f20b9b63ba9f7713	f	t	2026-07-13 01:30:06.677136
287	1	4	-11.99	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ Kundenreferenz Purchase at Microsoft RTE-151150881 Gläubiger-ID SE71ZZZ5567370431 Mand-ID FA38CCDE4C9042CA91981A25A9EF3533 RCUR Wiederholungslastschrift	Klarna Bank AB	2025-12-19	8453488ce070dec1ee0637b58b02a9a28757dfe0f4ceed679f895a7b91719c73	f	f	2026-07-13 01:30:06.69817
288	1	4	-45.19	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ Kundenreferenz Kd-Nr.: 6088305020, Rg-Nr.: 1431759231/8, Ihre Tarifrechnung 3502788782450001431759231008RCUR Gläubiger-ID DE9700000000142462 Mand-ID T0010001B000006088305020 RCUR Wiederholungslastschrift	Telefonica Germany GmbH + Co. OHG	2025-12-19	8ec0b19a24a6e924eaa4a2c669760da5b7b8eff5f39ae2a7a1fb42cf99f6b60a	f	f	2026-07-13 01:30:06.711322
289	1	3	-3.03	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 18-12-2025T22:22:54 Kartennr. 5356999999992427	Dott scooter ride	2025-12-22	3f3c634a4cdb4d3dfac6f4b88fff4edb674bf44ddf7c4e9c0cbbc6e009a6fe69	f	t	2026-07-13 01:30:08.849547
290	1	1	8.00	SEPA Überweisung von Iman Jahanpanah Verwendungszweck/ Kundenreferenz Essen	Iman Jahanpanah	2025-12-23	efb9d616060b20a0477de398d0a36eeaca1befe595eaa35e2e2457cfd517eb56	f	t	2026-07-13 01:30:25.060003
291	1	1	-2.34	Kartenzahlung Verwendungszweck/ Kundenreferenz Galeria Markth. Fr//Frankfurt/DE 19-12-2025T17:12:31 Kartennr. 5356999999992427	Galeria Markth.	2025-12-23	10c3849458c7a2f856c3a8294e96aa7d24f19b89f7ed4e0c5cf3990cc8c0cd93	f	t	2026-07-13 01:30:27.998512
292	1	3	-2.74	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//none/NL 20-12-2025T20:43:13 Kartennr. 5356999999992427	Dott scooter ride	2025-12-23	c527c0b470fda50270deca896bd45c65aecc89bef11d6cef15198dfe8e693cec	f	t	2026-07-13 01:30:29.535338
293	1	5	-2.85	Kartenzahlung Verwendungszweck/ Kundenreferenz DM-Drogerie Markt//Darmstadt/DE 20-12-2025T11:42:19 Kartennr. 5356999999992427	DM-Drogerie Markt	2025-12-23	33fde05d7049217db089bb58dec892af4cfbf3b555bf71aadb477979b82813d2	f	t	2026-07-13 01:30:36.254539
294	1	2	4.29	Kartenzahlung Verwendungszweck/ Kundenreferenz BURGER KING 28534//FRANKFURT/DE 19-12-2025 T19:46:12 Kartennr. 5356999999992427	BURGER KING 28534	2025-12-23	5aa725374335268c9a0b113e13cd14de1940953a39518a3664ae84f45b376408	f	f	2026-07-13 01:30:36.277874
295	1	3	-4.48	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 21-12-2025T23:18:15 Kartennr. 5356999999992427	Dott scooter ride	2025-12-23	83ca38fcb8b3f11a410c1ac56e4d87a9a2b6d1e37b56c5b16bb3fee575253374	f	t	2026-07-13 01:30:37.11192
296	1	6	39.98	Kartenzahlung Verwendungszweck/ Kundenreferenz ZALANDO OUTLET//FRANKFURT AM/DE 19-12-2025 T18:09:15 Kartennr. 5356999999992427	ZALANDO OUTLET	2025-12-23	0ab75b940ceafaf2d04d0a93a1090cc2917c1e70c382856f69fefd6c18c3ce5a	f	t	2026-07-13 01:30:38.740808
297	1	6	-52.98	Kartenzahlung Verwendungszweck/ Kundenreferenz H+M DE0667//FRANKFURT/DE 19-12-2025T19:19:03 Kartennr. 5356999999992427	H+M DE0667	2025-12-23	b26891af8744c4654e72aa441ae24a8af4f3a941f25eaae0d74de33805da3d8d	f	t	2026-07-13 01:30:40.602599
298	1	7	800.00	SEPA Überweisung von Klaus-Dieter Lemke und Heidrun Lemke Verwendungszweck/ Kundenreferenz Kaution Lerchenweg 9, Rosdorf Klaus Lemke	Klaus-Dieter Lemke und Heidrun Lemke	2025-12-24	a0595889ce00a0edc5081227f9b02cf722613210caf184192e2b7dff235b2ad3	f	t	2026-07-13 01:30:43.581327
299	1	12	1247.73	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 12/25 4535818629-0000003 SALA Lohn/Gehalt	Bantschow Services GmbH	2025-12-24	1c9a1b0c7ac15b5ce2ae81675901f938f103d6d617c1946878eb7d406a84965d	f	t	2026-07-13 01:30:48.246061
301	1	8	-29.46	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047117970848 PP.5065.PP . www.steampowered.com , Ihr Einkauf bei www.steampowered.com 1047117970848 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	steampowered.com	2025-12-24	8f71837da9c815c5d4439c1ecadf20901b170f5fa70125bd77e38c9902e64af9	f	f	2026-07-13 01:30:50.875987
302	1	8	-5.00	SEPA Echtzeitüberweisung an Deepan Dey IBAN DE45520503531005497057 BIC HELADEF1KAS Verwendungszweck/ Kundenreferenz Bier	Deepan Dey	2025-12-29	88ea0b75b5abdc4f1fddb36c2a7d58d6b401b4b57c1aa0a32917822f4138db25	f	t	2026-07-13 01:30:58.215825
303	1	11	-250.00	SEPA Echtzeitüberweisung an Omid tavassoli IBAN DE35100101780391592427 BIC REVODEB2XXX	Omid tavassoli	2025-12-29	f96e4dfa00bed47d0ed82bd03129330799c05fa88f553544d00b7a4de8d7ddca	f	t	2026-07-13 01:30:59.647495
304	1	11	-19.90	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047128632840 PP.5065.PP. SMP GmbH & Co. KG, Ihr Einkauf bei SMP GmbH & Co. KG 1047128632840 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	SMP GmbH & Co. KG	2025-12-29	8de529301e159c91408bd75f4d7654932019da43ff20e37e1035f2f99c0ef5db	f	f	2026-07-13 01:30:59.668533
305	1	1	-14.16	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 23-12-2025T16:35:12 Kartennr. 5356999999992427	ALDI SUED	2025-12-29	7a27f35be533b3a49ef5507b599755e3a1269390033f1b90401e16fff218623f	f	f	2026-07-13 01:30:59.685194
306	1	8	43.98	Kartenzahlung Verwendungszweck/ Kundenreferenz KINOPOLIS Darmstadt//089964600/DE 22-12-2025 T00:00:00 Kartennr. 5356999999992427	KINOPOLIS Darmstadt	2025-12-29	9ee0891f57ef7161bee5513e773baa56b465092095cf449b2a39aa2941495019	f	t	2026-07-13 01:31:01.380554
307	1	11	-27.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047220329362 PP.5065.PP. PayPal (Europe) S.a r.l. et Cie, SCA, Ihr Einkauf bei PayPal (Europe) S.a r.l. et Cie, SCA 1047220329362 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-12-30	d4fc138bd0c9877e8d80c3deaa673ab1bb0c4279eeba3620dc0bfc99b70ed746	f	f	2026-07-13 01:31:01.403622
308	1	3	-3.32	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//Amsterdam/NL 25-12-2025T07:37:56 Kartennr. 5356999999992427	Dott scooter ride	2025-12-30	da9bcbd502a353381048c73030f095250c179c065a7070654b53aedcaa17d902	f	t	2026-07-13 01:31:03.574805
309	1	2	-5.20	Kartenzahlung Verwendungszweck/ Kundenreferenz YORMAS AG//DARMSTADT/DE 26-12-2025T19:32:16 Kartennr. 5356999999992427	YORMAS AG	2025-12-30	3bb54a03febbaba7b36e3c0a011438beda3f7b7cab83a953b0d42808dda27975	f	f	2026-07-13 01:31:03.59427
310	1	2	12.99	Kartenzahlung Verwendungszweck/ Kundenreferenz King Palast//Darmstadt/DE 24-12-2025T18:28:07 Kartennr. 5356999999992427	King Palast	2025-12-30	14d45b62fbcce34e1b23cd49615f0148a9105653451d0219303e3c0daba45068	f	t	2026-07-13 01:31:06.501173
311	1	8	16.99	Kartenzahlung Verwendungszweck/ Kundenreferenz ENTERTAINMENT GMBH + C//DARMSTADT/DE 26-12-2025T19:40:09 Kartennr. 5356999999992427	ENTERTAINMENT GMBH + C	2025-12-30	50fc822138f9079183430adeabb5abbc26f341ba1e38ea795c22ba4f52aeaec2	f	t	2026-07-13 01:31:08.044043
312	1	12	14.70	Verwendungszweck/ Kundenreferenz Saldo der Abschlussposten	Postbank	2025-12-31	ed73eeb6f19a68f00635c3079690ff6118c8a183736002a57ef359840a7041cf	f	t	2026-07-13 01:31:14.715209
300	1	11	-350.00	SEPA Echtzeitüberweisung an Minh Ngoc Nguyen IBAN DE58520400210266086800 BIC COBADEFFXXX	Minh Ngoc Nguyen	2025-12-24	675d02ff43add2c2ca6baf2b09e34cf9f673faf7db9d7a9a269b364d6e824162	t	t	2026-07-13 01:30:50.853228
262	1	2	-52.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Kuh Bar//Darmstadt/DE 01-12-2025T21:23:40 Kartennr. 5356999999992427	Kuh Bar	2025-12-03	1710711aa28f277ea1363611c375e62fab4f30e0b9d3661a0bb4ca684c4d7e80	t	t	2026-07-13 01:28:52.467711
592	4	46	-4.78	Kartenzahlung Verwendungszweck/ Kundenreferenz Studierendenwerk Darmstadt AoeR//Darmstadt/DE 18-09-2025T11:06:32 Folgenr. 00 Verfalld. 1226	Studierendenwerk Darmstadt AoeR//Darmstadt/DE	2025-09-19	0450bfea1f135c75f7480800e94dccadf9c8e0eb999bab130d7991583c375538	f	f	2026-07-15 01:55:49.494894
585	4	47	-20.00	SEPA Echtzeitüberweisung an user IBAN 	user	2025-09-16	6eeeb5735ea244645d89b16302d1766ca55ad36071904da78b2a8499e8238dea	f	t	2026-07-15 01:55:31.768198
611	4	48	-14.70	Verwendungszweck/ Kundenreferenz Saldo der Abschlussposten	Unknown	2025-09-30	cd5c9d58fb8a38d0196fe55040adbd6b54bf73564bbe3494824ffd8c42640971	f	t	2026-07-15 01:56:04.327815
582	4	37	-45.03	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED	ALDI SUED	2025-09-11	6f926cfa5abfde97218ad1abfaf105b8aa41baea52260a367d0b4dd33e4e288b	t	f	2026-07-15 01:55:17.510277
600	4	38	-4.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 19-09-2025T10:32:25 Kartennr. 	Backfactory 626//Darmstadt/DE	2025-09-23	8b417facea536265d3e1dac3a9a329d3214514a5af062af2705db9600bc3057d	f	f	2026-07-15 01:55:51.915274
601	4	37	-5.28	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 20-09-2025 T18:00:02 Kartennr. 	REWE Darmstadt Luisenc//Darmstadt/DE	2025-09-23	3712327ec943c049bbde2cd500031bdf983bb01a6ce435317de629b39000c410	f	f	2026-07-15 01:55:51.931492
602	4	37	-9.66	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 20-09-2025T18:27:00 Kartennr. 	ALDI SUED//Darmstadt/DE	2025-09-23	cbb52cf2abbf89d81bd353c02103104e0ffd34fc27f308f8b13fa74f947bb956	f	f	2026-07-15 01:55:51.939375
603	4	37	-7.62	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Rossdorf/DE 22-09-2025T11:54:04 Kartennr. 	ALDI SUED	2025-09-24	7302e665ba5aa9297c868818e109846aa596c26885be42af6bb1f4d6a4b6efbf	f	f	2026-07-15 01:55:51.946218
604	4	37	-16.26	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Rossdorf/DE 22-09-2025T11:54:25 Kartennr. 	ALDI SUED	2025-09-24	64efda841ce0c78bcdc2289e7bff36ea0eb69bd080a9ad2f195f0ea64a7889d4	f	f	2026-07-15 01:55:51.955092
605	4	46	-3.87	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 23-09-2025T17:32:42 Kartennr. 	ADSON.STUDIERENDENWER//DARMSTADT/DE	2025-09-25	c0ad09b7e2b65cc1de64a7fd497ce7c738bcf2d273b0786c258b2326249b8579	f	t	2026-07-15 01:55:55.003311
606	4	37	-6.34	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 23-09-2025 T13:56:41 Kartennr. 	REWE Darmstadt Luisenc//Darmstadt/DE	2025-09-25	9f9004c4986bd0a2c70669273c0ead4b7a5e05fba982b5f0e1931becdb20c63e	f	f	2026-07-15 01:55:55.018089
607	4	37	-2.90	Kartenzahlung Verwendungszweck/ Kundenreferenz EDEKA Ercan KG//Rossdorf/DE 24-09-2025T17:30:33 Kartennr. 	EDEKA Ercan KG	2025-09-26	40e2475fcef161fd9493a42077a3e0f83a9cde1a215044e554fc98bf28b1c6b0	f	f	2026-07-15 01:55:55.027483
608	4	47	550.73	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 	Bantschow Services GmbH	2025-09-29	8e16095f00d921b4bbd480fc3c2940ddf2e2dd4e42bf88a9f924affc10256256	f	t	2026-07-15 01:55:57.898492
609	4	47	-13.00	SEPA Echtzeitüberweisung an user	user	2025-09-30	e5d1a24c8efe86eb9f5d6592bd53e80790aa6f0a7f76ba85967a9a57387ab2dd	f	t	2026-07-15 01:55:59.407804
610	4	47	-100.00	SEPA Überweisung an Omid tavassoli 	Omid tavassoli	2025-09-30	af80b67f5f0bc244fe1addb229e36d1a528e0bbeb526e4bf2b9598098c72ead5	f	t	2026-07-15 01:56:01.552391
612	4	43	-200.00	SEPA Echtzeitüberweisung an OMID TAVASSOLI 	OMID TAVASSOLI	2025-10-01	e4f26c1e43f26d8b42c1f6f5385a9b0c570030e4a72800e89d0c504e50cb1fd5	t	t	2026-07-15 01:59:15.692113
613	4	44	-24.95	SEPA Lastschrifteinzug von A.I. Fitness Sued GmbH Verwendungszweck	A.I. Fitness Sued GmbH	2025-10-01	9e30066b164e8a4a4b5d1809e2d23f1e1c95fe81e09d86979f16e87a43b040c3	f	f	2026-07-15 01:59:15.724896
624	4	48	30.00	SEPA Überweisung von user	user	2025-10-09	c999a2fbe14dfdd83b88ab33c04cc80d2835a080726b4510cd44270be0a36c14	f	t	2026-07-15 01:59:35.998094
643	4	\N	-11.00	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 14-10-2025T16:01:48 Folgenr. 00 Verfalld. 1226	HOTALO	2025-10-15	d4d67217b7ce93c9f820124f11c6d0b5f46b46c8c17b050319aa1ebb452b56b9	f	t	2026-07-15 02:02:10.718911
583	4	47	327.56	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 	Bantschow Services GmbH	2025-09-15	41b090a455741ddcea9392daa58e84d4571c17a41effc8bc6952678de6e8a882	f	t	2026-07-15 01:55:26.466517
677	4	48	-7.50	Kartenzahlung Verwendungszweck/ Kundenreferenz HOTALO//Darmstadt/DE 05-11-2025T14:35:42 Folgenr. 00 Verfalld. 1226	HOTALO	2025-11-06	e004f1c437127c9d1153708cd4bc65b7e925a0a4aa6cf0790b2cb0ff0c3c6d88	f	t	2026-07-15 02:12:08.868851
584	4	41	-144.24	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck	Techniker Krankenkasse	2025-09-15	6f3182b594c3a06ffa9f99a1396f1b1c584e530d1cd277a070c288e0834507e8	f	t	2026-07-15 01:55:27.457443
251	1	12	-46.38	Kartenzahlung Verwendungszweck/ Kundenreferenz DEICHMANN Frankfurt-Ze//Frankfurt-Zei/DE 27-11-2025 T13:00:15 Kartennr. 5356999999992427	DEICHMANN Frankfurt-Ze	2025-12-01	7ca631b3f25339e5978557a731d6581d9af2c6877ebc7a6fee001c732f99d3ac	f	t	2026-07-13 01:28:34.140001
151	1	11	-10.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ Kundenreferenz 1047286140241 PP.5065.PP. DisneyPlus, Ihr Einkauf bei DisneyPlus 1047286140241 PP.5065.PP PAYPAL Gläubiger-ID LU96ZZZ0000000000000000058 Mand-ID 5Q222259BDFXC RCUR Wiederholungslastschrift	PayPal (Europe) S.a r.l. et Cie, S.C.A. (for DisneyPlus)	2026-01-02	fdc5459eb9081525b4eb086db6da26eae9fd9a2eecd6b63064f89f60d98a1dc9	f	f	2026-07-01 13:28:13.830992
576	4	47	-4.99	SEPA Lastschrifteinzug von PayPal (Europe) 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-09-09	59e6757187f273ecd9038ce5435d522c3b7242e422471ee3f0c00c3aaa2c6ace	f	f	2026-07-15 01:55:01.334573
586	4	42	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL	APPLE.COM.BILL//CORK/IE	2025-09-16	cd9f3bcb11b0e20e6d04969c63d7da014a60740d0b724fde46e8c299348b259d	f	t	2026-07-15 01:55:39.44578
587	4	47	-100.00	SEPA Überweisung an Omid tavassoli 	Omid tavassoli	2025-09-16	41d5083fbedd8c4e9b7d00fce78ab0be488d89048d2c3f3d01837ceeb7e7d2b0	f	t	2026-07-15 01:55:42.607772
589	4	47	-5.00	SEPA Echtzeitüberweisung an user	user	2025-09-18	21a722749f5089aec4ae1a04ff919e753ab033babebff88429cef3baf82a6eef	f	t	2026-07-15 01:55:44.556964
590	4	47	-17.50	SEPA Echtzeitüberweisung an user	user	2025-09-18	a20ef91226f5461f0e1a3a322b74ab70db3f37cbb43d825ee1f89850060af5a5	f	t	2026-07-15 01:55:46.480463
591	4	46	-1.92	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 17-09-2025T16:55:26 Kartennr. 	ADSON.STUDIERENDENWER//DARMSTADT/DE	2025-09-19	d04ffa879fefc6a37caf2fefcf6e81fe6571192d7443d890b0e1fad138b232a1	f	t	2026-07-15 01:55:49.471381
593	4	37	-6.22	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 17-09-2025T11:06:34 Kartennr. 	Tegut Filiale 3122//Darmstadt/DE	2025-09-19	7a3e8c6796d1992177f6cae767ad3c34f192acb8a1c4b7a50a5a083fb2334d46	f	f	2026-07-15 01:55:49.507554
594	4	46	-8.13	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 17-09-2025T16:17:09 Kartennr. 	ADSON.STUDIERENDENWER//DARMSTADT/DE	2025-09-19	3264fae074bf86e224a4d1d6d9e327c3a7e95470a2d9da9c5ed5788621a118e8	f	t	2026-07-15 01:55:51.828728
595	4	40	-39.76	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck	Telefonica Germany GmbH + Co. OHG	2025-09-22	d83770278dd13bfea66aec6df6d0bd86c30d3729d177cc23965aaf379cc62231	f	f	2026-07-15 01:55:51.845935
596	4	37	-4.23	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 18-09-2025T15:37:59 Kartennr. 	Tegut Filiale 3122//Darmstadt/DE	2025-09-22	5d0bd0daff32194c2cdf0e5e72b0cc90f746557862c52411086c50f8742bafef	f	f	2026-07-15 01:55:51.86057
597	4	37	-1.54	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 20-09-2025T18:33:40 Kartennr. 	Tegut Filiale 3122//Darmstadt/DE	2025-09-23	c2f05ecdb547d5b0f6f3d0b4785cab6fad3270ac34d840ff6c95a666cee56749	f	f	2026-07-15 01:55:51.877677
598	4	41	-2.49	Kartenzahlung Verwendungszweck/ Kundenreferenz REHBERG-APOTHEKE J. MU//RO DORF/DE 19-09-2025T09:17:36 Kartennr. 	REHBERG-APOTHEKE J. MU//RO DORF/DE	2025-09-23	20a67065687dce550043caa56ff009043435aa2f74ae726f953b80b1e055b75d	f	f	2026-07-15 01:55:51.892361
599	4	37	-3.53	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED	ALDI SUED	2025-09-23	48dc3ff0ebba7f698febad92057f670db992748281e1f364114ccc5e6243e777	f	f	2026-07-15 01:55:51.903432
614	4	37	-2.19	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 29-09-2025T11:07:17 Kartennr. 	Tegut Filiale 3122	2025-10-01	8a4faf923ceb8f31ac33623bbb79a0378e7787c6902e16e8aaae251cf171c14e	f	f	2026-07-15 01:59:15.744593
615	4	37	-2.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Bormuth GmbH//Darmstadt/DE 29-09-2025T12:27:32 Kartennr. 	Bormuth GmbH	2025-10-01	02aeb7760c6ac7f6e09e2b9df9d757aa568fcf94139db20998b78a6d445f1e7f	f	t	2026-07-15 01:59:18.769014
616	4	48	-2.69	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Darmstadt/DE 29-09-2025T13:22:46 Kartennr. 	ALDI SUED	2025-10-01	2071acf36a143b5972b260f3719735b3cfa9d5d984226f77c9c8c395297d7dd5	f	f	2026-07-15 01:59:18.794578
617	4	38	-2.00	Kartenzahlung Verwendungszweck/ Kundenreferenz YORMAS AG//DARMSTADT/DE 30-09-2025T13:37:45 Kartennr. 	YORMAS AG	2025-10-02	acace1539b1e27f9673efa7fa3925a10802eb449f9362fd4792bbb0451aa7cde	f	f	2026-07-15 01:59:18.820078
618	4	38	-2.50	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 30-09-2025T11:58:25 Kartennr. 	Backfactory 626	2025-10-02	d1353889857b76ae9557ce5f18e45adea2ff976a25ba7b01f1b21158aed5bf35	f	f	2026-07-15 01:59:18.865392
619	4	40	-3.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 30-09-2025T10:00:18 Kartennr. 	APPLE.COM.BILL	2025-10-02	e11618e0b81eca1a823d18fe5fdc80937bcb363e89d4166f932d7b899c71bea7	f	t	2026-07-15 01:59:29.914337
620	4	44	-10.30	Kartenzahlung Verwendungszweck/ Kundenreferenz Staatliche Lotterie Ei//Darmstadt/DE 30-09-2025T00:00:00 Kartennr. 	Staatliche Lotterie Ei	2025-10-02	db43531b04297aa4a268a5abac8f0c199f90fbd0e07961d031da868137d06375	f	f	2026-07-15 01:59:29.941389
621	4	45	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-07	96b0162d0d75198b840920412ad7537c00d8be1390346022a6bfd2172a635663	f	f	2026-07-15 01:59:29.952893
622	4	40	-46.00	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck	Telefonica Germany GmbH + Co. OHG	2025-10-08	2b1df0fb3165bcd47b667c6f8d8c344c52f5d8b564444019b104c11606378160	f	f	2026-07-15 01:59:29.969344
623	4	41	-3.90	Kartenzahlung Verwendungszweck/ Kundenreferenz Alpha Apotheke//Darmstadt/DE 06-10-2025T16:46:41 Kartennr. 	Alpha Apotheke	2025-10-08	c60b1b2e3e9f8db9825981dbb982e14efad7723abc9d1a31caf69874cfc04e59	f	f	2026-07-15 01:59:29.978163
625	4	48	300.00	SEPA Echtzeitüberweisung von user	user	2025-10-09	32065564d1773a96fd8ee2e7c70e5352aa04b6c7a51a1eddf59a24aac5d34bbc	f	t	2026-07-15 01:59:38.699126
626	4	43	-600.00	SEPA Echtzeitüberweisung an user	user	2025-10-09	1b7a17a0a14e059523bd8d230deab52a4cb144fbb8e8e75658765088ee4796b0	f	f	2026-07-15 01:59:38.721486
627	4	40	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//ITUNES.COM/IE 07-10-2025 T00:00:00 Kartennr. 	APPLE.COM.BILL	2025-10-09	53b103d2df14f6140d6ec45e74be54ccf7ef5fa0ae450af6f80160da78a6e3b8	f	t	2026-07-15 01:59:44.377994
628	4	44	-2.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-10	038968a1817afe989b6415bd99c3f2ff805daa5e5c98fe17a7f4d45f69817a88	f	f	2026-07-15 01:59:44.395569
629	4	44	-5.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-10	34c5f9d936bf195a55e1ab36c0bf33a0161f40ff698339b5b6740e8d99143c3c	f	f	2026-07-15 01:59:44.414045
630	4	38	-15.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Central Park Corner//Frankfurt am/DE 08-10-2025 T17:50:02 Kartennr. 	Central Park Corner	2025-10-10	0142ff10c1c21f4c838fdeafd8dca2d9b87dd2647fe0a0d47d84511502e3f376	f	t	2026-07-15 01:59:47.399437
631	4	37	-15.16	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Ahmet Akay oHG//Frankfurt am/DE 08-10-2025 T19:59:55 Kartennr. 	REWE Ahmet Akay oHG	2025-10-10	43b856fc9357e661569b3f57b50341e9a7e86fad8c955b9d86af4dfaeb46b555	f	f	2026-07-15 01:59:47.417122
632	4	42	-30.10	Kartenzahlung Verwendungszweck/ Kundenreferenz ZARA 3550 FRA BORSENST//FRANKFURT/DE 08-10-2025T15:54:20 Kartennr. 	ZARA 3550	2025-10-10	4b5b16198848a1d6861d31796a518d003a58c15398affbf56b0fe82b0f365b45	t	f	2026-07-15 01:59:47.438316
633	4	42	-8.90	Kartenzahlung Verwendungszweck/ Kundenreferenz MUJI//Frankfurt/DE 09-10-2025T16:55:48 Kartennr. 	MUJI	2025-10-13	e2810c2326ab321d991b194445082a06ccc0ecf9bc6263ac3cbad862ec9e2eeb	f	f	2026-07-15 01:59:47.45491
634	4	42	-9.42	Kartenzahlung Verwendungszweck/ Kundenreferenz Rossmann 2727//Frankfurt/DE 09-10-2025T18:34:22 Kartennr. 	Rossmann 2727	2025-10-13	020cea80f5150754ae69442f59b63b92708f2ac9e9f1370013dd57f397d852a0	f	t	2026-07-15 01:59:53.39053
635	4	38	-41.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Restaurant Hani//Frankfurt am/DE 09-10-2025T16:12:29 Kartennr. 	Restaurant Hani	2025-10-13	e763382de24b0debdca618b7e259e02f379f3cec4034fdbbfc1b9224d69534e7	f	t	2026-07-15 01:59:54.814683
636	4	45	-5.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-14	ce0b8b87269c2db30312371b783d8b4499efa17e19edfc47b51a42400401fba6	f	f	2026-07-15 01:59:54.837929
637	4	48	-7.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Bantschow Services Gmb//Gross-Umstadt/DE 10-10-2025T15:50:53 Kartennr. 	Bantschow Services Gmb	2025-10-14	2e4e773126d9442c19ff36295ab0c38ae162d1fd1b7eb78ef1932efa96f95bdd	f	t	2026-07-15 01:59:57.65671
638	4	41	-8.79	Kartenzahlung Verwendungszweck/ Kundenreferenz Einhorn-Apotheke DA//Darmstadt/DE 12-10-2025 T18:58:01 Kartennr. 	Einhorn-Apotheke DA	2025-10-14	b4092e212eba791299c836bb7ce046f6fff1ef5d782333fceacae863c2fe9b6c	f	f	2026-07-15 01:59:57.690021
639	4	38	-9.30	Kartenzahlung Verwendungszweck/ Kundenreferenz Palmen Grill//Darmstadt/DE 11-10-2025T17:51:10 Kartennr. 	Palmen Grill	2025-10-14	71d7459427ed886548c30df535437ced60f82aad21f83b05653fc42363c09213	f	t	2026-07-15 01:59:58.986782
640	4	47	-100.00	SEPA Überweisung an Omid tavassoli 	Omid tavassoli	2025-10-14	047916f49def165846752f24febc8072c85c0ac7982059201f338989246e2423	f	t	2026-07-15 02:00:00.685685
641	4	41	-144.24	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck/ 	Techniker Krankenkasse	2025-10-15	45975417adedd95d45b293f01adc1c3664569837ba01a9f16c9f4037f044438c	f	t	2026-07-15 02:00:01.87648
642	4	\N	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//ITUNES.COM/IE 13-10-2025 T00:00:00 Kartennr. 	APPLE.COM.BILL	2025-10-15	9bd0ca0d76ec758c4e76a619d3d4945e4e2952d715009e029d3a9dd39904a636	f	t	2026-07-15 02:01:58.81551
644	4	41	-5.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Alpha Apotheke//Darmstadt/DE 14-10-2025T15:49:58 Kartennr. 	Alpha Apotheke	2025-10-16	b64fba142c3cc9ffca8a48d2ba6a7a55d6f7e3fbc520511c4052828d0fc8535a	f	f	2026-07-15 02:02:10.745373
645	4	44	-5.00	Kartenzahlung Verwendungszweck/ Kundenreferenz jumpers fitness GmbH//Rosenheim/DE 15-10-2025 T13:35:45 Kartennr. 	jumpers fitness GmbH	2025-10-17	c615828b773afcc3272c04298fa7cb1e89cba120255de3216bca5544faeea48c	f	f	2026-07-15 02:02:10.754737
646	4	\N	-13.40	SEPA Echtzeitüberweisung an user	user	2025-10-20	b8d8a2673fff0433397552963607fb12403f5886bd4c5d20922350624a1b27b0	f	t	2026-07-15 02:02:20.038659
647	4	46	-2.10	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 17-10-2025T11:36:21 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-21	cc265f2b49f37491012a1a30151b3962b98dcb52f7b0385056a8b3555463600e	f	t	2026-07-15 02:02:35.642446
648	4	\N	-7.62	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 17-10-2025T12:57:08 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-21	d7d40c86f4cc28b744afb290bb5e0fe56d652af7c7ada761da1976ac19953ae5	f	t	2026-07-15 02:02:48.722334
649	4	40	-41.64	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ 	Telefonica Germany GmbH + Co. OHG	2025-10-22	9f9790ede481a0a7557bbf3dd0d7f16d5db79bd4fe1288afd0ade7ed56c19a65	f	f	2026-07-15 02:02:48.768061
650	4	45	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-23	cd610ae3c40d8f8c7a2ff7672fa86380ce0be77f29bbcf6956a6c2f96837a75c	f	f	2026-07-15 02:02:48.783997
651	4	40	-13.14	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ Kundenreferenz Purchase at Microsoft RTE-137629795 Gläubiger-ID 	Klarna Bank AB	2025-10-23	9189f230676cc17afe72bd04683f0d8447d66a4ee0d3b64bafb8a758a1953a4c	f	f	2026-07-15 02:02:48.80241
652	4	47	-40.98	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-24	a016de4b8f7d05f80c6a4236aa7c8a3b9cdb0f630246d24b4b851c9163597d3c	f	f	2026-07-15 02:02:48.81847
653	4	38	-11.90	Kartenzahlung Verwendungszweck/ Kundenreferenz SumUp.Mr. Masala//Munster Hess/DE 23-10-2025 T14:04:56 Kartennr. 	SumUp.Mr. Masala	2025-10-27	7f3c5daaa9dc0b4df4c8a40729772fafb176a9d88e2d632d7fac1b51eadb2256	f	t	2026-07-15 02:02:51.502579
654	4	37	-2.04	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 25-10-2025 T15:54:11 Kartennr. 	REWE Darmstadt Luisenc	2025-10-28	c352f7ba7340bccdca9ba801142baccac9ebba3b78b65121057eda24e2861783	f	f	2026-07-15 02:02:51.521666
655	4	46	-2.10	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 24-10-2025T11:08:11 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-28	3cc27cffa8bf5fcd715155061eec163b819e0bfed885780f18748fb951d956bd	f	t	2026-07-15 02:02:54.77686
656	4	46	-3.02	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 24-10-2025T11:21:15 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-28	52e0306870405aed31af2a02a7a148e134fa45106a72a89ab6fca05af417212c	f	t	2026-07-15 02:02:57.691465
657	4	47	550.73	SEPA Echtzeitüberweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 	Bantschow Services GmbH	2025-10-29	2a721a50f06588d988b3dafcf14dd77e3966de014bee8a457fd0124758089043	f	t	2026-07-15 02:03:09.632847
658	4	47	-13.00	SEPA Echtzeitüberweisung an user	user	2025-10-29	762b75321c0a240bc994156906a309a36165faa88fe9e0b1fc938cf3b704f640	f	t	2026-07-15 02:03:11.021075
659	4	47	-240.00	SEPA Echtzeitüberweisung an OMID TAVASSOLI 	OMID TAVASSOLI	2025-10-29	1d32878c0a03a53909e00319f8921ccdcbdd06e934afc56f855ad45b8d4be185	t	t	2026-07-15 02:03:17.102731
660	4	46	-2.10	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 27-10-2025T13:53:21 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-29	602fa6eb611aa16cf30c26bd2a912c825651f3b548d67e4965acc12e870a3608	f	t	2026-07-15 02:03:27.144345
661	4	47	-50.00	SEPA Echtzeitüberweisung an user	user	2025-10-30	95f0b0d21e61146954ec984906a4ad822841be9d08a347368a05c1ce34aef3c2	f	t	2026-07-15 02:03:30.022455
662	4	46	-2.80	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 28-10-2025T12:54:47 Kartennr. 	ADSON.STUDIERENDENWER	2025-10-30	d31bd7d089c5bf59b802e45f33a3db40bd7f27ef7e81c0478e8ce74dba9a232c	f	t	2026-07-15 02:03:33.35548
663	4	37	-8.65	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 28-10-2025 T18:42:54 Kartennr. 	REWE Darmstadt Luisenc	2025-10-30	6eb24973ef869109d2df6ea31fd27f6b6395aef72ffefcbff6957a65aa7d4213	f	f	2026-07-15 02:03:33.373944
664	4	46	-10.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Hochschulbezogene Einr//Darmstadt/DE 28-10-2025 T13:10:51 Kartennr. 	Hochschulbezogene Einr	2025-10-30	054ae3d2500755915747f9faca05ee69846dcc74aec7ca08c6abef5a5f09a5f9	f	t	2026-07-15 02:03:35.100674
665	4	45	-20.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	PayPal (Europe) S.a r.l. et Cie, S.C.A.	2025-10-31	ff9320cfd45770bbf602b7fe8bce23c1e87c25630d81e4ce5fe96059d9c05abe	f	f	2026-07-15 02:03:35.121719
666	4	38	-42.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Xin Chao//Darmstadt/DE 29-10-2025T15:58:16 Kartennr. 	Xin Chao	2025-10-31	2248bb2fc0e08dc0d6b8fc7b6491121990fa2dc2b892301bae7da03a2b1b0e36	f	t	2026-07-15 02:03:39.275772
667	4	48	99.76	SEPA Echtzeitüberweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT	Bantschow Services GmbH	2025-11-03	11d814c455c1a7133e0b0a8bdb0d008e21e2e86d8cb001c2bee97ba66dfd9408	f	t	2026-07-15 02:11:48.158092
668	4	47	-30.00	SEPA Echtzeitüberweisung an user	user	2025-11-03	f67a2b8826670e3b4d6c05c69ef77074ce79a33a40c5991221a06a643dfc78d9	f	t	2026-07-15 02:11:50.317367
669	4	44	-24.95	SEPA Lastschrifteinzug von A.I. Fitness Sued GmbH Verwendungszweck/ 	A.I. Fitness Sued GmbH	2025-11-03	204fce854b8c49f3e9c387218f258933efbe2145dcc8dac9497dece51693c8be	f	f	2026-07-15 02:11:50.35292
670	4	40	-3.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 30-10-2025T00:00:00 Kartennr. 	APPLE.COM.BILL	2025-11-03	d69a13dadd8dcc180df5b629c19d75ab72d3b46b1e3c226b8bea01263dd19512	f	t	2026-07-15 02:12:00.475665
671	4	37	-3.43	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 01-11-2025T18:10:54 Kartennr. 	Tegut Filiale 3122	2025-11-04	2fafdf4e9c198f19ae33aadf346288176e985da4e508b2e9715418c184b4f744	f	f	2026-07-15 02:12:00.498458
672	4	43	-600.00	SEPA Echtzeitüberweisung an user	user	2025-11-05	bb27d7e29fad5364d2675182912f671b4b6e38f04e7a973180af2eef5a1a6410	f	f	2026-07-15 02:12:00.512063
673	4	41	-9.90	SEPA Lastschrifteinzug von Muenchener VEREIN Krankenversicherung a. Verwendungszweck/ 	Muenchener VEREIN Krankenversicherung a.	2025-11-05	72b8bb5de579eea38334c5302c0d9e893e9e965f7215089e3d28ca6bad6b105f	f	t	2026-07-15 02:12:02.762941
674	4	37	-6.46	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 03-11-2025T19:26:14 Kartennr. 	Tegut Filiale 3122	2025-11-05	d5f9c9b685c27aafec83940cd05043e87c548b77654e7ec51825dc3376d62591	f	f	2026-07-15 02:12:02.782956
675	4	47	-100.00	SEPA Überweisung an Omid tavassoli 	Omid tavassoli	2025-11-05	633c9b8c00b0cfe07f110478fae820ad7ad7945ba97f68e13afe5a73d3a60781	f	t	2026-07-15 02:12:06.08556
676	4	47	-29.95	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	SCHUFA Holding AG	2025-11-06	7a9429467cacf7b8822d5f0d6696681274bb16a175710d8d05905a54b2e80543	f	f	2026-07-15 02:12:06.104559
678	4	37	-11.73	Kartenzahlung Verwendungszweck/ Kundenreferenz Tegut Filiale 3122//Darmstadt/DE 04-11-2025T14:08:07 Kartennr. 	Tegut Filiale 3122	2025-11-06	2e5a7271b22b74b02e2db615b143c352236030110761e633db8f9005bd3082a3	f	f	2026-07-15 02:12:08.888151
679	4	47	300.00	SEPA Überweisung von user	user	2025-11-07	dc3182037b91b333285b478ef3877fa6320195511de3f82df2563a972eef78ac	f	t	2026-07-15 02:12:11.809838
680	4	40	-46.00	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ 	Telefonica Germany GmbH + Co. OHG	2025-11-07	02a5fc8e6bc0bc98dddc597cfae6c2fba9afea86a1d5556814b5651d4a1c26b1	f	f	2026-07-15 02:12:11.827682
681	4	42	-7.55	Kartenzahlung Verwendungszweck/ Kundenreferenz TEDI//Darmstadt/DE 05-11-2025T16:15:48 Kartennr. 	TEDI	2025-11-07	b71c821c6e7dc753d8932bd60bd6f25ee503b452b2b58e28aed690ace1948dd7	f	t	2026-07-15 02:12:13.868487
682	4	44	50.00	SEPA Überweisung von user	user	2025-11-10	13adab507ff04b5afa30b0ecdd5ed23b8545f7bde9db3bae0a4fee7c6185b05d	f	t	2026-07-15 02:12:19.37297
683	4	47	-2.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	Apple Services	2025-11-11	28dce76cd88d1c656149d53132e91a02cd637b33001197ba9b573e6a0c01521f	f	f	2026-07-15 02:12:19.391031
684	4	47	-5.99	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	Apple Services	2025-11-11	3b709e0655cad62e6ec55304757f8fbd459570299009abba0d9d74449cc3487b	f	f	2026-07-15 02:12:19.403167
685	4	40	-2.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 07-11-2025T00:00:00 Kartennr. 	APPLE.COM.BILL	2025-11-11	75d79e3001a7113015214d82f15c41aa28fe2ef80e70e1a6e830040113cd511b	f	t	2026-07-15 02:12:22.159655
686	4	38	-3.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 08-11-2025T07:34:34 Kartennr. 	Backfactory 626	2025-11-11	a7a00928adeb40361ec5111a5104866156331684ec570c8a0b484169bb2fa38e	f	f	2026-07-15 02:12:22.177465
687	4	37	-4.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Eisautomat Karlshof//Darmstadt/DE 07-11-2025 T21:06:11 Kartennr. 	Eisautomat	2025-11-11	7ed26dd9becbcce8d4288fed92dc2df12728f61f42b3d4328932cd0959a7bf75	f	t	2026-07-15 02:12:28.547136
688	4	46	-6.12	Kartenzahlung Verwendungszweck/ Kundenreferenz ADSON.STUDIERENDENWER//DARMSTADT/DE 07-11-2025T14:24:19 Kartennr. 	ADSON.STUDIERENDENWER	2025-11-11	f2bd06305e0d46e6489f50d06c52a92cd950c6c644bd778b86af361cbc1e5f33	f	t	2026-07-15 02:12:33.180224
689	4	38	-8.77	Kartenzahlung Verwendungszweck/ Kundenreferenz KFC 338//DARMSTADT/DE 11-11-2025T16:22:51 Kartennr. 	KFC 338	2025-11-13	8c33b17e0b67af1ccf6139e1f8e631aa0c6e3864a3edaa335e11b08989126fe6	f	t	2026-07-15 02:12:34.474029
690	4	41	-144.24	SEPA Lastschrifteinzug von Techniker Krankenkasse Verwendungszweck/ 	Techniker Krankenkasse	2025-11-17	5d62e94f69b005457b5c8352cef6e5f114019ceafcf0b172679ced40597ad2a6	f	t	2026-07-15 02:12:36.092939
691	4	40	-7.99	Kartenzahlung Verwendungszweck/ Kundenreferenz APPLE.COM.BILL//CORK/IE 13-11-2025T00:00:00 Kartennr. 	APPLE.COM.BILL	2025-11-17	ae22afa29e2fa41b20acf5adef415277964f0dd2c1ddb5b4d1139baa2fe97df6	f	t	2026-07-15 02:12:41.823728
692	4	40	-11.99	SEPA Lastschrifteinzug von Klarna Bank AB Verwendungszweck/ 	Klarna Bank AB	2025-11-18	087089badafa8529b7d3664167a54a12103ab4a7c1f29a06fb6b323c00cfed4d	f	f	2026-07-15 02:12:41.837792
693	4	44	-23.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Kuh Bar//Darmstadt/DE 17-11-2025T15:12:17 Kartennr. 	Kuh Bar	2025-11-19	4575c1f20a810a8c5e5bec3b144ef0794b877c958369116182e0164fd6f2ea49	f	t	2026-07-15 02:12:45.294531
694	4	42	-8.73	Kartenzahlung Verwendungszweck/ Kundenreferenz Rossmann 3575//Rossdorf/DE 18-11-2025T15:31:29 Kartennr. 	Rossmann 3575	2025-11-20	9e0ecf9444416ad9959e4041448675392f6f4d64376aeb9b567f3555832d5c35	f	t	2026-07-15 02:12:47.967467
695	4	37	-35.27	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED	ALDI SUED	2025-11-20	27acc89d3eaaeb6768f0fbc6fd2aadc9305cb658c38dd174c7980621f58b8596	f	f	2026-07-15 02:12:47.980421
696	4	47	104.98	SEPA Überweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN / GEHALT 	Bantschow Services GmbH	2025-11-21	de768d9e87946cd748c4692ca9c8c0ea12c735eba897bf4713b3ab6bc187f9e1	f	t	2026-07-15 02:12:57.543136
697	4	40	-44.97	SEPA Lastschrifteinzug von Telefonica Germany GmbH + Co. OHG Verwendungszweck/ 	Telefonica Germany GmbH + Co. OHG	2025-11-21	4a2ad3a727b9c94a5f165e8f011bc5a459f31d3d170989e42fcee7a09cadc167	f	f	2026-07-15 02:12:57.590692
698	4	38	-5.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Backfactory 626//Darmstadt/DE 19-11-2025T16:27:07 Kartennr. 	Backfactory 626	2025-11-21	53b43bc34b3a44894303bbfaa9050da1535bc9ff7ae921587690487f903cbef1	f	f	2026-07-15 02:12:57.610114
699	4	47	20.00	SEPA Überweisung von user	user	2025-11-24	ed70c9d5831eacbd5dab5cc8644a8fb5099dc0c2195c6b8c263b6d2e20693930	f	t	2026-07-15 02:13:00.431437
700	4	47	-7.00	SEPA Echtzeitüberweisung an user	user	2025-11-25	d824da86a09126d3a20a9e687a264264b5355f6d602e53d3c90b37d387ffac26	f	t	2026-07-15 02:13:01.684042
701	4	45	-10.00	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	SOS-Kinderdorfer weltweit	2025-11-25	547430ac76b2e6f0049ae1ac51ebcf883b4babb5f52c94abeafff2fbe9892666	f	f	2026-07-15 02:13:01.703778
702	4	39	-18.96	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	Uber Payments BV	2025-11-25	73c8f625ab90b35b572e121e7bc6785932631939d34cc41063395aeb919454c9	f	f	2026-07-15 02:13:01.715838
703	4	47	-19.90	SEPA Lastschrifteinzug von PayPal (Europe) S.a r.l. et Cie, S.C.A. Verwendungszweck/ 	SMP GmbH & Co. KG	2025-11-25	f09cb4c4156ce3cbb9009792ff21d0ba8c037e73902d680177b0c2860d5a27f0	f	f	2026-07-15 02:13:01.72683
704	4	39	-2.00	Kartenzahlung Verwendungszweck/ Kundenreferenz Dott scooter ride//none/NL 24-11-2025T00:20:14 Kartennr. 	Dott scooter ride	2025-11-25	db8ba88cee5ae04232fbd7517ab1fef13467b3b526482501509a0f73993a33c8	f	t	2026-07-15 02:13:03.938817
705	4	41	-4.99	Kartenzahlung Verwendungszweck/ Kundenreferenz REHBERG-APOTHEKE J. MU//RO DORF/DE 24-11-2025T13:35:46 Kartennr. 	REHBERG-APOTHEKE J. MU	2025-11-26	25b46300fc73541450e0a288f400364dd57edc9da2d7368792f3f20ae8034168	f	f	2026-07-15 02:13:03.953973
706	4	37	-21.23	Kartenzahlung Verwendungszweck/ Kundenreferenz ALDI SUED//Rossdorf/DE 24-11-2025T14:06:20 Kartennr. 	ALDI SUED	2025-11-26	7d7c2f1d272506a920ba22fef783417e7d8e26a598cffc71613b0a48b05efccd	f	f	2026-07-15 02:13:03.967303
707	4	38	5.00	SEPA Echtzeitüberweisung von user	user	2025-11-28	92dae92f21746a53d3b9ca2c5b9ef076700a41b432ef654c427575ec57003ae9	f	t	2026-07-15 02:13:11.351912
708	4	47	550.73	SEPA Echtzeitüberweisung von Bantschow Services GmbH Verwendungszweck/ Kundenreferenz LOHN/GEHALT	Bantschow Services GmbH	2025-11-28	3d0da0ef5fe23c77e02fc4d58d713ed8f644c25caf2d4fe763214b4f28130c33	f	t	2026-07-15 02:13:15.508319
709	4	42	-5.65	Kartenzahlung Verwendungszweck/ Kundenreferenz DM-Drogerie Markt//Darmstadt/DE 26-11-2025T10:41:02 Kartennr. 	DM-Drogerie Markt	2025-11-28	118aea1034f4772dd4336a65b076c884370a39f2fe00471f11ad36e2c1b98752	f	t	2026-07-15 02:13:18.62377
710	4	37	-7.47	Kartenzahlung Verwendungszweck/ Kundenreferenz REWE Darmstadt Luisenc//Darmstadt/DE 26-11-2025 T10:51:19 Kartennr. 	REWE Darmstadt Luisenc	2025-11-28	8028a303f8502dede9f917a37c1d7361a881f462b34053d6831224bbaa1b152e	f	f	2026-07-15 02:13:18.670424
\.


--
-- Data for Name: user_category_rules; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.user_category_rules (id, user_id, category_id, keyword, created_at) FROM stdin;
1	1	2	kartenzahlung\nverwendungszweck/ kundenreferenz\nhotalo//darmstadt/de 06-01-2026t14:11:36 folgenr.\n00 verfalld. 1226	2026-07-01 15:27:14.508219
2	1	2	kartenzahlung\nverwendungszweck/ kundenreferenz\nhotalo//darmstadt/de 22-01-2026t13:45:23 folgenr.\n00 verfalld. 1226	2026-07-01 15:31:19.422635
3	1	2	kartenzahlung verwendungszweck/ kundenreferenz hotalo//darmstadt/de 14-01-2026t13:47:39 folgenr. 00 verfalld. 1226	2026-07-01 15:31:23.942926
4	1	2	kartenzahlung\nverwendungszweck/ kundenreferenz\nhotalo//darmstadt/de 14-01-2026t13:47:39 folgenr.\n00 verfalld. 1226	2026-07-01 15:31:27.837381
5	1	7	sepa echtzeitüberweisung an\ndhanush narayana reddy\niban de75100101785806194951\nbic revodeb2xxx	2026-07-01 15:32:19.375199
6	1	7	sepa echtzeitüberweisung an dhanush narayana reddy iban de75100101785806194951 bic revodeb2xxx	2026-07-01 15:32:23.232479
7	1	11	sepa überweisung von bantschow services gmbh verwendungszweck/ kundenreferenz lohn/gehalt 12/25 7600801209-0000003 sala lohn/gehalt	2026-07-01 16:26:26.752655
8	4	47	sepa überweisung von bantschow services gmbh verwendungszweck/ kundenreferenz lohn / gehalt 09/25 7626900668-0000013lg0000 sala lohn/gehalt	2026-07-15 02:17:25.583499
9	4	47	sepa echtzeitüberweisung von bantschow services gmbh verwendungszweck/ kundenreferenz lohn/gehalt 11/25	2026-07-15 02:17:51.776589
10	4	47	sepa echtzeitüberweisung von bantschow services gmbh verwendungszweck/ kundenreferenz lohn / gehalt 10/25	2026-07-15 12:15:25.767768
11	4	42	kartenzahlung verwendungszweck/ kundenreferenz zara 3550 fra borsenst//frankfurt/de 08-10-2025t15:54:20 kartennr. 5356999999992427	2026-07-15 12:17:17.508378
12	4	43	sepa echtzeitüberweisung an omid tavassoli iban lt633250031866465028 bic revolt21xxx verwendungszweck/ kundenreferenz notprovided	2026-07-15 12:20:26.524779
13	4	48	kartenzahlung verwendungszweck/ kundenreferenz aldi sued//darmstadt/de 29-09-2025t13:22:46 kartennr. 5356999999992427	2026-07-15 12:30:10.268071
14	4	48	sepa echtzeitüberweisung von minh ngoc nguyen verwendungszweck/ kundenreferenz mob.282.ee.pos00068008	2026-07-15 12:30:30.738669
15	4	48	sepa überweisung von minh ngoc nguyen verwendungszweck/ kundenreferenz mob.281.ue.pos00241010	2026-07-15 12:30:33.503253
16	1	12	kartenzahlung verwendungszweck/ kundenreferenz deichmann frankfurt-ze//frankfurt-zei/de 27-11-2025 t13:00:15 kartennr. 5356999999992427	2026-07-15 12:34:41.820239
17	1	12	sepa echtzeitüberweisung an iman jahanpanah iban de70380601864941788012 bic genoded1brs	2026-07-16 13:17:43.911868
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: fintrack
--

COPY public.users (id, email, password, created_at, updated_at) FROM stdin;
1	omidddd105@gmail.com	$2a$10$mg8GxBT2vRIbD5b6wkSXcebbEw.WtUY7pSV2mICT0m6GBWCql6I7q	2026-06-27 02:06:54.662239	2026-06-27 02:06:54.662409
2	verify@test.com	$2a$10$TlJf7lutuyQAFbWEjoZUQ.N9ldgwy66K2zGU2Ix1qWahWBBlCwCyK	2026-07-02 00:01:22.189789	2026-07-02 00:01:22.192259
4	demo@fintrack.com	$2a$10$P.FB45Itiw2QI6fh9941ju7zJf12K9q2uGz0RldDMqMLSAUiWlInO	2026-07-14 22:00:53.452335	2026-07-14 22:00:53.453303
\.


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.budgets_id_seq', 5, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.categories_id_seq', 48, true);


--
-- Name: global_category_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.global_category_rules_id_seq', 133, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.transactions_id_seq', 710, true);


--
-- Name: user_category_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.user_category_rules_id_seq', 17, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fintrack
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: budgets budgets_user_id_category_id_month_year_key; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_category_id_month_year_key UNIQUE (user_id, category_id, month, year);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: global_category_rules global_category_rules_keyword_key; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.global_category_rules
    ADD CONSTRAINT global_category_rules_keyword_key UNIQUE (keyword);


--
-- Name: global_category_rules global_category_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.global_category_rules
    ADD CONSTRAINT global_category_rules_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_hash_key; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_hash_key UNIQUE (hash);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: user_category_rules user_category_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.user_category_rules
    ADD CONSTRAINT user_category_rules_pkey PRIMARY KEY (id);


--
-- Name: user_category_rules user_category_rules_user_id_keyword_key; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.user_category_rules
    ADD CONSTRAINT user_category_rules_user_id_keyword_key UNIQUE (user_id, keyword);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: fintrack
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_transactions_category; Type: INDEX; Schema: public; Owner: fintrack
--

CREATE INDEX idx_transactions_category ON public.transactions USING btree (category_id);


--
-- Name: idx_transactions_date; Type: INDEX; Schema: public; Owner: fintrack
--

CREATE INDEX idx_transactions_date ON public.transactions USING btree (transaction_date);


--
-- Name: idx_transactions_user_id; Type: INDEX; Schema: public; Owner: fintrack
--

CREATE INDEX idx_transactions_user_id ON public.transactions USING btree (user_id);


--
-- Name: budgets budgets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: budgets budgets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: categories categories_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_category_rules user_category_rules_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.user_category_rules
    ADD CONSTRAINT user_category_rules_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: user_category_rules user_category_rules_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fintrack
--

ALTER TABLE ONLY public.user_category_rules
    ADD CONSTRAINT user_category_rules_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 206K1gJRhGezMwkxlQ9fXxW8z3AlSXb4ygDEN37Lr9W6obpJGt0Y3JrAftWyZWx

