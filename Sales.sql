--0 Give me all the information about employee his name is (David Liu) 
select *
from person.Person
where FirstName='David' and LastName='Liu' and PersonType='EM'

--1 Salesperson who already met their salesquota
select BusinessEntityID,Bonus
from Sales.SalesPerson
where Bonus !=0.00

--3 Salesperson (SP) without salesquota
select BusinessEntityID 
from Sales.SalesPerson
where SalesQuota is null

--4 SP With the highest commission (Only Top 5)
select top(5) BusinessEntityID,CommissionPct*100 as commission
from Sales.SalesPerson
order by CommissionPct desc

-- 5- SP who makes highest sales last year 
select top(1) BusinessEntityID,SalesLastYear
from Sales.SalesPerson
order by SalesLastYear desc

-- 6- SP who have highest Bonus 
select top(5) BusinessEntityID,Bonus
from Sales.SalesPerson
order by Bonus desc

-- 7- SP number by territory and region 
select BusinessEntityID,sp.TerritoryID,cr.CountryRegionCode
from Sales.SalesPerson as sp
join Sales.SalesTerritory as st
on sp.TerritoryID=st.TerritoryID
join Person.CountryRegion as cr
on cr.CountryRegionCode=st.CountryRegionCode
group by sp.TerritoryID,cr.CountryRegionCode,BusinessEntityID
order by TerritoryID

-- 8- Let's see how many times SPs' Salesquota have change 
select BusinessEntityID,COUNT(QuotaDate) as change_freq
from Sales.SalesPersonQuotaHistory
group by BusinessEntityID

-- 9- Areas with the highest Sales Last year  
select top(3) TerritoryID,Name,SalesLastYear
from Sales.SalesTerritory as st
order by SalesLastYear desc

-- 10- Areas with the highest Sales so far this year  
select top(3) TerritoryID,Name,SalesYTD
from Sales.SalesTerritory
order by SalesYTD desc

-- 11- SP who have change territory multiple times 
select BusinessEntityID
from Sales.SalesTerritoryHistory
where EndDate is not null

-- 12- Get stores table all columns  
select *
from Sales.Store

-- 13- Number of Store 
select COUNT(BusinessEntityID) as num_of_stores
from Sales.Store

-- 13- Number of Store by SPs 
select COUNT(BusinessEntityID) as num_of_stores,SalesPersonID
from Sales.Store
group by SalesPersonID

-- 14- Average annual revenue by store 
select AVG(SalesYTD) as avg_annual_revenue,ss.BusinessEntityID as store_number
from Sales.SalesPerson as sp
join Sales.Store as ss
on sp.BusinessEntityID=ss.SalesPersonID
group by ss.BusinessEntityID,sp.BusinessEntityID

-- 15- Number of store by business type 
select COUNT(BusinessEntityID) as num_of_store,Name
from Sales.Store
group by Name

-- 16- Number of Order by Year 
select COUNT(SalesOrderID) as total_orders,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
group by YEAR(OrderDate)

-- 17- Total Sales by year 
select SUM(TotalDue) as total_sales,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by total_sales desc

-- 18- Why is 2014 Sales lower than 2013 ######## 
-- answered in separete file

-- 19- Total Tax amount by year 
select sum(TaxAmt) as total_tax
from Sales.SalesOrderHeader

-- 20- Total Freight amount by year 
select sum(Freight) as total_frieght
from Sales.SalesOrderHeader

-- 21- Average Shipping time 
select AVG( DATEDIFF(DAY,ShipDate,DueDate)) as avg_ship_time
from Sales.SalesOrderHeader

-- 22- Online Order Percentage;
-- 1 = Online Order, 0 = Order placed by Salesperson 
select COUNT(case when OnlineOrderFlag=1 then 1 end)*100 /COUNT(SalesOrderID) as online_percent
from Sales.SalesOrderHeader

-- 23- Online Order Sales 
select SUM(TotalDue) as online_sales
from Sales.SalesOrderHeader
where OnlineOrderFlag=1

-- 24- Shopping Cart 
select *
from Sales.ShoppingCartItem

-- 25- sales By Territory 
select TerritoryID,SalesYTD
from Sales.SalesTerritory
order by SalesYTD desc

-- 26- Order Details 
select CONCAT(FirstName,' ',LastName) as full_name, CustomerID,SalesOrderID,ISNULL(SalesPersonID,1) as online,OrderDate,DueDate,ShipDate,TotalDue
from Sales.SalesOrderHeader as sod
join Person.Person as p
on p.BusinessEntityID=sod.CustomerID

-- 27- Special Offer 
select *
from Sales.SpecialOffer

-- 28- Special Offer with the Highest discount 
select top(3) SpecialOfferID,Description, DiscountPct*100
from Sales.SpecialOffer
order by DiscountPct desc

-- 29- Number of Customers 
select count(CustomerID) as total_customers
from Sales.Customer
where StoreID is not null

-- 30- Customers number by territory 
select count(CustomerID) as total_customers,TerritoryID
from Sales.Customer
where StoreID is not null
group by TerritoryID
order by total_customers desc

-- 31- Customer INFO 
select p.FirstName,c.*
from Sales.Customer as c
left join Person.Person as p
on p.BusinessEntityID=c.CustomerID

-- 32- Individual Customers Analysis 
select c.*,PersonType
from Sales.Customer as c
left join Person.Person as p
on c.CustomerID=p.BusinessEntityID
where PersonType='IN' 

-- 33- Number of Individual Customers 
select COUNT(CustomerID) as total_custmoers,PersonType
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
where PersonType='IN'
group by PersonType

-- 34- Customer Number by marital Status 
select COUNT(CustomerID) as total_custmoers,MaritalStatus
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by MaritalStatus


-- 35- Customer Number by Gender 
select COUNT(CustomerID) as total_custmoers,Gender
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by Gender


-- 37- Average Purchases By income Category 
select CustomerID,COUNT(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader
group by CustomerID
order by avg_purchases asc

-- 38- Average Purchases By Gender 
select Gender,count(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader as soh
join Person.Person as p
on soh.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by Gender


-- 39- Average Purchases By MaritalStatus
select MaritalStatus,count(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader as soh
join Person.Person as p
on soh.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by MaritalStatus
