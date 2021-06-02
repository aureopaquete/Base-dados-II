------------------------------------------ Criação da Tabela MIDIA ------------------------------------------------------------
DROP TABLE MIDIA;
CREATE TABLE midia (
    midia_id   NUMBER(6) NOT NULL,
    name       VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE midia ADD CONSTRAINT midia_pk PRIMARY KEY ( midia_id );
/
------------------------------------------ Inserir dados rondom na tabela MIDIA -----------------------------------------------

create or replace procedure insert_tabela_MIDIA is 

TYPE NAMESARRAY IS VARRAY (5) OF MIDIA.NAME%TYPE;


V_MIDIA_ID MIDIA.MIDIA_ID%TYPE;
V_NAME MIDIA.NAME%TYPE;
V_VALOR_MAX NUMBER(2) := 50;
V_VALOR_MIN NUMBER(2) := 1;
NAME NAMESARRAY;
V_RAND NUMBER(1);


begin
    DELETE MIDIA;
                                       
    NAME := NAMESARRAY('FACEBOOK','TWITTER','SPOTFY','YOUTUBE','INSTAGRAM');                              
                                    

    for I in V_VALOR_MIN..V_VALOR_MAX LOOP
        
        V_MIDIA_ID := I;
        V_RAND := TRUNC(DBMS_RANDOM.VALUE(1,NAME.COUNT + 1)); 
        V_NAME := NAME(V_RAND);
       
      
  
    insert into MIDIA (
            MIDIA_ID,
            NAME
        ) values (
            V_MIDIA_ID,
            V_NAME
        );
    END LOOP; 
end;
/

EXEC insert_tabela_MIDIA;



select * FROM MIDIA;



---------------------------------------------------------- GITHUB --------------------------------------------------------------



------------------------------------------------- Criação da Tabela MARKETING ------------------------------------------------
DROP TABLE marketing;
CREATE TABLE marketing (
    marketing_id     NUMBER(6) NOT NULL,
    name             VARCHAR2(50) NOT NULL,
    description      VARCHAR2(50) NOT NULL,
    midia_midia_id   NUMBER(6) NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    category         VARCHAR2(50) NOT NULL,
    cost             NUMBER(8,2) NOT NULL
)
LOGGING;

ALTER TABLE marketing ADD CONSTRAINT marketing_pk PRIMARY KEY ( marketing_id );

ALTER TABLE marketing
    ADD CONSTRAINT marketing_midia_fk FOREIGN KEY ( midia_midia_id )
        REFERENCES midia ( midia_id )
    NOT DEFERRABLE;
    
/




----------------------------------------- Inserir dados rondom na tabela MARKETING -----------------------------------------------

create or replace PROCEDURE insert_tabela_MARKETING IS 


V_MARKETING_ID MARKETING.MARKETING_ID%TYPE;
V_NAME MARKETING.NAME%TYPE;
V_MIDIA_ID MARKETING.MIDIA_MIDIA_ID%TYPE;
V_FK_MARKETING SALES.MARKETING_ID%TYPE;
V_CATEGORY MARKETING.CATEGORY%TYPE;
V_COST MARKETING.COST%TYPE;
V_START_DATE DATE;
V_END_DATE DATE;
V_DESCRIPTION MARKETING.DESCRIPTION%TYPE;
V_COUNT NUMBER(6);
V_RAND NUMBER(6);
V_VALOR_MAX NUMBER(6);
V_VALOR_MIN NUMBER(6);



BEGIN
    


    SELECT MIN(MARKETING_ID),MAX(MARKETING_ID)-- + TRUNC(dbms_random.VALUE())
    INTO V_VALOR_MIN, V_VALOR_MAX
    FROM SALES;


    for I in V_VALOR_MIN..V_VALOR_MAX LOOP
    
    
          --- MIDIA_ID ---
        SELECT COUNT(*)INTO V_COUNT FROM MIDIA; -- Conta registos na Lookup 
        V_RAND := TRUNC(dbms_random.VALUE(0,V_COUNT)); -- pega um aleatoriamente
        SELECT MIDIA_ID INTO V_MIDIA_ID FROM MIDIA
        OFFSET V_RAND ROWS 
        FETCH FIRST 1 ROW ONLY;
    

        --- ID ---
        V_MARKETING_ID := I;  
        
        --- NAME ---    
        SELECT COUNT(*) INTO V_COUNT FROM MIDIA;
        V_NAME := TRUNC(DBMS_RANDOM.VALUE(0,V_COUNT));
        SELECT NAME INTO V_NAME FROM MIDIA
        OFFSET V_RAND ROWS
        FETCH FIRST 1 ROW ONLY;      
        
        --- DESCRIPTIONS ---
        SELECT COUNT(*) INTO V_COUNT FROM PRODUCT_DESCRIPTIONS;
        V_RAND := TRUNC(dbms_random.VALUE(0,V_COUNT));
        SELECT PROD_NAME INTO V_DESCRIPTION FROM PRODUCT_DESCRIPTIONS 
        OFFSET V_RAND ROWS
        FETCH FIRST 1 ROW ONLY;
      
        
       --- DATE ---
        V_START_DATE := TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2458000,2460000)),'J');
        V_END_DATE := TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(V_START_DATE,'J'),2460000)),'J');

        --- CATEGORY ---
        SELECT COUNT(*) INTO V_COUNT FROM CATEGORIES;
        V_RAND := TRUNC(dbms_random.VALUE(0,V_COUNT));
        SELECT PROD_CATEGORY INTO V_CATEGORY FROM CATEGORIES 
        OFFSET V_RAND ROWS
        FETCH FIRST 1 ROW ONLY;
        
        
        --- COST ---
    
        
        V_COST := TRUNC(dbms_random.value(100,500));

        
        



        INSERT INTO MARKETING(
            MARKETING_ID,
            NAME,
            DESCRIPTION,
            MIDIA_MIDIA_ID,
            START_DATE,
            END_DATE,           
            CATEGORY,
            COST
        )VALUES(
            V_MARKETING_ID,
            V_NAME,     
            V_DESCRIPTION,
            V_MIDIA_ID,
            V_START_DATE,
            V_END_DATE,
            V_CATEGORY,
            V_COST
        );

    END LOOP;


