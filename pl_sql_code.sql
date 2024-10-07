-- ------------------------------------------------------------------------------
-- Author: Paula Farebrother
--  References:
--      Tutor: Stefan Binder
--      Module: databases
--      University: Abertay
--  21-04-2024 (created)
--  07-10-2024 (last modified)
-- ------------------------------------------------------------------------------

-----------------------------------------------------------------------------
--                              Views
-----------------------------------------------------------------------------

-- Employee details for regular users
create or replace view Employee_view
as
select
  EmployeeID,
  FirstName, 
  LastName, 
  EmpAddress, 
  to_char( DoB, 'DD-MM-YYYY' ) as DoB,
  Email, 
  ContactNumber, 
  AltContactNumber,
  to_char( StartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( LeavingDate, 'DD-MM-YYYY' ) as LeavingDate
from Employee
;

-- Creates a View of which Employees are Supervisors
create or replace view Superv_view
as
select
  S.SupervisorID as Supervisor_ID,
  S.EmployeeID as Supervisor_EID,
  E.FirstName as Supervisor_FirstName,
  E.LastName as Supervisor_LastName,
  to_char( S.SupervisorStartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( S.SupervisorEndDate, 'DD-MM-YYYY' ) as EndDate
from Employee E
join Supervisor S on E.EmployeeID = S.EmployeeID
;

-- Supervised by View
create or replace view SupervBy_view as
select
  E.FirstName as Employee_FirstName,
  E.LastName as Employee_LastName,
  SE.SupervisorID,
  SV.Supervisor_FirstName,
  SV.Supervisor_LastName
from Employee E
join SupervisedEmployee SE on E.EmployeeID = SE.EmployeeID
join Superv_view SV on SE.SupervisorID = SV.Supervisor_ID
;

-- View to show Dependents
create or replace view Dependents_view
as
select
  E.FirstName as Employee_FirstName,
  E.LastName as Employee_LastName,
  D.FirstName as Dependent_FirstName,
  D.LastName as Dependent_LastName,
  D.DoB,
  D.Dep_Phone_Number,
  D.Dep_Alt_Number,
  D.ReltoEmp
from Employee E
join DependChild D on E.EmployeeID = D.EmployeeID
;

-- Department Managers View
-- Create a View of All Employees who are or have been Managers 
create or replace view Managers_view
as
select
  RM.ManagerID as Manager_ID,
  RM.EmployeeID as Manager_EID,
  E.FirstName as Manager_FirstName,
  E.LastName as Manager_LastName,
  to_char( RM.ManagerStartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( RM.ManagerEndDate, 'DD-MM-YYYY' ) as EndDate
from Employee E
join RoleManager RM on E.EmployeeID = RM.EmployeeID
;

-- Separate view created first to avoid getting duplicate results
create or replace view DeptLoc_view
as
select
  distinct D.DeptName,
  PL.LocationName as Location
from Department D
join ProjectLocation PL on D.DeptID = PL.DeptID
;

-- joining views/tables to create complete data
create or replace view Managers_Dept_view
as
select
  RM.ManagerID as Manager_ID,
  RM.EmployeeID as Manager_EID,
  E.FirstName as Manager_FirstName,
  E.LastName as Manager_LastName,
  D.DeptName,
  DV.Location,
  to_char( RM.ManagerStartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( RM.ManagerEndDate, 'DD-MM-YYYY' ) as EndDate
from Employee E
join RoleManager RM on E.EmployeeID = RM.EmployeeID
join Department D on RM.ManagerID = D.ManagerID
join DeptLoc_view DV on D.DeptName = DV.DeptName
;

-- Create view to show which employees work for which Department
create or replace view DeptEmp_view 
as
select
  E.FirstName as Employee_FirstName,
  E.LastName as Employee_LastName,
  D.DeptName,
  to_char( DE.DeptEmpStartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( DE.DeptEmpEndDate, 'DD-MM-YYYY' ) as EndDate
from DeptEmployee DE
join Employee E on DE.EmployeeID = E.EmployeeID
join Department D on DE.DeptID = D.DeptID
;

-- Simple Projects overview
create or replace view Projects_view
as
select
  * 
from WorkProject
;

-- Hours worked on each project by each employee
create or replace view Proj_All_view
as
select
  WP.ProjectName,
  to_char( WP.ProjectStartDate, 'DD-MM-YYYY' ) as StartDate,
  to_char( WP.ProjectEndDate, 'DD-MM-YYYY' ) as EndDate,
  E.FirstName,
  E.LastName,
  WA.HoursWorked,
  to_char( WA.DateofWork, 'DD-MM-YYYY' ) as Date_of_Work
from WorkProject WP
join WorkAllocation WA on WP.ProjectID = WA.ProjectID 
join Employee E on WA.EmployeeID = E.EmployeeID
;

-- Customers View with name of contact employee
create or replace view Customers_view
as
select
  C.CustFirstName as Customer_FirstName,
  C.CustLastName as Customer_LastName,
  C.CustAddress as Customer_Address,
  C.CustTelNum as Customer_PhoneNum,
  E.FirstName as Contact_Employee,
  E.LastName as Contact_Employee_Surname
from Customer C
join Employee E on C.EmployeeID = E.EmployeeID
;

-- Customer Orders view
-- Would be useful to have a total here for each order
create or replace view CustOrder_view
as
select
  C.CustFirstName,
  C.CustLastName, 
  CO.CustOrderID,
  CO.PayMethod,
  to_char( CO.TransacDate, 'DD-MM-YYYY' ) as Transaction_Date
from Customer C
join CustomerOrder CO on C.CustomerID = CO.CustomerID
;

-- Details of Customer Order by OrderID view
create or replace view CustOrdItems_view
as
select
  C.CustLastName, 
  CO.CustOrderID,
  P.ProductName,
  P.ProductPrice,
  CL.Quantity
from Customer C
join CustomerOrder CO on C.CustomerID = CO.CustomerID
join CustOrdLineItem CL on CO.CustOrderID = CL.CustOrderID 
join Product P on CL.ProductID = P.ProductID
order by CO.CustOrderID
;

-- Warehouse details view
create or replace view WH_view
as
select
  WarehouseID,
  WHName as Warehouse_Name,
  WHCapacity as Capacity,
  WHLocation as Warehouse_Location
from Warehouse
;

-- Warehouse Inventory view
create or replace view WHInventory_view
as
select
  W.Warehouse_Name,
  W.Warehouse_Location,
  P.ProductName,
  I.StockLevel
from WH_view W
join Inventory I on W.WarehouseID = I.WarehouseID
join Product P on I.ProductID = P.ProductID
;

-----------------------------------------------------------------------------
--                        All Views now created                            --
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
--                        Some PL/SQL testing of data                      --
-----------------------------------------------------------------------------

-- Creating a function for calculating Salary Tax across bands.
create or replace function getSalaryTax( amount number )
return number
as
band1 constant number := 17000 ;
band2 constant number := 40000 ;
band3 constant number := 90000 ;
begin
if amount between 0 and band1 then return amount * 0.02 ;
elsif amount between band1 + 1 and band2 then return amount * 0.05 ;
elsif amount between band2 + 1 and band3 then return amount * 0.08 ;
end if ;
return 0 ;
end ;
/

-- Creating a subquery to test the function
select sq.*
, case
when sq.expected_result = sq.tax then 'test passed'
else 'test FAILED'
end as testResult
from (
select
Salary
, expected_result
, getSalaryTax( Salary ) as tax
from Salarytest
) sq ;

