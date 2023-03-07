-- SQL

-- 1- ALTER TABLE
ALTER TABLE pessoa_tb ADD email VARCHAR(255);

-- 2- CREATE INDEX
CREATE INDEX idx_genero
ON Filme(genero);

-- 3 - INSERT INTO
INSERT INTO cupom (id_cupom, desconto) VALUES (6, .6);

-- 4 - UPDATE
UPDATE cargo
 SET SALARIO = 1280
 WHERE TIPO_CARGO = 'Limpeza';

-- 5 - DELETE
DELETE FROM TELEFONE
WHERE CPF = '01234567890';

-- 6 - SELECT-FROM-WHERE
SELECT * from elenco where id_filme = 1;

-- 7 - BETWEEN
SELECT * from sala WHERE capacidade BETWEEN 8 AND 10;

-- 8 - IN
SELECT * FROM Pessoa_tb
WHERE IDADE IN (
    	SELECT IDADE 
        FROM Pessoa_TB
    	WHERE IDADE BETWEEN 10 AND 20);

-- 9 - LIKE 
SELECT * FROM FILME WHERE DIRETOR LIKE 'S%';

-- 10 - IS NULL ou IS NOT NULL 
SELECT * from compra WHERE id_cupom IS NULL;

-- 11-  INNER JOIN
SELECT p.cpf, p.nome, c.tipo_ingresso , c.id_cupom, c.data_compra FROM pessoa_tb p
INNER JOIN compra c ON c.cpf = p.cpf;

-- 12 - MAX
SELECT max(desconto) AS maior_desconto FROM cupom;

-- 13 - MIN
SELECT MIN(IDADE) MIN_IDADE_PESSOA FROM PESSOA_TB;

-- 14 - AVG
SELECT round(AVG(valor),1) as VALOR_MEDIO_INGRESSO FROM ingresso;

-- 15 - COUNT
select count(*) AS QTD_INGRESSOS_VENDIDOS_DIA_6_MARÇO_2023 from reserva 
    where data ='2023-03-6';

-- 16 - LEFT ou RIGHT ou FULL OUTER JOIN 
SELECT * FROM FILME F 
FULL OUTER JOIN RESERVA R 
	ON F.ID_FILME = R.ID_FILME
    WHERE F.GENERO = 'Drama';

-- 17 - SUBCONSULTA COM OPERADOR RELACIONAL
SELECT *
FROM Pessoa_tb
WHERE Pessoa_tb.cpf NOT IN (SELECT Funcionario.cpf from Funcionario);

-- 18 - SUBCONSULTA COM IN
SELECT * FROM filme WHERE id_filme IN ( SELECT id_filme FROM reserva );

-- 19  - SUBCONSULTA COM ANY
SELECT * FROM COMPRA C WHERE C.ID_CUPOM = ANY  ( SELECT CP.ID_CUPOM FROM CUPOM CP);

-- 20 - ALL
SELECT * FROM SALA S1
WHERE S1.CAPACIDADE >= ALL (
    SELECT S2.CAPACIDADE FROM SALA S2 
    WHERE S2.ID_SALA = 2
);

-- 21 - ORDER BY 
SELECT cpf, codigo_ingresso, tipo_ingresso, data_compra 
FROM COMPRA 
ORDER BY DATA_COMPRA;

-- 22 - GROUP BY
SELECT CPF_FUNCIONARIO, COUNT(*) as LIMPEZAS_FEITAS FROM LIMPA 
GROUP BY CPF_FUNCIONARIO;

-- 23 - HAVING
SELECT F.NOME, COUNT(TIPO_INGRESSO) FROM RESERVA R
INNER JOIN FILME F ON F.ID_FILME = R.ID_FILME
GROUP BY F.NOME, TIPO_INGRESSO
HAVING TIPO_INGRESSO = 'M';

-- 24 - UNION 
SELECT ID_FILME, NOME, GENERO FROM filme
UNION
SELECT ID_FILME, NULL, NULL FROM reserva
WHERE ID_FILME <> NULL;

-- 25 - CREATE VIEW
CREATE VIEW idade_view_ex AS
SELECT nome, idade
FROM pessoa_tb
WHERE idade >= 40;

SELECT * FROM idade_view_ex;

-- 26 - GRANT / REVOKE
GRANT SELECT ON Telefone TO my_user;
REVOKE SELECT ON Ingresso FROM my_user;

-- GRANT e REVOKE são declarações SQL usadas para gerenciar privilégios de usuários do banco de dados.
-- GRANT é usado para conceder privilégios específicos a um usuário ou função. No exemplo de consulta qu forneci, o comando "GRANT SELECT ON Telefone TO my_user" concede ao usuário "my_user" o privilégio de executar consultas SELECT na tabela "Telefone".
-- REVOKE, por outro lado, é usado para revogar privilégios anteriormente concedidos de um usuário ou função. No exemplo de consulta que forneci, o comando "REVOKE SELECT ON Ingresso FROM my_user" revoga o privilégio de executar consultas SELECT na tabela "Ingresso" do usuário "my_user".