END;
/

EXEC insert_tabela_MARKETING;


GRANT SELECT ON MARKETING to bdii_1012639;

GRANT SELECT ON MIDIA to bdii_1012639;




---------------------------------------------------------GITHUB-----------------------------------------------------------------

--------------------------------------------- Criação das tabelas DIM E MINDIM -------------------------------------------------
------------------------------------------------- Criação das tabelas ----------------------------------------------------
CREATE TABLE dim_customers (
    cust_sk                  NUMBER(6) NOT NULL,
    cust_id                  NUMBER NOT NULL,
    cust_first_name          VARCHAR2(20 BYTE)
        CONSTRAINT ckc_cust_first_name_customer NOT NULL,
    cust_last_name           VARCHAR2(40 BYTE)
        CONSTRAINT ckc_cust_last_name_customer NOT NULL,
    cust_gender              CHAR(1 BYTE),
    cust_year_of_birth       NUMBER(4) NOT NULL,
    cust_marital_status      VARCHAR2(20 BYTE),
    cust_street_address      VARCHAR2(40 BYTE)
        CONSTRAINT ckc_cust_street_addre_customer NOT NULL,
    cust_postal_code         VARCHAR2(10 BYTE)
        CONSTRAINT ckc_cust_postal_code_customer NOT NULL,
    cust_main_phone_number   VARCHAR2(25 BYTE),
    cust_income_level        VARCHAR2(30 BYTE),
    cust_credit_limit        NUMBER,
    cust_email               VARCHAR2(30 BYTE),
    cust_total               VARCHAR2(14 BYTE),
    cust_city                VARCHAR2(12 BYTE) NOT NULL,
    cust_month_of_birth      NUMBER(2) NOT NULL,
    cust_birth_date          DATE NOT NULL,
    cust_day_of_birth        NUMBER(2) NOT NULL,
    mindim_cities_city_sk    NUMBER(6) NOT NULL
);

ALTER TABLE dim_customers ADD CONSTRAINT dim_customers_pk PRIMARY KEY ( cust_sk );

ALTER TABLE dim_customers
    ADD CONSTRAINT dim_customers_mindim_cities_fk FOREIGN KEY ( mindim_cities_city_sk )
        REFERENCES mindim_cities ( city_sk );
        
---------------------------------------------



CREATE TABLE dim_employee (
    employee_sk      NUMBER(6) NOT NULL,
    employee_id      NUMBER(6) NOT NULL,
    first_name       VARCHAR2(15 BYTE),
    last_name        VARCHAR2(12 BYTE),
    email            VARCHAR2(30 BYTE),
    phone_number     VARCHAR2(20 BYTE),
    hire_date        DATE,
    job_id           VARCHAR2(10 BYTE),
    salary           NUMBER(12),
    commission_pct   NUMBER(5,3),
    manager_id       NUMBER(10)
);

ALTER TABLE dim_employee ADD CONSTRAINT employee_pk PRIMARY KEY ( employee_sk );

-----------------------------------------------



CREATE TABLE mindim_salary (
    salary_sk                  NUMBER(6) NOT NULL,
    sal                        NUMBER(6,2) NOT NULL,
    com                        NUMBER(6,2) NOT NULL,
    dim_employee_employee_sk   NUMBER(6) NOT NULL
);

ALTER TABLE mindim_salary ADD CONSTRAINT mindim_salary_pk PRIMARY KEY ( salary_sk );

ALTER TABLE mindim_salary
    ADD CONSTRAINT mindim_salary_dim_employee_fk FOREIGN KEY ( dim_employee_employee_sk )
        REFERENCES dim_employee ( employee_sk );
        
------------------------------------------------



CREATE TABLE mindim_cities (
    city_sk             NUMBER(6) NOT NULL,
    city                VARCHAR2(50) NOT NULL,
    country_name        VARCHAR2(50) NOT NULL,
    country_subregion   VARCHAR2(50),
    country_region      VARCHAR2(50),
    state_province      VARCHAR2(50),
    gender              CHAR(1)
);

ALTER TABLE mindim_cities ADD CONSTRAINT dim_cities_pk PRIMARY KEY ( city_sk );


        
-------------------------------------------------



CREATE TABLE dim_marketing (
    marketing_sk     NUMBER(6) NOT NULL,
    marketing_id     NUMBER(6) NOT NULL,
    name             VARCHAR2(50) NOT NULL,
    description      VARCHAR2(50) NOT NULL,
    midia_id   NUMBER(6) NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    category         VARCHAR2(50) NOT NULL,
    cost             NUMBER(8,2) NOT NULL
   
);

ALTER TABLE dim_marketing ADD CONSTRAINT dim_marketing_pk PRIMARY KEY ( marketing_sk );



