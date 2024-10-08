
-- ================================================
-- 1. Eliminar Función y Trigger si ya existen
-- ================================================

-- Eliminar la función si ya existe
DROP FUNCTION IF EXISTS hdi.stg.update_timestamp() CASCADE;

-- ================================================
-- 2. Función para actualizar el campo updated_at
-- ================================================

-- Función para actualizar el campo updated_at antes de cada UPDATE.
-- Esta función se usará en todas las tablas para garantizar que la fecha y hora
-- de actualización (updated_at) se registren automáticamente.
CREATE OR REPLACE FUNCTION hdi.stg.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ================================================
-- 3. Script para la tabla hdi_tables_secrets
-- ================================================

-- Eliminar la tabla y el trigger si ya existen
DROP TABLE IF EXISTS hdi.stg.hdi_tables_secrets CASCADE;
DROP TRIGGER IF EXISTS set_timestamp_secrets ON hdi.stg.hdi_tables_secrets;

-- Tabla que almacena los secretos utilizados en la configuración de Airflow
-- para los procesos de extracción y migración de datos. Cada secreto está asociado
-- con un proceso específico que requiere credenciales o claves de acceso.
CREATE TABLE hdi.stg.hdi_tables_secrets (
    id SERIAL PRIMARY KEY,  -- Identificador único para cada secreto, generado automáticamente.
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro, valor por defecto NOW().
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización del registro.
    secret VARCHAR(50) NOT NULL UNIQUE, -- Nombre del secreto o clave utilizada en el proceso de extracción. Debe ser único.
    db_type VARCHAR(50) NOT NULL CHECK (db_type IN ('PostgreSQL', 'SQL Server', 'Oracle', 'MySQL', 'Otra')) -- Tipo de base de datos Eg. PostgreSQL, SQL Server, Oracle
);

-- Trigger para actualizar el campo updated_at en cada modificación de una fila.
CREATE TRIGGER set_timestamp_secrets
BEFORE UPDATE ON hdi.stg.hdi_tables_secrets
FOR EACH ROW
EXECUTE FUNCTION hdi.stg.update_timestamp();

-- Índices recomendados para búsquedas frecuentes basadas en la fecha de creación.
CREATE INDEX idx_secret_created_at ON hdi.stg.hdi_tables_secrets (created_at);

INSERT INTO hdi.stg.hdi_tables_secrets (secret, db_type)
VALUES
	 ('SVR-PRD-SLQDWH', 'PostgreSQL'),
	 ('SVR-PRD-SQLBI', 'SQL Server'),
	 ('BOG-FABIOS', 'Otra'),
	 ('classicmodels', 'MySQL'),
	 ('appdb', 'PostgreSQL'),
	 ('dwh_db_dev', 'PostgreSQL'),
	 ('cdif_config', 'PostgreSQL'),
	 ('FTP-SQL', 'Otra'),
	 ('FTP-CSV', 'Otra'),
	 ('AIRFLOW-CDIF-APPLOG', 'PostgreSQL'),
	 ('BUC-IFRS17-STAGECOMERCIAL', 'SQL Server'),
	 ('VRT-TST-DB1', 'SQL Server'),
	 ('KARIN', 'SQL Server'),
	 ('KARIN_AUTH', 'SQL Server'),
	 ('BPM_INSPECCIONES_PROD', 'SQL Server'),
	 ('BPM_MASIVOS_PROD', 'SQL Server'),
	 ('BPM_SINIESTROSGENERALES_PROD', 'SQL Server'),
	 ('BPM_SINIESTROSVIDA_PROD', 'SQL Server'),
	 ('BPM_BIZUITDASHBOARD_PROD', 'SQL Server'),
	 ('BPM_BIZUITPERSISTENCESTORE_PROD', 'SQL Server'),
	 ('PLANEACION_RPT', 'SQL Server'),
	 ('GENERALES_PROD', 'SQL Server'),
	 ('GENERALES_TEST', 'SQL Server'),
	 ('VIDA_PROD', 'SQL Server'),
	 ('VIDA_TEST', 'SQL Server'),
	 ('APPGENERALI_PROD', 'SQL Server'),
	 ('APPGENERALI_TEST', 'SQL Server'),
	 ('PRESUPUESTO_PROD', 'SQL Server'),
	 ('DATAMART_FINAN_PROD', 'SQL Server'),
	 ('PLANEACION_RPT_PROD', 'SQL Server'),
	 ('CLICKHDI_PROD', 'SQL Server'),
	 ('CLICK_HDI_CONSULTAS_HDI', 'Oracle'),
	 ('CLICK_HDI_CONSULTASGU_HDI', 'Oracle'),
	 ('CLICK_HDI_PROD_REPORTES_HDI', 'Oracle'),
	 ('GESTOR_DOCUMENTAL_WEB', 'Otra'),
	 ('sharefolder', 'Otra'),
	 ('Ser-Sqlbi', 'Otra'),
	 ('ser-qlikview', 'Otra'),
	 ('Reportes.Bi', 'Otra'),
	 ('cdif_hdi', 'PostgreSQL')
