-- Création de la base de données
CREATE TABLE Users (
    id_customer SERIAL PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL
);

CREATE TABLE Baskets (
    id_order SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES Customers(id_customer) ON DELETE CASCADE,
    product_list TEXT NOT NULL
);

-- Insertion de données
INSERT INTO Customers (firstname, lastname) VALUES ('Emma', 'Johnson');
INSERT INTO Customers (firstname, lastname) VALUES ('Liam', 'Brown');
INSERT INTO Customers (firstname, lastname) VALUES ('Olivia', 'Taylor');
INSERT INTO Customers (firstname, lastname) VALUES ('Noah', 'Williams');

INSERT INTO Orders (customer_id, product_list) VALUES (1, '1,2,3');
INSERT INTO Orders (customer_id, product_list) VALUES (2, '4,5,6');
INSERT INTO Orders (customer_id, product_list) VALUES (3, '7,8,9');
INSERT INTO Orders (customer_id, product_list) VALUES (4, '10,1,2');
