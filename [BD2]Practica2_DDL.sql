CREATE TABLE ZAPATERIA.CLIENTE(
    id_cliente          INTEGER         NOT NULL,
    nombre_cliente      VARCHAR2(50)    NOT NULL,
    apellido_cliente    VARCHAR2(50)    NOT NULL,
    direccion_cliente   VARCHAR2(50)    NOT NULL,
    dpi_cliente         VARCHAR2(50)    NOT NULL,
    
    CONSTRAINT cliente_pk PRIMARY KEY(id_cliente)
);

CREATE TABLE ZAPATERIA.VENDEDOR(
    id_vendedor         INTEGER         NOT NULL,
    nombre_vendedor     VARCHAR2(50)    NOT NULL,
    apellido_vendedor   VARCHAR2(50)    NOT NULL,
    correo_vendedor     VARCHAR2(50)    NOT NULL,
    dpi_vendedor        VARCHAR2(50)    NOT NULL,
    
    CONSTRAINT vendedor_pk PRIMARY KEY(id_vendedor)
);

CREATE TABLE ZAPATERIA.PRODUCTO(
    id_producto         INTEGER         NOT NULL,
    nombre_producto     VARCHAR2(30)    NOT NULL,
    precio_producto     INTEGER         NOT NULL,
    stock_producto      INTEGER         NOT NULL,
    
    CONSTRAINT producto_pk PRIMARY KEY(id_producto)
);

CREATE TABLE ZAPATERIA.FACTURA(
    id_factura      INTEGER     NOT NULL,
    id_cliente      INTEGER     NOT NULL,
    id_vendedor     INTEGER     NOT NULL,
    fecha_factura   DATE        NOT NULL,
    
    CONSTRAINT factura_pk PRIMARY KEY(id_factura),
    CONSTRAINT factura_cliente_fk FOREIGN KEY (id_cliente) REFERENCES ZAPATERIA.CLIENTE(id_cliente) on delete cascade,
    CONSTRAINT factura_vendedor_fk FOREIGN KEY (id_vendedor) REFERENCES ZAPATERIA.VENDEDOR(id_vendedor) on delete cascade
);

CREATE TABLE ZAPATERIA.DETALLE(
    id_detalle  INTEGER NOT NULL,
    id_factura  INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad    INTEGER NOT NULL,
    sub_total   INTEGER NOT NULL,
    
    CONSTRAINT detalle_pk PRIMARY KEY(id_detalle),
    CONSTRAINT detalle_factura_fk FOREIGN KEY (id_factura) REFERENCES ZAPATERIA.FACTURA(id_factura) on delete cascade,
    CONSTRAINT detalle_producto_fk FOREIGN KEY (id_producto) REFERENCES ZAPATERIA.PRODUCTO(id_producto) on delete cascade
);
