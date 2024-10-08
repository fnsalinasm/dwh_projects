
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
	p.id_pv
	, p.cia
	, p.cod_suc
	, p.nombre_sucursal
	, p.cod_ramo
	, p.ramo
	, p.poliza
	, p.endoso
	, p.tipo_negocio
	, p.cod_aseg
	, p.primer_apellido_aseg
	, p.segundo_apellido_aseg
	, p.nombre_aseg
	, p.documento_aseg
	, p.fec_emi
	, p.ano_emision
	, p.mes_emision
	, p.dia_emision
	, p.fec_vig_desde
	, p.ano_vigencia
	, p.mes_vigencia
	, p.dia_vigencia
	, p.fec_vig_hasta
	, p.ano_vencimiento
	, p.mes_vencimiento
	, p.dia_vencimiento
	, p.cod_moneda
	, p.imp_cambio
	, p.cod_grupo_endo
	, p.grupo_endoso
	, p.cod_tipo_endo
	, p.tipo_endoso
	, p.sn_fronting
	, p.cod_pto_vta
	, p.unidad_comercial
	, p.usuario
	, p.PIA
	, p.suma_asegurada
	, p.cod_tipo_agente
	, p.tipo_agente
	, p.cod_agente
	, p.agente
	, p.pje_partic_agente
	, p.ind_agente
	, p.comision_normal
	, p.comision_extra
	, p.prima_directa
	, p.prima_cedida
	, p.iva
	, p.cod_tipo_poliza
	, p.tipo_poliza
	, p.gastos_emision
	, p.otros_conceptos
	, p.prima_total
	, p.moneda
	, p.facultativo
	, p.clasificacion_negocio
	, p.agrupador
	, p.nro_control
	, p.ano_proceso
	, p.mes_proceso
	, p.prima_cedida_reas
FROM Produccion.dbo.Produccion_JT p
WHERE CAST(fec_emi AS DATE) BETWEEN CONVERT(DATE, '{start_date}', 23) AND CONVERT(DATE, '{end_date}', 23)
;
