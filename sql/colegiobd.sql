-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: colegio
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alumno_curso`
--

DROP TABLE IF EXISTS `alumno_curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno_curso` (
  `id_alumno_curso` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_matricula` bigint(20) unsigned NOT NULL,
  `id_docente_curso` int(11) NOT NULL,
  `anio` year(4) NOT NULL,
  PRIMARY KEY (`id_alumno_curso`),
  KEY `idx_ac_curso` (`id_docente_curso`),
  KEY `fk_ac_alumno` (`id_matricula`),
  CONSTRAINT `fk_ac_alumno` FOREIGN KEY (`id_matricula`) REFERENCES `matricula` (`id_matricula`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ac_curso` FOREIGN KEY (`id_docente_curso`) REFERENCES `docente_curso` (`id_docente_curso`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno_curso`
--

LOCK TABLES `alumno_curso` WRITE;
/*!40000 ALTER TABLE `alumno_curso` DISABLE KEYS */;
/*!40000 ALTER TABLE `alumno_curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apoderado_alumno`
--

DROP TABLE IF EXISTS `apoderado_alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apoderado_alumno` (
  `id_apoderado_alumno` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_rol_persona_apoderado` bigint(20) unsigned NOT NULL,
  `id_rol_persona_alumno` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_parentesco` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id_apoderado_alumno`),
  KEY `fk_apoderado_alumno_apoderado` (`id_rol_persona_apoderado`),
  KEY `fk_apoderado_alumno_alumno` (`id_rol_persona_alumno`),
  KEY `fk_apod_parentesco` (`id_parentesco`),
  CONSTRAINT `fk_apod_parentesco` FOREIGN KEY (`id_parentesco`) REFERENCES `parentesco` (`id_parentesco`) ON UPDATE CASCADE,
  CONSTRAINT `fk_apoderado_alumno_alumno` FOREIGN KEY (`id_rol_persona_alumno`) REFERENCES `persona_rol` (`id_persona_rol`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_apoderado_alumno_apoderado` FOREIGN KEY (`id_rol_persona_apoderado`) REFERENCES `persona_rol` (`id_persona_rol`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apoderado_alumno`
--

LOCK TABLES `apoderado_alumno` WRITE;
/*!40000 ALTER TABLE `apoderado_alumno` DISABLE KEYS */;
/*!40000 ALTER TABLE `apoderado_alumno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `area` (
  `id_area` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_area`),
  UNIQUE KEY `uk_area_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `area`
--

LOCK TABLES `area` WRITE;
/*!40000 ALTER TABLE `area` DISABLE KEYS */;
INSERT INTO `area` VALUES (1,'Matematica','Fundamentos matematicos para desarrollar razonamiento logico',1);
/*!40000 ALTER TABLE `area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comunicado`
--

DROP TABLE IF EXISTS `comunicado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comunicado` (
  `id_comunicado` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(120) NOT NULL,
  `descripcion` text NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `id_emisor` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_comunicado`),
  KEY `idx_comunicado_emisor` (`id_emisor`),
  CONSTRAINT `fk_comunicado_emisor` FOREIGN KEY (`id_emisor`) REFERENCES `usuario` (`id_usuario`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comunicado`
--

LOCK TABLES `comunicado` WRITE;
/*!40000 ALTER TABLE `comunicado` DISABLE KEYS */;
/*!40000 ALTER TABLE `comunicado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comunicado_destino`
--

DROP TABLE IF EXISTS `comunicado_destino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comunicado_destino` (
  `id_destino` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_comunicado` bigint(20) unsigned NOT NULL,
  `id_tipo_destino` tinyint(3) unsigned NOT NULL,
  `destino_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_destino`),
  KEY `idx_cd_comunicado` (`id_comunicado`),
  KEY `fk_cd_tipo` (`id_tipo_destino`),
  CONSTRAINT `fk_cd_comunicado` FOREIGN KEY (`id_comunicado`) REFERENCES `comunicado` (`id_comunicado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cd_tipo` FOREIGN KEY (`id_tipo_destino`) REFERENCES `tipo_destino` (`id_tipo_destino`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comunicado_destino`
--

LOCK TABLES `comunicado_destino` WRITE;
/*!40000 ALTER TABLE `comunicado_destino` DISABLE KEYS */;
/*!40000 ALTER TABLE `comunicado_destino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concepto_nota`
--

DROP TABLE IF EXISTS `concepto_nota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concepto_nota` (
  `id_concepto` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `descripcion` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`id_concepto`),
  UNIQUE KEY `uk_concepto_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concepto_nota`
--

LOCK TABLES `concepto_nota` WRITE;
/*!40000 ALTER TABLE `concepto_nota` DISABLE KEYS */;
/*!40000 ALTER TABLE `concepto_nota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concepto_pago`
--

DROP TABLE IF EXISTS `concepto_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concepto_pago` (
  `id_concepto_pago` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) NOT NULL,
  `id_periodicidad` tinyint(3) unsigned NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_concepto_pago`),
  UNIQUE KEY `uk_cp_desc` (`descripcion`),
  KEY `fk_cp_periodicidad` (`id_periodicidad`),
  CONSTRAINT `fk_cp_periodicidad` FOREIGN KEY (`id_periodicidad`) REFERENCES `periodicidad_pago` (`id_periodicidad`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concepto_pago`
--

LOCK TABLES `concepto_pago` WRITE;
/*!40000 ALTER TABLE `concepto_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `concepto_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso`
--

DROP TABLE IF EXISTS `curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso` (
  `id_curso` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `id_area` smallint(5) unsigned NOT NULL,
  `activo` int(11) DEFAULT 1,
  PRIMARY KEY (`id_curso`),
  UNIQUE KEY `uk_curso_nombre` (`nombre`),
  KEY `fk_curso_area` (`id_area`),
  CONSTRAINT `fk_curso_area` FOREIGN KEY (`id_area`) REFERENCES `area` (`id_area`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso`
--

LOCK TABLES `curso` WRITE;
/*!40000 ALTER TABLE `curso` DISABLE KEYS */;
INSERT INTO `curso` VALUES (1,'Algebra','Estudio de expresiones, ecuaciones y funciones',1,1),(2,'Geometria','Calculo',1,1);
/*!40000 ALTER TABLE `curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docente_curso`
--

DROP TABLE IF EXISTS `docente_curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docente_curso` (
  `id_docente_curso` int(11) NOT NULL AUTO_INCREMENT,
  `id_docente` bigint(20) unsigned NOT NULL,
  `id_curso` int(10) unsigned NOT NULL,
  `id_grado_seccion` int(11) NOT NULL,
  `anio` year(4) NOT NULL,
  PRIMARY KEY (`id_docente_curso`),
  KEY `idx_dc_docente` (`id_docente`),
  KEY `idx_dc_curso` (`id_curso`),
  KEY `idx_dc_grado_seccion` (`id_grado_seccion`),
  CONSTRAINT `fk_dc_curso` FOREIGN KEY (`id_curso`) REFERENCES `curso` (`id_curso`) ON UPDATE CASCADE,
  CONSTRAINT `fk_dc_docente` FOREIGN KEY (`id_docente`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE,
  CONSTRAINT `fk_dc_grado_seccion` FOREIGN KEY (`id_grado_seccion`) REFERENCES `grado_seccion` (`id_grado_seccion`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente_curso`
--

LOCK TABLES `docente_curso` WRITE;
/*!40000 ALTER TABLE `docente_curso` DISABLE KEYS */;
/*!40000 ALTER TABLE `docente_curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrega_utiles`
--

DROP TABLE IF EXISTS `entrega_utiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrega_utiles` (
  `id_entrega` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_alumno` bigint(20) unsigned NOT NULL,
  `id_utiles_grado` int(10) unsigned NOT NULL,
  `fecha_entrega` date NOT NULL,
  `cantidad` smallint(5) unsigned NOT NULL DEFAULT 1,
  `observacion` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`id_entrega`),
  KEY `idx_eu_alumno` (`id_alumno`),
  KEY `idx_eu_util` (`id_utiles_grado`),
  CONSTRAINT `fk_eu_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_eu_util` FOREIGN KEY (`id_utiles_grado`) REFERENCES `utiles_grado` (`id_utiles_grado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrega_utiles`
--

LOCK TABLES `entrega_utiles` WRITE;
/*!40000 ALTER TABLE `entrega_utiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `entrega_utiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escala_nota`
--

DROP TABLE IF EXISTS `escala_nota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `escala_nota` (
  `id_escala` tinyint(4) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(5) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`id_escala`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escala_nota`
--

LOCK TABLES `escala_nota` WRITE;
/*!40000 ALTER TABLE `escala_nota` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_nota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_asistencia`
--

DROP TABLE IF EXISTS `estado_asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_asistencia` (
  `id_estado` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `uk_estado_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_asistencia`
--

LOCK TABLES `estado_asistencia` WRITE;
/*!40000 ALTER TABLE `estado_asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `estado_asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_matricula`
--

DROP TABLE IF EXISTS `estado_matricula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_matricula` (
  `id_estado_matricula` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `observacion` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_estado_matricula`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_matricula`
--

LOCK TABLES `estado_matricula` WRITE;
/*!40000 ALTER TABLE `estado_matricula` DISABLE KEYS */;
/*!40000 ALTER TABLE `estado_matricula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_pago`
--

DROP TABLE IF EXISTS `estado_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_pago` (
  `id_estado_pago` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `es_inicial` tinyint(1) NOT NULL DEFAULT 0,
  `es_final` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_estado_pago`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_pago`
--

LOCK TABLES `estado_pago` WRITE;
/*!40000 ALTER TABLE `estado_pago` DISABLE KEYS */;
INSERT INTO `estado_pago` VALUES (1,'PENDIENTE',1,0),(2,'PAGADO',0,1),(3,'ANULADO',0,1),(4,'VENCIDO',0,0);
/*!40000 ALTER TABLE `estado_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_usuario`
--

DROP TABLE IF EXISTS `estado_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_usuario` (
  `id_estado` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(30) NOT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `uk_estado_nombre` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_usuario`
--

LOCK TABLES `estado_usuario` WRITE;
/*!40000 ALTER TABLE `estado_usuario` DISABLE KEYS */;
INSERT INTO `estado_usuario` VALUES (1,'ACTIVO'),(3,'BLOQUEADO'),(2,'INACTIVO');
/*!40000 ALTER TABLE `estado_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grado`
--

DROP TABLE IF EXISTS `grado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grado` (
  `id_grado` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_grado` varchar(30) NOT NULL,
  `id_nivel` tinyint(3) unsigned NOT NULL,
  `activo` int(11) DEFAULT 1,
  PRIMARY KEY (`id_grado`),
  UNIQUE KEY `uk_grado_nombre` (`nombre_grado`,`id_nivel`),
  KEY `fk_grado_nivel` (`id_nivel`),
  CONSTRAINT `fk_grado_nivel` FOREIGN KEY (`id_nivel`) REFERENCES `nivel` (`id_nivel`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grado`
--

LOCK TABLES `grado` WRITE;
/*!40000 ALTER TABLE `grado` DISABLE KEYS */;
INSERT INTO `grado` VALUES (1,'Primero',2,1),(2,'Segundo',2,1),(3,'Tercero',2,1),(4,'Cuarto',2,1),(5,'Quinto',3,1);
/*!40000 ALTER TABLE `grado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grado_seccion`
--

DROP TABLE IF EXISTS `grado_seccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grado_seccion` (
  `id_grado_seccion` int(11) NOT NULL AUTO_INCREMENT,
  `id_grado` smallint(5) unsigned NOT NULL,
  `id_seccion` smallint(5) unsigned NOT NULL,
  `anio_escolar` smallint(5) unsigned NOT NULL,
  `id_turno` tinyint(3) unsigned NOT NULL,
  `vacantes` smallint(5) unsigned NOT NULL,
  `activo` int(11) DEFAULT 1,
  PRIMARY KEY (`id_grado_seccion`),
  UNIQUE KEY `uq_grado_seccion` (`id_grado`,`id_seccion`,`anio_escolar`,`id_turno`),
  KEY `fk_gs_seccion` (`id_seccion`),
  KEY `fk_gs_turno` (`id_turno`),
  CONSTRAINT `fk_gs_grado` FOREIGN KEY (`id_grado`) REFERENCES `grado` (`id_grado`) ON UPDATE CASCADE,
  CONSTRAINT `fk_gs_seccion` FOREIGN KEY (`id_seccion`) REFERENCES `seccion` (`id_seccion`) ON UPDATE CASCADE,
  CONSTRAINT `fk_gs_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grado_seccion`
--

LOCK TABLES `grado_seccion` WRITE;
/*!40000 ALTER TABLE `grado_seccion` DISABLE KEYS */;
INSERT INTO `grado_seccion` VALUES (2,2,1,2025,1,15,1),(3,2,2,2025,1,15,0),(5,2,1,2025,2,24,1);
/*!40000 ALTER TABLE `grado_seccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matricula`
--

DROP TABLE IF EXISTS `matricula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matricula` (
  `id_matricula` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_alumno` bigint(20) unsigned NOT NULL,
  `id_grado_seccion` int(11) NOT NULL,
  `anio` year(4) NOT NULL,
  `fecha_matricula` date NOT NULL,
  `observacion` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_estado_matricula` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_matricula`),
  UNIQUE KEY `uk_matricula_unica` (`id_alumno`,`anio`),
  KEY `fk_grado_seccion` (`id_grado_seccion`),
  KEY `fk_matricula_estado` (`id_estado_matricula`),
  CONSTRAINT `fk_grado_seccion` FOREIGN KEY (`id_grado_seccion`) REFERENCES `grado_seccion` (`id_grado_seccion`) ON UPDATE CASCADE,
  CONSTRAINT `fk_mat_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matricula_estado` FOREIGN KEY (`id_estado_matricula`) REFERENCES `estado_matricula` (`id_estado_matricula`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matricula`
--

LOCK TABLES `matricula` WRITE;
/*!40000 ALTER TABLE `matricula` DISABLE KEYS */;
/*!40000 ALTER TABLE `matricula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nivel`
--

DROP TABLE IF EXISTS `nivel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nivel` (
  `id_nivel` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_nivel`),
  UNIQUE KEY `uk_nivel_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nivel`
--

LOCK TABLES `nivel` WRITE;
/*!40000 ALTER TABLE `nivel` DISABLE KEYS */;
INSERT INTO `nivel` VALUES (1,'Inicial',1),(2,'Primaria',0),(3,'Secundaria',1);
/*!40000 ALTER TABLE `nivel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nota`
--

DROP TABLE IF EXISTS `nota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nota` (
  `id_nota` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_alumno_curso` bigint(20) unsigned NOT NULL,
  `id_concepto` smallint(5) unsigned NOT NULL,
  `id_escala` tinyint(4) NOT NULL,
  `anio` year(4) NOT NULL,
  `fecha` date NOT NULL,
  `observacion` varchar(160) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_nota`),
  KEY `idx_nota_curso` (`id_alumno_curso`),
  KEY `fk_nota_concepto` (`id_concepto`),
  KEY `fk_nota_escala` (`id_escala`),
  CONSTRAINT `fk_nota_alumno` FOREIGN KEY (`id_alumno_curso`) REFERENCES `alumno_curso` (`id_alumno_curso`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_nota_concepto` FOREIGN KEY (`id_concepto`) REFERENCES `concepto_nota` (`id_concepto`) ON UPDATE CASCADE,
  CONSTRAINT `fk_nota_escala` FOREIGN KEY (`id_escala`) REFERENCES `escala_nota` (`id_escala`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nota`
--

LOCK TABLES `nota` WRITE;
/*!40000 ALTER TABLE `nota` DISABLE KEYS */;
/*!40000 ALTER TABLE `nota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `id_pago` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_matricula` bigint(20) unsigned NOT NULL,
  `id_tarifa` int(10) unsigned NOT NULL,
  `fecha_pago` datetime NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(10,2) NOT NULL,
  `id_estado_pago` tinyint(3) unsigned NOT NULL,
  `observacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `idx_pago_matricula` (`id_matricula`),
  KEY `idx_pago_tarifa` (`id_tarifa`),
  KEY `fk_pago_estado` (`id_estado_pago`),
  CONSTRAINT `fk_pago_estado` FOREIGN KEY (`id_estado_pago`) REFERENCES `estado_pago` (`id_estado_pago`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pago_matricula` FOREIGN KEY (`id_matricula`) REFERENCES `matricula` (`id_matricula`) ON UPDATE CASCADE,
  CONSTRAINT `fk_tarifa_pago` FOREIGN KEY (`id_tarifa`) REFERENCES `tarifa_pago` (`id_tarifa`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parentesco`
--

DROP TABLE IF EXISTS `parentesco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parentesco` (
  `id_parentesco` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_parentesco`),
  UNIQUE KEY `uk_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parentesco`
--

LOCK TABLES `parentesco` WRITE;
/*!40000 ALTER TABLE `parentesco` DISABLE KEYS */;
INSERT INTO `parentesco` VALUES (1,'Padre',1),(2,'Madre',1);
/*!40000 ALTER TABLE `parentesco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periodicidad_pago`
--

DROP TABLE IF EXISTS `periodicidad_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `periodicidad_pago` (
  `id_periodicidad` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_periodicidad`),
  UNIQUE KEY `uk_periodicidad_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periodicidad_pago`
--

LOCK TABLES `periodicidad_pago` WRITE;
/*!40000 ALTER TABLE `periodicidad_pago` DISABLE KEYS */;
INSERT INTO `periodicidad_pago` VALUES (1,'UNICO','Pago que se realiza una sola vez'),(2,'MENSUAL','Pago que se realiza cada mes'),(3,'ANUAL','Pago que se realiza cada año');
/*!40000 ALTER TABLE `periodicidad_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona`
--

DROP TABLE IF EXISTS `persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persona` (
  `id_persona` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dni` char(8) DEFAULT NULL,
  `nombres` varchar(80) NOT NULL,
  `apellido_paterno` varchar(50) NOT NULL,
  `apellido_materno` varchar(50) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `direccion` varchar(160) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(120) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `uk_persona_dni` (`dni`),
  UNIQUE KEY `uk_persona_correo` (`correo`),
  KEY `idx_persona_telefono` (`telefono`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona`
--

LOCK TABLES `persona` WRITE;
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` VALUES (1,'72687994','Jonathan Guillermo','Sanchez','Maluquis','2002-02-07','sacsahuaman 787','987654321','maluquis@gmail.com','2025-10-21 01:06:31','2025-10-21 01:06:31'),(2,'76587993','Juan Diego','Reyes','Salazar','2010-09-08','san ignacion 123','97627836','juan@gmail.com','2025-10-21 01:07:58','2025-10-21 01:07:58'),(3,'68736216','Elena ','Fernandez','Sanchez','2015-10-01','tupac amaru 300','986562126','elen@gmail.com','2025-10-21 04:24:47','2025-10-21 04:24:47'),(4,'77777777','Pedro','Bances','Ramos','1990-12-08','tucume 07','975832673','ban@gmail.com','2025-10-24 01:44:14','2025-10-24 01:44:14'),(5,'72337543','Jose Maria','Altamirano','Ramirez','2030-01-08','tupac 111','987654321','jose@gmail.com','2025-10-25 00:18:56','2025-10-25 00:18:56');
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona_rol`
--

DROP TABLE IF EXISTS `persona_rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persona_rol` (
  `id_persona_rol` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` bigint(20) unsigned NOT NULL,
  `id_rol` smallint(5) unsigned NOT NULL,
  `asignado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_persona_rol`),
  KEY `fk_pr_persona` (`id_persona`),
  KEY `fk_pr_rol` (`id_rol`),
  CONSTRAINT `fk_pr_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona_rol`
--

LOCK TABLES `persona_rol` WRITE;
/*!40000 ALTER TABLE `persona_rol` DISABLE KEYS */;
INSERT INTO `persona_rol` VALUES (1,1,3,'2025-10-21 01:06:31'),(2,2,3,'2025-10-21 01:07:58'),(3,2,5,'2025-10-21 01:07:58'),(4,3,3,'2025-10-21 04:24:47'),(5,4,6,'2025-10-24 01:44:14'),(6,5,3,'2025-10-25 00:18:56');
/*!40000 ALTER TABLE `persona_rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registro_asistencia`
--

DROP TABLE IF EXISTS `registro_asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_asistencia` (
  `id_registro` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_alumno_curso` bigint(20) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `id_estado` tinyint(3) unsigned NOT NULL,
  `observacion` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`id_registro`),
  UNIQUE KEY `uk_asistencia` (`id_alumno_curso`,`fecha`),
  KEY `idx_asistencia_curso` (`id_alumno_curso`),
  KEY `fk_asist_estado` (`id_estado`),
  CONSTRAINT `fk_asist_alumno` FOREIGN KEY (`id_alumno_curso`) REFERENCES `alumno_curso` (`id_alumno_curso`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_asist_estado` FOREIGN KEY (`id_estado`) REFERENCES `estado_asistencia` (`id_estado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registro_asistencia`
--

LOCK TABLES `registro_asistencia` WRITE;
/*!40000 ALTER TABLE `registro_asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `registro_asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(40) NOT NULL,
  `descripcion` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `uk_rol_nombre` (`nombre_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (3,'ALUMNO','estudiante'),(4,'APODERADO','Tutores'),(5,'DOCENTE','profesores'),(6,'ADMINISTRADOR','Acceso a todo el sistema'),(7,'MANTENIMIENTO','mantener el sistema');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seccion`
--

DROP TABLE IF EXISTS `seccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seccion` (
  `id_seccion` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_seccion` varchar(10) NOT NULL,
  `aforo_max` smallint(5) unsigned DEFAULT NULL,
  `activo` int(11) DEFAULT 1,
  PRIMARY KEY (`id_seccion`),
  KEY `idx_seccion_nombre` (`nombre_seccion`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seccion`
--

LOCK TABLES `seccion` WRITE;
/*!40000 ALTER TABLE `seccion` DISABLE KEYS */;
INSERT INTO `seccion` VALUES (1,'A',30,1),(2,'B',30,1);
/*!40000 ALTER TABLE `seccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifa_pago`
--

DROP TABLE IF EXISTS `tarifa_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifa_pago` (
  `id_tarifa` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_grado` smallint(5) unsigned NOT NULL,
  `id_concepto_pago` smallint(5) unsigned NOT NULL,
  `anio_escolar` year(4) NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `cuotas` tinyint(3) unsigned NOT NULL,
  `monto_cuota` decimal(10,2) GENERATED ALWAYS AS (`monto_total` / `cuotas`) STORED,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_tarifa`),
  UNIQUE KEY `uk_tarifa` (`id_grado`,`id_concepto_pago`,`anio_escolar`),
  KEY `fk_tp_concepto` (`id_concepto_pago`),
  CONSTRAINT `fk_tp_concepto` FOREIGN KEY (`id_concepto_pago`) REFERENCES `concepto_pago` (`id_concepto_pago`) ON UPDATE CASCADE,
  CONSTRAINT `fk_tp_grado` FOREIGN KEY (`id_grado`) REFERENCES `grado` (`id_grado`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifa_pago`
--

LOCK TABLES `tarifa_pago` WRITE;
/*!40000 ALTER TABLE `tarifa_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarifa_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_destino`
--

DROP TABLE IF EXISTS `tipo_destino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_destino` (
  `id_tipo_destino` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `descripcion` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_destino`),
  UNIQUE KEY `uk_tipo_destino_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_destino`
--

LOCK TABLES `tipo_destino` WRITE;
/*!40000 ALTER TABLE `tipo_destino` DISABLE KEYS */;
INSERT INTO `tipo_destino` VALUES (1,'USUARIO','Un usuario específico'),(2,'GRADO','Todos los alumnos de un grado'),(3,'GRADO_SECCION','Todos los alumnos de una sección'),(4,'ROL','Todos los usuarios que tengan un rol específico');
/*!40000 ALTER TABLE `tipo_destino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turno`
--

DROP TABLE IF EXISTS `turno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turno` (
  `id_turno` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_turno` varchar(20) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_turno`),
  UNIQUE KEY `nombre_turno` (`nombre_turno`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turno`
--

LOCK TABLES `turno` WRITE;
/*!40000 ALTER TABLE `turno` DISABLE KEYS */;
INSERT INTO `turno` VALUES (1,'MANANA',1),(2,'TARDE',1),(4,'NOCHE',1);
/*!40000 ALTER TABLE `turno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(40) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `id_persona` bigint(20) unsigned NOT NULL,
  `id_estado` tinyint(3) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_usuario_username` (`username`),
  KEY `idx_usuario_persona` (`id_persona`),
  KEY `fk_usuario_estado` (`id_estado`),
  CONSTRAINT `fk_usuario_estado` FOREIGN KEY (`id_estado`) REFERENCES `estado_usuario` (`id_estado`) ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'jonsanchez@mrn.edu.pe','72687994',1,1,'2025-10-23 17:40:46',NULL),(2,'pedo@mrn.edu.pe','77777777',4,1,'2025-10-24 01:45:55',NULL);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utiles`
--

DROP TABLE IF EXISTS `utiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utiles` (
  `id_util` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_util` varchar(80) NOT NULL,
  `descripcion` varchar(160) DEFAULT NULL,
  PRIMARY KEY (`id_util`),
  UNIQUE KEY `uk_util_nombre` (`nombre_util`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utiles`
--

LOCK TABLES `utiles` WRITE;
/*!40000 ALTER TABLE `utiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `utiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utiles_grado`
--

DROP TABLE IF EXISTS `utiles_grado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utiles_grado` (
  `id_utiles_grado` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_grado` smallint(5) unsigned NOT NULL,
  `id_util` int(10) unsigned NOT NULL,
  `cantidad` smallint(5) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_utiles_grado`),
  KEY `idx_ug_util` (`id_util`),
  KEY `fk_ug_grado` (`id_grado`),
  CONSTRAINT `fk_ug_grado` FOREIGN KEY (`id_grado`) REFERENCES `grado` (`id_grado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ug_util` FOREIGN KEY (`id_util`) REFERENCES `utiles` (`id_util`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utiles_grado`
--

LOCK TABLES `utiles_grado` WRITE;
/*!40000 ALTER TABLE `utiles_grado` DISABLE KEYS */;
/*!40000 ALTER TABLE `utiles_grado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'colegio'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-24 21:12:07