;

-- Comentarios explicativos
COMMENT ON TABLE hdi.stg.hdi_tables_secrets IS 'Tabla que almacena los secretos utilizados en la configuración de Airflow para procesos de extracción y migración de datos.';
COMMENT ON COLUMN hdi.stg.hdi_tables_secrets.secret IS 'Nombre del secreto o clave de acceso utilizada en los procesos de extracción de datos.';


-- ================================================
-- 4. Script para la tabla hdi_tables_users
-- ================================================

-- Eliminar la tabla y el trigger si ya existen
DROP TABLE IF EXISTS hdi.stg.hdi_tables_users CASCADE;
DROP TRIGGER IF EXISTS set_timestamp_users ON hdi.stg.hdi_tables_users;

-- Tabla que almacena la información de los usuarios responsables de configurar los
-- procesos de extracción de datos en la plataforma. Los usuarios tienen roles asignados
-- y derechos para definir configuraciones de extracción, como procedimientos o queries.
CREATE TABLE hdi.stg.hdi_tables_users (
    id SERIAL PRIMARY KEY,  -- Identificador único para cada usuario, generado automáticamente.
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro, valor por defecto NOW().
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización del registro.
    username VARCHAR(50) NOT NULL UNIQUE,  -- Nombre único de usuario responsable de la configuración de extracción.
    email VARCHAR(50) NOT NULL,  -- Correo electrónico del usuario.
    auth BOOLEAN NOT NULL  -- Indica si el usuario tiene permisos para crear nuevas configuraciones de extracción.
);

-- Trigger para actualizar el campo updated_at en cada modificación de una fila.
CREATE TRIGGER set_timestamp_users
BEFORE UPDATE ON hdi.stg.hdi_tables_users
FOR EACH ROW
EXECUTE FUNCTION hdi.stg.update_timestamp();

-- Índices recomendados para búsquedas frecuentes basadas en la fecha de creación.
CREATE INDEX idx_user_created_at ON hdi.stg.hdi_tables_users (created_at);

-- Insertar los valores predefinidos en la tabla
INSERT INTO stg.hdi_tables_users (username, email, auth)
VALUES
    ('andres.bejarano', 'andres.bejarano@hdi.com.co', TRUE),
    ('brayan.diaz', 'brayan.diaz@hdi.com.co', TRUE),
    ('fabio.salinas', 'fabio.salinas@hdi.com.co', TRUE)
;

-- Comentarios explicativos
COMMENT ON TABLE hdi.stg.hdi_tables_users IS 'Tabla que almacena la información de los usuarios que configuran los procesos de extracción de datos en la plataforma.';
COMMENT ON COLUMN hdi.stg.hdi_tables_users.username IS 'Nombre de usuario, que debe ser único, utilizado para identificar al responsable de la configuración de extracción.';
COMMENT ON COLUMN hdi.stg.hdi_tables_users.auth IS 'Campo booleano que indica si el usuario tiene permisos para crear nuevas configuraciones de extracción de datos.';

-- ================================================
-- 5. Script para la tabla hdi_tables_systems
-- ================================================

-- Eliminar la tabla y el trigger si ya existen
DROP TABLE IF EXISTS hdi.stg.hdi_tables_systems CASCADE;
DROP TRIGGER IF EXISTS set_timestamp_systems ON hdi.stg.hdi_tables_systems;