-- PL

-- 1 - USO DE RECORD
DECLARE
    TYPE filme_record_type IS RECORD(
        id_filme Filme.ID_FILME%TYPE,
        genero Filme.GENERO%TYPE,
        classificacao Filme.CLASSIFICACAO%TYPE,
        nome Filme.NOME%TYPE,
        duracao Filme.DURACAO%TYPE,
        diretor Filme.DIRETOR%TYPE
    );
    
    v_filme filme_record_type;
BEGIN
    v_filme.id_filme := 123;
    v_filme.genero := 'Ação';
    v_filme.classificacao := '18';
    v_filme.nome := 'Filme de Ação';
    v_filme.duracao := 120;
    v_filme.diretor := 'John Doe';
    
    dbms_output.put_line('ID do Filme: ' || v_filme.id_filme);
    dbms_output.put_line('Gênero: ' || v_filme.genero);
    dbms_output.put_line('Classificação: ' || v_filme.classificacao);
    dbms_output.put_line('Nome: ' || v_filme.nome);
    dbms_output.put_line('Duração: ' || v_filme.duracao);
    dbms_output.put_line('Diretor: ' || v_filme.diretor);
END;

-- 2 - USO DE ESTRUTURA DE DADOS DO TIPO TABLE 
DECLARE
    TYPE cargo_table_type IS TABLE OF funcionario.cargo%TYPE INDEX BY PLS_INTEGER;
    v_cargos cargo_table_type;
    v_count INTEGER := 0;
BEGIN

    SELECT cargo BULK COLLECT INTO v_cargos FROM funcionario;
    
    v_count := v_cargos.COUNT;
    
    FOR i IN 1..v_count LOOP
        dbms_output.put_line('Cargo Funcionário ' || i || ': ' || v_cargos(i));
    END LOOP;
END;

-- 3 - BLOCO ANÔNIMO
DECLARE
    tipo_ingresso_p VARCHAR(4);
    valor_p NUMBER;
	codigo_ingresso_p VARCHAR(11);
BEGIN
    SELECT  codigo_ingresso, TIPO_INGRESSO, VALOR INTO codigo_ingresso_p, tipo_ingresso_p, valor_p
    FROM ingresso
    WHERE CODIGO_INGRESSO = 001 AND TIPO_INGRESSO = 'M';
    DBMS_OUTPUT.PUT_LINE('O Código pra esse ingresso é ' || codigo_ingresso_p || ' O tipo de ingresso é ' || tipo_ingresso_p || ' e o valor é ' || valor_p );
END;

-- 4- CREATE PROCEDURE
CREATE OR REPLACE PROCEDURE get_duracao_filme(
    p_id_filme IN NUMBER,
    p_duracao OUT VARCHAR2
) AS
BEGIN
    SELECT duracao INTO p_duracao FROM Filme WHERE ID_FILME = p_id_filme;
END;
/
DECLARE
    v_duracao VARCHAR(5);
BEGIN
    get_duracao_filme(1, v_duracao);
    DBMS_OUTPUT.PUT_LINE('Duração do filme: ' || v_duracao || ' minutos');
END;

-- 5 - CREATE FUNCTION
CREATE OR REPLACE FUNCTION get_salario(tipo_cargo IN VARCHAR)
RETURN NUMBER
IS
  v_salario Cargo.salario%TYPE;
BEGIN
  SELECT salario INTO v_salario
  FROM Cargo
  WHERE tipo_cargo = get_salario.tipo_cargo;

  RETURN v_salario;
END;
/
DECLARE
  v_salario NUMBER;
BEGIN
  v_salario := get_salario('Gerente de cinema');
  DBMS_OUTPUT.PUT_LINE('O salário do cargo de Gerente é: ' || v_salario);
END;

-- 6- %TYPE
DECLARE
   v_id_filme elenco.ID_FILME%TYPE := 2;
   v_nome_ator elenco.NOME_ATOR%TYPE;

   CURSOR c_elenco IS SELECT NOME_ATOR FROM elenco WHERE ID_FILME = v_id_filme ORDER BY NOME_ATOR;
BEGIN
   OPEN c_elenco;
   LOOP
      FETCH c_elenco INTO v_nome_ator;
      EXIT WHEN c_elenco%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('ID_FILME: ' || v_id_filme || ', NOME_ATOR: ' || v_nome_ator);
   END LOOP;
   CLOSE c_elenco;
END;

-- 7 - %ROWTYPE
DECLARE
  v_cupom Cupom%ROWTYPE;
