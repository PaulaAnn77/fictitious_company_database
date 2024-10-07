-- ------------------------------------------------------------------------------
--  Author: Paula Farebrother
--  20-04-2024 (created)
--  06-10-2024 (last modified)
-- ------------------------------------------------------------------------------

-----------------------------------------------------------------------------
--                       Delete data statements
-----------------------------------------------------------------------------

delete from People ;
delete from Employee ;
delete from NIrandoms ;
delete from Supervisor ;
delete from SupervisedEmployee ;
delete from Depend ;
delete from DependChild ;
delete from WorkProjData ;
delete from WorkProject ;
delete from WorkAllocData ;
delete from WorkAllocation ;
delete from RoleManager ;
delete from Department ;
delete from ProjectLocation ;
delete from DeptEmpData ;
delete from DeptEmployee ;
delete from CustData ;
delete from Customer ;
delete from ProdData ;
delete from Product ;
delete from CustomerOrder ;
delete from LineItemData ;
delete from CusOrdData ;
delete from WHData ;
delete from Warehouse ;
delete from InventoryData ;
delete from Inventory ;

------------------- Delete data statements complete --------------------------

-----------------------------------------------------------------------------
--                  Creating a table from a CSV file
-----------------------------------------------------------------------------

-- People table created at csv file upload stage in Apex
-- add columns to 'people' table
alter table people
add (
    startdate date default sysdate,
    salary number,
    DoB date default sysdate
) ;

-- add randomly generated data
-- (min and max values represent number of days subtracted from current date)
-- (max set at 6,000 to represent potential employees who have worked for the company for less than 17 years)
update people
set 
    startdate = sysdate - dbms_random.value(50, 6000),
    salary = round( dbms_random.value( 25000, 75000 ) , -2 ),
    DoB = sysdate - dbms_random.value(6570, 29200)
;

--------------- Uploads from People Table (CSV file) complete------------------

-----------------------------------------------------------------------------
--                       Employee Table
-----------------------------------------------------------------------------

-- Populating table using updated csv file (using 200 employees for testing):
insert into Employee ( 
    FirstName, LastName, NINumber, 
    EmpAddress, Salary, DoB, Email, 
    ContactNumber, StartDate 
    )
select
    first_name,
    last_name,
    NINumber,
    emp_address,
    salary,
    DoB,
    Email,
    Phone_Number,
    StartDate
from people
where id <= 200
;
    
-- this adds randomly placed numbers through the dataset
update Employee
set AltContactNumber = 
    case round(dbms_random.value(1, 26))
        when 1 then '061-689325'
        when 10 then '081-237458'
        when 20 then '031-569142'
        when 30 then '014-239564'
        when 40 then '012-568921'
        when 50 then '081-751423'
        when 60 then '011-568142'
        when 70 then '091-462814'
        when 80 then '031-561334'
        when 90 then '056-146278'
        when 100 then '012-146321'
        when 110 then '055-314562'
        when 120 then '072-314825'
        when 130 then '016-423519'
        when 140 then '12-5142893'
        when 150 then '021-325674'
        when 160 then '031-246218'
        when 170 then '014-234869'
        when 180 then '018-214863'
        when 190 then '016-245633'
        when 200 then '033-156647'
    end
where rownum <= 200;

-- fill only every 25th employee with a randomly generated leaving date
update Employee
set LeavingDate = 
  case 
    when EmployeeID = 1 then to_date('04/20/2023', 'MM/DD/YY')
    when EmployeeID = 25 then to_date('12/15/2018', 'MM/DD/YY')
    when EmployeeID = 50 then to_date('04/20/2017', 'MM/DD/YY')
    when EmployeeID = 75 then to_date('07/5/2020', 'MM/DD/YY')
    when EmployeeID = 100 then to_date('02/15/2024', 'MM/DD/YY')
    when EmployeeID = 125 then to_date('09/10/2001', 'MM/DD/YY')
    when EmployeeID = 150 then to_date('06/8/2016', 'MM/DD/YY')
    when EmployeeID = 175 then to_date('03/07/2022', 'MM/DD/YY')
    when EmployeeID = 200 then to_date('11/25/2020', 'MM/DD/YY')
end;

-------------- Employee Table complete with test data -------------------------


-----------------------------------------------------------------------------
--                        Supervisor Table
-----------------------------------------------------------------------------

-- 13 supervisors with 14 (and remainder) employees each
-- Plus 3 Supervisors who are no longer Supervisors
insert into Supervisor (EmployeeID)
select EmployeeID
from Employee
where EmployeeID in (
    14, 21, 27, 40, 52, 79, 110, 123, 
    129, 147, 167, 180, 192, 1, 15, 77
    )
;