--------------------------------------------------
CREATE TABLE dim_products (
    prod_sk                NUMBER(6) NOT NULL,
    prod_id                NUMBER NOT NULL,
    prod_name              VARCHAR2(50)
        CONSTRAINT ckc_prod_name_prod_desc NOT NULL,
    --sub_cat_id             NUMBER(6) NOT NULL,
    prod_weight_class      NUMBER(2),
    prod_unit_of_measure   VARCHAR2(20 BYTE),
    prod_pack_size         VARCHAR2(30 BYTE),
    prod_status            VARCHAR2(20 BYTE)
        CONSTRAINT ckc_prod_status_products NOT NULL,
    prod_list_price        NUMBER(8,2)
        CONSTRAINT ckc_prod_list_price_products NOT NULL,
    prod_min_price         NUMBER(8,2)
        CONSTRAINT ckc_prod_min_price_products NOT NULL,
    --prod_descriptions_id   NUMBER(6) NOT NULL,
    prod_cost              NUMBER(8,2),
    prod_desc              VARCHAR2(4000 BYTE)
        CONSTRAINT ckc_prod_desc_prod_desc NOT NULL,
    prod_category          VARCHAR2(50) NOT NULL,
    prod_subcategory       VARCHAR2(50 BYTE)
        CONSTRAINT ckc_prod_subcategory_sub_cate NOT NULL
);


ALTER TABLE dim_products ADD CONSTRAINT dim_products_pk PRIMARY KEY ( prod_sk );



----------------------------------------------------



CREATE TABLE dim_date (
    date_id        NUMBER(9) NOT NULL,
    day_of_year    NUMBER(3) NOT NULL,
    day_of_month   NUMBER(2) NOT NULL,
    day_of_week    NUMBER(1) NOT NULL,
    week_month     NUMBER(4) NOT NULL,
    month          NUMBER(9) NOT NULL,
    trimester      NUMBER(1) NOT NULL,
    year           NUMBER(4) NOT NULL
);

ALTER TABLE dim_date ADD CONSTRAINT date_pk PRIMARY KEY ( date_id );

DROP TABLE DIM_DATE;
-------------------------------------------------------


CREATE TABLE dim_time (
    time_id   NUMBER(9) NOT NULL,
    name      VARCHAR2(50 BYTE) NOT NULL
);

ALTER TABLE dim_time ADD CONSTRAINT dim_time_pk PRIMARY KEY ( time_id );



---------------------------------------------------------

CREATE TABLE fact_sales (
    quantity_sold                NUMBER(9) NOT NULL,
    amount_sold                  NUMBER(9,2) NOT NULL,
    dim_date_date_id             NUMBER(6) NOT NULL,
    dim_employee_employee_sk     NUMBER(6) NOT NULL,
    dim_marketing_marketing_sk   NUMBER(6) NOT NULL,
    dim_products_prod_sk         NUMBER(6) NOT NULL,
    dim_customers_cust_sk        NUMBER(6) NOT NULL,
    mindim_cities_city_sk        NUMBER(6) NOT NULL,
    mindim_salary_salary_sk      NUMBER(6) NOT NULL,
    dim_time_time_id             NUMBER(9) NOT NULL
);

ALTER TABLE fact_sales
    ADD CONSTRAINT sales_pk PRIMARY KEY ( dim_date_date_id,
                                          dim_customers_cust_sk,
                                          dim_products_prod_sk,
                                          dim_marketing_marketing_sk,
                                          dim_employee_employee_sk,
                                          mindim_cities_city_sk,
                                          mindim_salary_salary_sk,
                                          dim_time_time_id );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_customers_fk FOREIGN KEY ( dim_customers_cust_sk )
        REFERENCES dim_customers ( cust_sk );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_date_fk FOREIGN KEY ( dim_date_date_id )
        REFERENCES dim_date ( date_id );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_employee_fk FOREIGN KEY ( dim_employee_employee_sk )
        REFERENCES dim_employee ( employee_sk );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_marketing_fk FOREIGN KEY ( dim_marketing_marketing_sk )
        REFERENCES dim_marketing ( marketing_sk );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_products_fk FOREIGN KEY ( dim_products_prod_sk )
        REFERENCES dim_products ( prod_sk );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_dim_time_fk FOREIGN KEY ( dim_time_time_id )
        REFERENCES dim_time ( time_id );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_mindim_cities_fk FOREIGN KEY ( mindim_cities_city_sk )
        REFERENCES mindim_cities ( city_sk );

ALTER TABLE fact_sales
    ADD CONSTRAINT fact_sales_mindim_salary_fk FOREIGN KEY ( mindim_salary_salary_sk )
        REFERENCES mindim_salary ( salary_sk );
        
        
             

---------------------------------------------------------GITHUB-----------------------------------------------------------------

----------------------------------------- Carregamento das ETL -------------------------------------

drop synonym MIDIA;
drop synonym MARKETING;

create synonym MARKETING for BDII_1012385.MARKETING; 
create synonym MIDIA for BDII_1012385.MIDIA; 

SELECT * FROM MARKETING;
SELECT * FROM MIDIA;



CREATE SEQUENCE DIM_MARKETING_SEQ;

