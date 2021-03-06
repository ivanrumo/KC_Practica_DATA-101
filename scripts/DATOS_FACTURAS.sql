USE ODS;

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO ODS_DM_FCINICIO_FACTURAS (FC_INICIO, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT START_DATE, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(START_DATE)<>'';
INSERT INTO ODS_DM_FCINICIO_FACTURAS VALUES (999, STR_TO_DATE('31/12/9999','%d/%m/%Y'), NOW(),NOW());
INSERT INTO ODS_DM_FCINICIO_FACTURAS VALUES (998, STR_TO_DATE('31/12/9998','%d/%m/%Y'), NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_FCINICIO_FACTURAS;

INSERT INTO ODS_DM_FCFIN_FACTURAS (FC_FIN, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT END_DATE, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(END_DATE)<>'';
INSERT INTO ODS_DM_FCFIN_FACTURAS VALUES (999, STR_TO_DATE('31/12/9999','%d/%m/%Y'), NOW(),NOW());
INSERT INTO ODS_DM_FCFIN_FACTURAS VALUES (998, STR_TO_DATE('31/12/9998','%d/%m/%Y'), NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_FCFIN_FACTURAS;

INSERT INTO ODS_DM_FCESTADO_FACTURAS (FC_ESTADO, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT STATEMENT_DATE, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(STATEMENT_DATE)<>'';
INSERT INTO ODS_DM_FCESTADO_FACTURAS VALUES (999, STR_TO_DATE('31/12/9999','%d/%m/%Y'), NOW(),NOW());
INSERT INTO ODS_DM_FCESTADO_FACTURAS VALUES (998, STR_TO_DATE('31/12/9998','%d/%m/%Y'), NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_FCESTADO_FACTURAS;

INSERT INTO ODS_DM_FCPAGO_FACTURAS (FC_PAGO, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT PAYMENT_DATE, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(PAYMENT_DATE)<>'';
INSERT INTO ODS_DM_FCPAGO_FACTURAS VALUES (999, STR_TO_DATE('31/12/9999','%d/%m/%Y'), NOW(),NOW());
INSERT INTO ODS_DM_FCPAGO_FACTURAS VALUES (998, STR_TO_DATE('31/12/9998','%d/%m/%Y'), NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_FCPAGO_FACTURAS;

INSERT INTO ODS_DM_CICLOS_FACTURACION (DE_CICLO_FACTURACION, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT BILL_CYCLE, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(BILL_CYCLE)<>'';
INSERT INTO ODS_DM_CICLOS_FACTURACION VALUES (99, 'DESCONOCIDO', NOW(),NOW());
INSERT INTO ODS_DM_CICLOS_FACTURACION VALUES (98, 'NO APLICA', NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_CICLOS_FACTURACION;


INSERT INTO ODS_DM_METODOS_PAGO (DE_METODO_PAGO, FC_INSERT, FC_MODIFICACION)
SELECT DISTINCT BILL_METHOD, NOW(), NOW()
FROM STAGE.STG_FACTURAS_FCT
WHERE TRIM(BILL_METHOD)<>'';
INSERT INTO ODS_DM_METODOS_PAGO VALUES (99, 'DESCONOCIDO', NOW(),NOW());
INSERT INTO ODS_DM_METODOS_PAGO VALUES (98, 'NO APLICA', NOW(),NOW());
COMMIT;
ANALYZE TABLE ODS_DM_METODOS_PAGO;


INSERT INTO ODS_HC_CLIENTES VALUES (
    999999999,
    'DESCONOCIDO',
    'DESCONOCIDO',
    '99-999-9999', 
    99, 
    999999, 
    9999999999, 
    'DESCONOCIDO',
    STR_TO_DATE('31/12/9999', '%d/%m/%Y'), 
    999, 
    999, 
    NOW(),
    STR_TO_DATE('31/12/9999', '%d/%m/%Y'));
COMMIT;
ANALYZE TABLE ODS_HC_CLIENTES;

INSERT INTO ODS_HC_FACTURAS (ID_FACTURA, ID_CLIENTE, ID_INICIO, ID_FIN, ID_ESTADO, ID_PAGO, ID_CICLO_FACTURACION, ID_METODO_PAGO, CANTIDAD, FC_INSERT, FC_MODIFICATION)
SELECT BILL_REF_NO ID_FACTURA,
CASE WHEN TRIM(CLI.ID_CLIENTE)<>'' THEN CLI.ID_CLIENTE ELSE 999999999 END ID_CLIENTE,
CASE WHEN TRIM(FINI.ID_INICIO)<>'' THEN FINI.ID_INICIO ELSE 999 END ID_INICIO,
CASE WHEN TRIM(FFIN.ID_FIN)<>'' THEN FFIN.ID_FIN ELSE 999 END ID_FIN,
CASE WHEN TRIM(FEST.ID_ESTADO)<>'' THEN FEST.ID_ESTADO ELSE 999 END ID_ESTADO,
CASE WHEN TRIM(FPAGO.ID_PAGO)<>'' THEN FPAGO.ID_PAGO ELSE 999 END ID_PAGO,
CASE WHEN TRIM(CFCT.ID_CICLO_FACTURACION)<>'' THEN CFCT.ID_CICLO_FACTURACION ELSE 999 END ID_CICLO_FACTURACION ,
CASE WHEN TRIM(PFCT.ID_METODO_PAGO)<>'' THEN PFCT.ID_METODO_PAGO ELSE 999 END ID_METODO_PAGO,
CASE WHEN LENGTH(TRIM(AMOUNT))<>0 THEN CAST(AMOUNT AS DECIMAL(5,2)) ELSE '99999.99' END CANTIDAD,
NOW(),
NOW()
FROM STAGE.STG_FACTURAS_FCT FCT
INNER JOIN 
    ODS_DM_FCINICIO_FACTURAS FINI ON CASE WHEN LENGTH(TRIM(FCT.START_DATE))<>0 THEN STR_TO_DATE(UPPER(TRIM(FCT.START_DATE)),'%Y-%m-%d %H:%i:%s') ELSE STR_TO_DATE('31/12/9999','%d/%m/%Y') END=FINI.FC_INICIO
INNER JOIN 
    ODS_DM_FCFIN_FACTURAS FFIN ON CASE WHEN LENGTH(TRIM(FCT.END_DATE))<>0 THEN STR_TO_DATE(UPPER(TRIM(FCT.END_DATE)),'%Y-%m-%d %H:%i:%s') ELSE STR_TO_DATE('31/12/9999','%d/%m/%Y') END=FFIN.FC_FIN
INNER JOIN 
    ODS_DM_FCESTADO_FACTURAS FEST ON CASE WHEN LENGTH(TRIM(FCT.STATEMENT_DATE))<>0 THEN STR_TO_DATE(UPPER(TRIM(FCT.STATEMENT_DATE)),'%Y-%m-%d %H:%i:%s') ELSE STR_TO_DATE('31/12/9999','%d/%m/%Y') END=FEST.FC_ESTADO
INNER JOIN 
    ODS_DM_FCPAGO_FACTURAS FPAGO ON CASE WHEN LENGTH(TRIM(FCT.PAYMENT_DATE))<>0 THEN STR_TO_DATE(UPPER(TRIM(FCT.PAYMENT_DATE)),'%Y-%m-%d %H:%i:%s') ELSE STR_TO_DATE('31/12/9999','%d/%m/%Y') END=FPAGO.FC_PAGO
INNER JOIN 
    ODS_DM_CICLOS_FACTURACION CFCT ON CASE WHEN LENGTH(TRIM(FCT.BILL_CYCLE))<>0 THEN UPPER(TRIM(FCT.BILL_CYCLE)) ELSE 'DESCONOCIDO' END=CFCT.DE_CICLO_FACTURACION
INNER JOIN
    ODS_DM_METODOS_PAGO PFCT ON CASE WHEN LENGTH(TRIM(FCT.BILL_METHOD))<>0 THEN UPPER(TRIM(FCT.BILL_METHOD)) ELSE 'DESCONOCIDO' END=PFCT.DE_METODO_PAGO
LEFT OUTER JOIN
    ODS_HC_CLIENTES CLI ON CASE WHEN LENGTH(TRIM(CUSTOMER_ID))<>0 THEN TRIM(CUSTOMER_ID) ELSE 999999999 END=CLI.ID_CLIENTE;
COMMIT;
ANALYZE TABLE ODS_HC_FACTURAS;


SET FOREIGN_KEY_CHECKS=1;