-- 1. Актуальное состояние товаров на 2020-06-01
SELECT 
  DISTINCT ON (item_id) item_id, 
  name, 
  price, 
  update_date
FROM items
WHERE update_date <= '2020-06-01'
ORDER BY 
  item_id ASC, 
  update_date DESC
  
  
  
-- 2. Товары, купленные по цене больше или равно чем 3

SELECT 
  DISTINCT l.item_id, 
  r.name, 
  r.price
FROM orders AS l
JOIN items AS r ON l.item_id = r.item_id
WHERE 
  r.price >= 3 
  AND 
  r.update_date = (SELECT MAX(update_date) 
                   FROM items AS t 
                   WHERE 
                    t.item_id = r.item_id 
                    AND 
                    t.update_date <= l.order_date)

-- 3. Сумма покупок клиента 1

SELECT 
  SUM(r.price) AS purchase_amount
FROM orders AS l
JOIN items AS r ON l.item_id = r.item_id
WHERE l.user_id = 1 
AND r.update_date = (SELECT MAX(update_date) 
                     FROM items AS t 
                     WHERE t.item_id = r.item_id 
                     AND t.update_date <= l.order_date)

-- 4. Сумма всех покупок до 2020-05-01 включительно

SELECT 
  SUM(r.price) AS all_sum
FROM orders AS l
JOIN items AS r ON l.item_id = r.item_id
WHERE l.order_date <= '2020-05-01'
AND r.update_date = (SELECT MAX(update_date) 
                     FROM items AS t 
                     WHERE t.item_id = r.item_id 
                     AND t.update_date <= l.order_date)

-- 5. Сумма всех заказов и среднее цена заказа поквартально

SELECT 
    DATE_TRUNC('quarter', l.order_date)::DATE AS quarter,
    SUM(r.price) AS total_revenue,
    ROUND(AVG(r.price), 2) AS avg_order_price
FROM orders AS l
JOIN items AS r ON l.item_id = r.item_id
WHERE r.update_date = (
    SELECT MAX(update_date) 
    FROM items AS t 
    WHERE t.item_id = r.item_id 
    AND t.update_date <= l.order_date
)
GROUP BY quarter
ORDER BY quarter

-- 6. Оптимизация запросов для больших объемов данных

-- 1. Создать индексы на часто используемые колонки,например, ускорения поиска актуальной цены и соединение таблиц

CREATE INDEX idx_orders_item ON orders(item_id);
CREATE INDEX idx_items_item_date ON items(item_id, update_date)


-- 2. Создать материализованный вид (если данные редко меняются)

-- Если обновления данных происходят редко, можно сохранить результат в отдельную таблицу:

CREATE MATERIALIZED VIEW latest_items AS
SELECT DISTINCT ON (item_id) item_id, name, price, update_date
FROM items
ORDER BY item_id, update_date DESC

-- 3. Партиционирование (разбиение данных на части)

-- Если таблица orders очень большая, можно её разбить по годам или кварталам:

CREATE TABLE orders_2020 PARTITION OF orders
FOR VALUES FROM ('2020-01-01') TO ('2020-12-31')