CREATE OR REPLACE PROCEDURE  ETL_DIM_MARKETING IS
BEGIN
    
    INSERT INTO DIM_MARKETING(
                     MARKETING_SK,               
                     MARKETING_ID,
                     NAME,
                     DESCRIPTION,
                     MIDIA_ID,
                     START_DATE,
                     END_DATE,
                     CATEGORY,
                     COST
                   
    )
    SELECT DIM_MARKETING_SEQ.NEXTVAL,
           MARKETING_ID,
           MARKETING.NAME,
           MARKETING.DESCRIPTION,
           MIDIA.MIDIA_ID,
           MARKETING.START_DATE,
           MARKETING.END_DATE,
           MARKETING.CATEGORY,
           MARKETING.COST
    FROM MARKETING,MIDIA 
    WHERE MARKETING.MIDIA_MIDIA_ID = MIDIA.MIDIA_ID
        AND MARKETING_ID NOT IN(
          SELECT MARKETING_ID
          FROM DIM_MARKETING
        );
END;
/


EXEC ETL_DIM_MARKETING;


/


SELECT MIN(MARKETING_SK) FROM DIM_MARKETING;



--------------------------------- DIM PRODUCTS ------------------------------------------



create or replace PROCEDURE  ETL_DIM_PRODUCTS IS
BEGIN

    INSERT INTO DIM_PRODUCTS(
                     PROD_SK,               
                     PROD_ID,
                     PROD_NAME,                    
                     prod_weight_class,
                     prod_unit_of_measure,
                     prod_pack_size,
                     prod_status,
                     prod_list_price,
                     prod_min_price,                     
                     prod_cost,
                     prod_desc,
                     prod_subcategory,
                     PROD_CATEGORY      

    )
    SELECT DIM_PRODUCTS_SEQ.NEXTVAL,
           PROD_ID,
           PROD_NAME,
           PROD_WEIGHT_CLASS,
           NVL(PROD_UNIT_OF_MEASURE,'Não Tem'),
           PROD_PACK_SIZE,
           PROD_STATUS,
           PROD_LIST_PRICE,
           PROD_MIN_PRICE,
           PROD_COST,
           PROD_DESC,
           PROD_SUBCATEGORY,
           PROD_CATEGORY
    FROM PRODUCTS, PRODUCT_DESCRIPTIONS, SUB_CATEGORIES,CATEGORIES
    WHERE PRODUCTS.SUB_CAT_ID = SUB_CATEGORIES.SUB_CAT_ID
        AND PRODUCTS.PROD_DESCRIPTIONS_ID = PRODUCT_DESCRIPTIONS.PROD_DESC_ID
        AND SUB_CATEGORIES.CAT_ID = CATEGORIES.CAT_ID
        AND PROD_ID NOT IN(
          SELECT PROD_ID
          FROM DIM_PRODUCTS
        );
END;
/

EXEC ETL_DIM_PRODUCTS;

SELECT count(MARKETING_SK) FROM DIM_MARKETING;
SELECT count(PROD_SK) FROM DIM_PRODUCTS;





--------------------------------------------- DIM TIME-------------------------------------------------


CREATE OR REPLACE PROCEDURE ETL_DIM_TIME IS

T_COUNT NUMBER(1);

BEGIN

    SELECT COUNT(*)
    INTO T_COUNT
    FROM DIM_TIME;
    
    IF T_COUNT = 0 THEN
        INSERT INTO DIM_TIME(TIME_ID, NAME)VALUES(1,'MORNING');
        INSERT INTO DIM_TIME(TIME_ID, NAME)VALUES(2,'EVENING');
    END IF;
END;
/

EXEC ETL_DIM_TIME;

SELECT * FROM DIM_TIME;



------------------------------------------------- ETL_DATE --------------------------------------------------
CREATE SEQUENCE DIM_DATE_SEQ;
 



CREATE OR REPLACE PROCEDURE ETL_DIM_DATE (YEAR_INIT NUMBER, YEAR_END NUMBER) IS

BEGIN 

IF YEAR_INIT < YEAR_END THEN 
        FOR CURRENT_YEAR IN YEAR_INIT..YEAR_END LOOP
            ETL_YEAR(CURRENT_YEAR);
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ano final que ser maior inicial');
    END IF;  
END;
/




CREATE OR REPLACE PROCEDURE ETL_YEAR( E_YEAR NUMBER) IS

--V_DATE_ID DIM_DATE.DATE_ID%TYPE;
V_DAY_OF_YEAR DIM_DATE.DAY_OF_YEAR%TYPE;
V_DAY_OF_MONTH DIM_DATE.DAY_OF_MONTH%TYPE;
V_DAY_OF_WEEK DIM_DATE.DAY_OF_WEEK%TYPE;
V_MONTH DIM_DATE.MONTH%TYPE;
V_TRIMESTER DIM_DATE.TRIMESTER%TYPE;
V_YEAR DIM_DATE.YEAR%TYPE;
V_WEEK_MONTH DIM_DATE.WEEK_MONTH%TYPE;
V_DATE DATE;
V_NUMBER_DAYS NUMBER(3);
 
BEGIN

  V_NUMBER_DAYS := ADD_MONTHS(TRUNC(TO_DATE('01/01' || E_YEAR, 'DD/MM/YYYY'),'Y'),12)
                                - TRUNC(TO_DATE('01/01' || E_YEAR, 'DD/MM/YYYY'),'Y');
        
  
  FOR I IN 0..(V_NUMBER_DAYS - 1 ) LOOP
    V_DATE := TRUNC(TO_DATE('01/01' || E_YEAR, 'DD/MM/YYYY'),'Y')+ I;
    V_DAY_OF_YEAR := TO_CHAR(V_DATE,'DDD');
    V_DAY_OF_MONTH := TO_CHAR(V_DATE,'DD');
    V_DAY_OF_WEEK := TO_CHAR(V_DATE,'D');
    V_WEEK_MONTH := TO_CHAR(V_DATE,'W');
    V_MONTH := TO_CHAR(V_DATE,'MM');
    V_TRIMESTER := TO_CHAR(V_DATE,'Q'); -- QUARTER DO ANO 1,2,3,4
    V_YEAR := TO_CHAR(V_DATE,'YYYY');




    INSERT INTO DIM_DATE (
            DATE_ID,
            DAY_OF_YEAR,
            DAY_OF_MONTH,
            DAY_OF_WEEK,
            WEEK_MONTH,
            MONTH,
            TRIMESTER,
            YEAR
        )VALUES(
            DIM_DATE_SEQ.NEXTVAL,
            V_DAY_OF_YEAR,
            V_DAY_OF_MONTH,
            V_DAY_OF_WEEK,
            V_WEEK_MONTH,
            V_MONTH,
            V_TRIMESTER,
            V_YEAR            
        );
      END LOOP;