-- Tabla que contiene la información de los sistemas de origen que gestionan los datos
-- a ser extraídos o migrados. Cada sistema puede ser una base de datos, un software,
-- o un entorno con múltiples tablas y esquemas. Se utiliza para registrar y monitorizar
-- el origen de los datos migrados.
CREATE TABLE hdi.stg.hdi_tables_systems (
    id SERIAL PRIMARY KEY,  -- Identificador único para cada sistema, generado automáticamente.
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro, valor por defecto NOW().
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización del registro.
    system VARCHAR(50) NOT NULL UNIQUE,  -- Nombre del sistema de origen que contiene los datos (e.g., 'dwh', 'sise', 'bpm').
    description VARCHAR(250) NOT NULL  -- Descripción breve del sistema y su función en la arquitectura de datos.
);

-- Trigger para actualizar el campo updated_at en cada modificación de una fila.
CREATE TRIGGER set_timestamp_systems
BEFORE UPDATE ON hdi.stg.hdi_tables_systems
FOR EACH ROW
EXECUTE FUNCTION hdi.stg.update_timestamp();

-- Índices recomendados para búsquedas frecuentes basadas en la fecha de creación.
CREATE INDEX idx_system_created_at ON hdi.stg.hdi_tables_systems (created_at);

INSERT INTO stg.hdi_tables_systems ("system", description)
values
	('dwh', 'Data Warehouse de HDI (PostgreSQL)'),
	('sise', 'Sistema Core de HDI'),
	('bpm', 'Sistema de administraciónd e flujos de trabajo y cotizaciones de HDI'),
	('karin', 'Sistema de administraciónd e flujos de trabajo y cotizaciones de HDI'),
	('clickhdi', 'Sistema de cotizaciones de Auto Individual de HDI')
;

-- Comentarios explicativos
COMMENT ON TABLE hdi.stg.hdi_tables_systems IS 'Tabla que almacena los sistemas de origen desde los cuales se extraen o migran los datos. Cada sistema representa un entorno con tablas y esquemas a ser utilizados en el proceso de migración.';
COMMENT ON COLUMN hdi.stg.hdi_tables_systems.system IS 'Nombre del sistema de origen de los datos, que debe ser único en el entorno de migración.';


-- ================================================
-- 6. Script para la tabla hdi_tables_dates_replacement
-- ================================================

-- Eliminar la tabla si ya existe
DROP TABLE IF EXISTS stg.hdi_tables_dates_replacement CASCADE;

-- Crear la tabla para reemplazos de fechas
CREATE TABLE stg.hdi_tables_dates_replacement (
    id SERIAL PRIMARY KEY,  -- Identificador único, autonumérico
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro, valor por defecto NOW().
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización del registro.
    date_name VARCHAR(50) NOT NULL UNIQUE,  -- Nombre descriptivo del valor de reemplazo de fecha
    date_value DATE  -- Valor de la fecha (puede ser NULL en caso de ser variable)
);

