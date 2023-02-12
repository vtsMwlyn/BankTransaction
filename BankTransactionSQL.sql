DROP DATABASE IF EXISTS databeesu;
CREATE DATABASE databeesu;
USE databeesu;

/*
DROP USER 'eric'@'localhost';
DROP USER 'leon'@'localhost';
DROP USER 'hansen'@'localhost';

CREATE USER 'eric'@'localhost' IDENTIFIED BY 'erika69';
CREATE USER 'leon'@'localhost' IDENTIFIED BY 'leonita69';
CREATE USER 'hansen'@'localhost' IDENTIFIED BY 'hana69';
*/

CREATE TABLE nasabah (
	id_nasabah CHAR(4) PRIMARY KEY,
    nama_nasabah VARCHAR(50) NOT NULL,
    saldo BIGINT NOT NULL
);

INSERT INTO nasabah VALUES
	("N001", "Leon", 5000000),
    ("N002", "Hansen", 7000000),
    ("N003", "Eric", 9000000);

SELECT * FROM nasabah;

CREATE TABLE transaksi_tarik (
	id_transaksi CHAR(4) PRIMARY KEY,
    tanggal DATE NOT NULL,
    id_nasabah CHAR(4) NOT NULL,
    nominal BIGINT NOT NULL
);

CREATE TABLE transaksi_setor (
	id_transaksi CHAR(4) PRIMARY KEY,
    tanggal DATE NOT NULL,
    id_nasabah CHAR(4) NOT NULL,
    nominal BIGINT NOT NULL,
    CONSTRAINT fk_idn2 FOREIGN KEY (id_nasabah) REFERENCES nasabah (id_nasabah)
		ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE transaksi_tarik
ADD CONSTRAINT fk_idn1 FOREIGN KEY (id_nasabah) REFERENCES nasabah (id_nasabah)
	ON UPDATE CASCADE ON DELETE CASCADE;

DELIMITER $$
CREATE TRIGGER update_saldo_setelah_tarik_tunai
AFTER INSERT ON transaksi_tarik FOR EACH ROW
BEGIN
	UPDATE nasabah SET saldo = saldo - NEW.nominal WHERE id_nasabah = NEW.id_nasabah;
END;
$$

DELIMITER $$
CREATE TRIGGER update_saldo_setelah_setor_tunai
AFTER INSERT ON transaksi_setor FOR EACH ROW
BEGIN
	UPDATE nasabah SET saldo = saldo + NEW.nominal WHERE id_nasabah = NEW.id_nasabah;
END;
$$

/*
DELIMITER $$
CREATE PROCEDURE user_validation (IN username VARCHAR(100), IN pass_word VARCHAR(100))
	IF username = "Leon" AND pass_word = "leonita69" THEN
		GRANT EXECUTE ON PROCEDURE transaksi TO 'leon'@'localhost';
	ELSEIF username = "Hansen" AND pass_word = "hana69" THEN
		GRANT EXECUTE ON PROCEDURE transaksi TO 'hansen'@'localhost';
	ELSEIF username = "Eric" AND pass_word = "erika69" THEN
		GRANT EXECUTE ON PROCEDURE transaksi TO 'eric'@'localhost';
	END IF;
$$
*/

DELIMITER $$
CREATE PROCEDURE transaksi (IN tipe ENUM("Tarik", "Setor"), IN id_transaksi CHAR(4), IN tanggal DATE, IN id_nasabah CHAR(4), IN nominal BIGINT)
	IF tipe = "Tarik" THEN
		INSERT INTO transaksi_tarik VALUES (id_transaksi, tanggal, id_nasabah, nominal);
	ELSEIF tipe = "Setor" THEN
		INSERT INTO transaksi_setor VALUES (id_transaksi, tanggal, id_nasabah, nominal);
	END IF;
$$

DELIMITER $$
START TRANSACTION;
	/*
	CALL user_validation("leon", "leonita69");
	SELECT * FROM nasabah WHERE id_nasabah = "N001";
    */
	CALL transaksi("Tarik", "T001", "2023-02-01", "N001", 500000);
    /*
    CALL user_validation("hansen", "hana69");
    SELECT * FROM nasabah WHERE id_nasabah = "N002";
    */
	CALL transaksi("Setor", "T002", "2023-02-01", "N002", 1000000);
COMMIT;
$$

SELECT * FROM nasabah;