END;
/

EXEC ETL_DIM_DATE(1998,2000);
EXEC ETL_YEAR(2000);


DELETE DIM_DATE;
SELECT * FROM DIM_DATE; 


SELECT * FROM DIM_DATE
order by  DATE_ID,
            DAY_OF_YEAR,
            DAY_OF_MONTH,
            DAY_OF_WEEK,
            WEEK_MONTH,
            MONTH,
            TRIMESTER,
            YEAR ;

SELECT ADD_MONTHS(TRUNC(TO_DATE('01/01/2020', 'DD/MM/YYYY'),'Y'),12)
                                - TRUNC(TO_DATE('01/01/2020', 'DD/MM/YYYY'),'Y') FROM DUAL;

SELECT (ADD_MONTHS(TO_DATE(SYSDATE),12)) FROM DUAL;

SELECT ADD_MONTHS(TRUNC(TO_DATE('01/01/2021', 'DD/MM/YYYY'),'Y'),12) FROM DUAL;

SELECT TRUNC(TO_DATE('01/01/2020', 'DD/MM/YYYY'),'Y') FROM DUAL;


select  year,month,day_of_month,count(*)
from dim_date
group by year,month,day_of_month
having count(*) > 1;

select count(*)/2 from dim_date;
select * from dim_date;




----------------------------------------------------- DIM_MIN --------------------------------------------------------
----------------------------------------------------- CITIES  -----------------------------------------------------

CREATE SEQUENCE ETL_MINDIM_CITIES_SEQ;


CREATE OR REPLACE PROCEDURE ETL_MINDIM_CITIES IS 

BEGIN

    FOR DISTINCT_DATA IN (
        SELECT DISTINCT 
            CITY_ID,
            COUNTRY_NAME,
            COUNTRY_SUBREGIONS.COUNTRY_SUBREGION,
            COUNTRY_REGIONS.COUNTRY_REGION,
            STATE_PROVINCES.STATE_PROVINCE                
            
        FROM                
            CUSTOMERS,
            CITIES,
            COUNTRIES,
            COUNTRY_SUBREGIONS,
            COUNTRY_REGIONS,
            STATE_PROVINCES
            
        WHERE CUSTOMERS.CUST_CITY = CITIES.CITY_ID
            AND CITIES.STATE_PROVINCE = STATE_PROVINCES.STATE_PROVINCE_ID
            AND STATE_PROVINCES.COUNTRY = COUNTRIES.COUNTRY_ID
            AND COUNTRIES.COUNTRY_SUBREGION = COUNTRY_SUBREGIONS.COUNTRY_SUBREGION_ID
            AND COUNTRY_SUBREGIONS.COUNTRY_REGION = COUNTRY_REGIONS.COUNTRY_REGION_ID
            
            
    )LOOP
    
        INSERT INTO MINDIM_CITIES(
            CITY_SK,
            CITY,
            COUNTRY_NAME,
            COUNTRY_SUBREGION,
            COUNTRY_REGION,
            STATE_PROVINCE,
            GENDER  
        )VALUES (
            ETL_MINDIM_CITIES_SEQ.NEXTVAL,
            DISTINCT_DATA.CITY_ID,
            DISTINCT_DATA.COUNTRY_NAME,
            DISTINCT_DATA.COUNTRY_SUBREGION,
            DISTINCT_DATA.COUNTRY_REGION,
            DISTINCT_DATA.STATE_PROVINCE,
            'M'   
        );
        
        
        INSERT INTO MINDIM_CITIES(
            CITY_SK,
            CITY,
            COUNTRY_NAME,
            COUNTRY_SUBREGION,
            COUNTRY_REGION,
            STATE_PROVINCE,
            GENDER  
        )VALUES (
            ETL_MINDIM_CITIES_SEQ.NEXTVAL,
            DISTINCT_DATA.CITY_ID,
            DISTINCT_DATA.COUNTRY_NAME,
            DISTINCT_DATA.COUNTRY_SUBREGION,
            DISTINCT_DATA.COUNTRY_REGION,
            DISTINCT_DATA.STATE_PROVINCE,
            'F'   
        );    
    END LOOP;    
END;
/

EXEC ETL_MINDIM_CITIES;

SELECT * FROM MINDIM_CITIES
ORDER BY CITY_SK,
            CITY,
            COUNTRY_NAME,
            COUNTRY_SUBREGION,
            COUNTRY_REGION,
            STATE_PROVINCE,
            GENDER;
            
SELECT COUNT(*) FROM MINDIM_CITIES;


-------------------------------------------------------- ETL CUSTOMER ---------------------------------------------------------


CREATE SEQUENCE ETL_DIM_CUSTOMERS_SEQ;


