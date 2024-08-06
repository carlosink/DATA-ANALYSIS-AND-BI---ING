CREATE SCHEMA Dimensional;
CREATE SCHEMA Relational;

CREATE SEQUENCE Dimensional.KeySeller;
CREATE TABLE Dimensional.DimensionSeller(
  KeySeller int default nextval('Dimensional.KeySeller'::regclass) PRIMARY KEY,
  IDSeller int,
  Name Varchar(50),
  StartDateValidity date not null,
  EndDateValidity date
);

CREATE SEQUENCE Dimensional.KeyCustomer;
CREATE TABLE Dimensional.DimensionCustomer(
  KeyCustomer int default nextval('Dimensional.KeyCustomer'::regclass) PRIMARY KEY,
  IDCustomer int,
  Customer Varchar(50),
  State Varchar(2),
  Sex Char(1),
  Status Varchar(50),
  StartDateValidity date not null,
  EndDateValidity date
);

CREATE SEQUENCE Dimensional.KeyProduct;
CREATE TABLE Dimensional.DimensionProduct(
  KeyProduct int default nextval('Dimensional.KeyProduct'::regclass) PRIMARY KEY,
  IDProduct int,
  Product Varchar(100),
  StartDateValidity date not null,
  EndDateValidity date

);

CREATE SEQUENCE Dimensional.KeyTime;
CREATE TABLE Dimensional.DimensionTime(
  KeyTime int default nextval('Dimensional.KeyTime'::regclass) PRIMARY KEY,
  Data Date,
  Month int,
  Day int,
  Year int,
  DayWeek int,
  Quarter int
);

CREATE SEQUENCE Dimensional.KeySales;
CREATE TABLE Dimensional.FactSales(
  KeySales int default nextval('Dimensional.KeySales'::regclass) PRIMARY KEY,
  KeySeller int references Dimensional.DimensionSeller (KeySeller),
  KeyCustomer int references Dimensional.DimensionCustomer (KeyCustomer),
  KeyProduct int references Dimensional.DimensionProduct (KeyProduct),
  KeyTime int references Dimensional.DimensionTime (KeyTime),
  Quantity int,
  UnitaryValue Numeric(10,2),
  TotalValue Numeric(10,2),
  Discount Numeric(10,2)
);

CREATE SEQUENCE Relational.IDSeller;
CREATE TABLE Relational.Sellers(
  IDSeller int default nextval('Relational.IDSeller'::regclass) PRIMARY KEY,
  Name Varchar(50)
);

CREATE SEQUENCE Relational.IDProduct;
CREATE TABLE Relational.Products(
  IDProduct int default nextval('Relational.IDProduct'::regclass) PRIMARY KEY,
  Product Varchar(100),
  Price Numeric(10,2)
);

CREATE SEQUENCE Relational.IDCustomer;
CREATE TABLE Relational.Customers(
  IDCustomer int default nextval('Relational.IDCustomer'::regclass) PRIMARY KEY,
  Customer Varchar(50),
  State Varchar(2),
  Sex Char(1),
  Status Varchar(50)
);

CREATE SEQUENCE Relational.IDSale;
CREATE TABLE Relational.Sales(
  IDSale int default nextval('Relational.IDSale'::regclass) PRIMARY KEY,
  IDSeller int references Relational.Sellers (IDSeller),
  IDCustomer int references Relational.Customers (IDCustomer),
  Data Date,
  Total Numeric(10,2)
);

CREATE TABLE Relational.ItemsSales (
    IDProduct int REFERENCES Relational.Products ON DELETE RESTRICT, 
    IDSale int REFERENCES Relational.Sales ON DELETE CASCADE,
    Quantity int,
    UnitaryValue decimal(10,2),
    TotalValue decimal(10,2),
    Discount decimal(10,2),
    PRIMARY KEY (IDProduct, IDSale)
);


