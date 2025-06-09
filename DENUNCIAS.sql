CREATE DATABASE DENUNCIAS;


CREATE TABLE denuncia (
	idDenuncia INT PRIMARY KEY,
	fechaSuceso DATE NOT NULL,
	horaSuceso TIME NOT NULL,
	tipoDenuncia varchar(20) NOT NULL CHECK (
		tipoDenuncia IN ('Abuso Sexual', 'Acoso', 'Acoso Sexual', 'Domestica', 'Psicologica', 'Violencia')), 
	estado varchar(20) NOT NULL CHECK (
		estado IN ('Nueva','En Revision', 'Aprobada', 'Rechazada', 'En Proceso', 'Resuelta', 'Cerrada', 'Eliminada')),
	riesgo varchar(20) NOT NULL CHECK (riesgo IN ('ALTO', 'CRITICO', 'EXTREMO'))
);

CREATE TABLE datos_personales(
	idDenuncia INT PRIMARY KEY,
	nombre varchar(50) NOT NULL,
	apellidoPaterno varchar(50) NOT NULL,
	apellidoMaterno varchar(50) NOT NULL,
	tipoDocumento varchar(4) NOT NULL CHECK (tipoDocumento IN ('DNI','CE')),
	idDocumento INT NOT NULL,
	email varchar(100) NOT NULL,
	celular varchar(20) NOT NULL,
	edad INT NOT NULL
	FOREIGN KEY (idDenuncia) REFERENCES denuncia(idDenuncia) ON DELETE CASCADE
);

CREATE TABLE ubicacion(
	idDenuncia INT PRIMARY KEY,
	departamento varchar(50) NOT NULL,
	provincia varchar(50) NOT NULL,
	distrito varchar(50) NOT NULL,
	direccion varchar(200),
	detallesAdicionales varchar(500)
	FOREIGN KEY (idDenuncia) REFERENCES denuncia(idDenuncia) ON DELETE CASCADE
);

CREATE TABLE detalles_denuncia(
	idDenuncia INT PRIMARY KEY, 
	victima varchar(100),
	agresor varchar(100),
	relacionAgresor varchar(20) CHECK (relacionAgresor IN ('Ninguna', 'Conocido/a', 'Amistad', 'Pareja')),
	medio varchar(20) CHECK (medio IN ('Virtual', 'Presencial')),
	testigos bit,
	frecuencia varchar(20) CHECK (frecuencia IN ('Primera Vez', 'Ocasionalmente', 'Frecuentemente', 'Repetitivo')),
	menoresInvolucrados bit,
	sintomas varchar(50),
	heridas varchar(200),
	gravedadHeridas varchar(20) CHECK (gravedadHeridas IN ('Leve', 'Moderada', 'Grave')), 
	hospitalizacion bit,
	usoDeObjetos bit,
	agresores bit,
	objetos varchar(50),
	descripcion varchar(1000)
	FOREIGN KEY (idDenuncia) REFERENCES denuncia(idDenuncia) ON DELETE CASCADE
);


