use ecomerce;

select concat(Fname,'  ', Lname) as Client, IdOrder as Request, OrderStatus as Status
	from clients c, orders o 
    where c.IdClient = o.IdOrderClient;
    
select count(*) from clients c, orders o
	where c.IdClient = IdOrderClient
    group by idOrder;
    
select * from clients left outer join orders on IdClient = IdOrderClient;    

select * from clients c inner join orders o on c.IdClient = o.IdOrderClient
					inner join ProductOrder p on p.IdPOorder = o.IdOrder; 



-- Mostrar apenas pedidos confirmados.
select * from orders
	where OrderStatus = 'Confirmado';
 
 -- produtos com avaliação maior que 4.
 select Pname, Avaliacao
	from product
	where Avaliacao > 4;
    
-- calcular valor do frete com taxa de 10%.
select IdOrder, SendValue, SendValue * 1.10 as Total_Com_Taxa
	from orders;

-- idade aproximada do cliente.
select concat(Fname, Lname) as Cliente, year(curdate()) - year(Bdate) as Idade
	from clients;
    
-- Listar produtos ordenados pela maior avaliação.
select Pname, Avaliacao
	from product
	order by Avaliacao desc;  
    
-- clientes em ordem alfabética.
select Fname, Lname
	from clients
	order by Lname asc;

-- Contar quantos pedidos cada cliente fez.
select IdOrderClient, count(*) as TotalPedidos
	from orders
	group by IdOrderClient;
    
-- filtrando clientes com mais de 1 pedido.
select IdOrderClient, count(*) as TotalPedidos
	from orders
	group by IdOrderClient
	having count(*) > 1;
    
desc orders;
desc product;
-- cliente + pedido
select c.Fname, c.Lname, o.IdOrder, o.OrderStatus
	from clients c join orders o on c.IdClient = o.IdOrderClient;
    
select concat (c.Fname,'  ',c.Lname) as clientes, o.IdOrder as codigo, p.Pname as descrição, o.OrderStatus as status
from clients c join orders o on c.IdClient = o.IdOrderClient
join productOrder po on o.IdOrder = po.IdPOorder
join product p on p.IdProduct = po.IdPOproduct;   
    
-- Cliente + pedido + pagamento
select c.Fname, o.IdOrder, o.OrderStatus, p.TypePayment
	from clients c join orders o on c.IdClient = o.IdOrderClient
	join payments p on o.IdOrder = p.IdOrder;
    
-- Produto dentro do pedido
select p.Pname, o.IdOrder, po.PoQuantity
	from product p join productOrder po on p.IdProduct = po.IdPOproduct
	join orders o on o.IdOrder = po.IdPOorder;
    
-- Quantos pedidos cada cliente fez
select c.IdClient, c.Fname,
	count(o.IdOrder) as TotalPedidos
	from clients c
	left join orders o
	on c.IdClient = o.IdOrderClient
	group by c.IdClient, c.Fname;
    
-- Algum vendedor também é fornecedor
select s.SocialName as Vendedor, sp.SocialName as Fornecedor, s.CNPJ
	from seller s
	join supplier sp
	on s.CNPJ = sp.CNPJ;
    
-- Relação de produtos, fornecedores e estoque
select p.Pname as Produto, s.SocialName as Fornecedor,
ps.Quantity as QuantidadeFornecedor, st.Quantity as QuantidadeEstoque
	from product p
	join productSupplier ps
	on p.IdProduct = ps.IdPsProduct
	join supplier s
	on s.IdSupplier = ps.idPsSupplier
	join storageLocation sl
	on p.IdProduct = sl.IdProduct
	join productStorage st
	on st.IdProdStorage = sl.IdStorage;
    
-- Nome dos fornecedores e produtos
select s.SocialName as Fornecedor, p.Pname as Produto
	from supplier s
	join productSupplier ps
	on s.IdSupplier = ps.idPsSupplier
	join product p
	on p.IdProduct = ps.IdPsProduct
	order by s.SocialName;