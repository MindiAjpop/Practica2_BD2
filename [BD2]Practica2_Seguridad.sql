/* Crea el tablespace tszapateria con los parámetros requeridos*/
CREATE TABLESPACE TSZAPATERIA DATAFILE 'ZAPATERIADF.tbs' SIZE 250M AUTOEXTEND ON NEXT 1M MAXSIZE 500M;

/* Habilita la sesión para crear el usuario y schema ZAPATERIA*/
alter session set "_ORACLE_SCRIPT"=true;

/* Crea el usuario zapateria en el tablespace creado anteriormente para crear un schema homónimo */
CREATE USER ZAPATERIA IDENTIFIED BY ZAPATERIA DEFAULT TABLESPACE TSZAPATERIA;

/* otorga los permisos pertinentes al usuario */

GRANT create session TO ZAPATERIA;
GRANT create table TO ZAPATERIA;
GRANT create view TO ZAPATERIA;
GRANT create any trigger TO ZAPATERIA;
GRANT create any procedure TO ZAPATERIA;
GRANT create sequence TO ZAPATERIA;
GRANT create synonym TO ZAPATERIA;

/* habilita la creación de usuarios y permisos */
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; 



/* crea los roles */
CREATE ROLE Contabilidad;
CREATE ROLE Ventas;
CREATE ROLE IT;
CREATE ROLE Gerencia;

/* concede permisos a cada uno de los roles */
GRANT
    INSERT ANY TABLE,
    SELECT ANY TABLE 
    TO Contabilidad;

GRANT 
    CREATE ANY VIEW,
    INSERT ANY TABLE,
    SELECT ANY TABLE 
    TO Ventas;

GRANT
    SELECT ANY TABLE,
    DELETE ANY TABLE,
    CREATE USER,
    CREATE ANY TABLE 
    TO IT;

GRANT 
    CREATE ANY VIEW,
    UPDATE ANY TABLE,
    INSERT ANY TABLE,
    SELECT ANY TABLE,
    DELETE ANY TABLE,
    CREATE USER 
    TO Gerencia;



/* crea los usuarios con nombre y contraseña */
CREATE USER Contabilidad1 IDENTIFIED BY bd2Conta1 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER Contabilidad2 IDENTIFIED BY bd2Conta2 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER Ventas1 IDENTIFIED BY bd2Ventas1 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER Ventas2 IDENTIFIED BY bd2Ventas2 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER IT1 IDENTIFIED BY bd2IT1 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER IT2 IDENTIFIED BY bd2IT2 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER Gerencia1 IDENTIFIED BY bd2Gerencia1 DEFAULT TABLESPACE TSZAPATERIA;
CREATE USER Gerencia2 IDENTIFIED BY bd2Gerencia2 DEFAULT TABLESPACE TSZAPATERIA;


/* Enlaza los usuarios con los roles según el cargo del usuario */
GRANT Contabilidad TO Contabilidad1;
GRANT Contabilidad TO Contabilidad2;
GRANT Ventas TO Ventas1;
GRANT Ventas TO Ventas2;
GRANT IT TO IT1;
GRANT IT TO IT2;
GRANT Gerencia TO Gerencia1;
GRANT Gerencia TO Gerencia2;
