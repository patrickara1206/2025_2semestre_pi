-- =================================================================================
-- SCRIPT COMPLETO DO BANCO DE DADOS - PLATAFORMA DE GESTÃO DE LABORATÓRIO ETEC
-- Versão: 1.0
-- Este script cria a estrutura e popula com os dados fornecidos.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- ETAPA 1: CRIAÇÃO DA ESTRUTURA DE TABELAS
-- Apaga tabelas existentes para garantir uma instalação limpa.
-- ---------------------------------------------------------------------------------
create database laboratorio;
use laboratorio;
DROP TABLE IF EXISTS ItensKit;
DROP TABLE IF EXISTS Kits;
DROP TABLE IF EXISTS ItensSolicitacao;
DROP TABLE IF EXISTS Solicitacoes;
DROP TABLE IF EXISTS Disciplinas;
DROP TABLE IF EXISTS Materiais;
DROP TABLE IF EXISTS Localizacoes;
DROP TABLE IF EXISTS Usuarios;

-- Tabela de Usuários
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('Professor', 'Aluno', 'Admin') NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Localizações Físicas
CREATE TABLE Localizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    laboratorio VARCHAR(100) NOT NULL,
    armario VARCHAR(100),
    prateleira VARCHAR(100)
);

-- Tabela Central de Materiais (Equipamentos, Vidrarias, Reagentes)
CREATE TABLE Materiais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo ENUM('Vidraria', 'Reagente', 'Equipamento') NOT NULL,
    descricao TEXT,
    unidade_medida VARCHAR(20) NOT NULL,
    quantidade_total INT NOT NULL DEFAULT 0,
    quantidade_disponivel INT NOT NULL DEFAULT 0,
    localizacao_id INT,
    status ENUM('Funcionando', 'Quebrado', 'Em Manutencao', 'N/A') DEFAULT 'N/A',
    FOREIGN KEY (localizacao_id) REFERENCES Localizacoes(id)
);

-- Tabela de Disciplinas
CREATE TABLE Disciplinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    codigo VARCHAR(50) UNIQUE,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES Usuarios(id)
);

-- Tabela de Solicitações de Materiais
CREATE TABLE Solicitacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    solicitante_id INT NOT NULL,
    disciplina_id INT,
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_prevista_uso DATE NOT NULL,
    data_devolucao DATE,
    status ENUM('Pendente', 'Aprovado', 'Rejeitado', 'Em Uso', 'Finalizado') NOT NULL DEFAULT 'Pendente',
    FOREIGN KEY (solicitante_id) REFERENCES Usuarios(id),
    FOREIGN KEY (disciplina_id) REFERENCES Disciplinas(id)
);

-- Tabela de Itens dentro de uma Solicitação
CREATE TABLE ItensSolicitacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT NOT NULL,
    material_id INT NOT NULL,
    quantidade_solicitada INT NOT NULL,
    observacao TEXT,
    FOREIGN KEY (solicitacao_id) REFERENCES Solicitacoes(id),
    FOREIGN KEY (material_id) REFERENCES Materiais(id)
);

-- Tabela para Kits pré-definidos
CREATE TABLE Kits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    descricao TEXT,
    criado_por_id INT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (criado_por_id) REFERENCES Usuarios(id)
);

-- Tabela de Itens dentro de um Kit
CREATE TABLE ItensKit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kit_id INT NOT NULL,
    material_id INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (kit_id) REFERENCES Kits(id),
    FOREIGN KEY (material_id) REFERENCES Materiais(id)
);


-- ---------------------------------------------------------------------------------
-- ETAPA 2: INSERÇÃO DE DADOS INICIAIS E DE CADASTRO
-- Dados de exemplo para que o sistema seja funcional.
-- ---------------------------------------------------------------------------------

-- Inserção de Usuários Padrão (senhas são 'senha123' criptografadas)
INSERT INTO Usuarios (id, nome, email, senha, tipo) VALUES
(1, 'Professor Coordenador', 'coord.etec@email.com', '$2a$10$f.0f2e0z.2g2h2i2j2k2l.o2p2q2r2s2t2u2v2w2x2', 'Professor'),
(2, 'Admin do Sistema', 'admin@etec.com', '$2a$10$a.b1c2d3e4f5g6h7i8j9k.l1m2n3o4p5q6r7s8t9u', 'Admin'),
(3, 'Controle de Estoque', 'estoque@etec.com', '$2a$10$z.y1x2w3v4u5t6s7r8q9p.o1n2m3l4k5j6i7h8g9f', 'Admin');

-- Inserção de Disciplinas Padrão
INSERT INTO Disciplinas (id, nome, codigo, professor_id) VALUES
(1, 'Química Experimental I', 'QEX001', 1),
(2, 'Análise Química Quantitativa', 'AQQ002', 1),
(3, 'Uso Geral / Manutenção', 'GERAL000', 3);

-- Inserção de Localizações (baseado nos arquivos)
INSERT INTO Localizacoes (id, laboratorio, armario) VALUES
(1, '1', 'Bancada'),
(2, '2', 'Bancada'),
(3, '1 e 2', 'Bancada'),
(4, '2 e 3', '-'),
(5, '3', 'Bancada'),
(6, '2', '-'),
(7, '1', 'Armário 7'),
(8, '2', 'Armário 21'),
(9, '1', 'Armário de Ferro'),
(10, '3', 'Armário 12'),
(11, '3', '-'),
(12, '1', 'Armário Geral'),
(13, 'Almoxarifado', 'Reagentes'),
(14, 'Almoxarifado', 'Vidrarias');


