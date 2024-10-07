
/*
Autor: Andres Bejarano
Email: andres.bejarano@hdi.com.co
Fecha de creación de script: 08 Octubre de 2024 (2024-10-08)
Descripción del script: Query de ejecución de extracción de datos
Variables de remplazo:
 - start_date:	{start_date}
 - end_date:	{end_date}
*/

DECLARE @start_date VARCHAR(10) = '{start_date}';
DECLARE @end_date VARCHAR(10) = '{end_date}';

-- Prueba de reemplazo de fechas
-- SELECT @start_date AS start_date, @end_date AS end_date;

EXEC APPGENERALI.dbo.INFOGC_PEAU_SP_LEE_INFO_COTIZACIONES
              @FCH_DESDE = @start_date
              , @FCH_HASTA = @end_date
;
