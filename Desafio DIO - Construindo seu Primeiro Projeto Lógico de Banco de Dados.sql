-- criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(45),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

alter table clients modify column Address varchar(100);

-- criar tabela produto
-- size = dimensão do produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(10),
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

alter table product modify column Pname varchar(50);

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento

-- criar tabela pagamento
create table payment(
	idClient int,
    id_Payment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient, id_payment)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
   StorageLocation varchar(255),
   quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier modify column CNPJ char(50) not null;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- criar tabela produtos do vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller (idSeller),
    constraint fk_product_product foreign key (idPproduct) references product (idProduct)
);

-- criar tabela produtos do pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

-- criar tabela localização do estoque
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product (idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage (idProdStorage)
);

-- criar tabela fornecedor do produto
create table productSupplier(
idPsSupplier int,
idPsProduct int,
quantity int not null,
primary key (idPsSupplier, idPsProduct),
constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier (idSupplier),
constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
);

use information_schema;
select * from referential_constraints where constraint_schema = 'ecommerce';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- inserção de dados e queries
use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients (Fname, Minit, Lname, CPF, Address)
values ('Maria','M','Silva', 123456789, 'rua silva de prata 29, Carangola - Cidade das flores'),
       ('Matheus','O','Pimentel', 987654321, 'rua alemeda 289, Centro - Cidade das flores'),
       ('Ricardo','F','Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
       ('Julia','S','França', 789123456,'rua laranjeiras 861, Centro - Cidade das flores'),
       ('Roberta','G','Assis', 98745631,'avenida koller 19, Centro - Cidade das flores'),
       ('Isabela','M','Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');
      
      
-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (idProduct, Pname, classification_kids, category, avaliação, size) values
		    ('Fone de ouvido',false,'Eletrônico','4',null),
                    ('Barbie Elsa',true,'Brinquedos','3',null),
                    ('Body Carters',true,'Vestimenta','5',null),
                    ('Microfone Vedo - Youtuber',false,'Eletrônico','4',null),
                    ('Sofá retrátil',False,'Móveis','3','3x57x80'),
                    ('Farinha de arroz',false,'Alimentos','2',null),
                    ('Fire Stick Amazon',false,'Eletrônico','3',null);
                    
select * from clients;
select * from product;
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
		    (1, default,'compra via aplicativo',null,1),
                    (2,default,'compra via aplicativo',50,0),
                    (3,'Confirmado',null,null,1),
                    (4,default,'compra via web site',150,0);
                    
delete from orders where idOrderClient in (1,2,3,4);

select * from orders;                    
-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						(1,5,2,null),
                        (2,5,1,null),
						(3,6,1,null);
                        
-- storageLocation, qwuantity
insert into productStorage (storageLocation, quantity) values
			    ('Rio de Janeiro',1000),
                            ('Rio de Janeiro', 500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);
                            
-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
			   (1,2,'RJ'),
			   (2,6,'GO');
                            
-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
		     ('Almeida e filhos', 123456789123456,'21985474'),
                     ('Eletrônicos Silva', 8545196499143457,'21985484'),
                     ('Eletrônicos Valma', 9345678934695, '21975474');
                     
-- idPSSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
							(1,1,500),
                            (1,2,400),
                            (2,4,633),
                            (3,3,5),
                            (2,5,10);
                            
-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact                            
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
			('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
                        ('Botique Durgas', null, 2349534058909, 123456783,'Rio de Janeiro', 219567895),
                        ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);
                        
select * from seller;
-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values
			    (4,6,80),
                            (5,7,10);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Desafio DIO

use ecommerce;

-- Quantos pedidos foram feitos por cada cliente?
select o.idOrder, c.idClient, c.Fname, COUNT(o.idOrder) as total_pedidos
from orders o
inner join clients c on c.idClient = o.idOrderClient
group by o.idOrder, c.idClient, c.Fname order by c.Fname;

-- Algum vendedor também é fornecedor?
select s.idSeller, s.SocialName
from seller s inner join supplier sup
on s.idSeller = sup.idSupplier;

-- Relação de produtos fornecedores e estoques
select * from productSupplier
inner join productStorage;

-- Relação de nomes dos fornecedores e nomes dos produtos
select s.SocialName, p.Pname
from supplier s, product p inner join productSupplier ps 
where idPsSupplier = idSupplier and idPsProduct = idProduct; 

-- Quantos clientes fizeram mais de um pedido?
select c.idClient, c.Fname, o.idOrderClient, count(o.idOrderClient) as total_pedidos
from clients c inner join orders o on c.idClient = o.idOrderClient
group by idOrderClient
having count(o.idOrderClient) > 1;
