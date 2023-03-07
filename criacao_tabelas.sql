CREATE SEQUENCE Funcionario_seq
START WITH 1 
INCREMENT BY 1;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';


create table Pessoa_tb(
    CPF varchar(11), 
    nome varchar(50),
    idade integer,
    CONSTRAINT PK_Pessoa PRIMARY KEY (CPF)

);

create table Telefone(
    CPF varchar(11),
    Contato varchar(50),
    CONSTRAINT PK_Telefone PRIMARY KEY (CPF, Contato),
    CONSTRAINT FK_CPF FOREIGN KEY (CPF) 
        REFERENCES Pessoa_tb(CPF)
);

create table CEP(
    cep varchar(8),
    rua varchar(50),
    cidade varchar(50),
    CONSTRAINT PK_CEP PRIMARY KEY (CEP)

);

create table Endereco(
    CPF varchar(11),
    CEP varchar(8),
    Numero integer,
    CONSTRAINT PK_Endereco PRIMARY KEY (CPF),
    CONSTRAINT FK_CPF_ENDERECO FOREIGN KEY (CPF)
        REFERENCES Pessoa_tb(CPF),
    CONSTRAINT FK_CEP FOREIGN KEY (CEP)
        REFERENCES CEP(cep)
);

create table Cargo(
    tipo_cargo varchar(50),
    salario number(8,2),
    CONSTRAINT PK_Cargo PRIMARY KEY (tipo_cargo)
);

create table Funcionario(
    CPF varchar(11),
    cadastro_funcionario integer UNIQUE,
    cargo varchar(50),
    supervisor_cadastro integer,
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (CPF),
    CONSTRAINT FK_CPF_FUNC FOREIGN KEY (CPF)
        REFERENCES Pessoa_tb(CPF),
    CONSTRAINT FK_CARGO FOREIGN KEY (cargo) 
        REFERENCES Cargo(tipo_cargo),
    CONSTRAINT FK_SUPERVISOR FOREIGN KEY (supervisor_cadastro)
        REFERENCES Funcionario(cadastro_funcionario)
);

create table Cliente(
    CPF varchar(11),
    fidelidade NUMBER(1,0),
    CONSTRAINT PK_CPF PRIMARY KEY (CPF),
    CONSTRAINT FK_CPF_CLIENTE FOREIGN KEY (CPF)
        REFERENCES Pessoa_tb(CPF)
);

create table Ingresso(
    codigo_ingresso varchar(11),
    tipo_ingresso varchar(4),
    CHECK (tipo_ingresso = 'M' or tipo_ingresso ='I'),
    valor integer,
    CONSTRAINT PK_INGRESSO PRIMARY KEY (codigo_ingresso,tipo_ingresso)
);


create table Cupom(
    id_cupom integer,
    desconto number(4,4),
    CONSTRAINT PK_CUPOM PRIMARY KEY (id_cupom)

);

create table Compra(
    CPF varchar(11),
    codigo_ingresso varchar(11),
    tipo_ingresso varchar(1),
    id_cupom integer,
    data_compra date,
    CONSTRAINT PK_COMPRA PRIMARY KEY (CPF,codigo_ingresso),
    CONSTRAINT FK_CPF_COMPRA FOREIGN KEY(CPF) 
        REFERENCES Cliente(CPF),
    CONSTRAINT FK_INGRESSO FOREIGN KEY(codigo_ingresso,tipo_ingresso)
        REFERENCES Ingresso(codigo_ingresso,tipo_ingresso),
    CONSTRAINT FK_CUPOM FOREIGN KEY(id_cupom)
        REFERENCES Cupom(id_cupom)
);

create table Filme(
    id_filme integer,
    genero varchar(35),
    classificacao varchar(10),
    nome varchar(50),
    duracao varchar(5),
    diretor varchar(20),
    CONSTRAINT PK_Filme PRIMARY KEY (id_filme)
);


create table Elenco(
    id_filme integer,
    nome_ator varchar(30),
    CONSTRAINT PK_Elenco PRIMARY KEY (id_filme, nome_ator),
    CONSTRAINT FK_ID FOREIGN KEY (id_filme)
        REFERENCES Filme(id_filme)
);

create table Sala(
    id_sala integer,
    capacidade integer,
    CONSTRAINT PK_SALA PRIMARY KEY (id_sala)
);

create table Assento(
    id_sala integer,
    cod_assento integer,
    tipo_assento varchar(10),
    CONSTRAINT PK_ASSENTO PRIMARY KEY (id_sala,cod_assento),
    CONSTRAINT FK_ASSENTO FOREIGN KEY (id_sala)
        REFERENCES Sala(id_sala)
);

create table Reserva(
    id_filme integer,
    cod_ingresso varchar(11),
    id_sala integer,
    cod_assento integer,
    tipo_ingresso varchar(1),
    data date,
    CONSTRAINT PK_ASSENTO_RESERVA PRIMARY KEY (id_filme, cod_ingresso, id_sala, cod_assento),
    CONSTRAINT FK_FILME FOREIGN KEY(id_filme)
        REFERENCES Filme(id_filme),
    CONSTRAINT FK_INGRESSO_RESERVA FOREIGN KEY(cod_ingresso,tipo_ingresso)
        REFERENCES Ingresso(codigo_ingresso,tipo_ingresso),
    CONSTRAINT FK_SALA FOREIGN KEY(id_sala,cod_assento)
        REFERENCES Assento(id_sala,cod_assento)

);

create table Limpa(
    data date,
    CPF_Funcionario varchar(11),
    id_sala integer,
    CONSTRAINT PK_LIMPA PRIMARY KEY (data),
    CONSTRAINT FK_CPF_LIMPA FOREIGN KEY (CPF_Funcionario)
        REFERENCES Funcionario(CPF),
    CONSTRAINT FK_SALA_LIMPA FOREIGN KEY (id_sala)
        REFERENCES Sala(id_sala)

);

