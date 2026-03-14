-- criação de banco de dados para o cenário de E-comerce
create database ecomerce;
use  ecomerce;
show tables;

-- CLIENTES
create table clients(
    IdClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(45),
    Bdate date,
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

-- PRODUTOS
create table product(
    IdProduct int auto_increment primary key,
    Pname varchar(10) not null,
    Classification_kids bool default false,
    Category enum('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') not null,
    Avaliacao float default 0,
    size varchar(10)
);

-- PEDIDOS
create table orders(
    IdOrder int auto_increment primary key,
    IdOrderClient int,
    OrderStatus enum('Cancelado','Confirmado','Em Processamento') default 'Em Processamento',
    OrderDescription varchar(255),
    SendValue float default 10,
    PaymentCash bool default false,
    constraint fk_orders_client foreign key (IdOrderClient) references clients(IdClient)
);

-- PAGAMENTOS 
create table payments(
    IdPayment int auto_increment primary key,
    IdOrder int,
    TypePayment enum('Boleto','Cartao','Dois cartoes') not null,
    LimitAvailable float,
    constraint fk_payment_order foreign key (IdOrder) references orders(IdOrder)
);

-- ESTOQUE
create table productStorage(
    IdProdStorage int auto_increment primary key,
    StorageLocation varchar(255),
    Quantity int default 0
);

-- FORNECEDOR
create table supplier(
    IdSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    Contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- VENDEDOR
create table seller(
    IdSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(11),
    Location varchar(255),
    Contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- PRODUTO DO VENDEDOR
create table productSeller(
    IdSeller int,
    IdProduct int,
    Quantity int default 1,
	primary key (IdSeller, IdProduct),
    constraint fk_product_seller foreign key (IdSeller) references seller(IdSeller),
	constraint fk_product_product foreign key (IdProduct) references product(IdProduct)
);

-- PRODUTO NO PEDIDO
create table productOrder(
    IdPOproduct int,
    IdPOorder int,
    PoQuantity int default 1,
    PoStatus enum('Disponivel','Sem estoque') default 'Disponivel',
	primary key (IdPOproduct, IdPOorder),
    constraint fk_po_product foreign key (IdPOproduct) references product(IdProduct),
    constraint fk_po_order foreign key (IdPOorder) references orders(IdOrder)
);

-- LOCAL DE ARMAZENAMENTO
create table storageLocation(
    IdProduct int,
    IdStorage int,
    Location varchar(255) not null,
	primary key (IdProduct, IdStorage),
	constraint fk_storage_product foreign key (IdProduct) references product(IdProduct),
    constraint fk_storage_storage foreign key (IdStorage) references productStorage(IdProdStorage)
);

-- Produto vendedor
create table productSupplier(
	idPsSupplier int,
    IdPsProduct int,
    Quantity int not null,
    primary key (idPsSupplier,IdPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(IdSupplier),
    constraint fk_product_supplier_product foreign key (IdPsProduct) references product(IdProduct)
);

-- CLIENTE PF
create table clientPF(
    IdClient int primary key,
    CPF char(11) not null unique,
    constraint fk_client_pf
    foreign key (IdClient) references clients(IdClient)
);

-- CLIENTE PJ
create table clientPJ(
    IdClient int primary key,
    CNPJ char(15) not null unique,
    constraint fk_client_pj
    foreign key (IdClient) references clients(IdClient)
);

create table delivery(
    IdDelivery int auto_increment primary key,
    IdOrder int,
    DeliveryStatus enum('Em transporte','Entregue','Aguardando envio'),
    TrackingCode varchar(45),
    constraint fk_delivery_order
    foreign key (IdOrder) references orders(IdOrder)
);

inserção de dados e queries 

-- CLIENTES
insert into clients (Fname, Minit, Lname, CPF, Address, Bdate) values
('Pedro','A','Silva','12345678901','Rua das Flores 120','1998-05-12'),
('Maria','B','Souza','23456789012','Av Brasil 450','1995-09-20'),
('Carlos','C','Oliveira','34567890123','Rua Paraná 88','2000-02-10'),
('Ana','D','Pereira','45678901234','Rua Central 77','1992-11-03'),
('Lucas','E','Costa','56789012345','Av Paulista 100','1999-07-15');

-- PRODUTOS
insert into product (Pname, Classification_kids, Category, Avaliacao, size) values
('Notebook',false,'Eletronico',4.5,'15'),
('Camiseta',false,'Vestimenta',4.0,'M'),
('Boneca',true,'Brinquedos',4.7,'30cm'),
('Chocolate',true,'Alimentos',4.8,'200g'),
('Sofa',false,'Moveis',4.3,'Grande');

-- VENDEDORES
insert into seller (SocialName, AbstName, CNPJ, CPF, Location, Contact) values
('Tech Store','Tech','11222333000101',null,'São Paulo','11999999999'),
('Moda Brasil','Moda','22333444000102',null,'Rio de Janeiro','21988888888'),
('Brinquedos Feliz','BF','33444555000103',null,'Curitiba','41977777777');

-- FORNECEDORES
insert into supplier (SocialName, CNPJ, Contact) values
('Distribuidora Tech','44555666000104','11966666666'),
('Confecções Alpha','55666777000105','21955555555'),
('Brinquedos SA','66777888000106','41944444444');

-- ESTOQUE
insert into productStorage (StorageLocation, Quantity) values
('Galpão A',100),
('Galpão B',200),
('Centro Logistico',150);

-- PEDIDOS
insert into orders (IdOrderClient, OrderStatus, OrderDescription, SendValue, PaymentCash) values
(1,'Confirmado','Compra de notebook',25,false),
(2,'Em Processamento','Compra de camiseta',15,true),
(3,'Confirmado','Compra de boneca',20,false),
(4,'Cancelado','Compra de chocolate',10,true),
(5,'Confirmado','Compra de sofa',50,false);

-- PAGAMENTOS
insert into payments (IdOrder, TypePayment, LimitAvailable) values
(1,'Cartao',5000),
(2,'Boleto',1000),
(3,'Cartao',2000),
(4,'Boleto',500),
(5,'Dois cartoes',8000);

-- PRODUTO VENDEDOR
insert into productSeller (IdSeller, IdProduct, Quantity) values
(1,1,10),
(2,2,30),
(3,3,20),
(1,4,50),
(2,5,5);

-- PRODUTO PEDIDO
insert into productOrder (IdPOproduct, IdPOorder, PoQuantity, PoStatus) values
(1,1,1,'Disponivel'),
(2,2,2,'Disponivel'),
(3,3,1,'Disponivel'),
(4,4,5,'Disponivel'),
(5,5,1,'Disponivel');

-- LOCAL DE ARMAZENAMENTO
insert into storageLocation (IdProduct, IdStorage, Location) values
(1,1,'Prateleira A1'),
(2,1,'Prateleira A2'),
(3,2,'Prateleira B1'),
(4,3,'Prateleira C1'),
(5,2,'Prateleira B3');

-- PRODUTO FORNECEDOR
insert into productSupplier (idPsSupplier, IdPsProduct, Quantity) values
(1,1,50),
(2,2,100),
(3,3,80),
(1,4,120),
(2,5,20);

-- CLIENTES PF
insert into clientPF (IdClient, CPF) values
(1,'12345678901'),
(2,'23456789012'),
(3,'34567890123');

-- CLIENTES PJ
insert into clientPJ (IdClient, CNPJ) values
(4,'11222333000101'),
(5,'22333444000102');

-- STATUS DE ENTREGA
insert into delivery (IdOrder, DeliveryStatus, TrackingCode) values
(1,'Entregue','BR1234567890'),
(2,'Em transporte','BR2345678901'),
(3,'Aguardando envio','BR3456789012'),
(4,'Entregue','BR4567890123'),
(5,'Em transporte','BR5678901234');


