
-- Creating Table Cube with Main Dimensions and Sales Transitions

select 
        DimensionCustomer.Customer,
       DimensionCustomer.State,
       DimensionCustomer.Sex,
       DimensionCustomer.Status,
       FactSales.Quantity,
       FactSales.UnitaryValue,
       FactSales.TotalValue,
       FactSales.Discount,
       DimensionProduct.Product,
       DimensionTime.Data,
       DimensionTime.Day,
       DimensionTime.Month,
       DimensionTime.Year,
       DimensionTime.Quarter,
       DimensionSeller.Name
       
     INTO Dimensional.CubeSales
  from Dimensional.DimensionCustomer
       inner join
        Dimensional.FactSales
         on (Dimensional.FactSales.KeyCustomer = Dimensional.DimensionCustomer.KeyCustomer)
       inner join 
        Dimensional.DimensionProduct
         on (Dimensional.DimensionProduct.KeyProduct = Dimensional.FactSales.KeyProduct)
       inner join 
        Dimensional.DimensionTime
         on (Dimensional.DimensionTime.KeyTime = Dimensional.FactSales.KeyTime)
       inner join 
        Dimensional.DimensionSeller
         on (Dimensional.DimensionSeller.KeySeller = Dimensional.FactSales.KeySeller)