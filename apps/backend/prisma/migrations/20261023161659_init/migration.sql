-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('ADMIN', 'GERENTE', 'ENCARGADO_AREA', 'TECNICO_TI', 'ENCARGADO_SEGURIDAD', 'EMPLEADO');

-- CreateEnum
CREATE TYPE "EstadoIdea" AS ENUM ('PROPUESTA', 'FILTRO_AREA', 'VIABILIDAD_TECNICA', 'CUMPLIMIENTO_SEGURIDAD', 'APROBACION_GERENTE', 'EN_DESARROLLO', 'COMPLETADA', 'RECHAZADA');

-- CreateEnum
CREATE TYPE "PilarEstrategico" AS ENUM ('INFRAESTRUCTURA', 'SEGURIDAD', 'EXPERIENCIA_CLIENTE', 'EFICIENCIA_OPERATIVA');

-- CreateEnum
CREATE TYPE "Criticidad" AS ENUM ('ALTA', 'MEDIA', 'BAJA');

-- CreateEnum
CREATE TYPE "PrioridadTicket" AS ENUM ('ALTA', 'MEDIA', 'BAJA');

-- CreateEnum
CREATE TYPE "EstadoTicket" AS ENUM ('ABIERTO', 'EN_PROGRESO', 'RESUELTO', 'CERRADO', 'VENCIDO');

-- CreateEnum
CREATE TYPE "TipoActivo" AS ENUM ('BASE_DATOS', 'SERVIDOR', 'EQUIPO', 'SOFTWARE', 'RED');

-- CreateEnum
CREATE TYPE "NivelRiesgo" AS ENUM ('VERDE', 'AMARILLO', 'ROJO');

-- CreateEnum
CREATE TYPE "NivelMeta" AS ENUM ('EMPRESA', 'TI', 'PROCESO');

-- CreateEnum
CREATE TYPE "TipoEvaluacionFundibeq" AS ENUM ('AUTOEVALUACION', 'EXTERNA', 'BENCHMARKING');

-- CreateEnum
CREATE TYPE "TipoElementoFundibeq" AS ENUM ('FACILITADOR', 'RESULTADO');

-- CreateEnum
CREATE TYPE "EstadoGenerico" AS ENUM ('PENDIENTE', 'EN_CURSO', 'COMPLETADO');

-- CreateEnum
CREATE TYPE "EstadoPropuesta" AS ENUM ('BORRADOR', 'APROBADA', 'RECHAZADA', 'EN_EJECUCION', 'COMPLETADA');