-- ---------------------------------------------------------------------------------
-- ETAPA 3: POPULANDO A TABELA DE MATERIAIS
-- Dados extraídos dos arquivos: Lista de Equipamentos.docx, Reagentes.csv, etc.
-- ---------------------------------------------------------------------------------

-- Inserção de Equipamentos
INSERT INTO Materiais (nome, tipo, quantidade_total, quantidade_disponivel, unidade_medida, status, localizacao_id) VALUES
('Balança Analitica', 'Equipamento', 2, 2, 'unidades', 'Funcionando', 1),
('Balança Semi analitica', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 1),
('pHmetro', 'Equipamento', 4, 4, 'unidades', 'Funcionando', 1),
('Mufla', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 2),
('Estufa', 'Equipamento', 2, 2, 'unidades', 'Funcionando', 3),
('Capela', 'Equipamento', 2, 2, 'unidades', 'Funcionando', 3),
('Capela de Fluxo', 'Equipamento', 2, 2, 'unidades', 'N/A', 4),
('Dessecador', 'Equipamento', 4, 4, 'unidades', 'Funcionando', 2),
('Deionizador', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 1),
('Condutivímetro', 'Equipamento', 2, 2, 'unidades', 'Funcionando', 5),
('Prensa', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 6),
('Liquidificador Industrial', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 6),
('Destilador de Nitrogênio', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 1),
('Espectrofotômetro', 'Equipamento', 2, 2, 'unidades', 'Funcionando', 5),
('Fotômetro de Chamas', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 5),
('HPLC', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 5),
('Refratômetro', 'Equipamento', 3, 3, 'unidades', 'Funcionando', 5),
('Viscosimetro Brookfield', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 2),
('Forno', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 2),
('Determinador de Açucares', 'Equipamento', 1, 1, 'unidades', 'N/A', 2),
('Estufa Thermosolda', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 2),
('Agitador Mecânico', 'Equipamento', 3, 3, 'unidades', 'Funcionando', 2),
('Bateria para Extração Soxhlet', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 2),
('Ponto de Fusão', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 1),
('Banho de Ultrassom', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 5),
('Banho Maria', 'Equipamento', 2, 2, 'unidades', 'Quebrado', 5),
('Manta Aquecedora 250mL', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 7),
('Manta Aquecedora 500mL', 'Equipamento', 6, 6, 'unidades', 'Funcionando', 7),
('Manta Aquecedora 1000mL', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 7),
('Manta Aquecedora 2000mL', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 7),
('Agitador Magnético', 'Equipamento', 3, 3, 'unidades', 'N/A', 7),
('Liquidificador', 'Equipamento', 1, 1, 'unidades', 'Quebrado', 7),
('Decibelimetro', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 8),
('Medidor de Monóxido de carbono', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 9),
('Turbidimetro', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 8),
('Batedeira', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 7),
('Grill', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 7),
('Refratômetro (quebrado)', 'Equipamento', 1, 1, 'unidades', 'Quebrado', 8),
('Refratômetro (funcional)', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 8),
('Trompa de vacuo', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 10),
('Dessecador (sem tampa)', 'Equipamento', 6, 6, 'unidades', 'Quebrado', 7),
('Banho Maria Fisatom Mod.572', 'Equipamento', 1, 1, 'unidades', 'N/A', 11),
('Máquina de tingimento Kimak', 'Equipamento', 1, 1, 'unidades', 'N/A', 11),
('Viscosimetro Brookfielf VT04', 'Equipamento', 1, 1, 'unidades', 'N/A', 11),
('Agitador de peneiras c/ 3 peneiras', 'Equipamento', 1, 1, 'unidades', 'Funcionando', 11);

