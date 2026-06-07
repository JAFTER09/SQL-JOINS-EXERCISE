-- Databricks notebook source
--SQL JOINS EXERCISE

--Creating Users Table

CREATE OR REPLACE TABLE users (
    user_id INT,
    user_name STRING,
    country STRING
);

INSERT INTO users VALUES
(1,'Nomvula','Johannesburg'),
(2,'David','Cape Town'),
(3,'Anele','Durban'),
(4,'Kabelo','Pretoria'),
(5,'Lerato','Port Elizabeth');

--Creating Plans Table
CREATE OR REPLACE TABLE plans (
    plan_id INT,
    plan_name STRING,
    monthly_price INT
);
INSERT INTO plans VALUES
(10,'Basic',79),
(11,'Standard',129),
(12,'Premium',199),
(13,'Family',249),
(14,'Mobile',59);

--Creating Subscriptions Table
CREATE OR REPLACE TABLE subscriptions (
    subscription_id INT,
    user_id INT,
    plan_id INT,
    start_date DATE
);
INSERT INTO subscriptions VALUES
(501,1,10,'2026-01-15'),
(502,2,11,'2026-02-01'),
(503,1,12,'2026-03-10'),
(504,6,11,'2026-03-20'),
(505,3,13,'2026-04-05');

--Creating Shows Table 
CREATE OR REPLACE TABLE shows (
    show_id INT,
    show_title STRING,
    genre STRING
);
INSERT INTO shows VALUES
(701,'Comedy Hour','Comedy'),
(702,'Crime Time','Drama'),
(703,'Tech Tales','Documentary'),
(704,'Cooking Lab','Lifestyle'),
(706,'Wild Earth','Documentary');

--Creating Viewing Sessions Table
CREATE OR REPLACE TABLE viewing_sessions (
    session_id INT,
    user_id INT,
    show_id INT,
    watch_minutes INT
);
INSERT INTO viewing_sessions VALUES
(901,1,701,45),
(902,2,703,30),
(903,1,702,60),
(904,7,701,20),
(905,3,705,90);

SHOW TABLES;

SELECT * FROM users;
SELECT *FROM plans;
SELECT *FROM subscriptions;
SELECT*FROM shows;
SELECT*FROM viewing_sessions;


--QUESTION 1: INNER JOIN
--Shows every user who has a subscription.
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM users u
INNER JOIN subscriptions s
ON u.user_id = s.user_id;

--QUESTION 2
--Shows every subscription with its matching plan name and monthly price.
SELECT
    s.subscription_id,
    s.user_id,
    p.plan_name,
    p.monthly_price
FROM subscriptions s
INNER JOIN plans p
ON s.plan_id = p.plan_id;

--QUESTION 3
--It shows every viewing session that has a matching show, which includes the show title and genre.
SELECT
    vs.session_id,
    vs.user_id,
    s.show_title,
    s.genre,
    vs.watch_minutes
FROM viewing_sessions vs
INNER JOIN shows s
ON vs.show_id = s.show_id;

--QUESTION 4
--It shows every viewing session with the user who watched it, on the sessions that matches with a user.
SELECT
    u.user_name,
    u.country,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM users u
INNER JOIN viewing_sessions vs
ON u.user_id = vs.user_id;


--QUESTION 5
--It shows users along with their subscriptions, the plan name, and the price.
SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price,
    s.start_date
FROM users u
INNER JOIN subscriptions s
ON u.user_id = s.user_id
INNER JOIN plans p
ON s.plan_id = p.plan_id;

--PART B-LEFT JOIN
--QUESTION 6
--It shows every user and any subscriptions they have, and users without subscriptions must still appear.
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM users u
LEFT JOIN subscriptions s
ON u.user_id = s.user_id;

--QUESTION 7
--It shows every plan and the subscriptions on it, and plans with no subscribers must still appear.
SELECT
    p.plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM plans p
LEFT JOIN subscriptions s
ON p.plan_id = s.plan_id;

--QUESTION 8
--It shows every show and any viewing sessions on it, shows that were never watched must still appear.
SELECT
    sh.show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM shows sh
LEFT JOIN viewing_sessions vs
ON sh.show_id = vs.show_id;

--QUESTION 9 
--It shows every viewing session and the user who watched it, sessions referencing users that do not exist must still appear (with NULL user details).
SELECT
    vs.session_id,
    vs.show_id,
    vs.watch_minutes,
    u.user_id,
    u.user_name
FROM viewing_sessions vs
LEFT JOIN users u
ON vs.user_id = u.user_id;

--QUESTION 10
--It shows every user, the plan they are on and the monthly price if there is any. Users without a subscription must still appear.
SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price
FROM users u
LEFT JOIN subscriptions s
ON u.user_id = s.user_id
LEFT JOIN plans p
ON s.plan_id = p.plan_id;

--Part C — FULL OUTER JOIN
--QUESTION 11
--It shows every user and every subscription, including users without subscriptions AND subscriptions referencing users that do not exist.
SELECT
    COALESCE(u.user_id, s.user_id) AS user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM users u
FULL OUTER JOIN subscriptions s
ON u.user_id = s.user_id;

--QUESTION 12 
--It shows every plan and every subscription, including plans without subscribers AND any subscription referencing a plan that does not exist.
SELECT
    COALESCE(p.plan_id, s.plan_id) AS plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM plans p
FULL OUTER JOIN subscriptions s
ON p.plan_id = s.plan_id;

--QUESTION 13
--It shows every show and every viewing session, including shows that were never watched AND sessions referencing shows that do not exist.
SELECT
    COALESCE(sh.show_id, vs.show_id) AS show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM shows sh
FULL OUTER JOIN viewing_sessions vs
ON sh.show_id = vs.show_id;

--QUESTION 14
--It shows every user and every viewing session, including users with no sessions AND sessions referencing users who do not exist.
SELECT
    COALESCE(u.user_id, vs.user_id) AS user_id,
    u.user_name,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM users u
FULL OUTER JOIN viewing_sessions vs
ON u.user_id = vs.user_id;

--QUESTION 15
--It shows every user, every subscription, and every plan in one query — using FULL OUTER JOIN throughout.
SELECT
    COALESCE(u.user_id, s.user_id) AS user_id,
    u.user_name,
    s.subscription_id,
    COALESCE(p.plan_id, s.plan_id) AS plan_id,
    p.plan_name
FROM users u
FULL OUTER JOIN subscriptions s
ON u.user_id = s.user_id
FULL OUTER JOIN plans p
ON s.plan_id = p.plan_id;

--06 BONUS CHALLANGE

--Bonus 1
--Users with no subscriptions are:
--User 4- Kabelo
--User 5-Lerato

--Bonus 2
--Subscriptions referencing users that do not exist:
--Subscription 504
--User ID 6 does not exist in users table

--Bonus 3
--Shows never watched:
--Show 704 - Cooking Lab
--Show 706 - Wild Earth

--Bonus 4
--Viewing sessions reference shows that do not exist are:
--Session 905
--Show ID 705 does not exist


--Bonus 5
--Plans with no subcribers are;
--Plan - Mobile




-- COMMAND ----------


