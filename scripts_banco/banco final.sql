USE nivel_agua;
CREATE DATABASE nivel_agua;
SELECT * FROM tabela_para_job;
SHOW EVENTS;
set global event_scheduler = on; 
DROP EVENT event_job;

-- criando a job
DELIMITER $$

CREATE EVENT event_job 
ON SCHEDULE EVERY 5 MINUTE
DO
BEGIN
    CALL prc_job('inserido por job1', 'inserido por job2', 'inserido por job3');
END$$

DELIMITER ;
-- essa tabela serve somente para job
CREATE TABLE tabela_para_job(
	p1 VARCHAR(255),
    P2 VARCHAR(255),
    p3 VARCHAR(255),
    data_teste TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- procedure para job
DELIMITER $$
CREATE PROCEDURE prc_job(
	pp1 VARCHAR(255),
    pp2 VARCHAR(255),
    pp3 VARCHAR(255)
)
BEGIN
	INSERT INTO tabela_para_job(p1, p2, p3)
	VALUES (pp1, pp2, pp3);
END $$
DELIMITER ;
-- fim do bloco de codigo pra job 
-- tabelas (usuarios)
CREATE TABLE usuarios (
    idusuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(100) NOT NULL UNIQUE,
    nomeusuario VARCHAR(255) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);
-- tabela de registro
CREATE TABLE registro (
    idregistro INT AUTO_INCREMENT PRIMARY KEY,
    nivel_agua DECIMAL(5,2) NOT NULL, 
    dataregistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- tabela de log
CREATE TABLE log (
    idlog INT AUTO_INCREMENT PRIMARY KEY,
    tpacao VARCHAR(50),  
    login_usuario VARCHAR(50),  
    dataacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_registro INT,  
    dsregold VARCHAR(255),  
    dsregnew VARCHAR(255),  
    tpacaogold VARCHAR(50),  
    tpacaornew VARCHAR(50),  
    nomeusuarioold VARCHAR(255), 
    nomeusuarionew VARCHAR(255)  
);
-- procedure para inserir usuario
DELIMITER $$
CREATE PROCEDURE insert_usuario(c VARCHAR(100), d VARCHAR(255), e VARCHAR(15), f VARCHAR(255), g VARCHAR(50), h VARCHAR(255))
BEGIN 
	INSERT INTO usuarios(usuario, nomeusuario,telefone,email, login, senha)
    VALUES (c,d,e,f,g,h);
    SELECT * FROM usuarios;
END $$

DELIMITER ;
-- procedure de atualizar usuario
DELIMITER $$

CREATE PROCEDURE update_usuario(
    IN p_idusuario INT,
    IN p_usuario VARCHAR(100),
    IN p_nomeusuario VARCHAR(255),
    IN p_telefone VARCHAR(15),
    IN p_email VARCHAR(255),
    IN p_login VARCHAR(50),
    IN p_senha VARCHAR(255)
)
BEGIN
    UPDATE usuarios
    SET 
        usuario = p_usuario,
        nomeusuario = p_nomeusuario,
        telefone = p_telefone,
        email = p_email,
        login = p_login,
        senha = p_senha
    WHERE idusuario = p_idusuario;

    SELECT * FROM usuarios WHERE idusuario = p_idusuario;
END $$

DELIMITER ;
-- procedure para deletar usuario
DELIMITER $$

CREATE PROCEDURE delete_usuario(
    IN p_idusuario INT
)
BEGIN
    DELETE FROM usuarios WHERE idusuario = p_idusuario;
    SELECT * FROM usuarios;
END $$

DELIMITER ;

-- procedure de registro
DELIMITER $$

CREATE PROCEDURE insert_registro(
    IN p_nivel_agua DECIMAL(5,2)
)
BEGIN
    INSERT INTO registro(nivel_agua)
    VALUES (p_nivel_agua);
    SELECT * FROM registro;
END $$

DELIMITER ;

DELIMITER $$
-- procedure para atualizar registro
CREATE PROCEDURE update_registro(
    IN p_idregistro INT,
    IN p_nivel_agua DECIMAL(5,2)
)
BEGIN
    UPDATE registro
    SET nivel_agua = p_nivel_agua
    WHERE idregistro = p_idregistro;
    SELECT * FROM registro WHERE idregistro = p_idregistro;
END $$

DELIMITER ;
-- procedure para deletar registro
DELIMITER $$

CREATE PROCEDURE delete_registro(
    IN p_idregistro INT
)
BEGIN
    DELETE FROM registro WHERE idregistro = p_idregistro;
    SELECT * FROM registro;
END $$

DELIMITER ;

-- trigger para log usuario (insert)
DELIMITER $$

CREATE TRIGGER trg_log_insert_usuario
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'INSERT',
    NEW.login,
    NULL,
    NULL,
    CONCAT('Usuário inserido: ', NEW.usuario),
    NULL,
    'INSERT',
    NULL,
    NEW.nomeusuario
  );
END $$

DELIMITER ;

-- trigger para log usuario (atualizar)
DELIMITER $$

CREATE TRIGGER trg_log_update_usuario
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'UPDATE',
    NEW.login,
    NULL,
    CONCAT('Usuário: ', OLD.usuario, ' - Email: ', OLD.email),
    CONCAT('Usuário: ', NEW.usuario, ' - Email: ', NEW.email),
    'UPDATE',
    'UPDATE',
    OLD.nomeusuario,
    NEW.nomeusuario
  );
END $$

DELIMITER ;

-- trigger para log usuario (deletar)
DELIMITER $$

CREATE TRIGGER trg_log_delete_usuario
AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'DELETE',
    OLD.login,
    NULL,
    CONCAT('Usuário deletado: ', OLD.usuario),
    NULL,
    'DELETE',
    NULL,
    OLD.nomeusuario,
    NULL
  );
END $$

DELIMITER ;


-- triggers que vao alimentar log registro
DELIMITER $$

CREATE TRIGGER trg_log_insert_registro
AFTER INSERT ON registro
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'INSERT',
    NULL, 
    NEW.idregistro,
    NULL,
    CONCAT('Nível água: ', NEW.nivel_agua),
    NULL,
    'INSERT',
    NULL,
    NULL
  );
END $$

DELIMITER ;

-- trigger para log registro (update)
DELIMITER $$

CREATE TRIGGER trg_log_update_registro
AFTER UPDATE ON registro
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'UPDATE',
    NULL,
    NEW.idregistro,
    CONCAT('Nível antigo: ', OLD.nivel_agua),
    CONCAT('Nível novo: ', NEW.nivel_agua),
    'UPDATE',
    'UPDATE',
    NULL,
    NULL
  );
END $$

DELIMITER ;

-- trigger para log registro (delete)
DELIMITER $$

CREATE TRIGGER trg_log_delete_registro
AFTER DELETE ON registro
FOR EACH ROW
BEGIN
  INSERT INTO log (
    tpacao,
    login_usuario,
    id_registro,
    dsregold,
    dsregnew,
    tpacaogold,
    tpacaornew,
    nomeusuarioold,
    nomeusuarionew
  ) VALUES (
    'DELETE',
    NULL,
    OLD.idregistro,
    CONCAT('Nível deletado: ', OLD.nivel_agua),
    NULL,
    'DELETE',
    NULL,
    NULL,
    NULL
  );
END $$

DELIMITER ;