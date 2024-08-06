-- UPLOAD COSTUMERS DATA (1ST LOUD ) 
WITH S AS (
     Select * From Relational.Customers
),
UPD AS (
     UPDATE Dimensional.DimensionCustomer T
     SET    EndDateValidity = current_date
     FROM   S
     WHERE  (T.IDCustomer = S.IDCustomer AND T.EndDateValidity is null) 
          AND (T.Customer <> S.Customer OR T.State <> S.State OR T.Sex <> S.Sex OR T.Status <> S.Status) 
     RETURNING T.IDCustomer
)

     
INSERT INTO Dimensional.DimensionCustomer(IDCustomer, Customer, State, Sex, Status, StartDateValidity, EndDateValidity)
SELECT IDCustomer, Customer, State, Sex, Status, current_date, null FROM S
WHERE S.IDCustomer IN (SELECT IDCustomer FROM UPD) OR
       S.IDCustomer NOT IN (SELECT IDCustomer FROM Dimensional.DimensionCustomer)


-- UPLOAD DATA PRODUCTS (1ST LOAD) 
WITH S AS (
     Select * From Relational.Products
),
UPD AS (
     UPDATE Dimensional.DimensionProduct T
     SET    EndDateValidity = current_date
     FROM   S
     WHERE  (T.IDProduct = S.IDProduct AND T.EndDateValidity is null) 
          AND (T.Product <> S.Product)
     RETURNING T.IDProduct
)
INSERT INTO Dimensional.DimensionProduct(IDProduct, Product, StartDateValidity, EndDateValidity)
SELECT IDProduct, Product, current_date, null FROM S
WHERE S.IDProduct IN (SELECT IDProduct FROM UPD) OR
       S.IDProduct NOT IN (SELECT IDProduct FROM Dimensional.DimensionProduct)

	  
-- LOADING SELLERS' DATA (1st LOAD) 
WITH S AS (
     Select * From Relational.Sellers
),
UPD AS (
     UPDATE Dimensional.DimensionSeller T
     SET    EndDateValidity = current_date
     FROM   S
     WHERE  (T.IDSeller = S.IDSeller AND T.EndDateValidity is null) 
          AND (T.Name <> S.Name)  
     RETURNING T.IDSeller
)
INSERT INTO Dimensional.DimensionSeller(IDSeller, Name, StartDateValidity, EndDateValidity)
SELECT IDSeller, Name, current_date, null FROM S
WHERE S.IDSeller IN (SELECT IDSeller FROM UPD) OR
       S.IDSeller NOT IN (SELECT IDSeller FROM Dimensional.DimensionSeller)
       
	  


--UPLOADING DATA ONLY FOR THE MONTH OF JANUARY TO THE FACTSALES TABLE 
--UPLOADING DATA ONLY FOR THE MONTH OF JANUARY TO THE FACTSALES TABLE 
INSERT INTO dimensional.FactSales(keyseller,KeyCustomer,KeyProduct,KeyTime,Quantity,UnitaryValue,TotalValue,discount)
Select
     Vdd.KeySeller,
    C.KeyCustomer,
    P.KeyProduct,
    T.KeyTime,
    IV.Quantity,
    IV.UnitaryValue,
    IV.TotalValue,
    IV.Discount