-- Insertar los valores predefinidos en la tabla
INSERT INTO stg.hdi_tables_dates_replacement (date_name)
VALUES
    ('@TODAY_DATE'),
    ('@YESTERDAY_DATE'),
    ('@TOMORROW_DATE'),
    ('@2_DAYS_BEFORE_END_DATE'),
    ('@3_DAYS_BEFORE_END_DATE'),
    ('@4_DAYS_BEFORE_END_DATE'),
    ('@5_DAYS_BEFORE_END_DATE'),
    ('@6_DAYS_BEFORE_END_DATE'),
    ('@7_DAYS_BEFORE_END_DATE'),
    ('@8_DAYS_BEFORE_END_DATE'),
    ('@9_DAYS_BEFORE_END_DATE'),
    ('@10_DAYS_BEFORE_END_DATE'),
    ('@11_DAYS_BEFORE_END_DATE'),
    ('@12_DAYS_BEFORE_END_DATE'),
    ('@13_DAYS_BEFORE_END_DATE'),
    ('@14_DAYS_BEFORE_END_DATE'),
    ('@15_DAYS_BEFORE_END_DATE'),
    ('@16_DAYS_BEFORE_END_DATE'),
    ('@17_DAYS_BEFORE_END_DATE'),
    ('@18_DAYS_BEFORE_END_DATE'),
    ('@19_DAYS_BEFORE_END_DATE'),
    ('@20_DAYS_BEFORE_END_DATE'),
    ('@21_DAYS_BEFORE_END_DATE'),
    ('@22_DAYS_BEFORE_END_DATE'),
    ('@23_DAYS_BEFORE_END_DATE'),
    ('@24_DAYS_BEFORE_END_DATE'),
    ('@25_DAYS_BEFORE_END_DATE'),
    ('@26_DAYS_BEFORE_END_DATE'),
    ('@27_DAYS_BEFORE_END_DATE'),
    ('@28_DAYS_BEFORE_END_DATE'),
    ('@29_DAYS_BEFORE_END_DATE'),
    ('@1_WEEK_BEFORE_END_DATE'),
    ('@2_WEEKS_BEFORE_END_DATE'),
    ('@3_WEEKS_BEFORE_END_DATE'),
    ('@4_WEEKS_BEFORE_END_DATE'),
    ('@1ST_DAY_OF_ACTUAL_MONTH'),
    ('@LAST_DAY_OF_ACTUAL_MONTH'),
    ('@1ST_DAY_OF_LAST_MONTH'),
    ('@LAST_DAY_OF_LAST_MONTH'),
    ('@EVERY_MONDAY'),
    ('@EVERY_TUESDAY'),
    ('@EVERY_WEDNESDAY'),
    ('@EVERY_THURSDAY'),
    ('@EVERY_FRIDAY'),
    ('@EVERY_SATURDAY'),
    ('@EVERY_SUNDAY');

-- Comentarios explicativos
COMMENT ON TABLE stg.hdi_tables_dates_replacement IS 'Tabla que almacena valores predefinidos y dinámicos para el reemplazo de fechas en procesos de migración de datos.';
COMMENT ON COLUMN stg.hdi_tables_dates_replacement.date_name IS 'Nombre del valor de fecha predefinido, por ejemplo @TODAY_DATE, @YESTERDAY_DATE, etc.';
COMMENT ON COLUMN stg.hdi_tables_dates_replacement.date_value IS 'Valor de la fecha asociado, en caso de ser una fecha fija. En valores dinámicos, puede ser NULL.';


-- ================================================
-- 7. . Script para la tabla hdi_tables_dates_replacement
-- ================================================

DROP TABLE IF EXISTS hdi.stg.hdi_tables_dags CASCADE;
DROP TRIGGER IF EXISTS set_timestamp_dags ON hdi.stg.hdi_tables_dags;

CREATE TABLE hdi.stg.hdi_tables_dags (
    dag_id VARCHAR(50) PRIMARY KEY,  -- Identificador único del DAG.
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización.
    dag_owner VARCHAR(20) NOT NULL,  -- Nombre del propietario del DAG (referencia a hdi_tables_users).
    depends_on_past BOOLEAN NOT NULL,  -- Indica si depende del éxito de ejecuciones pasadas.
    email VARCHAR(100) NOT NULL,  -- Correo electrónico para notificaciones del DAG.
    email_on_failure BOOLEAN NOT NULL,  -- Determina si se envía correo en caso de fallos.
    email_on_retry BOOLEAN NOT NULL,  -- Determina si se envía correo en reintentos.
    retries INTEGER NOT NULL,  -- Número de reintentos permitidos.
    retry_delay_seconds INTEGER NOT NULL,  -- Tiempo de espera entre reintentos en segundos.
    dagrun_timeout_minutes INTEGER NOT NULL,  -- Tiempo máximo para la ejecución del DAG.
    description VARCHAR(250) NOT NULL,  -- Descripción del DAG.
    schedule VARCHAR(50) NOT NULL,  -- Expresión cron o intervalo de tiempo para la ejecución del DAG.
    max_active_tasks INTEGER NOT NULL,  -- Número máximo de tareas activas concurrentemente.
    max_active_runs INTEGER NOT NULL,  -- Número máximo de ejecuciones activas concurrentemente.
    start_date DATE NOT NULL,  -- Fecha y hora de inicio del DAG.
    catchup BOOLEAN NOT NULL,  -- Determina si debe ejecutar tareas no ejecutadas previamente.
    tags TEXT,  -- Lista de etiquetas asociadas al DAG.
    on_failure_callback BOOLEAN NOT NULL,  -- Indica si hay una función de callback en caso de fallo.
    is_active BOOLEAN NOT NULL,  -- Determina si el DAG está activo.
    is_paused_upon_creation BOOLEAN NOT NULL  -- Indica si el DAG debe estar en pausa al crearse.
);

