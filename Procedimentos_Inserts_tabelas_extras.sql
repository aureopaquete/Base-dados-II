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