BEGIN
  v_cupom.id_cupom := 8;
  v_cupom.desconto := 0.8;

  INSERT INTO Cupom VALUES v_cupom;

 DBMS_OUTPUT.PUT_LINE('Cupom inserido com ID ' || v_cupom.id_cupom ||
                       ' e desconto ' || v_cupom.desconto);
END;

--  8 - IF ELSIF
DECLARE
v_genero Filme.GENERO%TYPE;
BEGIN
    SELECT GENERO INTO v_genero FROM Filme WHERE ID_FILME = 3;
    IF v_genero = 'Ação' THEN
        DBMS_OUTPUT.PUT_LINE('Filme de ação!');
        ELSIF v_genero = 'Comédia' THEN
        DBMS_OUTPUT.PUT_LINE('Filme de comédia!');
        ELSE
        DBMS_OUTPUT.PUT_LINE('Outro tipo de filme.');
    END IF;
END;

-- 9 - CASE WHEN
DECLARE
  v_idade pessoa_tb.idade%TYPE;
  v_nome pessoa_tb.nome%TYPE;
BEGIN
  SELECT nome, idade
  INTO v_nome, v_idade
  FROM pessoa_tb
  WHERE cpf = '12345678901';

  CASE
    WHEN v_idade < 18 THEN
      DBMS_OUTPUT.PUT_LINE('Esta pessoa é menor de idade.');
    WHEN v_idade >= 18 AND v_idade < 60 THEN
    DBMS_OUTPUT.PUT_LINE(v_nome || ' é adulto(a) com ' || v_idade || ' anos.');

    ELSE
    DBMS_OUTPUT.PUT_LINE(v_nome || ' é idoso(a) com ' || v_idade || ' anos.');

  END CASE;
END;

-- 10 - LOOP EXIT WHEN
DECLARE
  v_codigo_ingresso ingresso.codigo_ingresso%TYPE;
  v_tipo_ingresso ingresso.tipo_ingresso%TYPE;
  v_valor ingresso.valor%TYPE;
BEGIN
  FOR i IN (SELECT codigo_ingresso, tipo_ingresso, valor FROM ingresso) LOOP
    v_codigo_ingresso := i.codigo_ingresso;
    v_tipo_ingresso := i.tipo_ingresso;
    v_valor := i.valor;
    
    DBMS_OUTPUT.PUT_LINE('Código de ingresso: ' || v_codigo_ingresso);
    DBMS_OUTPUT.PUT_LINE('Tipo de ingresso: ' || v_tipo_ingresso);
    DBMS_OUTPUT.PUT_LINE('Valor: R$' || v_valor);
    
    EXIT WHEN v_valor > 100;
  END LOOP;
END;

-- 11 - WHILE LOOP
DECLARE
   CURSOR c_elenco IS SELECT ID_FILME, NOME_ATOR FROM elenco ORDER BY ID_FILME, NOME_ATOR;
   v_id_filme elenco.ID_FILME%TYPE;
   v_nome_ator elenco.NOME_ATOR%TYPE;
BEGIN
   OPEN c_elenco;
   WHILE TRUE LOOP
      FETCH c_elenco INTO v_id_filme, v_nome_ator;
      EXIT WHEN c_elenco%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('ID_FILME: ' || v_id_filme || ', NOME_ATOR: ' || v_nome_ator);
   END LOOP;
   CLOSE c_elenco;
END;

-- 12 - FOR IN LOOP
DECLARE
  v_id_sala Sala.id_sala%TYPE;
  v_capacidade Sala.capacidade%TYPE;
BEGIN
  FOR sala IN (SELECT id_sala, capacidade FROM Sala)
  LOOP
    v_id_sala := sala.id_sala;
    v_capacidade := sala.capacidade;

    DBMS_OUTPUT.PUT_LINE('Sala ' || v_id_sala || ' tem capacidade para ' || v_capacidade || ' pessoas.');
  END LOOP;
END;

-- 13 - SELECT … INTO
DECLARE
    v_cadastro_funcionario funcionario.cadastro_funcionario%TYPE := 5;
    v_cargo funcionario.cargo%TYPE;
    v_supervisor_cadastro funcionario.supervisor_cadastro%TYPE;
BEGIN
    SELECT cargo, supervisor_cadastro INTO v_cargo, v_supervisor_cadastro 
    FROM funcionario 
    WHERE cadastro_funcionario = v_cadastro_funcionario;
    
    dbms_output.put_line('Cargo: ' || v_cargo || ', Supervisor Cadastro: ' || v_supervisor_cadastro);
END;

-- 14 - CURSOR
DECLARE
    v_codigo_ingresso ingresso.codigo_ingresso%TYPE;
    v_tipo_ingresso ingresso.tipo_ingresso%TYPE;
    v_valor ingresso.valor%TYPE;
    v_count INTEGER := 0;
    CURSOR c_ingresso IS SELECT codigo_ingresso, tipo_ingresso, valor FROM ingresso WHERE ROWNUM <= 3;