CREATE TRIGGER set_timestamp_dags
BEFORE UPDATE ON hdi.stg.hdi_tables_dags
FOR EACH ROW
EXECUTE FUNCTION hdi.stg.update_timestamp();

CREATE INDEX idx_dag_owner ON hdi.stg.hdi_tables_dags (dag_owner);
CREATE INDEX idx_dag_start_date ON hdi.stg.hdi_tables_dags (start_date);
CREATE INDEX idx_dag_is_active ON hdi.stg.hdi_tables_dags (is_active);

COMMENT ON TABLE hdi.stg.hdi_tables_dags IS 'Tabla que almacena la configuración de los DAGs en Airflow, incluyendo los parámetros de ejecución, notificaciones y tiempos de espera.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.dag_id IS 'Identificador único del DAG, usado para referenciar y ejecutar el DAG.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.dag_owner IS 'Nombre del propietario del DAG, generalmente un usuario o equipo responsable del DAG (referencia a hdi_tables_users).';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.depends_on_past IS 'Booleano que indica si la ejecución de las tareas depende del éxito de las ejecuciones anteriores.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.email IS 'Dirección de correo electrónico (o lista de correos) a la que se enviarán las notificaciones relacionadas con el DAG.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.email_on_failure IS 'Booleano que determina si se debe enviar un correo electrónico cuando una tarea del DAG falla.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.email_on_retry IS 'Booleano que determina si se debe enviar un correo electrónico cuando se reintenta una tarea que ha fallado.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.retries IS 'Número de reintentos que se realizarán cuando una tarea falla antes de marcarla como fallida definitivamente.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.retry_delay_seconds IS 'Tiempo de espera (en segundos) entre reintentos en caso de fallo de una tarea.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.dagrun_timeout_minutes IS 'Tiempo máximo (en minutos) permitido para la ejecución completa del DAG antes de marcarlo como fallido.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.description IS 'Descripción breve del propósito o funcionalidad del DAG.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.schedule IS 'Expresión cron o intervalo de tiempo que define cuándo debe ejecutarse el DAG.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.max_active_tasks IS 'Número máximo de tareas que pueden ejecutarse de manera concurrente dentro del DAG.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.max_active_runs IS 'Número máximo de ejecuciones activas (corriendo) del DAG en un momento dado.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.start_date IS 'Fecha y hora a partir de la cual el DAG comenzará a ejecutarse.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.catchup IS 'Booleano que indica si el DAG debe ejecutar los períodos previos (backfill) que no fueron ejecutados cuando el DAG no estaba activo.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.tags IS 'Lista de etiquetas asociadas con el DAG para facilitar la organización o búsqueda en la interfaz de usuario.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.on_failure_callback IS 'Función o callback que se ejecuta cuando una tarea del DAG falla.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.is_active IS 'Booleano que indica si el DAG está activo y debe ser programado para ejecutarse.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.is_paused_upon_creation IS 'Booleano que determina si el DAG debe estar en pausa cuando es creado.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.created_at IS 'Fecha y hora de creación del registro.';
COMMENT ON COLUMN hdi.stg.hdi_tables_dags.updated_at IS 'Fecha y hora de la última actualización del registro.';