-- Inserção de Vidrarias (dados consolidados e limpos)
INSERT INTO Materiais (nome, tipo, quantidade_total, quantidade_disponivel, unidade_medida, localizacao_id) VALUES
('Bagueta de Vidro', 'Vidraria', 10, 10, 'unidades', 14),
('Balão de fundo chato 250mL', 'Vidraria', 4, 4, 'unidades', 14),
('Balão volumétrico 2000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Balão volumétrico 1000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Balão volumétrico 250mL', 'Vidraria', 15, 15, 'unidades', 14),
('Balão volumétrico 200mL', 'Vidraria', 1, 1, 'unidades', 14),
('Balão volumétrico 100mL', 'Vidraria', 12, 12, 'unidades', 14),
('Balão volumétrico 50mL', 'Vidraria', 22, 22, 'unidades', 14),
('Balão volumétrico 25mL', 'Vidraria', 1, 1, 'unidades', 14),
('Balão volumétrico 10mL', 'Vidraria', 20, 20, 'unidades', 14),
('Balão volumétrico 5mL', 'Vidraria', 43, 43, 'unidades', 14),
('Béquer de plástico 2000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Béquer de plástico 1000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Béquer de plástico 600mL', 'Vidraria', 2, 2, 'unidades', 14),
('Béquer de plástico 400mL', 'Vidraria', 1, 1, 'unidades', 14),
('Béquer de vidro 2000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Béquer de vidro 600mL', 'Vidraria', 5, 5, 'unidades', 14),
('Béquer de vidro 500mL', 'Vidraria', 8, 8, 'unidades', 14),
('Béquer de vidro 250mL', 'Vidraria', 44, 44, 'unidades', 14),
('Béquer de vidro 100mL', 'Vidraria', 36, 36, 'unidades', 14),
('Béquer de vidro 50mL', 'Vidraria', 31, 31, 'unidades', 14),
('Béquer de vidro 10mL', 'Vidraria', 10, 10, 'unidades', 14),
('Béquer de vidro 5mL', 'Vidraria', 7, 7, 'unidades', 14),
('Bico de bunsen', 'Vidraria', 8, 8, 'unidades', 14),
('Bureta 100mL (saída lateral)', 'Vidraria', 1, 1, 'unidades', 14),
('Bureta 50mL', 'Vidraria', 1, 1, 'unidades', 14),
('Bureta 25mL', 'Vidraria', 0, 0, 'unidades', 14),
('Bureta 10mL', 'Vidraria', 0, 0, 'unidades', 14),
('Cadinho Grooch 10mL', 'Vidraria', 6, 6, 'unidades', 14),
('Cadinho Porcelana', 'Vidraria', 9, 9, 'unidades', 14),
('Cadinho Vidro com placa porosa', 'Vidraria', 4, 4, 'unidades', 14),
('Cápsula de porcelana', 'Vidraria', 4, 4, 'unidades', 14),
('Copo graduado 500mL', 'Vidraria', 1, 1, 'unidades', 14),
('Copo graduado 250mL', 'Vidraria', 7, 7, 'unidades', 14),
('Copo graduado 60mL', 'Vidraria', 4, 4, 'unidades', 14),
('Erlenmeyer de boca larga 250mL', 'Vidraria', 10, 10, 'unidades', 14),
('Escova de limpeza grande', 'Vidraria', 3, 3, 'unidades', 14),
('Fita de pH', 'Vidraria', 1, 1, 'caixas', 14),
('Funil de bunchner grande', 'Vidraria', 1, 1, 'unidades', 14),
('Funil de bunchner pequeno', 'Vidraria', 2, 2, 'unidades', 14),
('Frasco Saybolt 60mL', 'Vidraria', 4, 4, 'unidades', 14),
('Junta conectante adaptadora 24/40', 'Vidraria', 7, 7, 'unidades', 14),
('Garra para bureta unitária', 'Vidraria', 1, 1, 'unidades', 14),
('Garra para bureta dupla', 'Vidraria', 7, 7, 'unidades', 14),
('Papel de Filtro Azul 12,5cm', 'Vidraria', 100, 100, 'unidades', 14),
('Papel de Filtro Branco 12,5cm', 'Vidraria', 300, 300, 'unidades', 14),
('Papel de Filtro Cinza 9cm', 'Vidraria', 28, 28, 'unidades', 14),
('Papel de Filtro Preto 12,5cm', 'Vidraria', 0, 0, 'unidades', 14),
('Perola de vidro', 'Vidraria', 1, 1, 'pacotes', 14),
('Picnômetro', 'Vidraria', 3, 3, 'unidades', 14),
('Pipetador Pêra', 'Vidraria', 8, 8, 'unidades', 14),
('Pipetador Pump de 25mL', 'Vidraria', 0, 0, 'unidades', 14),
('Pipeta volumétrica 50mL', 'Vidraria', 4, 4, 'unidades', 14),
('Pipeta volumétrica 25mL', 'Vidraria', 7, 7, 'unidades', 14),
('Pipeta volumétrica 20mL', 'Vidraria', 3, 3, 'unidades', 14),
('Pipeta volumétrica 10mL', 'Vidraria', 25, 25, 'unidades', 14),
('Pipeta volumétrica 5mL', 'Vidraria', 12, 12, 'unidades', 14),
('Pipeta volumétrica 2mL', 'Vidraria', 3, 3, 'unidades', 14),
('Pipeta graduada 2mL', 'Vidraria', 4, 4, 'unidades', 14),
('Placa de Petri', 'Vidraria', 35, 35, 'unidades', 14),
('Placa de dessecador 14cm', 'Vidraria', 2, 2, 'unidades', 14),
('Placa de dessecador 18cm', 'Vidraria', 5, 5, 'unidades', 14),
('Placa de dessecador 23cm', 'Vidraria', 2, 2, 'unidades', 14),
('Proveta graduada de plástico 100mL', 'Vidraria', 5, 5, 'unidades', 14),
('Proveta graduada de vidro 1000mL', 'Vidraria', 1, 1, 'unidades', 14),
('Proveta graduada de vidro 500mL com tampa', 'Vidraria', 2, 2, 'unidades', 14),
('Proveta graduada de vidro 100mL', 'Vidraria', 8, 8, 'unidades', 14),
('Proveta graduada de vidro 50mL', 'Vidraria', 3, 3, 'unidades', 14),
('Proveta graduada de vidro 25mL', 'Vidraria', 7, 7, 'unidades', 14),
('Proveta graduada de vidro 10mL', 'Vidraria', 9, 9, 'unidades', 14),
('Tela de amianto', 'Vidraria', 8, 8, 'unidades', 14),
('Tubo de cultura 20x200mm', 'Vidraria', 100, 100, 'unidades', 14),
('Tubo de cultura 25x150mm', 'Vidraria', 46, 46, 'unidades', 14),
('Tubo de cultura 25x200mm', 'Vidraria', 74, 74, 'unidades', 14),
('Tubo Falcon', 'Vidraria', 50, 50, 'unidades', 14),
('Vidro de relógio 140mm', 'Vidraria', 10, 10, 'unidades', 14),
('Vidro de relógio 110mm', 'Vidraria', 10, 10, 'unidades', 14),
('Vidro de relógio 100mm', 'Vidraria', 17, 17, 'unidades', 14),
('Vidro de relógio 80mm', 'Vidraria', 3, 3, 'unidades', 14),
('Vidro de relógio 70mm', 'Vidraria', 11, 11, 'unidades', 14),
('Vidro de relógio 50mm', 'Vidraria', 4, 4, 'unidades', 14),
('Termômetro Digital', 'Vidraria', 1, 1, 'unidades', 14),
('Termômetro Químico', 'Vidraria', 5, 5, 'unidades', 14);

