create or replace PROCEDURE P_SPLIT (
        p_ruta IN VARCHAR2,
        p_filename IN VARCHAR2,
        p_deli IN VARCHAR2 := ';'
    ) IS v_archivo UTL_FILE.FILE_TYPE;
-- variable que contendrá el archivo
    v_linea VARCHAR2 (32767);
    v_cont int := 1;
    v_subtotal int := 0;
    v_idDetalle int := 1;
    v_precio int := 0;
    existe int := 0;
    
    V_id VARCHAR2 (32767);
    V_campo1 VARCHAR2 (32767);
    V_campo2 VARCHAR2 (32767);
    V_campo3 VARCHAR2 (32767);
    V_campo4 VARCHAR2 (32767);

    e_parent_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT ( e_parent_not_found , -2291);

BEGIN -- Abrir el archivo «myfile.csv» ubicado en «/home/usr/scripts»
    dbms_output.PUT_LINE (p_filename);
    v_archivo := UTL_FILE.FOPEN (p_ruta, p_filename, 'R');
    IF UTL_FILE.IS_OPEN(v_archivo) THEN
        LOOP
    -- inicializar la variable v_salida 
        BEGIN 
            UTL_FILE.GET_LINE (v_archivo, v_linea);
            IF v_linea IS NULL THEN
            EXIT;
            END IF;

            IF  v_cont > 1 THEN
                IF p_filename = '[BD2] Clientes.csv' THEN

                    V_id := REGEXP_SUBSTR(v_linea, '[^,]+',1,1);
                    V_campo1 := REGEXP_SUBSTR(v_linea, '[^,]+',1,2);
                    V_campo2:= REGEXP_SUBSTR(v_linea, '[^,]+',1,3);
                    V_campo3 := REGEXP_SUBSTR(v_linea, '[^,]+',1,4);
                    V_campo4 := REGEXP_SUBSTR(v_linea, '[^,]+',1,5);


                    INSERT INTO ZAPATERIA.CLIENTE VALUES (TO_NUMBER(V_id),V_campo1,V_campo2, V_campo3, V_campo4 );
                    COMMIT;
                ELSIF p_filename = '[BD2] Vendedores.csv' THEN
                    V_id := REGEXP_SUBSTR(v_linea, '[^,]+',1,1);
                    V_campo1 := REGEXP_SUBSTR(v_linea, '[^,]+',1,2);
                    V_campo2:= REGEXP_SUBSTR(v_linea, '[^,]+',1,3);
                    V_campo3 := REGEXP_SUBSTR(v_linea, '[^,]+',1,4);
                    V_campo4 := REGEXP_SUBSTR(v_linea, '[^,]+',1,5);
                    INSERT INTO ZAPATERIA.VENDEDOR VALUES (TO_NUMBER(V_id),V_campo1,V_campo2, V_campo3, V_campo4 );
                    COMMIT;
                ELSIF p_filename = '[BD2] Productos.csv' THEN
                    V_id := REGEXP_SUBSTR(v_linea, '[^,]+',1,1);
                    V_campo1 := REGEXP_SUBSTR(v_linea, '[^,]+',1,2);
                    V_campo2 := REGEXP_SUBSTR(v_linea, '[^,]+',1,3);
                    V_campo2 := SUBSTR(V_campo2,2);
                    V_campo3  := REGEXP_SUBSTR(v_linea, '[^,]+',1,4);

                    INSERT INTO ZAPATERIA.PRODUCTO VALUES (TO_NUMBER(V_id),V_campo1,TO_NUMBER(V_campo2), TO_NUMBER(V_campo3) );
                    COMMIT;
                ELSIF p_filename = '[BD2] Facturas.csv' THEN
                    V_id := REGEXP_SUBSTR(v_linea, '[^,]+',1,1);
                    V_campo1 := REGEXP_SUBSTR(v_linea, '[^,]+',1,2);
                    V_campo2 := REGEXP_SUBSTR(v_linea, '[^,]+',1,3);
                    V_campo3  := REGEXP_SUBSTR(v_linea, '[^,]+',1,4);

                    INSERT INTO ZAPATERIA.FACTURA VALUES (TO_NUMBER(V_id),TO_NUMBER(V_campo1),TO_NUMBER(V_campo2), TO_DATE(V_campo3,'DD/MM/YYYY') );
                    COMMIT;
                ELSIF p_filename = '[BD2] Detalle.csv' THEN
                    v_precio := 0;
                    V_campo1 := REGEXP_SUBSTR(v_linea, '[^,]+',1,1);
                    V_campo2 := REGEXP_SUBSTR(v_linea, '[^,]+',1,2);
                    V_campo3 := REGEXP_SUBSTR(v_linea, '[^,]+',1,3);
                    
                    SELECT COUNT(*) INTO existe  FROM ZAPATERIA.PRODUCTO WHERE ID_PRODUCTO = TO_NUMBER(V_campo2);
                    
                    IF existe > 0 THEN
                        dbms_output.PUT_LINE ('AQUI ENTRÓ');
                        SELECT PRECIO_PRODUCTO INTO v_precio  FROM ZAPATERIA.PRODUCTO WHERE ID_PRODUCTO = TO_NUMBER(V_campo2);
                    END IF;
                    v_subtotal := TO_NUMBER(V_campo3) * v_precio;
                    
                    INSERT INTO ZAPATERIA.DETALLE VALUES (v_idDetalle, TO_NUMBER(V_campo1),TO_NUMBER(V_campo2), TO_NUMBER(V_campo3), v_subtotal );
                    v_idDetalle := v_idDetalle + 1;
                    COMMIT;

                END IF;
            END IF;
            v_cont:=  v_cont + 1;
           -- dbms_output.PUT_LINE (v_cont);
                

        EXCEPTION
           
            WHEN DUP_VAL_ON_INDEX THEN CONTINUE;
            WHEN INVALID_NUMBER THEN CONTINUE;
            WHEN  e_parent_not_found THEN CONTINUE; 
            WHEN NO_DATA_FOUND THEN EXIT;
            WHEN OTHERS THEN CONTINUE;

        END;
        END LOOP;
    END IF;
    COMMIT;
    UTL_FILE.FCLOSE (v_archivo);
-- cerrar el archivo abierto
EXCEPTION
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (
    'ERROR: Se ha presentado un problema en el proceso aqui.'
    );
END;

SET serveroutput ON
BEGIN
     P_SPLIT('BFILE_DIR','[BD2] Clientes.csv',','); 
     P_SPLIT('BFILE_DIR','[BD2] Vendedores.csv',',');
     P_SPLIT('BFILE_DIR','[BD2] Productos.csv',',');
     P_SPLIT('BFILE_DIR','[BD2] Facturas.csv',',');
     P_SPLIT('BFILE_DIR','[BD2] Detalle.csv',',');
END;