INSERT INTO hdi.stg.hdi_tables_dags(dag_id, dag_owner, depends_on_past, email, email_on_failure, email_on_retry, retries, retry_delay_seconds, dagrun_timeout_minutes, description, schedule, max_active_tasks, max_active_runs, start_date, catchup, tags, on_failure_callback, is_active, is_paused_upon_creation)
VALUES
	('migration_daily', 'fabio.salinas', 'False', 'fabio.salinas@hdi.com.co', 'False', 'False', '3', '30', '60', 'Migración de tablas diarias de HDI a HDI Seguros', '0 6 * * *', '1', '1', '2024-10-07', 'False', '{"migración", "hdi", "hdiseguros"}', 'True', 'True', 'False'),
	('migration_weekly', 'fabio.salinas', 'False', 'fabio.salinas@hdi.com.co', 'False', 'False', '3', '30', '60', 'Migración de tablas diarias de HDI a HDI Seguros', '0 5 * * 1', '1', '1', '2024-10-07', 'False', '{"migración", "hdi", "hdiseguros"}', 'True', 'True', 'False'),
	('migration_monthly', 'fabio.salinas', 'False', 'fabio.salinas@hdi.com.co', 'False', 'False', '3', '30', '60', 'Migración de tablas diarias de HDI a HDI Seguros', '0 4 1 */1 *', '1', '1', '2024-10-07', 'False', '{"migración", "hdi", "hdiseguros"}', 'True', 'True', 'False')
;


-- ================================================
-- 8. Script para la tabla hdi_tables_migration
-- ================================================

-- Eliminar la tabla y el trigger si ya existen
DROP TABLE IF EXISTS hdi.stg.hdi_tables_migration CASCADE;
DROP TRIGGER IF EXISTS set_timestamp_migration ON hdi.stg.hdi_tables_migration;

-- Tabla que gestiona y registra los procesos de migración de datos entre los sistemas
-- de origen y destino. Cada registro documenta los detalles de la migración, incluyendo
-- el sistema, el tipo de extracción, el usuario responsable, y los secretos necesarios
-- para la configuración. Se utiliza para auditar y realizar un seguimiento de las
-- migraciones de datos.
CREATE TABLE hdi.stg.hdi_tables_migration (
    id SERIAL PRIMARY KEY,  -- Identificador único para cada proceso de migración, generado automáticamente.
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de creación del registro, valor por defecto NOW().
    updated_at TIMESTAMP DEFAULT NOW() NOT NULL,  -- Fecha y hora de la última actualización del registro.
    system VARCHAR(50) NOT NULL,  -- Nombre del sistema de origen de los datos a ser migrados (referencia a hdi_tables_systems).
    db VARCHAR(50) NOT NULL,  -- Nombre de la base de datos dentro del sistema que contiene las tablas migradas.
    schema VARCHAR(10) NOT NULL,  -- Nombre del esquema dentro de la base de datos.
    table_name VARCHAR(100) NOT NULL,  -- Nombre de la tabla que está siendo migrada.
    extraction_type VARCHAR(2) NOT NULL CHECK (extraction_type IN ('SP', 'QY', 'ST', 'TA', 'DW')),  -- Tipo de extracción: SP (Stored Procedure), QY (Query), ST (Streaming), TA (Tabla), DW (Data Warehouse).
    username VARCHAR(50) NOT NULL,  -- Usuario responsable de configurar el proceso de migración (referencia a hdi_tables_users).
    secret VARCHAR(50) NOT NULL,  -- Secreto o clave de acceso utilizado en la extracción (referencia a hdi_tables_secrets).
    extraction_mode VARCHAR(10) NOT NULL CHECK (extraction_mode IN ('delta', 'replace')),  -- Modo de extracción: 'delta' (cambios incrementales) o 'replace' (reemplazo completo).
    replace_for_start_date VARCHAR(50) NOT NULL,  -- Fecha inicial para reemplazo de datos en el sistema destino.
    replace_for_end_date VARCHAR(50) NOT NULL,  -- Fecha final para reemplazo de datos en el sistema destino.
    hdi_path VARCHAR(250) NOT NULL,  -- Ruta del sistema HDI que almacena los datos migrados.
    hdiseguros_path VARCHAR(250) NOT NULL,  -- Ruta del sistema destino (HDI Seguros) donde se almacenan los datos migrados.
    target_table VARCHAR(250) NOT NULL, -- Nombre de la tabla en la que se cargaran los datos extraidos en el sistema de HDI Seguros
    dag_id VARCHAR(50) NOT NULL, -- Cron que define la frecuencia de ejecución del proceso

    -- Foreign keys para garantizar la integridad referencial.
    CONSTRAINT fk_system FOREIGN KEY (system) REFERENCES hdi.stg.hdi_tables_systems(system),
    CONSTRAINT fk_username FOREIGN KEY (username) REFERENCES hdi.stg.hdi_tables_users(username),
    CONSTRAINT fk_secret FOREIGN KEY (secret) REFERENCES hdi.stg.hdi_tables_secrets(secret),
    CONSTRAINT fk_replace_for_start_date FOREIGN KEY (replace_for_start_date) REFERENCES hdi.stg.hdi_tables_dates_replacement(date_name),
    CONSTRAINT fk_replace_for_end_date FOREIGN KEY (replace_for_end_date) REFERENCES hdi.stg.hdi_tables_dates_replacement(date_name),
    CONSTRAINT fk_dag_id FOREIGN KEY (dag_id) REFERENCES hdi.stg.hdi_tables_dags(dag_id),
    CONSTRAINT unique_target_table UNIQUE (target_table) -- Restricción de unicidad
);