CREATE OR REPLACE PROCEDURE ETL_DIM_CUSTOMERS IS

BEGIN

INSERT INTO DIM_CUSTOMERS(

        CUST_SK,
        CUST_ID,
        CUST_FIRST_NAME,
        CUST_LAST_NAME,
        CUST_GENDER,
        CUST_YEAR_OF_BIRTH,
        CUST_MARITAL_STATUS,
        CUST_STREET_ADDRESS,
        CUST_POSTAL_CODE,
        CUST_MAIN_PHONE_NUMBER,
        CUST_INCOME_LEVEL,
        CUST_CREDIT_LIMIT,
        CUST_EMAIL,
        CUST_TOTAL,
        CUST_CITY,
        CUST_MONTH_OF_BIRTH,
        CUST_BIRTH_DATE,
        CUST_DAY_OF_BIRTH,
        MINDIM_CITIES_CITY_SK
    ) SELECT 
        ETL_DIM_CUSTOMERS_SEQ.NEXTVAL,
        CUST_ID,
        CUST_FIRST_NAME,
        CUST_LAST_NAME,
        CUST_GENDER,
        CUST_YEAR_OF_BIRTH,
        NVL(CUST_MARITAL_STATUS, 'Outro'),
        CUST_STREET_ADDRESS,
        CUST_POSTAL_CODE,
        CUST_MAIN_PHONE_NUMBER,
        CUST_INCOME_LEVEL,
        CUST_CREDIT_LIMIT,
        CUST_EMAIL,
        CUST_TOTAL,
        CUST_CITY,
        CUST_MONTH_OF_BIRTH,
        CUST_BIRTH_DATE,
        CUST_DAY_OF_BIRTH,
        MINDIM_CITIES.CITY_SK
    FROM 
       CUSTOMERS, MINDIM_CITIES 
    WHERE CUSTOMERS.CUST_CITY = MINDIM_CITIES.CITY
    AND CUSTOMERS.CUST_GENDER = MINDIM_CITIES.GENDER
        AND CUST_ID NOT IN(
          SELECT CUST_ID
          FROM DIM_CUSTOMERS
        );

END;
/


EXEC ETL_DIM_CUSTOMERS;

DELETE DIM_CUSTOMERS;

SELECT* FROM DIM_CUSTOMERS;


select employee_pk(190) from dual;

select CUST_ID, count(*)
from DIM_CUSTOMERS
group by CUST_ID
having count(*) > 1;





------------------------------------------------- MINDIM_SALRY ---------------------------------------------------

CREATE SEQUENCE MINDIM_SALARY_SEQ;

create or replace PROCEDURE ETL_MINDIM_SALARY IS

    TYPE LEVELARRAY IS VARRAY (5) OF VARCHAR2(1);

V_SAL_LEVEL LEVELARRAY := LEVELARRAY('A','B','C','D');
V_COM_LEVEL LEVELARRAY := LEVELARRAY('A','B','C','D','-');
V_COUNT NUMBER(5);

BEGIN 
    SELECT COUNT(*)
    INTO V_COUNT
    FROM MINDIM_SALARY;

   IF V_COUNT != (V_SAL_LEVEL.COUNT * V_COM_LEVEL.COUNT) THEN
        DELETE FROM MINDIM_SALARY;

        FOR SAL IN 1..V_SAL_LEVEL.COUNT LOOP
           FOR COMM IN 1..V_COM_LEVEL.COUNT LOOP

        INSERT INTO MINDIM_SALARY (
                                    SALARY_SK,
                                    SAL,
                                    COM                                   
                              )VALUES(
                                    MINDIM_SALARY_SEQ.NEXTVAL,
                                    V_SAL_LEVEL(SAL),
                                    V_COM_LEVEL(COMM)
                              );
                    END LOOP;                    
            END LOOP;
       END IF;
END;
/

EXEC ETL_MINDIM_SALARY;
    
DELETE MINDIM_SALARY;    
    
SELECT * FROM MINDIM_SALARY;



------------------------------------------- ETL_DIM_EMPLOYEES -------------------------------------------------------------

INSERT INTO DIM_EMPLOYEE( 
        EMPLOYEE_SK,
        EMPLOYEE_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE_NUMBER,
        HIRE_DATE,
        JOB_ID,
        SALARY,
        COMMISSION_PCT,
        MANAGER_ID,
        MINDIM_SALARY_SALARY_SK
    )VALUES(-1, -1,'SEM','SEM','NADA','SEM', TO_DATE('01/01/1997','DD/MM/YYYY'),'SEM',0,0,0,-1 );


 INSERT INTO MINDIM_SALARY (
                                    SALARY_SK,
                                    SAL,
                                    COM                                   
                              )VALUES(
                                   -1,
                                    '-',
                                    '-'
                              );
SELECT * FROM MINDIM_SALARY;


CREATE SEQUENCE ETL_EMPLOYEES_SEQ;

create or replace PROCEDURE ETL_DIM_EMPLOYEES IS


V_CATEGORY VARCHAR2(1);
V_COMMISSION VARCHAR2(1);