BEGIN
    OPEN c_ingresso;
    LOOP
        FETCH c_ingresso INTO v_codigo_ingresso, v_tipo_ingresso, v_valor;
        EXIT WHEN c_ingresso%NOTFOUND OR v_count = 3;
        DBMS_OUTPUT.PUT_LINE('Código do ingresso: ' || v_codigo_ingresso || ', Tipo de ingresso: ' || v_tipo_ingresso || ', Valor: ' || v_valor);
        v_count := v_count + 1;
    END LOOP;
    CLOSE c_ingresso;
END;

-- 15-  EXCEPTION
DECLARE
  v_cadastro_funcionario funcionario.cadastro_funcionario%TYPE := 1;
  v_cargo funcionario.cargo%TYPE;
BEGIN
  SELECT cargo INTO v_cargo
  FROM funcionario
  WHERE cadastro_funcionario = v_cadastro_funcionario;
  
  DBMS_OUTPUT.PUT_LINE('Cargo do funcionário com cadastro ' || v_cadastro_funcionario || ' é ' || v_cargo);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Funcionário com cadastro ' || v_cadastro_funcionario || ' não encontrado.');
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Já existe um funcionário com o cadastro ' || v_cadastro_funcionario);
END;

-- 16 - USO DE PAR METROS (IN, OUT ou IN OUT)
CREATE OR REPLACE PROCEDURE update_nome(
    cpf_in IN pessoa_tb.cpf%TYPE,
    idade_in IN pessoa_tb.idade%TYPE,
    nome_in_out IN OUT pessoa_tb.nome%TYPE,
    nome_out OUT pessoa_tb.nome%TYPE
)
IS
BEGIN
    UPDATE pessoa_tb SET nome = nome_in_out WHERE cpf = cpf_in AND idade = idade_in;
    SELECT nome INTO nome_out FROM pessoa_tb WHERE cpf = cpf_in AND idade = idade_in;
END;
/

DECLARE
    cpf pessoa_tb.cpf%TYPE := '12345678901';
    idade pessoa_tb.idade%TYPE := 25;
    nome pessoa_tb.nome%TYPE := 'João Constantino';
    updated_nome pessoa_tb.nome%TYPE;
BEGIN
    update_nome(cpf, idade, nome, updated_nome);
    dbms_output.put_line('Nome atualizado: ' || updated_nome);
END;

-- 17 -  CREATE OR REPLACE PACKAGE
CREATE OR REPLACE PACKAGE filme_pkg IS
  FUNCTION get_filmes RETURN SYS_REFCURSOR;
END filme_pkg;
/

-- 18 - CREATE OR REPLACE PACKAGE (BODY)
CREATE OR REPLACE PACKAGE BODY filme_pkg IS
  FUNCTION get_filmes RETURN SYS_REFCURSOR IS
    filmes_cursor SYS_REFCURSOR;
  BEGIN
    OPEN filmes_cursor FOR SELECT * FROM Filme;
    RETURN filmes_cursor;
  END;
END filme_pkg;
/

DECLARE
  filmes_cursor SYS_REFCURSOR;

  id_filme Filme.id_filme%TYPE;
  genero Filme.genero%TYPE;
  classificacao Filme.classificacao%TYPE;
  nome Filme.nome%TYPE;
  duracao Filme.duracao%TYPE;
  diretor Filme.diretor%TYPE;
BEGIN
  filmes_cursor := filme_pkg.get_filmes;

  LOOP
    FETCH filmes_cursor INTO id_filme, genero, classificacao, nome, duracao, diretor;
    EXIT WHEN filmes_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(id_filme || ', ' || genero || ', ' || classificacao || ', ' || nome || ', ' || duracao || ', ' || diretor);
  END LOOP;
END;


-- 19 - CREATE OR REPLACE TRIGGER (COMANDO)
CREATE OR REPLACE TRIGGER Sala_trigger
AFTER INSERT ON Sala
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('New row inserted into Sala');
END;

-- 20 -  CREATE OR REPLACE TRIGGER (LINHA)
CREATE OR REPLACE TRIGGER elenco_trigger
BEFORE INSERT OR UPDATE OR DELETE ON elenco
FOR EACH ROW
WHEN (NEW.ID_FILME IS NULL OR NEW.NOME_ATOR IS NULL)
BEGIN
  RAISE_APPLICATION_ERROR(-20001, 'Não pode modificar a linha com ID_FILME ou NOME_ATOR com valores nulos');
END;
/
INSERT INTO elenco (ID_FILME, NOME_ATOR) VALUES (NULL, 'John Doe');


