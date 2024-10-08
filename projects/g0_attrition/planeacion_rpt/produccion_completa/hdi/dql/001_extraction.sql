
/*
Autor: Fabio Salinas
Email: fabio.salinas@hdi.com.co
Fecha de creación de script: 06 Octubre de 2024 (2024-10-06)
Descripción del script: Query de ejecución de extracción de datos
Variables de remplazo:
 - start_date:	{start_date}
 - end_date:	{end_date}
*/

SELECT
	p.CIA
	, p.AAAA_PROCESO
	, p.MM_PROCESO
	, p.ID_PV
	, p.ID_PV_CERO
	, p.ID_PV_MODIFICA
	, p.COD_SUC
	, p.SUC_NOMBRE
	, p.COD_UNIDAD
	, p.UNIDAD
	, p.COD_RAMO_CIAL
	, p.NOM_COMERCIAL
	, p.COD_RAMO_TECNICO
	, p.NOM_TECNICO
	, p.COD_TOMADOR
	, p.TIPO_DOCUMENTO
	, p.NUM_DOCUMENTO
	, p.NOM_TOMADOR
	, p.COD_AGENTE
	, p.COD_TIPO_AGENTE
	, p.DESC_AGENTE
	, p.NOM_AGENTE
	, p.PJE_PARTIC_AGENTE
	, p.NRO_POL
	, p.SUMA_ASEGURADA
	, p.AAAA_ENDOSO
	, p.NRO_ENDOSO
	, p.FEC_EMI
	, p.FEC_VIG_DESDE
	, p.FEC_VIG_HASTA
	, p.COD_GRUPO_ENDO
	, p.GRUPO_ENDOSO
	, p.ESTADO
	, p.COD_TIPO_ENDO
	, p.DESC_ENDOSO
	, p.SN_FACULTATIVO
	, p.SN_FACILITY
	, p.PRIMA_EMITIDA
	, p.PRIMA_CEDIDA
	, p.PRIMA_NETA
	, p.DEVENGADA_BRUTA
	, p.DEVENGADA_NETA
	, p.PRIMA_RECAUDADA
	, p.COMISION
	, p.COMISION_AMORTIZADA
	, p.COMISION_EXTRA
	, p.SINIESTROS_BRUTOS
	, p.SINIESTROS_NETOS
	, p.STRO_BRUTOS_POR_OCURRENCIA
	, p.STRO_NETOS_POR_OCURRENCIA
	, p.STRO_BRUTOS_POR_AVISO
	, p.STRO_NETOS_POR_AVISO
	, p.NRO_STRO_INCURRIDOS
	, p.NRO_STRO_AVISADOS
	, p.NRO_ASEGURADOS
	, p.IBNR
	, p.COD_PRODUCTO
	, p.NOM_PRODUCTO
	, p.COD_TIPO_POLIZA
	, p.CANAL
	, p.SEGMENTO
	, p.SEGMENTO_CORPORATE
	, p.NOM_EJECUTIVO_COM
	, p.COD_USUARIO
	, p.PERIODO
	, p.RETAIL_BANCASSURANCE
	, p.DESCRIP_BANCASSURANCE
	, p.COD_OPERACION
	, p.TIPO_NEGOCIO
	, p.PJE_PARTIC_HDI
	, p.MACRO_RAMO
	, p.TIPO_CARTERA
	, p.FORMA_PAGO
	, p.COD_GRUPO
	, p.CANAL_PLANEACION
	, p.SEGMENTO_PLANEACION
	, p.LICITACIONES
	, p.FACULTATIVOS
	, p.SUB_CANAL_PLANEACION
	, p.SUB_SEGMENTO_PLANEACION
	, p.SEGMENTO_COMERCIAL
	, p.ORIGINACION
	, p.LICITACIONES_PUBLICAS
	, p.INTERMEDIARIO
	, p.SPONSOR
	, p.BANCASEGUROS
	, p.PRIMA_DEVENGADA_BRUTA_NEGOCIO
	, p.PRIMA_DEVENGADA_NETA_NEGOCIO
	, p.RESERVA_TECNICA
	, p.SEGMENTO_AUTOS
	, p.NIT_AGENTE
	, p.CANAL_COMERCIAL
	, p.SEGMENTO_COMERCIAL_2
	, p.SEGMENTO_EMPRESARIAL_COMERCIAL
	, p.PRODUCTO_COMERCIAL
	, p.FECHA_PROCESO
	, p.CANAL_COMERCIAL_HDI
	, p.PRIMA_CEDIDA_REAS
	, p.PRIMA_RETENIDA_REAS
FROM PLANEACION_RPT.dbo.PRODUCCION_COMPLETA p WITH(NOLOCK)
WHERE DATEFROMPARTS(p.AAAA_PROCESO, p.MM_PROCESO, 1) BETWEEN CONVERT(DATE, '{start_date}', 23) AND CONVERT(DATE, '{end_date}', 23)
-- WHERE p.AAAA_PROCESO = CAST(SUBSTRING('{start_date}', 1, AS INTEGER) AND p.MM_PROCESO = CAST(SUBSTRING('{end_date}', 6, 2) AS INTEGER)
;