From Relational.Sales V
Inner Join Dimensional.DimensionSeller Vdd
     On V.IDSeller = Vdd.IDSeller And Vdd.EndDateValidity Is Null /*EndDateValidity IF NULL REPRESENTS THE UPDATED SELLER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Relational.ItemsSales IV
     On V.IDSale = IV.IDSale
Inner Join Dimensional.DimensionCustomer C
     On V.IDCustomer = C.IDCustomer And C.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED CUSTOMER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionProduct P
     On IV.IDProduct = P.IDProduct And P.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED PRODUCTS RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionTime T
     On V.Data = T.Data

Where date_part('MONTH', V.DATA) = 01


-- MAKES CHANGES TO THE STATUS RATING OF CUSTOMERS IN RANGE OF 1 TO 5     
UPDATE RELATIONAL.CUSTOMERS SET STATUS = 'Gold' WHERE IDCUSTOMER BETWEEN 1 AND 5


-- WHEN UPLOADING CUSTOMER DATA, ONLY DATA WITH STATUS 1 TO 5 WILL BE PROCESSED IN THE REGISTRATION HISTORY
WITH S AS (
     Select * From Relational.Customers
),
UPD AS (
     UPDATE Dimensional.DimensionCustomer T
     SET    EndDateValidity = current_date
     FROM   S
     WHERE  (T.IDCustomer = S.IDCustomer AND T.EndDateValidity is null) 
          AND (T.Customer <> S.Customer OR T.state <> S.state OR T.SEX <> S.SEX OR T.STATUS <> S.STATUS)
     RETURNING T.IDCustomer
)
INSERT INTO Dimensional.DimensionCustomer(IDCustomer, Customer,State, Sex, Status, StartDateValidity, EndDateValidity)
SELECT IDCustomer,Customer, State, Sex, Status, current_date, null FROM S
WHERE S.IDCustomer IN (SELECT IDCustomer FROM UPD) OR
       S.IDCustomer NOT IN (SELECT IDCustomer FROM Dimensional.DimensionCustomer)



-- VIEW THE CUSTOMER TABLE TO SEE IF HISTORY OF RECORD STATUS FIELD 1 TO 5 HAS CHANGED
SELECT * FROM DIMENSIONAL.DIMENSIONCUSTOMER WHERE IDCUSTOMER BETWEEN 1 AND 5




-- CHECKS WHETHER THE IDS (IDENTITIES) OF THE SKS (SURROGATE KEYS) ARE POINTING TP THE OLD STATUS 1 TO 5
SELECT * FROM Dimensional.FactSales f
     inner join Dimensional.DimensionCustomer c
     on f.keycustomer = c.keycustomer
where c.idcustomer between 1 and 5

--Note:
---The data load in the datawarehouse follows these steps so that the changes are shown in the simulated data in the relational model, 
---and how this history of changes was maintained in the Datawarehouse, even if in the relational model in the transactional database this 
---old information was lost



-- ONLY LOADED THE MONTH FEBRUARY IN THE FACTSALES TABLE
INSERT INTO Dimensional.FactSales(KeySeller,KeyCustomer,KeyProduct,KeyTime,Quantity,UnitaryValue,TotalValue,Discount)
Select
     Vdd.KeySeller,
     C.KeyCustomer,
     P.KeyProduct,
     T.KeyTime,
     IV.Quantity,
     IV.UnitaryValue,
     IV.TotalValue,
     IV.Discount
From Relational.Sales V
Inner Join Dimensional.DimensionSeller Vdd
     On V.IDSeller = Vdd.IDSeller And Vdd.EndDateValidity Is Null /*EndDateValidity IF NULL REPRESENTS THE UPDATED SELLER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Relational.ItemsSales  IV
     On V.IDSale = IV.IDSale
Inner Join Dimensional.DimensionCustomer C
     On V.IDCustomer = C.IDCustomer And C.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED CUSTOMER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionProduct P
     On IV.IDProduct = P.IDProduct And P.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED PRODUCTS RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionTime T
     On V.Data = T.Data

Where date_part('MONTH', V.DATA) = 02



--VIEW THE CUSTOMER TABLE TO SEE IF HISTORY OF RECORD STATUS FIELD 1 TO 5 HAS CHANGED
--IN FEBRUARY, ONLY CUSTOMERS WITH STATUS=5 MADE PURCHASES
--RECORDS IN THE FACTSALES TABLE ALREADY POINT FOR UPDATED RECORDS
SELECT * FROM Dimensional.FactSales f
   inner join Dimensional.DimensionCustomer c    
     on f.KeyCustomer = c.KeyCustomer
where c.idcustomer between 1 and 5


 --UPLOADING DATA ONLY FOR THE MONTH OF MARCH TO THE FACTSALES TABLE 
INSERT INTO dimensional.fatovendas(chavevendedor, chavecliente, chaveproduto, chavetempo, quantidade, valorunitario, valortotal, desconto)
Select
	Vdd.ChaveVendedor,
    C.ChaveCliente,
    P.ChaveProduto,
    T.ChaveTempo,
    IV.Quantidade,
    IV.ValorUnitario,
    IV.ValorTotal,
    IV.Desconto
From Relacional.Vendas V
Inner Join Dimensional.DimensaoVendedor Vdd
	On V.IDVendedor = Vdd.IDVendedor And Vdd.DataFimValidade Is Null /*EndDateValidity IF NULL REPRESENTS THE UPDATED SELLER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Relacional.ItensVenda IV
	On V.IDVenda = IV.IDVenda
Inner Join Dimensional.DimensaoCliente C
	On V.IDCliente = C.IDCliente And C.DataFimValidade Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED CUSTOMER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
	On IV.IDProduto = P.IDProduto And P.DataFimValidade Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED PRODUCTS RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensaoTempo T
	On V.Data = T.Data

Where date_part('MONTH', V.DATA) = 03


--IN MARCH, NONE OF THE CUSTOMERS WE ARE MONITORING MADES A PURSHAGE
SELECT * FROM Dimensional.FactSales f
     inner join Dimensional.DimensionCustomer c
     on f.KeyCustomer = c.KeyCustomer
    inner join Dimensional.DimensionTime t
     on f.KeyTime = t.KeyTime 
where c.idcustomer between 1 and 5 and t.month = 3


-- CHANGES CUSTOMER STATUS 3
UPDATE RELATIONAL.CUSTOMERS SET STATUS = 'Platinum' WHERE IDCUSTOMER = 3


-->>>> parei aqui -- 21-06-2024


-- LOAD CUSTOMER DATA. ONLY UPDATE THE RECORD HISTORY WITH CHANGES (CUSTOMER 3)
WITH S AS (
     Select * From Relational.Customers
),
UPD AS (
     UPDATE Dimensional.DimensionCustomer T
     SET    EndDateValidity = current_date
     FROM   S
     WHERE  (T.IDCustomer = S.IDCustomer AND T.EndDateValidity is null) 
          AND (T.Customer <> S.Customer OR T.State <> S.State OR T.Sex <> S.Sex OR T.STATUS <> S.STATUS)
     RETURNING T.IDCustomer
)
INSERT INTO Dimensional.DimensionCustomer(IDCustomer, Customer, State, Sex, Status, StartDateValidity,EndDateValidity)
SELECT IDCustomer, Customer, State, Sex, Status, current_date, null FROM S
WHERE S.IDCustomer IN (SELECT IDCustomer FROM UPD) OR
       S.IDCustomer NOT IN (SELECT IDCustomer FROM Dimensional.DimensionCustomer)



--CONSULTATION WITH CHANGED CUSTOMERS TO CHECK HISTORY OF EACH CUSTOMER. FIELD DATA IS UP TO DATE
SELECT * FROM DIMENSIONAL.DIMENSIONCUSTOMER WHERE IDCUSTOMER BETWEEN 1 AND 5

-- UPLOAD DATA ONLY FROM THE OTHER MISSING MONTHS
INSERT INTO Dimensional.FactSales(KeySeller,KeyCustomer,KeyProduct,KeyTime,Quantity,UnitaryValue,TotalValue,Discount)
Select
     Vdd.KeySeller,
     C.KeyCustomer,
     P.KeyProduct,
     T.KeyTime,
     IV.Quantity,
     IV.UnitaryValue,
     IV.TotalValue,
     IV.Discount
From Relational.Sales V
Inner Join Dimensional.DimensionSeller Vdd
     On V.IDSeller = Vdd.IDSeller And Vdd.EndDateValidity Is Null /*EndDateValidity IF NULL REPRESENTS THE UPDATED SELLER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Relational.ItemsSales  IV
     On V.IDSale = IV.IDSale
Inner Join Dimensional.DimensionCustomer C
     On V.IDCustomer = C.IDCustomer And C.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED CUSTOMER RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionProduct P
     On IV.IDProduct = P.IDProduct And P.EndDateValidity Is Null /*DateEndValidate IF NULL REPRESENTS THE UPDATED PRODUCTS RECORD FOR THE DATA CURRENTLY
LOADED INTO THE SALESFACT TABLE */
Inner Join Dimensional.DimensionTime T
     On V.Data = T.Data

Where date_part('MONTH', V.DATA) > 03


-- CHECK ALL PURCHASES FROM THE CUSTOMERS WE ARE MONITORING (1 TO 5)
-- WE VERIFY THAT THERE WERE PURCHASES WITH OLD SK(SURROGATE KEY) , BUT NOW NEW PURCHASES WERE MADE THE NEW UPADATED STATUS DATA OF NEW SK (SURROGATE KEY) IS NOW APPEARING
SELECT * FROM Dimensional.FactSales f
     inner join Dimensional.DimensionCustomer c
     on f.KeyCustomer  = c.KeyCustomer
    inner join Dimensional.DimensionTime t
     on f.KeyTime = t.KeyTime
where c.IdCustomer between 1 and 5