BEGIN

        
    FOR EMPLOYEE IN (SELECT * FROM EMPLOYEES) LOOP
        IF EMPLOYEE.SALARY < 2000 THEN
                V_CATEGORY := 'D';
            ELSIF EMPLOYEE.SALARY < 4000 THEN
                V_CATEGORY := 'C';
            ELSIF EMPLOYEE.SALARY < 6000 THEN
                 V_CATEGORY := 'B';
            ELSE
                V_CATEGORY := 'A';
        END IF;

        IF EMPLOYEE.COMMISSION_PCT IS NULL THEN
                V_COMMISSION := '-';
            ELSIF EMPLOYEE.COMMISSION_PCT < 0.60 THEN
                V_COMMISSION := 'D';
            ELSIF EMPLOYEE.COMMISSION_PCT < 0.75 THEN
                V_COMMISSION := 'C';
            ELSIF EMPLOYEE.COMMISSION_PCT < 0.90 THEN
                V_COMMISSION := 'B';
            ELSE
            V_COMMISSION := 'A';
        END IF;

    INSERT INTO DIM_EMPLOYEE( 
        EMPLOYEE_SK,
        EMPLOYEE_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE_NUMBER,
        HIRE_DATE,
        JOB_ID,
        SALARY,
        COMMISSION_PCT,
        MANAGER_ID,
        MINDIM_SALARY_SALARY_SK
    )VALUES(
        ETL_EMPLOYEES_SEQ.NEXTVAL,
        EMPLOYEE.EMPLOYEE_ID,
        EMPLOYEE.FIRST_NAME,
        EMPLOYEE.LAST_NAME,        
        EMPLOYEE.EMAIL,
        EMPLOYEE.PHONE_NUMBER,
        EMPLOYEE.HIRE_DATE,
        EMPLOYEE.JOB_ID,        
        EMPLOYEE.SALARY,
        NVL(EMPLOYEE.COMMISSION_PCT,0),        
        EMPLOYEE.MANAGER_ID,
        (
            SELECT NVL(SALARY_SK,0)         
            FROM MINDIM_SALARY        
            WHERE SAL = V_CATEGORY        
                AND COM = V_COMMISSION
        )
    );
    END LOOP;
END;
/

EXEC ETL_DIM_EMPLOYEES;

SELECT EMPLOYEE_SK FROM DIM_EMPLOYEE;

SELECT * FROM DIM_EMPLOYEE;



select employee_pk(190) from dual;

select EMPLOYEE_ID, count(*)
from DIM_EMPLOYEE
group by EMPLOYEE_ID
having count(*) > 1;




--------------------------------------------------- SALES FACTS ----------------------------------------------------------------

------------------------------------------------- FUNÇÃO CUSTOMERS -------------------------------------------------------------

CREATE OR REPLACE FUNCTION CUSTOMERS_PK (PK_CUST NUMBER) RETURN NUMBER IS

V_SK_CUST DIM_CUSTOMERS.CUST_SK%TYPE;

BEGIN 
    
    SELECT CUST_SK
    INTO V_SK_CUST
    FROM DIM_CUSTOMERS
    WHERE CUST_ID = PK_CUST;

    RETURN V_SK_CUST;

END;
/


------------------------------------------------- FUNÇÃO EMPLOYEE -------------------------------------------------------------
 
 
CREATE OR REPLACE FUNCTION EMPLOYEE_PK (PK_EMPLOYEE NUMBER) RETURN NUMBER IS

V_SK_EMPLOYEE DIM_EMPLOYEE.EMPLOYEE_SK%TYPE;

BEGIN 
   IF PK_EMPLOYEE IS NOT NULL THEN 
        SELECT EMPLOYEE_SK
        INTO V_SK_EMPLOYEE
        FROM DIM_EMPLOYEE
        WHERE EMPLOYEE_ID = PK_EMPLOYEE;
        
        RETURN V_SK_EMPLOYEE;
   ELSE
        RETURN -1;
  END IF;
  
END;
/

select employee_pk(190) from dual;
select EMPLOYEE_ID, count(*)
from DIM_EMPLOYEE
group by EMPLOYEE_ID
having count(*) > 1;

select count(*) from dim_employee;

select count(distinct employee_id) from sales;

select count(*) from sales where employee_id is null;

SELECT * FROM DIM_EMPLOYEE;
------------------------------------------------- FUNÇÃO PRODUCTS -------------------------------------------------------------


CREATE OR REPLACE FUNCTION PRODUCTS_PK (PK_PRODUCTS NUMBER) RETURN NUMBER IS

V_SK_PRODUCTS DIM_PRODUCTS.PROD_SK%TYPE;

BEGIN 
    
    SELECT PROD_SK
    INTO V_SK_PRODUCTS
    FROM DIM_PRODUCTS
    WHERE PROD_ID = PK_PRODUCTS;

    RETURN V_SK_PRODUCTS;

END;
/

SELECT * FROM DIM_PRODUCTS;



------------------------------------------------- FUNÇÃO MARKETING -------------------------------------------------------------


CREATE OR REPLACE FUNCTION MARKETING_PK (PK_MARKETING NUMBER) RETURN NUMBER IS

V_SK_MARKETING DIM_MARKETING.MARKETING_SK%TYPE;

BEGIN 
    
    SELECT MARKETING_SK
    INTO V_SK_MARKETING
    FROM DIM_MARKETING
    WHERE MARKETING_ID = PK_MARKETING;

    RETURN V_SK_MARKETING;

END;
/


SELECT * FROM DIM_MARKETING;





------------------------------------------------- FUNÇÃO DATE -------------------------------------------------------------

CREATE OR REPLACE FUNCTION DATE_PK (V_DATE DATE) RETURN NUMBER IS

V_DIM_DATE_ID DIM_DATE.DATE_ID%TYPE;

