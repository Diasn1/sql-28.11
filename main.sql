CREATE TABLE employees (
    'id' SERIAL PRIMARY KEY,
    'name' VARCHAR(255),
    'salary' DECIMAL
);

CREATE TABLE users (
    'id' SERIAL PRIMARY KEY,
    'name' VARCHAR(255)
);

CREATE TABLE posts (
    'id' SERIAL PRIMARY KEY,
    'user_id' INTEGER REFERENCES users(id),
    'text' TEXT
);

CREATE TABLE orders (
    'id' SERIAL PRIMARY KEY,
    'date' DATE,
    'quantity' INTEGER,
    'amount' DECIMAL
);

INSERT INTO employees ('name', 'salary') VALUES
    ('Сотрудник1', 50000),
    ('Сотрудник2', 60000),
    ('Сотрудник3', 70000);

INSERT INTO users ('name') VALUES
    ('Пользователь1'),
    ('Пользователь2'),
    ('Пользователь3');

INSERT INTO posts ('user_id', 'text') VALUES
    (1, 'Пост1'),
    (1, 'Пост2'),
    (2, 'Пост3'),
    (3, 'Пост4'),
    (3, 'Пост5');

INSERT INTO orders ('date', 'quantity', 'amount') VALUES
    ('2023-01-01', 10, 1000),
    ('2023-02-01', 15, 1500),
    ('2023-03-01', 20, 2000);


CREATE OR REPLACE VIEW view_sorted_employees AS
SELECT * FROM employees
ORDER BY salary DESC;

CREATE MATERIALIZED VIEW mv_sorted_employees AS
SELECT * FROM view_sorted_employees;


CREATE OR REPLACE VIEW view_user_post_count AS
SELECT users.id AS user_id, users.name AS user_name, COUNT(posts.id) AS post_count
FROM users
LEFT JOIN posts ON users.id = posts.user_id
GROUP BY users.id, users.name;

CREATE OR REPLACE VIEW view_users_with_more_than_5_posts AS
SELECT * FROM view_user_post_count
WHERE post_count > 5;

CREATE MATERIALIZED VIEW mv_order_summary_by_month AS
SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  SUM(quantity) AS total_orders,
  SUM(amount) AS total_amount
FROM orders
WHERE date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY year, month;
