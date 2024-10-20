﻿-- total amount
select SUM(TotalDue) as total_amount,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
where YEAR(OrderDate) in (2013,2014)
group by YEAR(OrderDate)
order by total_amount 

--total orders
select COUNT(SalesOrderID) as total_orders,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
where YEAR(OrderDate) in (2013,2014)
group by YEAR(OrderDate)
order by total_orders

--ممكن يكون فيه اوردرات اتلغت
select COUNT(SalesOrderID) as total_orders,COUNT(case when Status!=5 then SalesOrderID end) as total_unshipped_orders,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
where YEAR(OrderDate) in (2013,2014)
group by YEAR(OrderDate)

--طب نعرف الكمية اللى اتطلب وعدد المنتجات المطلوبة وادفع قد ايه
select YEAR(OrderDate) as year,SUM(OrderQty) as total_quantity,SUM(TotalDue) as total_purchase_amount,COUNT(distinct ProductID)as total_ordered_products
from Sales.SalesOrderHeader as soh
join Sales.SalesOrderDetail as sod
on soh.SalesOrderID=sod.SalesOrderID
where YEAR(OrderDate) in (2013,2014)
group by YEAR(OrderDate)

--maybe because the products we buy doesn't give enough money even though the number of ordersincreased 
--2014
select p.ProductID,Name,UnitPrice,YEAR(OrderDate) as year_of_demand,OrderQty
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID=soh.SalesOrderID
join Production.Product as p
on sod.ProductID=p.ProductID
where YEAR(OrderDate)=2014

--2013
select p.ProductID,Name,UnitPrice,YEAR(OrderDate) as year_of_demand,OrderQty
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID=soh.SalesOrderID
join Production.Product as p
on sod.ProductID=p.ProductID
where YEAR(OrderDate)=2013

--اعلى خمس منتجات فى الكمية وسعرها فى كل سنة
--2014
select top(5) p.ProductID ,p.Name,SUM(OrderQty) as total_quantity,UnitPrice,YEAR(OrderDate) as year
from Sales.SalesOrderDetail as sod
join Production.Product as p
on p.ProductID=sod.ProductID
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID=soh.SalesOrderID
where YEAR(OrderDate)=2014
group by Name,p.ProductID,UnitPrice,YEAR(OrderDate)
order by total_quantity desc

--2013
select top(5) p.ProductID ,p.Name,SUM(OrderQty) as total_quantity,UnitPrice,YEAR(OrderDate) as year
from Sales.SalesOrderDetail as sod
join Production.Product as p
on p.ProductID=sod.ProductID
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID=soh.SalesOrderID
where YEAR(OrderDate)=2013
group by Name,p.ProductID,UnitPrice,YEAR(OrderDate)
order by total_quantity desc

--نشوف عدد العملاءاللى اشتروا منى فى كل سنة
select COUNT(c.CustomerID)as total_customers,YEAR(OrderDate)as year
from Sales.SalesOrderHeader as soh
join Sales.SalesOrderDetail as sod
on soh.SalesOrderID=sod.SalesOrderID
join Sales.Customer as c
on soh.CustomerID=c.CustomerID
where YEAR(OrderDate) in (2013,2014) and StoreID is not null
group by YEAR(OrderDate)

--نشوف الطلبات الاونلاين والاوفلاين فى كل سنة
select COUNT(case when OnlineOrderFlag=1 then SalesOrderID end) as online_orders,COUNT(case when OnlineOrderFlag=0 then SalesOrderID end) as offline_orders,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
where YEAR(OrderDate) in (2013,2014)
group by YEAR(OrderDate)

--طب اشوف العروض والخصومات على المنتجات كانت قد ايه وامتى

--2014
select distinct ProductID,UnitPriceDiscount*100 as product_discount,YEAR(OrderDate) as year,MONTH(OrderDate) as month
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on soh.SalesOrderID=sod.SalesOrderID
where YEAR(OrderDate)=2014 and UnitPriceDiscount!=0.00
order by MONTH(OrderDate) asc
--2013
select distinct ProductID,UnitPriceDiscount*100 as product_discount,YEAR(OrderDate) as year,MONTH(OrderDate) as month
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on soh.SalesOrderID=sod.SalesOrderID
where YEAR(OrderDate)=2013 and UnitPriceDiscount!=0.00
order by MONTH(OrderDate) asc