BEGIN 



    SELECT DATE_ID
    INTO V_DIM_DATE_ID
    FROM DIM_DATE
    WHERE 
        DAY_OF_MONTH = TO_NUMBER(TO_CHAR(V_DATE, 'DD'))
        AND MONTH = TO_NUMBER (TO_CHAR(V_DATE, 'MM'))
        AND YEAR = TO_NUMBER(TO_CHAR(V_DATE,'YYYY'));  


    RETURN V_DIM_DATE_ID;

END;

/

select  year,month,day_of_month,count(*)
from dim_date
group by year,month,day_of_month
having count(*) > 1;

select count(*)/2 from dim_date;
select * from dim_date;

------------------------------------------------- FUNÇÃO TIME -------------------------------------------------------------

CREATE OR REPLACE FUNCTION TIME_PK(PK_TIME VARCHAR2) RETURN NUMBER IS

V_TIME DIM_TIME.TIME_ID%TYPE; 

BEGIN

    SELECT TIME_ID
    INTO V_TIME
    FROM DIM_TIME
    WHERE TIME_ID = PK_TIME;
    
    RETURN V_TIME;


END;
/


------------------------------------------------- FUNÇÃO SALARY -------------------------------------------------------------


CREATE OR REPLACE FUNCTION SALARY_PK (PK_SALARY NUMBER) RETURN NUMBER IS

V_SALARY_SK DIM_EMPLOYEE.MINDIM_SALARY_SALARY_SK%TYPE;

BEGIN 
    IF PK_SALARY IS NOT NULL THEN 
        SELECT MINDIM_SALARY_SALARY_SK
        INTO V_SALARY_SK
        FROM DIM_EMPLOYEE
        WHERE EMPLOYEE_ID = PK_SALARY;
          
        RETURN V_SALARY_SK;
    ELSE
        RETURN -1;
    END IF;
    
END;
/


------------------------------------------------- FUNÇÃO CITIES -------------------------------------------------------------




CREATE OR REPLACE FUNCTION CITIES_PK (PK_CITIES NUMBER) RETURN NUMBER IS

V_CITIES_SK DIM_CUSTOMERS.MINDIM_CITIES_CITY_SK%TYPE;

BEGIN 
    
    SELECT MINDIM_CITIES_CITY_SK
    INTO V_CITIES_SK
    FROM DIM_CUSTOMERS
    WHERE CUST_ID = PK_CITIES;
      

    RETURN V_CITIES_SK;

END;
/


---------------------------------------------------- Sales Factos --------------------------------------------------------------


CREATE OR REPLACE PROCEDURE ETL_SALES_FACT IS 


CURSOR C_FACT_SALES IS
    SELECT SUM(QUANTITY_SOLD), SUM(AMOUNT_SOLD), CUST_ID, PROD_ID, EMPLOYEE_ID, MARKETING_ID, TRUNC(SALE_DATE), TIME_ID
    FROM SALES, SALES_ROWS, DIM_TIME
    WHERE SALES.SALE_ID = SALES_ROWS.SALE_ID
    GROUP BY CUST_ID, PROD_ID, EMPLOYEE_ID, MARKETING_ID, TRUNC(SALE_DATE),TIME_ID;

V_QUANTIDADE SALES_ROWS.QUANTITY_SOLD%TYPE;
V_TOTAL SALES_ROWS.AMOUNT_SOLD%TYPE;
V_SALE_DATE SALES.SALE_DATE%TYPE;
V_TIME VARCHAR2(2);
V_EMPLOYEE SALES.EMPLOYEE_ID%TYPE;
V_PROD SALES_ROWS.PROD_ID%TYPE;
V_MARKETING SALES.MARKETING_ID%TYPE;
V_CUST SALES.CUST_ID%TYPE;

V_CONTA_DADOS NUMBER(6);

BEGIN
    V_CONTA_DADOS := 0;
      OPEN C_FACT_SALES;
        LOOP 
             
            FETCH C_FACT_SALES INTO
                V_QUANTIDADE,
                V_TOTAL,
                V_CUST,
                V_PROD,
                V_EMPLOYEE,
                V_MARKETING,
                V_SALE_DATE,
                V_TIME;               
                            
            EXIT WHEN C_FACT_SALES%NOTFOUND;
             
             
        
            INSERT INTO FACT_SALES( 
                                    QUANTITY_SOLD,
                                    AMOUNT_SOLD,
                                    DIM_CUSTOMERS_CUST_SK,
                                    DIM_PRODUCTS_PROD_SK,
                                    DIM_EMPLOYEE_EMPLOYEE_SK,
                                    DIM_MARKETING_MARKETING_SK,
                                    DIM_DATE_DATE_ID,
                                    DIM_TIME_TIME_ID,                                   
                                    MINDIM_CITIES_CITY_SK,
                                    MINDIM_SALARY_SALARY_SK
                                  
                                    
                            ) VALUES (
                                    V_QUANTIDADE,
                                    V_TOTAL,
                                    CUSTOMERS_PK(V_CUST),
                                    PRODUCTS_PK(V_PROD),
                                    EMPLOYEE_PK(V_EMPLOYEE),
                                    MARKETING_PK(V_MARKETING),                              
                                    DATE_PK(V_SALE_DATE),
                                    TIME_PK(V_TIME),
                                    CITIES_PK(V_CUST),
                                    SALARY_PK(V_EMPLOYEE)
                                   
                                  );
                            V_CONTA_DADOS := V_CONTA_DADOS + 1;
                            IF MOD(V_CONTA_DADOS,1000) = 0 THEN
                                COMMIT;
                            END IF;
        END LOOP; 
    CLOSE C_FACT_SALES;
END;
/


EXEC ETL_SALES_FACT;