-- CreateTable
CREATE TABLE "Usuario" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "rol" "Rol" NOT NULL DEFAULT 'EMPLEADO',
    "area" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "ideasMesActual" INTEGER NOT NULL DEFAULT 0,
    "ultimoReinicio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "idUsuario" TEXT,
    "accion" TEXT NOT NULL,
    "tablaAfectada" TEXT NOT NULL,
    "idRegistro" TEXT,
    "datosAnteriores" JSONB,
    "datosNuevos" JSONB,
    "ip" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Idea" (
    "id" TEXT NOT NULL,
    "titulo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "pilar" "PilarEstrategico" NOT NULL,
    "estado" "EstadoIdea" NOT NULL DEFAULT 'PROPUESTA',
    "scorePrioridad" INTEGER,
    "motivoRechazo" TEXT,
    "idUsuario" TEXT NOT NULL,
    "idMeta" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Idea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApoyoIdea" (
    "id" TEXT NOT NULL,
    "idIdea" TEXT NOT NULL,
    "idUsuario" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ApoyoIdea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HistorialIdea" (
    "id" TEXT NOT NULL,
    "idIdea" TEXT NOT NULL,
    "estadoAnterior" "EstadoIdea" NOT NULL,
    "estadoNuevo" "EstadoIdea" NOT NULL,
    "idUsuario" TEXT NOT NULL,
    "comentario" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HistorialIdea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FeedbackIdea" (
    "id" TEXT NOT NULL,
    "idIdea" TEXT NOT NULL,
    "calificacion" INTEGER NOT NULL,
    "comentario" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FeedbackIdea_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Servicio" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "criticidad" "Criticidad" NOT NULL,
    "slaHoras" INTEGER NOT NULL,
    "idDueno" TEXT NOT NULL,
    "valorGenerado" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "cadenaITIL" JSONB NOT NULL DEFAULT '{"planificar":false,"mejorar":false,"involucrar":false,"disenar_transitar":false,"obtener_construir":false,"entregar_soportar":false}',
    "entradasSalidas" JSONB NOT NULL DEFAULT '[]',
    "rtoHoras" INTEGER,
    "rpoHoras" INTEGER,
    "estrategiaRespaldo" TEXT,
    "continuidadEstado" TEXT,
    "ultimaPrueba" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Servicio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ticket" (
    "id" TEXT NOT NULL,
    "idServicio" TEXT NOT NULL,
    "idUsuario" TEXT NOT NULL,
    "idTecnicoAsignado" TEXT,
    "descripcion" TEXT NOT NULL,
    "prioridad" "PrioridadTicket" NOT NULL,
    "estado" "EstadoTicket" NOT NULL DEFAULT 'ABIERTO',
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaLimite" TIMESTAMP(3) NOT NULL,
    "fechaResolucion" TIMESTAMP(3),

    CONSTRAINT "Ticket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Activo" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "tipo" "TipoActivo" NOT NULL,
    "ubicacion" TEXT,
    "idDueno" TEXT NOT NULL,
    "criticidad" "Criticidad" NOT NULL,
    "requisitosCOBIT" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Activo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Riesgo" (
    "id" TEXT NOT NULL,
    "idActivo" TEXT NOT NULL,
    "amenaza" TEXT NOT NULL,
    "vulnerabilidad" TEXT NOT NULL,
    "probabilidad" INTEGER NOT NULL,
    "impacto" INTEGER NOT NULL,
    "riesgoCalculado" INTEGER NOT NULL,
    "nivel" "NivelRiesgo" NOT NULL,
    "accionMitigacion" TEXT,
    "idResponsableMitigacion" TEXT,
    "fechaLimiteMitigacion" TIMESTAMP(3),
    "estadoMitigacion" "EstadoGenerico",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Riesgo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Control" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "implementado" BOOLEAN NOT NULL DEFAULT false,
    "fechaImplementacion" TIMESTAMP(3),
    "idResponsable" TEXT,

    CONSTRAINT "Control_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncidenteSeguridad" (
    "id" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tipo" TEXT NOT NULL,
    "idActivo" TEXT NOT NULL,
    "impacto" TEXT NOT NULL,
    "acciones" TEXT,
    "estado" TEXT NOT NULL,
    "idReportadoPor" TEXT NOT NULL,

    CONSTRAINT "IncidenteSeguridad_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MetaCOBIT" (
    "id" TEXT NOT NULL,
    "nivel" "NivelMeta" NOT NULL,
    "descripcion" TEXT NOT NULL,
    "idMetaPadre" TEXT,

    CONSTRAINT "MetaCOBIT_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Madurez" (
    "id" TEXT NOT NULL,
    "proceso" TEXT NOT NULL,
    "nivelActual" INTEGER NOT NULL,
    "nivelObjetivo" INTEGER NOT NULL,
    "fechaEvaluacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "observaciones" TEXT,

    CONSTRAINT "Madurez_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EvaluacionFundibeq" (
    "id" TEXT NOT NULL,
    "tipoElemento" "TipoElementoFundibeq" NOT NULL,
    "nombre" TEXT NOT NULL,
    "puntuacion" INTEGER NOT NULL,
    "evidencias" TEXT,
    "tipoEvaluacion" "TipoEvaluacionFundibeq" NOT NULL DEFAULT 'AUTOEVALUACION',
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EvaluacionFundibeq_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropuestaSolucion" (
    "id" TEXT NOT NULL,
    "objetivo" TEXT NOT NULL,
    "cambios" TEXT NOT NULL,
    "inversion" DOUBLE PRECISION NOT NULL,
    "costo" DOUBLE PRECISION NOT NULL,
    "beneficio" TEXT NOT NULL,
    "riesgo" TEXT NOT NULL,
    "estado" "EstadoPropuesta" NOT NULL DEFAULT 'BORRADOR',
    "idUsuario" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PropuestaSolucion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Planificacion" (
    "id" TEXT NOT NULL,
    "hito" TEXT NOT NULL,
    "entregable" TEXT NOT NULL,
    "idResponsable" TEXT NOT NULL,
    "fechaEntrega" TIMESTAMP(3) NOT NULL,
    "estado" "EstadoGenerico" NOT NULL DEFAULT 'PENDIENTE',

    CONSTRAINT "Planificacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mantenimiento" (
    "id" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idResponsable" TEXT NOT NULL,
    "estado" "EstadoGenerico" NOT NULL DEFAULT 'PENDIENTE',

    CONSTRAINT "Mantenimiento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FaseImplementacion" (
    "id" TEXT NOT NULL,
    "fase" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    "estado" "EstadoGenerico" NOT NULL DEFAULT 'PENDIENTE',
    "fechaInicio" TIMESTAMP(3),
    "fechaFin" TIMESTAMP(3),
    "evidencias" TEXT,

    CONSTRAINT "FaseImplementacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FactorDiseno" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "valor" TEXT NOT NULL,
    "descripcion" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FactorDiseno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Configuracion" (
    "id" TEXT NOT NULL,
    "clave" TEXT NOT NULL,
    "valor" TEXT NOT NULL,
    "descripcion" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Configuracion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_email_key" ON "Usuario"("email");

-- CreateIndex
CREATE INDEX "Usuario_rol_idx" ON "Usuario"("rol");

-- CreateIndex
CREATE INDEX "AuditLog_tablaAfectada_idx" ON "AuditLog"("tablaAfectada");

-- CreateIndex
CREATE INDEX "AuditLog_idUsuario_idx" ON "AuditLog"("idUsuario");

-- CreateIndex
CREATE INDEX "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");

-- CreateIndex
CREATE INDEX "Idea_estado_idx" ON "Idea"("estado");

-- CreateIndex
CREATE INDEX "Idea_pilar_idx" ON "Idea"("pilar");

-- CreateIndex
CREATE UNIQUE INDEX "ApoyoIdea_idIdea_idUsuario_key" ON "ApoyoIdea"("idIdea", "idUsuario");

-- CreateIndex
CREATE UNIQUE INDEX "FeedbackIdea_idIdea_key" ON "FeedbackIdea"("idIdea");

-- CreateIndex
CREATE INDEX "Servicio_activo_idx" ON "Servicio"("activo");

-- CreateIndex
CREATE INDEX "Ticket_estado_idx" ON "Ticket"("estado");

-- CreateIndex
CREATE INDEX "Ticket_idTecnicoAsignado_idx" ON "Ticket"("idTecnicoAsignado");

-- CreateIndex
CREATE INDEX "Riesgo_nivel_idx" ON "Riesgo"("nivel");

-- CreateIndex
CREATE UNIQUE INDEX "Madurez_proceso_key" ON "Madurez"("proceso");

-- CreateIndex
CREATE INDEX "EvaluacionFundibeq_tipoElemento_nombre_idx" ON "EvaluacionFundibeq"("tipoElemento", "nombre");

-- CreateIndex
CREATE UNIQUE INDEX "FaseImplementacion_fase_key" ON "FaseImplementacion"("fase");

-- CreateIndex
CREATE UNIQUE INDEX "FactorDiseno_nombre_key" ON "FactorDiseno"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Configuracion_clave_key" ON "Configuracion"("clave");

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Idea" ADD CONSTRAINT "Idea_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Idea" ADD CONSTRAINT "Idea_idMeta_fkey" FOREIGN KEY ("idMeta") REFERENCES "MetaCOBIT"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApoyoIdea" ADD CONSTRAINT "ApoyoIdea_idIdea_fkey" FOREIGN KEY ("idIdea") REFERENCES "Idea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApoyoIdea" ADD CONSTRAINT "ApoyoIdea_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HistorialIdea" ADD CONSTRAINT "HistorialIdea_idIdea_fkey" FOREIGN KEY ("idIdea") REFERENCES "Idea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HistorialIdea" ADD CONSTRAINT "HistorialIdea_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FeedbackIdea" ADD CONSTRAINT "FeedbackIdea_idIdea_fkey" FOREIGN KEY ("idIdea") REFERENCES "Idea"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Servicio" ADD CONSTRAINT "Servicio_idDueno_fkey" FOREIGN KEY ("idDueno") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_idServicio_fkey" FOREIGN KEY ("idServicio") REFERENCES "Servicio"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_idTecnicoAsignado_fkey" FOREIGN KEY ("idTecnicoAsignado") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Activo" ADD CONSTRAINT "Activo_idDueno_fkey" FOREIGN KEY ("idDueno") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Riesgo" ADD CONSTRAINT "Riesgo_idActivo_fkey" FOREIGN KEY ("idActivo") REFERENCES "Activo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Riesgo" ADD CONSTRAINT "Riesgo_idResponsableMitigacion_fkey" FOREIGN KEY ("idResponsableMitigacion") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Control" ADD CONSTRAINT "Control_idResponsable_fkey" FOREIGN KEY ("idResponsable") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidenteSeguridad" ADD CONSTRAINT "IncidenteSeguridad_idActivo_fkey" FOREIGN KEY ("idActivo") REFERENCES "Activo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidenteSeguridad" ADD CONSTRAINT "IncidenteSeguridad_idReportadoPor_fkey" FOREIGN KEY ("idReportadoPor") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MetaCOBIT" ADD CONSTRAINT "MetaCOBIT_idMetaPadre_fkey" FOREIGN KEY ("idMetaPadre") REFERENCES "MetaCOBIT"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropuestaSolucion" ADD CONSTRAINT "PropuestaSolucion_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Planificacion" ADD CONSTRAINT "Planificacion_idResponsable_fkey" FOREIGN KEY ("idResponsable") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mantenimiento" ADD CONSTRAINT "Mantenimiento_idResponsable_fkey" FOREIGN KEY ("idResponsable") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
