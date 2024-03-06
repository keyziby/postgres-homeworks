-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT cus.company_name, CONCAT(emp.first_name, ' ', emp.last_name) as fullname
FROM customers cus
JOIN orders ord USING(customer_id)
JOIN employees emp USING(employee_id)
JOIN shippers ship ON ord.ship_via=ship.shipper_id AND ship.company_name='United Package'
WHERE cus.city='London' AND emp.city='London'

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT prod.product_name, prod.units_in_stock, sup.contact_name, sup.phone
FROM products prod
JOIN suppliers sup USING(supplier_id)
JOIN categories cat USING(category_id)
WHERE prod.discontinued<>1 AND prod.units_in_stock<25 AND (cat.category_name = 'Dairy Products' OR cat.category_name = 'Condiments')
ORDER BY prod.units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT customers.company_name
FROM customers
WHERE NOT EXISTS (SELECT * FROM orders WHERE orders.customer_id = customers.customer_id)

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products
WHERE product_id IN (SELECT product_id FROM order_details WHERE quantity=10)
