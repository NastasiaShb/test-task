CREATE TABLE items (
    item_id INT,
    name TEXT,
    price INT,
    update_date DATE,
    PRIMARY KEY (item_id, update_date)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    item_id INT,
    order_date DATE
);

INSERT INTO items (item_id, name, price, update_date) VALUES
(1, 'Ручка гелевая', 10, '2020-02-01'),
(2, 'Карандаш 1HH', 2, '2020-01-01'),
(1, 'Ручка шариковая', 10, '2020-03-01'),
(3, 'Ластик', 5, '2020-07-01'),
(2, 'Карандаш 1HH', 3, '2020-05-01'),
(1, 'Ручка шариковая', 5, '2020-05-01'),
(2, 'Карандаш 1H', 7, '2020-06-01');

INSERT INTO orders (order_id, user_id, item_id, order_date) VALUES
(1, 1, 1, '2020-02-01'),
(2, 2, 2, '2020-02-01'),
(3, 1, 3, '2020-07-01'),
(4, 3, 2, '2020-07-01'),
(5, 2, 1, '2020-04-01'),
(6, 1, 1, '2020-06-01');