-- Altering Start Dates for Supervisors
update Supervisor
set SupervisorStartDate = 
  case 
    when EmployeeID = 14 then to_date('05/18/2010', 'MM/DD/YYYY')
    when EmployeeID = 21 then to_date('05/10/2011', 'MM/DD/YYYY')
    when EmployeeID = 27 then to_date('03/01/2020', 'MM/DD/YYYY')
    when EmployeeID = 40 then to_date('06/10/2023', 'MM/DD/YYYY')
    when EmployeeID = 52 then to_date('08/20/2019', 'MM/DD/YYYY')
    when EmployeeID = 79 then to_date('08/21/2022', 'MM/DD/YYYY')
    when EmployeeID = 110 then to_date('07/05/2019', 'MM/DD/YYYY')
    when EmployeeID = 123 then to_date('04/05/2012', 'MM/DD/YYYY')
    when EmployeeID = 129 then to_date('11/19/2017', 'MM/DD/YYYY')
    when EmployeeID = 147 then to_date('05/10/2016', 'MM/DD/YYYY')
    when EmployeeID = 167 then to_date('07/30/2013', 'MM/DD/YYYY')
    when EmployeeID = 180 then to_date('02/16/2022', 'MM/DD/YYYY')
    when EmployeeID = 192 then to_date('12/08/2013', 'MM/DD/YYYY')
    when EmployeeID = 1 then to_date('06/08/2021', 'MM/DD/YYYY')
    when EmployeeID = 15 then to_date('05/29/2014', 'MM/DD/YYYY')
    when EmployeeID = 77 then to_date('10/21/2014', 'MM/DD/YYYY')
end;

-- Adding End Dates for Supervisors
update Supervisor
set SupervisorEndDate = 
  case 
    when EmployeeID = 1 then to_date('04/20/2023', 'MM/DD/YYYY')
    when EmployeeID = 15 then to_date('06/10/2014', 'MM/DD/YYYY')
    when EmployeeID = 77 then to_date('01/18/2020', 'MM/DD/YYYY')
end;

----------- Supervisor Table is now complete with test data ------------------


-----------------------------------------------------------------------------
--                     SupervisedEmployee Table 
-----------------------------------------------------------------------------

-- Employees with leaving date and Supervisors (as will have a manager) are skipped.
insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e 
where s.SupervisorID in ( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 )
and e.EmployeeID in ( 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 )
and e.EmployeeID in ( 17, 18, 19, 20, 22, 23, 24, 26, 28, 29, 30, 31, 32, 33 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 )
and e.EmployeeID in ( 34, 35, 36, 37, 38, 39, 41, 42, 43, 44, 45, 46, 47, 48 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 )
and e.EmployeeID in ( 49, 51, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7 )
and e.EmployeeID in ( 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 76, 77, 78, 80 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 )
and e.EmployeeID in ( 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 )
and e.EmployeeID in ( 95, 96, 97, 98, 99, 101, 102, 103, 104, 105, 106, 107, 108, 109 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11 )
and e.EmployeeID in ( 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 124, 126 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12 )
and e.EmployeeID in ( 127, 128, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13 )
and e.EmployeeID in ( 142, 143, 144, 145, 146, 148, 149, 151, 152, 153, 154, 155, 156, 157 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14 )
and e.EmployeeID in ( 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 )
and e.EmployeeID in ( 173, 174, 176, 177, 178, 179, 181, 182, 183, 184, 185, 186, 187, 188 );

insert into SupervisedEmployee ( SupervisorID, EmployeeID )
select s.SupervisorID, e.EmployeeID
from Supervisor s, Employee e  
where s.SupervisorID in ( 16, 16, 16, 16, 16, 16, 16, 16, 16, 16 )
and e.EmployeeID in ( 189, 190, 191, 193, 194, 195, 196, 197, 198, 199 );

------- SupervisedEmployee table is now complete with test data  --------------


-----------------------------------------------------------------------------
--                         DependChild Table
-----------------------------------------------------------------------------

-- using adapted People CSV file to create Dependent table in Apex upload
alter table Depend
add (
    DoB date default sysdate
) ;

update Depend
set 
    DoB = sysdate - dbms_random.value(6570, 29200)
;

-- insert data from CSV file Depend
insert into DependChild ( EmployeeID, FirstName, LastName, DoB, Dep_Phone_Number, ReltoEmp )
select ID, first_name, last_name, DoB, phone_number, ReltoEmp
from Depend
where id <= 200 
;

