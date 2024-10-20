--0
select *
from person.Person
where FirstName='David' and LastName='Liu' and PersonType='EM'

--1
select BusinessEntityID,Bonus
from Sales.SalesPerson
where Bonus !=0.00

--3
select BusinessEntityID 
from Sales.SalesPerson
where SalesQuota is null

--4
select top(5) BusinessEntityID,CommissionPct*100 as commission
from Sales.SalesPerson
order by CommissionPct desc

--5
select top(1) BusinessEntityID,SalesLastYear
from Sales.SalesPerson
order by SalesLastYear desc

--6
select top(5) BusinessEntityID,Bonus
from Sales.SalesPerson
order by Bonus desc

--7
select BusinessEntityID,sp.TerritoryID,cr.CountryRegionCode
from Sales.SalesPerson as sp
join Sales.SalesTerritory as st
on sp.TerritoryID=st.TerritoryID
join Person.CountryRegion as cr
on cr.CountryRegionCode=st.CountryRegionCode
group by sp.TerritoryID,cr.CountryRegionCode,BusinessEntityID
order by TerritoryID

--8
select BusinessEntityID,COUNT(QuotaDate) as change_freq
from Sales.SalesPersonQuotaHistory
group by BusinessEntityID

--9
select top(3) TerritoryID,Name,SalesLastYear
from Sales.SalesTerritory as st
order by SalesLastYear desc

--10
select top(3) TerritoryID,Name,SalesYTD
from Sales.SalesTerritory
order by SalesYTD desc

--11
select BusinessEntityID
from Sales.SalesTerritoryHistory
where EndDate is not null

--12
select *
from Sales.Store

--13
select COUNT(BusinessEntityID) as num_of_stores
from Sales.Store

--13
select COUNT(BusinessEntityID) as num_of_stores,SalesPersonID
from Sales.Store
group by SalesPersonID

--14 from demograghics
select AVG(SalesYTD) as avg_annual_revenue,ss.BusinessEntityID as store_number
from Sales.SalesPerson as sp
join Sales.Store as ss
on sp.BusinessEntityID=ss.SalesPersonID
group by ss.BusinessEntityID,sp.BusinessEntityID

--15 from demograghics
select COUNT(BusinessEntityID) as num_of_store,Name
from Sales.Store
group by Name

--16
select COUNT(SalesOrderID) as total_orders,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
group by YEAR(OrderDate)

--17
select SUM(TotalDue) as total_sales,YEAR(OrderDate) as year
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by total_sales desc

--18 maybe because the products we buy doesn't give enough money even though the number of orders increased 
select p.ProductID,Name,UnitPrice,YEAR(OrderDate) as year_of_demand,OrderQty
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID=soh.SalesOrderID
join Production.Product as p
on sod.ProductID=p.ProductID
where YEAR(OrderDate)=2014

--19
select sum(TaxAmt) as total_tax
from Sales.SalesOrderHeader

--20
select sum(Freight) as total_frieght
from Sales.SalesOrderHeader

--21
select AVG( DATEDIFF(DAY,ShipDate,DueDate)) as avg_ship_time
from Sales.SalesOrderHeader

--22
select COUNT(case when OnlineOrderFlag=1 then 1 end)*100 /COUNT(SalesOrderID) as online_percent
from Sales.SalesOrderHeader

--23
select SUM(TotalDue) as online_sales
from Sales.SalesOrderHeader
where OnlineOrderFlag=1

--24
select *
from Sales.ShoppingCartItem

--25
select TerritoryID,SalesYTD
from Sales.SalesTerritory
order by SalesYTD desc

--26
select CONCAT(FirstName,' ',LastName) as full_name, CustomerID,SalesOrderID,ISNULL(SalesPersonID,1) as online,OrderDate,DueDate,ShipDate,TotalDue
from Sales.SalesOrderHeader as sod
join Person.Person as p
on p.BusinessEntityID=sod.CustomerID

--27
select *
from Sales.SpecialOffer

--28
select top(3) SpecialOfferID,Description, DiscountPct*100
from Sales.SpecialOffer
order by DiscountPct desc

--29
select count(CustomerID) as total_customers
from Sales.Customer
where StoreID is not null

--30
select count(CustomerID) as total_customers,TerritoryID
from Sales.Customer
where StoreID is not null
group by TerritoryID
order by total_customers desc

--31
select p.FirstName,c.*
from Sales.Customer as c
left join Person.Person as p
on p.BusinessEntityID=c.CustomerID

--32
select c.*,PersonType
from Sales.Customer as c
left join Person.Person as p
on c.CustomerID=p.BusinessEntityID
where PersonType='IN' 

--33
select COUNT(CustomerID) as total_custmoers,PersonType
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
where PersonType='IN'
group by PersonType

--34
select COUNT(CustomerID) as total_custmoers,MaritalStatus
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by MaritalStatus

--35

--36
select COUNT(CustomerID) as total_custmoers,Gender
from Sales.Customer as c
join Person.Person as p
on c.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by Gender

--37

--38
select CustomerID,COUNT(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader
group by CustomerID
order by avg_purchases asc

--39
select Gender,count(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader as soh
join Person.Person as p
on soh.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by Gender

--40

--41
select MaritalStatus,count(SalesOrderID) as total_orders,AVG(TotalDue) as avg_purchases
from Sales.SalesOrderHeader as soh
join Person.Person as p
on soh.CustomerID=p.BusinessEntityID
join HumanResources.Employee as e
on e.BusinessEntityID=p.BusinessEntityID
group by MaritalStatus