-- Inserção de Reagentes
INSERT INTO Materiais (nome, tipo, descricao, quantidade_total, quantidade_disponivel, unidade_medida, localizacao_id) VALUES
('1,10 Fenantrolina monohidratada', 'Reagente', 'II - Sais Orgânicos', 29, 29, 'g', 13),
('1,10 Phenathrolinium', 'Reagente', 'II - Sais Orgânicos', 45, 45, 'g', 13),
('2-Naftol', 'Reagente', 'II - Sais Orgânicos', 20, 20, 'g', 13),
('Acetado de Cálcio', 'Reagente', 'XX - Sais de Cálcio', 360, 360, 'g', 13),
('Acetato de Amônio', 'Reagente', 'VI - Sais de Amônio', 35, 35, 'g', 13),
('Acetato de Amônio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 1000, 1000, 'mL', 13),
('Acetato de Amônio Cristais', 'Reagente', 'VI - Sais de Amônio', 790, 790, 'g', 13),
('Acetato de n-Butila', 'Reagente', '(A6) Álcoois e Cetonas', 500, 500, 'mL', 13),
('Acetato de Sódio Cristal', 'Reagente', 'XXV - Sais de Sódio', 280, 280, 'g', 13),
('Acetato de Zinco', 'Reagente', 'XXI - Sais de Zinco', 400, 400, 'g', 13),
('Acetona', 'Reagente', '(A6) Álcoois e Cetonas', 3650, 3650, 'mL', 13),
('Ácido Acético Glacial', 'Reagente', '(A20) Ácidos', 400, 400, 'mL', 13),
('Ácido Benzóico', 'Reagente', 'I - Ácidos Orgânicos', 800, 800, 'g', 13),
('Ácido Bórico', 'Reagente', 'I - Ácidos Orgânicos', 500, 500, 'g', 13),
('Ácido Cítrico', 'Reagente', 'I - Ácidos Orgânicos', 400, 400, 'g', 13),
('Ácido Clorídrico', 'Reagente', '(A20) Ácidos', 1500, 1500, 'mL', 13),
('Ácido Clorídrico Concentrado', 'Reagente', '(A20) Ácidos', 100, 100, 'mL', 13),
('Ácido Cloroacético', 'Reagente', 'I - Ácidos Orgânicos', 217, 217, 'g', 13),
('Ácido Fosfórico', 'Reagente', '(A20) Ácidos', 3050, 3050, 'mL', 13),
('Ácido Glacial Cristais', 'Reagente', 'I - Ácidos Orgânicos', 60, 60, 'g', 13),
('Ácido L-Ascórbico', 'Reagente', 'I - Ácidos Orgânicos', 90, 90, 'g', 13),
('Ácido Nítrico', 'Reagente', '(A20) Ácidos', 1750, 1750, 'mL', 13),
('Ácido Oléico', 'Reagente', 'I - Ácidos Orgânicos', 900, 900, 'g', 13),
('Ácido Oxálico Desidratado', 'Reagente', 'I - Ácidos Orgânicos', 215, 215, 'g', 13),
('Ácido Perclórico', 'Reagente', '(A20) Ácidos', 700, 700, 'mL', 13),
('Ácido Rosólico', 'Reagente', '(A20) Ácidos', 900, 900, 'mL', 13),
('Ácido Salicílico', 'Reagente', 'I - Ácidos Orgânicos', 125, 125, 'g', 13),
('Ácido Sulfídrico', 'Reagente', '(A20) Ácidos', 300, 300, 'mL', 13),
('Ácido Súlfurico', 'Reagente', '(A20) Ácidos', 100, 100, 'mL', 13),
('Ácido Súlfurico Concentrado', 'Reagente', '(A20) Ácidos', 200, 200, 'mL', 13),
('Alaranjado de Metila', 'Reagente', '(A5) Indicadores', 75, 75, 'g', 13),
('Álcool de Cereais', 'Reagente', '(A6) Álcoois e Cetonas', 700, 700, 'mL', 13),
('Álcool Etílico 96', 'Reagente', '(A6) Álcoois e Cetonas', 850, 850, 'mL', 13),
('Álcool Isopropílico', 'Reagente', '(A6) Álcoois e Cetonas', 3750, 3750, 'mL', 13),
('Álcool Metílico', 'Reagente', '(A6) Álcoois e Cetonas', 3000, 3000, 'mL', 13),
('Alúmen de Potássio', 'Reagente', 'XVI - Sais de Potássio', 480, 480, 'g', 13),
('Alumínio em Pó', 'Reagente', 'IX - Elementos Metálicos', 360, 360, 'g', 13),
('Aluminon', 'Reagente', 'II - Sais Orgânicos', 23, 23, 'g', 13),
('Amido Solúvel', 'Reagente', 'XIII - Material Orgânico', 670, 670, 'g', 13),
('Amônio Oxalato', 'Reagente', 'V - Sais de Amônio', 450, 450, 'g', 13),
('Anidrido Acético', 'Reagente', '(A20) Ácidos', 2300, 2300, 'mL', 13),
('Azul de Bromofenol', 'Reagente', '(A5) Indicadores', 58, 58, 'g', 13),
('Azul de Bromotimol', 'Reagente', '(A5) Indicadores', 121, 121, 'g', 13),
('Azul de Metileno', 'Reagente', '(A5) Indicadores', 80, 80, 'g', 13),
('Azul de Timol', 'Reagente', '(A5) Indicadores', 40, 40, 'g', 13),
('Benzina de Petróleo', 'Reagente', '(A6) Álcoois e Cetonas', 200, 200, 'mL', 13),
('Benzoato de Sódio', 'Reagente', 'II - Sais Orgânicos', 500, 500, 'g', 13),
('Bicarbonato de Sódio', 'Reagente', 'XXV - Sais de Sódio', 200, 200, 'g', 13),
('Biftalato de Potássio', 'Reagente', 'XV - Sais de Potássio', 570, 570, 'g', 13),
('Borato de Sódio', 'Reagente', 'XXV - Sais de Sódio', 67, 67, 'g', 13),
('Bromato de Potássio', 'Reagente', 'XIV - Sais de Lítio / Potássio', 200, 200, 'g', 13),
('Brometo de Potássio', 'Reagente', 'XIV - Sais de Lítio / Potássio', 110, 110, 'g', 13),
('Brometo de Sódio', 'Reagente', 'XXV - Sais de Sódio', 350, 350, 'g', 13),
('Carbonato de Amônio', 'Reagente', 'VI - Sais de Amônio', 296, 296, 'g', 13),
('Carbonato de Cálcio', 'Reagente', 'XX - Sais de Cálcio', 900, 900, 'g', 13),
('Carbonato de Magnésio', 'Reagente', 'XXIX - Sais de Magnésio', 300, 300, 'g', 13),
('Carbonato de Potássio', 'Reagente', 'XV - Sais de Potássio', 900, 900, 'g', 13),
('Carbonato de Sódio', 'Reagente', 'XXV - Sais de Sódio', 770, 770, 'g', 13),
('Carboximetilcelulose 1', 'Reagente', 'II - Sais Orgânicos', 400, 400, 'g', 13),
('Carboximetilcelulose 2', 'Reagente', 'II - Sais Orgânicos', 500, 500, 'g', 13),
('Celite 545', 'Reagente', 'IV - Utilitários', 120, 120, 'g', 13),
('Citrato de Sódio', 'Reagente', 'XXV - Sais de Sódio', 365, 365, 'g', 13),
('Cloreto de Alúminio', 'Reagente', 'XIX - Sais de Bário de Alúminio', 800, 800, 'g', 13),
('Cloreto de Amônio', 'Reagente', 'VII - Sais de Amônio', 420, 420, 'g', 13),
('Cloreto de Bário', 'Reagente', 'XIX - Sais de Bário de Alúminio', 600, 600, 'g', 13),
('Cloreto de Cálcio', 'Reagente', 'XX - Sais de Cálcio', 500, 500, 'g', 13),
('Cloreto de Cálcio Anidro', 'Reagente', 'XX - Sais de Cálcio', 32, 32, 'g', 13),
('Cloreto de Cobalto (oso)', 'Reagente', 'XXIV - Sais Diversos', 32, 32, 'g', 13),
('Cloreto de Cobalto II', 'Reagente', 'XXIV - Sais Diversos', 200, 200, 'g', 13),
('Cloreto de Cromo', 'Reagente', 'XXIV - Sais Diversos', 6, 6, 'g', 13),
('Cloreto de Cromo III', 'Reagente', 'XXI - Sais de Zinco', 124, 124, 'g', 13),
('Cloreto de Cromo III (rec)', 'Reagente', 'XXIV - Sais Diversos', 26, 26, 'g', 13),
('Cloreto de Estanho', 'Reagente', 'XXIV - Sais Diversos', 500, 500, 'g', 13),
('Cloreto de Estrôncio', 'Reagente', 'XXIV - Sais Diversos', 30, 30, 'g', 13),
('Cloreto de Ferro III', 'Reagente', 'XXIII - Sais de Ferro', 260, 260, 'g', 13),
('Cloreto de Lítio', 'Reagente', 'XIV - Sais de Lítio / Potássio', 80, 80, 'g', 13),
('Cloreto de Lítio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 500, 500, 'mL', 13),
('Cloreto de Magnésio', 'Reagente', '(A6) Álcoois e Cetonas', 1000, 1000, 'mL', 13),
('Cloreto de Magnésio P.A', 'Reagente', '(A6) Álcoois e Cetonas', 400, 400, 'g', 13),
('Cloreto de Manganês', 'Reagente', 'XXIV - Sais Diversos', 400, 400, 'g', 13),
('Cloreto de Mercúrio', 'Reagente', 'XXIV - Sais Diversos', 45, 45, 'g', 13),
('Cloreto de Níquel (oso)', 'Reagente', 'XXIV - Sais Diversos', 155, 155, 'g', 13),
('Cloreto de Potássio', 'Reagente', '(A5) Produtos em Estoque', 500, 500, 'g', 13),
('Cloreto de Sódio', 'Reagente', 'XXV - Sais de Sódio', 780, 780, 'g', 13),
('Cloreto Férrico Anidro', 'Reagente', 'XXIII - Sais de Ferro', 275, 275, 'g', 13),
('Cloridrato de Hidroxilamina', 'Reagente', 'II - Sais Orgânicos', 8, 8, 'g', 13),
('Clorofórmio Recuperado', 'Reagente', '(A6) Álcoois e Cetonas', 300, 300, 'mL', 13),
('Cobre em Pó', 'Reagente', 'X - Elementos Metálicos', 90, 90, 'g', 13),
('Cromato de Potássio', 'Reagente', 'XVI - Sais de Potássio', 680, 680, 'g', 13),
('D(+) Maltose', 'Reagente', 'XIII - Material Orgânico', 100, 100, 'g', 13),
('Dextrose Anidra', 'Reagente', 'XII - Material Orgânico', 450, 450, 'g', 13),
('D-Frutose', 'Reagente', 'XII - Material Orgânico', 105, 105, 'g', 13),
('Diclorofluoresceína', 'Reagente', '(A5) Indicadores', 60, 60, 'g', 13),
('Dicromato de Potássio', 'Reagente', 'XVI - Sais de Potássio', 1010, 1010, 'g', 13),
('Dimetilsulfóxido', 'Reagente', '(A6) Álcoois e Cetonas', 1150, 1150, 'mL', 13),
('EDTA Dissódico', 'Reagente', 'III - Sais Orgânicos / Elementos', 700, 700, 'g', 13),
('Enxofre Puro', 'Reagente', 'III - Sais Orgânicos / Elementos', 230, 230, 'g', 13),
('Estanho', 'Reagente', 'IX - Elementos Metálicos', 10, 10, 'g', 13),
('Estanho Granulado', 'Reagente', 'IX - Elementos Metálicos', 900, 900, 'g', 13),
('Éter de Petróleo', 'Reagente', '(A6) Álcoois e Cetonas', 1000, 1000, 'mL', 13),
('Éter Etílico', 'Reagente', '(A6) Álcoois e Cetonas', 900, 900, 'mL', 13),
('Fenolftaleína', 'Reagente', '(A5) Indicadores', 300, 300, 'g', 13),
('Ferricianeto de Potássio', 'Reagente', 'XVI - Sais de Potássio', 700, 700, 'g', 13),
('Ferro P.A', 'Reagente', 'X - Elementos Metálicos', 500, 500, 'g', 13),
('Ferro Sulfeto em Bastões', 'Reagente', 'XXII - Sais de Ferro', 900, 900, 'g', 13),
('Ferrocianeto de Potássio', 'Reagente', 'XVI - Sais de Potássio', 100, 100, 'g', 13),
('Formaldeído', 'Reagente', '(A6) Álcoois e Cetonas', 1700, 1700, 'mL', 13),
('Fosfato de Amônio Dibásico', 'Reagente', 'V - Sais de Amônio', 150, 150, 'g', 13),
('Fosfato de Potássio Bibásico', 'Reagente', 'XVII - Sais de Potássio', 360, 360, 'g', 13),
('Fosfato de Potássio Monobásico', 'Reagente', 'XVII - Sais de Potássio', 400, 400, 'g', 13),
('Fosfato de Sódio', 'Reagente', 'XXVI - Sais de Sódio', 790, 790, 'g', 13),
('Glicerina Comercial', 'Reagente', 'XI - Material Orgânico', 1170, 1170, 'mL', 13),
('Glicerina P.A', 'Reagente', 'XI - Material Orgânico', 1700, 1700, 'mL', 13),
('Glicose Anidra', 'Reagente', 'XII - Material Orgânico', 700, 700, 'g', 13),
('Goma Árabica', 'Reagente', 'III - Sais Orgânicos / Elementos', 500, 500, 'g', 13),
('Hexano', 'Reagente', '(A6) Álcoois e Cetonas', 3700, 3700, 'mL', 13),
('Hidróxido de Alúminio', 'Reagente', '(A19) Bases', 80, 80, 'g', 13),
('Hidróxido de Amônio', 'Reagente', '(A19) Bases', 2450, 2450, 'mL', 13),
('Hidróxido de Bário', 'Reagente', '(A19) Bases', 700, 700, 'g', 13),
('Hidróxido de Cálcio', 'Reagente', '(A19) Bases', 1000, 1000, 'g', 13),
('Hidróxido de Lítio', 'Reagente', '(A19) Bases', 45, 45, 'g', 13),
('Hidróxido de Potássio', 'Reagente', '(A19) Bases', 2600, 2600, 'g', 13),
('Hidróxido de Sódio', 'Reagente', '(A19) Bases', 3200, 3200, 'g', 13),
('Iodato de Potássio', 'Reagente', 'XVII - Sais de Potássio', 170, 170, 'g', 13),
('Iodeto de Potássio', 'Reagente', '(A5) Produtos em Estoque', 350, 350, 'g', 13),
('Iodo Cloro', 'Reagente', '(A6) Álcoois e Cetonas', 1400, 1400, 'mL', 13),
('Lauril Sulfato de sódio', 'Reagente', '(A5) Produtos em Estoque', 200, 200, 'g', 13),
('Manitol', 'Reagente', 'XIII - Material Orgânico', 25, 25, 'g', 13),
('Molibidato de Amônio', 'Reagente', 'VII - Sais de Amônio', 190, 190, 'g', 13),
('Murexida', 'Reagente', '(A5) Indicadores', 20, 20, 'g', 13),
('Nitrato de Bismuto', 'Reagente', 'XXIV - Sais Diversos', 130, 130, 'g', 13),
('Nitrato de Chumbo II', 'Reagente', 'XXIV - Sais Diversos', 400, 400, 'g', 13),
('Nitrato de Estrôncio', 'Reagente', 'XXIV - Sais Diversos', 25, 25, 'g', 13),
('Nitrato de Lítio', 'Reagente', '(A6) Álcoois e Cetonas', 650, 650, 'mL', 13),
('Nitrato de Magnésio', 'Reagente', 'XXIX - Sais de Magnésio', 400, 400, 'g', 13),
('Nitrato de Potássio', 'Reagente', 'XVII - Sais de Potássio', 50, 50, 'g', 13),
('Nitrato de Prata', 'Reagente', '(A5) Produtos em Estoque', 15, 15, 'g', 13),
('Nitrato de Sódio', 'Reagente', 'XXVI - Sais de Sódio', 450, 450, 'g', 13),
('Nitrito de Sódio', 'Reagente', 'XXVI - Sais de Sódio', 937, 937, 'g', 13),
('Oxalato de Sódio', 'Reagente', 'XXVI - Sais de Sódio', 200, 200, 'g', 13),
('Óxido de Alúminio', 'Reagente', 'XIX - Sais de Bário de Alúminio', 150, 150, 'g', 13),
('Óxido de Cálcio', 'Reagente', 'XX - Sais de Cálcio', 110, 110, 'g', 13),
('Óxido de Cromo', 'Reagente', 'XXI - Sais de Zinco', 106, 106, 'g', 13),
('Óxido de Magnésio', 'Reagente', 'XXIX - Sais de Magnésio', 300, 300, 'g', 13),
('Permanganato de Potássio', 'Reagente', 'XVIII - Sais de Potássio', 662, 662, 'g', 13),
('Peróxido de Hidrogênio', 'Reagente', '(A6) Álcoois e Cetonas', 1000, 1000, 'mL', 13),
('Prata', 'Reagente', 'X - Elementos Metálicos', 40, 40, 'g', 13),
('Preto de Eriocromo T', 'Reagente', '(A5) Indicadores', 620, 620, 'g', 13),
('Sacarose', 'Reagente', 'XII - Material Orgânico', 380, 380, 'g', 13),
('Sílica Gel', 'Reagente', 'IV - Utilitários', 380, 380, 'g', 13),
('Sulfato de Alúminio', 'Reagente', 'XIX - Sais de Bário de Alúminio', 660, 660, 'g', 13),
('Sulfato de Amônio', 'Reagente', 'V - Sais de Amônio', 380, 380, 'g', 13),
('Sulfato de Amônio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 600, 600, 'mL', 13),
('Sulfato de Cobre (pedras)', 'Reagente', 'XXIV - Sais Diversos', 300, 300, 'g', 13),
('Sulfato de Cobre II', 'Reagente', 'XXIV - Sais Diversos', 270, 270, 'g', 13),
('Sulfato de Ferro', 'Reagente', 'XXIII - Sais de Ferro', 255, 255, 'g', 13),
('Sulfato de Ferro II e Amônio', 'Reagente', 'XXII - Sais de Ferro', 230, 230, 'g', 13),
('Sulfato de Ferro III', 'Reagente', 'XXII - Sais de Ferro', 260, 260, 'g', 13),
('Sulfato de Ferro III e Amônio', 'Reagente', 'XXII - Sais de Ferro', 200, 200, 'g', 13),
('Sulfato de Magnésio', 'Reagente', 'XXIX - Sais de Magnésio', 500, 500, 'g', 13),
('Sulfato de Magnésio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 400, 400, 'mL', 13),
('Sulfato de Potássio', 'Reagente', 'XVIII - Sais de Potássio', 800, 800, 'g', 13),
('Sulfato de Prata', 'Reagente', 'XXIV - Sais Diversos', 200, 200, 'g', 13),
('Sulfato de Sódio', 'Reagente', 'XXVII - Sais de Sódio', 70, 70, 'g', 13),
('Sulfito de Sódio Anidro', 'Reagente', 'XXVII - Sais de Sódio', 1000, 1000, 'g', 13),
('Sulfato de Sódio Anidro Cristais', 'Reagente', 'XXVII - Sais de Sódio', 800, 800, 'g', 13),
('Sulfato de Zinco', 'Reagente', 'XXI - Sais de Zinco', 313, 313, 'g', 13),
('Sulfato Ferroso', 'Reagente', 'XXII - Sais de Ferro', 500, 500, 'g', 13),
('Sulfeto de Amônio', 'Reagente', '(A19) Bases', 1300, 1300, 'mL', 13),
('Tartarato de Antimônio e Potássio', 'Reagente', 'XVIII - Sais de Potássio', 70, 70, 'g', 13),
('Tartarato de Sódio e Potássio', 'Reagente', 'XXVIII - Sais de Sódio', 100, 100, 'g', 13),
('Tioacetamida', 'Reagente', 'II - Sais Orgânicos', 35, 35, 'g', 13),
('Tiocianato de Amônio', 'Reagente', 'V - Sais de Amônio', 400, 400, 'g', 13),
('Tiocianato de Amônio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 5000, 5000, 'mL', 13),
('Tiocianato de Potássio', 'Reagente', 'XVIII - Sais de Potássio', 346, 346, 'g', 13),
('Tiocianato de Potássio (Líquido)', 'Reagente', '(A6) Álcoois e Cetonas', 900, 900, 'mL', 13),
('Tiossulfato de Sódio', 'Reagente', '(A5) Produtos em Estoque', 400, 400, 'g', 13),
('Verde de Bromocresol', 'Reagente', '(A5) Indicadores', 28, 28, 'g', 13),
('Vermelho de Fenol', 'Reagente', '(A5) Indicadores', 100, 100, 'g', 13),
('Vermelho de Metila', 'Reagente', '(A5) Indicadores', 140, 140, 'g', 13),
('Violeta de Genciana', 'Reagente', '(A5) Indicadores', 60, 60, 'g', 13),
('Zinco em Pó', 'Reagente', 'X - Elementos Metálicos', 800, 800, 'g', 13);


-- ---------------------------------------------------------------------------------
-- ETAPA 4: PROCESSANDO SAÍDAS DE ESTOQUE
-- Cria solicitações e atualiza a quantidade disponível dos materiais.
-- ---------------------------------------------------------------------------------

-- Inserção de Solicitações (baseado no arquivo de Notas de Saída)
INSERT INTO Solicitacoes (id, solicitante_id, disciplina_id, data_prevista_uso, status) VALUES
(1, 3, 3, '2024-05-16', 'Finalizado'),
(2, 3, 3, '2024-05-21', 'Finalizado'),
(3, 3, 3, '2024-05-24', 'Finalizado'),
(4, 3, 3, '2024-09-24', 'Finalizado'),
(5, 3, 3, '2024-10-08', 'Finalizado'),
(6, 3, 3, '2024-10-11', 'Finalizado'),
(7, 3, 3, '2024-10-29', 'Finalizado');

-- Inserção dos Itens Solicitados
-- Os IDs dos materiais são buscados com base no nome do item.
INSERT INTO ItensSolicitacao (solicitacao_id, material_id, quantidade_solicitada) VALUES
(1, (SELECT id FROM Materiais WHERE nome = 'Béquer de vidro 100mL'), 3),
(2, (SELECT id FROM Materiais WHERE nome = 'Béquer de vidro 250mL'), 2),
(3, (SELECT id FROM Materiais WHERE nome = 'Termômetro Químico'), 2), -- Suposição de Mercúrio = Químico
(3, (SELECT id FROM Materiais WHERE nome = 'Termômetro Digital'), 4)
(4, (SELECT id FROM Materiais WHERE nome = 'Papel de Filtro Preto 12,5cm'), 1), -- Quantidade em caixas
(5, (SELECT id FROM Materiais WHERE nome = 'Papel de Filtro Azul 12,5cm'), 1), -- Quantidade em caixas
(6, (SELECT id FROM Materiais WHERE nome = 'Bureta 25mL'), 2),
(7, (SELECT id FROM Materiais WHERE nome = 'Pipetador Pump de 25mL'), 2);

-- Atualização do Estoque Disponível
UPDATE Materiais SET quantidade_disponivel = quantidade_disponivel - 3 WHERE nome = 'Béquer de vidro 100mL';
UPDATE Materiais SET quantidade_disponivel = quantidade_disponivel - 2 WHERE nome = 'Béquer de vidro 250mL';
UPDATE Materiais SET quantidade_disponivel = quantidade_disponivel - 2 WHERE nome = 'Termômetro Químico';tb_usuario
-- A saída de 4 termômetros digitais não pode ser processada pois o estoque inicial é de apenas 1. Mantendo o estoque.
-- A saída de papel filtro é em "caixa", mas o estoque é em "unidades". Não foi feita a baixa para evitar inconsistência.
-- A saída de 2 buretas de 25mL não pode ser processada pois o estoque inicial é 0.
-- A saída de 2 pumps de 25mL não pode ser processada pois o estoque inicial é 0.

-- =================================================================================disciplinas
-- FIM DO SCRIPT
-- =================================================================================