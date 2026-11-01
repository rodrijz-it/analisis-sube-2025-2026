-- Análisis de uso de SUBE: 2025 vs 2026 (mismos días: 1/01 al 27/10)
-- Base: sube_usos.db (tabla "sube"), creada así:
--   sqlite3 sube_usos.db
--   .mode csv
--   .import sube2025.csv sube
--   .import --skip 1 sube2026.csv sube
-- Ejecutar con: sqlite3 sube_usos.db < consultas.sql

.headers on
.mode column

-- 1) VERIFICACIÓN
SELECT COUNT(*) AS filas FROM sube;

SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, MIN(DIA_TRANSPORTE) AS desde, MAX(DIA_TRANSPORTE) AS hasta, COUNT(DISTINCT DIA_TRANSPORTE) AS dias FROM sube GROUP BY anio;

SELECT DISTINCT TIPO_TRANSPORTE FROM sube;

SELECT DATO_PRELIMINAR, COUNT(*) AS filas FROM sube GROUP BY DATO_PRELIMINAR;

SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, MIN(DIA_TRANSPORTE) AS desde, MAX(DIA_TRANSPORTE) AS hasta, COUNT(*) AS filas FROM sube WHERE DATO_PRELIMINAR = 'SI' GROUP BY anio;

SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, COUNT(DISTINCT NOMBRE_EMPRESA) AS empresas, COUNT(DISTINCT LINEA) AS lineas FROM sube WHERE SUBSTR(DIA_TRANSPORTE, 6) <= '10-27' GROUP BY anio;

SELECT PROVINCIA, SUM(CAST(CANTIDAD AS INTEGER)) AS total FROM sube GROUP BY PROVINCIA ORDER BY total DESC LIMIT 10;

-- 2) ANÁLISIS (CANTIDAD se importa como texto, por eso el CAST)

-- 2.1 Total por año
SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, SUM(CAST(CANTIDAD AS INTEGER)) AS total FROM sube WHERE SUBSTR(DIA_TRANSPORTE, 6) <= '10-27' GROUP BY anio;

-- 2.2 Variación porcentual 2026 vs 2025 (con los totales de 2.1)
SELECT ROUND(100.0 * (2902662060 - 3224864561) / 3224864561, 2) AS variacion_pct;

-- 2.3 Total por año y tipo de transporte
SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, TIPO_TRANSPORTE, SUM(CAST(CANTIDAD AS INTEGER)) AS total FROM sube WHERE SUBSTR(DIA_TRANSPORTE, 6) <= '10-27' GROUP BY anio, TIPO_TRANSPORTE ORDER BY anio, total DESC;

-- 2.4 Peso de los datos preliminares
SELECT SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, DATO_PRELIMINAR, SUM(CAST(CANTIDAD AS INTEGER)) AS total, COUNT(*) AS filas FROM sube WHERE SUBSTR(DIA_TRANSPORTE, 6) <= '10-27' GROUP BY anio, DATO_PRELIMINAR;

-- 2.5 Total por mes y año
SELECT SUBSTR(DIA_TRANSPORTE, 6, 2) AS mes, SUBSTR(DIA_TRANSPORTE, 1, 4) AS anio, SUM(CAST(CANTIDAD AS INTEGER)) AS total FROM sube WHERE SUBSTR(DIA_TRANSPORTE, 6) <= '10-27' GROUP BY mes, anio ORDER BY mes, anio;

-- 3) EXPORTAR A CSV (opcional; se ejecuta a mano dentro de sqlite3)
--   .headers on
--   .mode csv
--   .output sube_mensual.csv
--   (consulta 2.5)
--   .output stdout