GO
CREATE FUNCTION fn_getDenunciaAcoso(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Testigos: ' + CASE WHEN dd.testigos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Frecuencia: ' + dd.frecuencia + CHAR(13) +
	'Medio: ' + ISNULL(dd.medio, 'No especificado') + CHAR(13) +
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion

	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'ACOSO';




GO
CREATE FUNCTION fn_getDenunciaAcosoSexual(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Testigos: ' + CASE WHEN dd.testigos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Frecuencia: ' + dd.frecuencia + CHAR(13) +
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion


	
	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'ACOSO_SEXUAL';




GO
CREATE FUNCTION fn_getDenunciaAbusoSexual(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Más de un agresor: ' + CASE WHEN dd.agresores = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Testigos: ' + CASE WHEN dd.testigos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Sintomas: '+ ISNULL(dd.sintomas, 'No especficados') + CHAR(13) +
	'Hospitalización: ' + CASE WHEN dd.hospitalizacion = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion

	
	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'ABUSO_SEXUAL';




GO
CREATE FUNCTION fn_getDenunciaDomestica(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Testigos: ' + CASE WHEN dd.testigos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Frecuencia: ' + dd.frecuencia + CHAR(13) +
	'Heridas: ' +  ISNULL(dd.heridas, 'No especificados') + CHAR(13) + 
	'Gravedad de las heridas: ' + dd.gravedadHeridas + CHAR(13) +
	'Hospitalización: ' + CASE WHEN dd.hospitalizacion = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Menores involucrados: ' + CASE WHEN dd.menoresInvolucrados = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion


	
	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'DOMESTICA';




GO
CREATE FUNCTION fn_getDenunciaPsicologica(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Frecuencia: ' + dd.frecuencia + CHAR(13) +
	'Sintomas: ' +  ISNULL(dd.sintomas, 'No especificados') + CHAR(13) + 
	'Hospitalización: ' + CASE WHEN dd.hospitalizacion = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) + 
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion


	
	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'PSICOLOGICA';




GO
CREATE FUNCTION fn_getDenunciaViolencia(@idDenuncia INT)
RETURNS TABLE
AS
RETURN 
SELECT
	'------------------ DATOS PERSONALES ------------------' + CHAR(13) +
    'Nombre: ' + dp.nombre + CHAR(13) +
	'Apellido Paterno: ' + dp.apellidoPaterno + CHAR(13) +
	'Apellido Materno: ' + dp.apellidoMaterno + CHAR(13) +
    'Documento: ' + dp.tipoDocumento + ' / ' + CAST(dp.idDocumento AS VARCHAR) + CHAR(13) +
    'Email: ' + dp.email + CHAR(13) +
    'Celular: ' + dp.celular + CHAR(13) +
    'Edad: ' + CAST(dp.edad AS VARCHAR) + CHAR(13) +

	CHAR(13) + '--------------------- UBICACIÓN ---------------------' + CHAR(13) +
    'Departamento: ' + uu.departamento + CHAR(13) +
    'Provincia: ' + uu.provincia + CHAR(13) +
    'Distrito: ' + uu.distrito + CHAR(13) +
    'Dirección: ' + ISNULL(uu.direccion, 'No especificada') + CHAR(13) +
    'Detalles: ' + ISNULL(uu.detallesAdicionales, 'Ninguno') + CHAR(13) +

	CHAR(13) + '----------------- DETALLES DEL HECHO ----------------' + CHAR(13) +
	'Fecha: ' + CONVERT(VARCHAR, d.fechaSuceso, 103) + ' - Hora: ' + CONVERT(VARCHAR, d.horaSuceso, 108) + CHAR(13) +
	'Tipo: ' + d.tipoDenuncia + CHAR(13) +
	'Riesgo' + d.riesgo + CHAR(13) +
	CHAR(13) +
	'Victima: ' + ISNULL(dd.victima, 'No especificada') + CHAR(13) +
    'Más de un agresor: ' + CASE WHEN dd.agresores = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Agresor: ' + ISNULL(dd.agresor, 'No especificado o Desconocido') + CHAR(13) +
	'Relación con agresor: ' + ISNULL(dd.relacionAgresor, 'Desconocida') + CHAR(13) +
	CHAR(13) +
	'Testigos: ' + CASE WHEN dd.testigos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13)+
	'Uso de objetos: ' + CASE WHEN dd.usoDeObjetos = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) +
	'Objetos: ' + ISNULL(dd.objetos, 'No especificados') + CHAR(13) + 
	'Heridas: ' + dd.heridas + CHAR(13) +
	'Gravedad de las heridas: ' + dd.gravedadHeridas + CHAR(13) +
	'Hospitalización: ' + CASE WHEN dd.hospitalizacion = 1 THEN 'Sí' ELSE 'No' END + CHAR(13) + 
	CHAR(13) +
	'Descripcion' + CHAR(13) +
	dd.descripcion
	
	AS mensaje
FROM denuncia d
JOIN datos_personales dp ON d.idDenuncia = dp.idDenuncia
JOIN detalles_denuncia dd ON d.idDenuncia = dd.idDenuncia
JOIN ubicacion uu ON d.idDenuncia = uu.idDenuncia
WHERE d.idDenuncia = @idDenuncia AND d.tipoDenuncia = 'VIOLENCIA';




GO
CREATE PROCEDURE sp_getMensajeDenuncia
    @idDenuncia INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @tipo VARCHAR(20);
    DECLARE @mensaje NVARCHAR(MAX);

    SELECT @tipo = tipoDenuncia FROM denuncia WHERE idDenuncia = @idDenuncia;

    IF @tipo IS NULL
    BEGIN
        RAISERROR('Denuncia no encontrada', 16, 1);
        RETURN;
    END

    IF @tipo = 'ACOSO'
    BEGIN
        SELECT @mensaje = mensaje FROM fn_getDenunciaAcoso(@idDenuncia);
    END

    ELSE IF @tipo = 'PSICOLOGICA'
    BEGIN
        SELECT @mensaje = mensaje FROM fn_getDenunciaPsicologica(@idDenuncia);
    END

    ELSE IF @tipo = 'ABUSO_SEXUAL'
    BEGIN
        SELECT @mensaje = mensaje FROM fn_getDenunciaAbusoSexual(@idDenuncia);
    END

	ELSE IF @tipo = 'ACOSO_SEXUAL'
	BEGIN
		SELECT @mensaje = mensaje FROM fn_getDenunciaAcosoSexual(@idDenuncia);
	END
    
	ELSE IF @tipo = 'DOMESTICA'
	BEGIN
		SELECT @mensaje = mensaje FROM fn_getDenunciaDomestica(@idDenuncia);
	END

	ELSE IF @tipo = 'VIOLENCIA'
	BEGIN
		SELECT  @mensaje = mensaje FROM fn_getDenunciaViolencia(@idDenuncia);
	END

    ELSE
    BEGIN
        SELECT @mensaje = 'Tipo de denuncia no soportado o función no definida.';
    END

    SELECT @mensaje AS mensaje;
END