-- Trigger para actualizar el campo updated_at en cada modificación de una fila.
CREATE TRIGGER set_timestamp_migration
BEFORE UPDATE ON hdi.stg.hdi_tables_migration
FOR EACH ROW
EXECUTE FUNCTION hdi.stg.update_timestamp();

-- Índices recomendados para búsquedas frecuentes basadas en la fecha de creación.
CREATE INDEX idx_migration_created_at ON hdi.stg.hdi_tables_migration (created_at);
CREATE INDEX idx_migration_system ON hdi.stg.hdi_tables_migration (system);

-- Comentarios explicativos
COMMENT ON TABLE hdi.stg.hdi_tables_migration IS 'Tabla que documenta y gestiona los procesos de migración de datos entre los sistemas de origen y destino. Proporciona una auditoría detallada de cada proceso de migración.';
COMMENT ON COLUMN hdi.stg.hdi_tables_migration.extraction_type IS 'Tipo de extracción de datos: SP (Stored Procedure), QY (Query), ST (Streaming), TA (Tabla), DW (Data Warehouse).';
COMMENT ON COLUMN hdi.stg.hdi_tables_migration.extraction_mode IS 'Modo de extracción de datos: delta (cambios incrementales) o replace (reemplazo completo).';

INSERT INTO hdi.stg.hdi_tables_migration(system, db, schema, table_name, extraction_type, username, secret, extraction_mode, replace_for_start_date, replace_for_end_date, hdi_path, hdiseguros_path, target_table, dag_id)
values
	('sise', 'PLANEACION_RPT', 'dbo', 'PRODUCCION_COMPLETA', 'QY', 'fabio.salinas', 'PLANEACION_RPT_PROD',
	 'delta', '@1ST_DAY_OF_LAST_MONTH', '@LAST_DAY_OF_LAST_MONTH', 'g0_attrition/planeacion_rpt/produccion_completa/',
	 'Pendiente', 'sise_planeacion_rpt_produccion_completa', 'migration_monthly'),
	('sise', 'PLANEACION_RPT', 'dbo', 'PRODUCCION_COMPLETA_MTD', 'QY', 'fabio.salinas', 'PLANEACION_RPT_PROD',
	 'replace', '@1ST_DAY_OF_ACTUAL_MONTH', '@TODAY_DATE', 'g0_attrition/planeacion_rpt/produccion_completa_mtd/',
	 'Pendiente', 'sise_planeacion_rpt_produccion_completa_mtd', 'migration_daily')
;


grant all on hdi.stg.hdi_tables_dags to bi_analyst;
grant all on hdi.stg.hdi_tables_dates_replacement to bi_analyst;
grant all on hdi.stg.hdi_tables_migration to bi_analyst;
grant all on hdi.stg.hdi_tables_secrets to bi_analyst;
grant all on hdi.stg.hdi_tables_systems to bi_analyst;
grant all on hdi.stg.hdi_tables_users to bi_analyst;

grant all on hdi.stg.hdi_tables_migration_id_seq to bi_analyst;