-- this adds randomly placed numbers through the dataset
update DependChild
set Dep_Alt_Number = 
    case round(dbms_random.value(1, 26))
        when 1 then '061-689325'
        when 10 then '081-237458'
        when 20 then '031-569142'
        when 30 then '014-239564'
        when 40 then '012-568921'
        when 50 then '081-751423'
        when 60 then '011-568142'
        when 70 then '091-462814'
        when 80 then '031-561334'
        when 90 then '056-146278'
        when 100 then '012-146321'
        when 110 then '055-314562'
        when 120 then '072-314825'
        when 130 then '016-423519'
        when 140 then '12-5142893'
        when 150 then '021-325674'
        when 160 then '031-246218'
        when 170 then '014-234869'
        when 180 then '018-214863'
        when 190 then '016-245633'
        when 200 then '033-156647'
    end
where rownum <= 200;

----------- DependChild Table is now complete with test data  -----------------

-----------------------------------------------------------------------------
--                          WorkProject Table
-----------------------------------------------------------------------------

-- Values entered in Apex Script
insert into WorkProjData ( ProjectName )
values ( 'ProjectOne' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectTwo' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectThree' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectFour' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectFive' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectSix' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectSeven' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectEight' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectNine' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectTen' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectEleven' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectTwelve' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectThirteen' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectFourteen' );

insert into WorkProjData ( ProjectName )
values ( 'ProjectFifteen' );

-- add StartDate column
alter table WorkProjData
add (
    startdate date default sysdate
) ;

-- update a randomly generated start date
update WorkProjData
set 
    startdate = sysdate - dbms_random.value(50, 6000)
;

-- transfer data across into WorkProject Table
insert into WorkProject ( ProjectName, ProjectStartDate )
select
    ProjectName,
    startdate
from WorkProjData
;

-- Set some Projects to show as ended
update WorkProject
set ProjectEndDate = 
  case 
    when ProjectID = 4 then to_date('06/20/2023', 'MM/DD/YYYY')
    when ProjectID = 8 then to_date('01/08/2022', 'MM/DD/YYYY')
    when ProjectID = 12 then to_date('10/05/2023', 'MM/DD/YYYY')
end;

----------- WorkProject Table is now complete with test data  -----------------

-----------------------------------------------------------------------------
--                          WorkAllocation Table
-----------------------------------------------------------------------------

-- WorkAllocData table create using CSV file in Apex
-- add column for workDate
alter table WorkAllocData
add (
    workDate date default sysdate
) ;

-- Add randomly generated work date
update WorkAllocData
set 
    workDate = sysdate - dbms_random.value(50, 3000)
;

-- transfer data into WorkAllocation Table
insert into WorkAllocation ( EmployeeID, ProjectID, HoursWorked, DateofWork )
select
    EmployeeID,
    ProjectID,
    HoursWorked,
    workDate
from WorkAllocData
where id <= 105
;

--------- WorkAllocation Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                          RoleManager Table
-----------------------------------------------------------------------------

-- Sets a selection of 12 Employees to the role of Manager, 2 showing a leaving date
insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 16, to_date('01/15/2013', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 24, to_date('06/20/2008', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 55, to_date('12/15/2018', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 99, to_date('01/28/2018', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 132, to_date('07/14/2016', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 136, to_date('01/18/2011', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 152, to_date('03/18/2014', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 162, to_date('03/08/2016', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 197, to_date('01/28/2020', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate )
values ( 199, to_date('03/19/2017', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate, ManagerEndDate )
values ( 1, to_date('06/08/2021', 'MM/DD/YYYY'), to_date('04/20/2023', 'MM/DD/YYYY'));

insert into RoleManager ( EmployeeID, ManagerStartDate, ManagerEndDate )
values ( 25, to_date('02/02/2011', 'MM/DD/YYYY'), to_date('12/15/2018', 'MM/DD/YYYY'));

--------- RoleManager Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                          Department Table
-----------------------------------------------------------------------------

-- Creates 5 Departments

insert into Department ( ManagerID, DeptName )
values ( 1, 'HumanResources');

insert into Department ( ManagerID, DeptName )
values ( 21, 'Sales');

insert into Department ( ManagerID, DeptName )
values ( 22, 'Marketing');

insert into Department ( ManagerID, DeptName )
values ( 23, 'ResearchDevelopment');

insert into Department ( ManagerID, DeptName )
values ( 24, 'IT');

------------- Department Table is now complete with test data  ----------------

-----------------------------------------------------------------------------
--                       ProjectLocation Table
-----------------------------------------------------------------------------
-- There are 5 Locations, 5 Departments, and 9 Projects
-- Each Project has a single location, Departments have several locations and 
-- control a number of Projects. 

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 6, 1, 'Haverfordwest');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 21, 2, 'MilfordHaven');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 7, 3, 'BroadHaven');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 21, 5, 'MilfordHaven');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 8, 6, 'Stackpole');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 6, 7, 'Haverfordwest');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 22, 9, 'Letterston');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 21, 10, 'MilfordHaven');

insert into ProjectLocation ( DeptID, ProjectID, LocationName )
values ( 7, 11, 'BroadHaven');

--------- ProjectLocation Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                          DeptEmployee Table
-----------------------------------------------------------------------------

-- Stores which Employee works for which Department
-- all RoleManagers are in the correct Department which they manage

-- transfer data from CSV uploaded Table 'DeptEmpData' into 'DeptEmployee' Table
-- NB issue with date format in Excel but data has inserted correctly.
insert into DeptEmployee ( EmployeeID, DeptID, DeptEmpStartDate, DeptEmpEndDate )
select
    EmployeeID,
    DeptID,
    DeptEmpStartDate,
    DeptEmpEndDate
from DeptEmpData
where EmployeeID <= 200
;

------------ DeptEmployee Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                        Customer Table
-----------------------------------------------------------------------------

-- transfer data from CSV uploaded Table 'CustData' into 'Customer' Table
insert into Customer ( 
    EmployeeID, CustFirstName, CustLastName, 
    CustAddress, CustTelNum 
    )
select
    EmployeeID,
    CustFirstName,
    CustLastName,
    CustAddress,
    CustTelNum
from CustData
where EmployeeID <= 200
;

--------------- Customer Table is now complete with test data  ---------------

-----------------------------------------------------------------------------
--                        Product Table
-----------------------------------------------------------------------------

-- transfer data from CSV uploaded Table 'ProdData' into 'Product' Table
insert into Product ( ProductName, ProductPrice )
select
    ProductName,
    Price
from ProdData
where rownum <= 200
;

--------------- Product Table is now complete with test data  ---------------

-----------------------------------------------------------------------------
--                        CustomerOrder Table
-----------------------------------------------------------------------------

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 24, to_date( '05/20/2020', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 32, to_date( '09/29/2014', 'MM/DD/YYYY'), 'Cash');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 45, to_date( '04/12/2022', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 50, to_date( '06/18/2023', 'MM/DD/YYYY'), 'On Account');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 55, to_date( '08/09/2020', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 60, to_date( '10/25/2021', 'MM/DD/YYYY'), 'BACS');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 62, to_date( '11/18/2019', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 70, to_date( '07/15/2018', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 75, to_date( '06/14/2021', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 82, to_date( '07/19/2020', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 95, to_date( '02/25/2018', 'MM/DD/YYYY'), 'BACS');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 120, to_date( '05/10/2019', 'MM/DD/YYYY'), 'On Account');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 132, to_date( '01/15/2020', 'MM/DD/YYYY'), 'BACS');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 150, to_date( '09/05/2018', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 180, to_date( '05/29/2019', 'MM/DD/YYYY'), 'Card');

insert into CustomerOrder ( CustomerID, TransacDate, PayMethod )
values ( 192, to_date( '06/20/2020', 'MM/DD/YYYY'), 'Cash');

----------- CustomerOrder Table is now complete with test data  ---------------

-----------------------------------------------------------------------------
--                        CustOrdLineItem Table
-----------------------------------------------------------------------------

-- CSV file data uploaded and table 'LineItemData' created

-- add data to empty columns

update LineItemData
set 
    ProductID = round( dbms_random.value( 1, 162 )),
    Quantity = round( dbms_random.value( 1, 100 ))
;

-- transfer data into custOrdLineItem

insert into CustOrdLineItem ( CustOrderID, ProductID, Quantity )
select
    CustOrderID,
    ProductID,
    Quantity
from LineItemData
where rownum <= 101
;

---------- CustOrdLineItem Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                        Warehouse Table
-----------------------------------------------------------------------------

-- insert data from CSV uploaded data 'WHData'
insert into Warehouse ( WHName, WHCapacity, WHLocation )
select  
    WHName,
    WHCapacity,
    WHLocation
from WHData
where rownum <= 10
;

---------- Warehouse Table is now complete with test data  --------------


-----------------------------------------------------------------------------
--                        Inventory Table
-----------------------------------------------------------------------------

-- add data to empty columns

update InventoryData
set 
    ProductID = round( dbms_random.value( 1, 162 )),
    StockLevel = round( dbms_random.value( 1, 2000 ))
;

-- insert data from CSV uploaded data

insert into Inventory ( WarehouseID, ProductID, StockLevel )
select  
    WarehouseID,
    ProductID,
    StockLevel
from InventoryData
where rownum <= 251
;

---------- Inventory Table is now complete with test data  --------------

-----------------------------------------------------------------------------
--                      All Essential Tables now complete                  --
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--                      Additional tables utilising PL/SQL                 --
-----------------------------------------------------------------------------

update Employee 
set
    SalaryTax = getSalaryTax( Salary )
;

