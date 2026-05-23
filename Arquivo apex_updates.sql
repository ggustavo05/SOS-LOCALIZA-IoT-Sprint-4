-- =============================================
-- SOS Localiza - Scripts Oracle APEX
-- Integracao IA + Oracle Database
-- =============================================

-- 1. Criacao da tabela
CREATE TABLE areas_risco (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome         VARCHAR2(100)  NOT NULL,
    latitude     NUMBER(10, 6)  NOT NULL,
    longitude    NUMBER(10, 6)  NOT NULL,
    ocorrencias  NUMBER(5)      DEFAULT 0 NOT NULL,
    populacao    NUMBER(10)     DEFAULT 1 NOT NULL,
    tipo_area    VARCHAR2(20)   DEFAULT 'URBANA' NOT NULL,
    ativo        VARCHAR2(1)    DEFAULT 'S' NOT NULL,
    criado_em    TIMESTAMP      DEFAULT SYSTIMESTAMP
);

-- 2. Adicionar coluna de resultado da IA
ALTER TABLE areas_risco ADD risco_ia VARCHAR2(10);

-- 3. Funcao de classificacao de risco (PL/SQL)
CREATE OR REPLACE FUNCTION calcular_risco(
    p_ocorrencias IN NUMBER,
    p_populacao   IN NUMBER,
    p_tipo_area   IN VARCHAR2
) RETURN VARCHAR2 IS
    v_taxa      NUMBER;
    v_score     NUMBER;
    v_risco     VARCHAR2(10);
BEGIN
    IF p_populacao > 0 THEN
        v_taxa := (p_ocorrencias / p_populacao) * 1000;
    ELSE
        v_taxa := 0;
    END IF;
    IF v_taxa >= 15 THEN
        v_score := 3;
    ELSIF v_taxa >= 5 THEN
        v_score := 2;
    ELSE
        v_score := 1;
    END IF;
    IF p_tipo_area = 'PERIFERICA' THEN
        v_score := v_score + 1;
    ELSIF p_tipo_area = 'PARQUE' THEN
        v_score := v_score - 1;
    END IF;
    IF v_score >= 3 THEN
        v_risco := 'alto';
    ELSIF v_score >= 2 THEN
        v_risco := 'medio';
    ELSE
        v_risco := 'baixo';
    END IF;
    RETURN v_risco;
END;
/

-- 4. View da API (prioriza resultado da IA)
CREATE OR REPLACE VIEW vw_areas_risco_api AS
SELECT
    ROUND(latitude, 6)  AS latitude,
    ROUND(longitude, 6) AS longitude,
    CASE
        WHEN risco_ia IS NOT NULL THEN risco_ia
        ELSE calcular_risco(ocorrencias, populacao, tipo_area)
    END AS risco_previsto
FROM areas_risco
WHERE ativo = 'S';

-- 5. Insercao dos dados das 25 areas de Sao Paulo
BEGIN
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 1 - SP', -23.6922327977, -46.5012876731, 92, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 2 - SP', -23.5045612257, -46.6380338244, 88, 5500, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 3 - SP', -23.6946729404, -46.6206553016, 15, 6000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 4 - SP', -23.5564824834, -46.5763600795, 95, 5500, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 5 - SP', -23.5558925638, -46.7639123847, 90, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 6 - SP', -23.6228333382, -46.5659326484, 85, 5500, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 7 - SP', -23.5452575706, -46.6512761045, 87, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 8 - SP', -23.5143732619, -46.6245553583, 89, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 9 - SP', -23.4972520513, -46.7114579434, 91, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 10 - SP', -23.5393192911, -46.6354077731, 86, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 11 - SP', -23.6182501947, -46.5613376251, 93, 5500, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 12 - SP', -23.5585246724, -46.7006114272, 88, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 13 - SP', -23.6932430719, -46.7260307366, 94, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 14 - SP', -23.5443003704, -46.5234185712, 89, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 15 - SP', -23.6165528565, -46.6580143583, 90, 5500, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 16 - SP', -23.6877975209, -46.5667575896, 87, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 17 - SP', -23.6448131461, -46.657742391, 88, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 18 - SP', -23.5385622365, -46.7700217481, 91, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 19 - SP', -23.5819814481, -46.5548074596, 89, 5000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 20 - SP', -23.4766933293, -46.6880235793, 90, 5000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 21 - SP', -23.5939313869, -46.5217652356, 55, 10000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 22 - SP', -23.5874792252, -46.6117816323, 20, 8000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 23 - SP', -23.6621306948, -46.5191927511, 10, 6000, 'PERIFERICA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 24 - SP', -23.5231334301, -46.5993911601, 12, 7000, 'URBANA');
  INSERT INTO areas_risco (nome, latitude, longitude, ocorrencias, populacao, tipo_area)
  VALUES ('Área 25 - SP', -23.4767131738, -46.5481644352, 8, 5000, 'PERIFERICA');
  COMMIT;
END;
/

-- 6. Atualizacao do risco_ia com resultado do modelo Random Forest
BEGIN
    UPDATE areas_risco SET risco_ia = 'alto'  WHERE id IN (21,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40);
    UPDATE areas_risco SET risco_ia = 'medio' WHERE id IN (23,41,42,43);
    UPDATE areas_risco SET risco_ia = 'baixo' WHERE id IN (44,45);
    COMMIT;
END;
/