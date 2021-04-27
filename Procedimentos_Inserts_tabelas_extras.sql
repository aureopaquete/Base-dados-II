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
    
        
        V_COST := TRUNC(dbms_random.value(10,500));

        
        



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





