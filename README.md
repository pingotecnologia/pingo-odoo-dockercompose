# pingo-odoo-dockercompose

Este repositório fornece um ambiente Docker Compose para a instalação do Odoo 16, criado pela **Pingo Tecnologia**. O ambiente está configurado para facilitar a implantação e manutenção do Odoo em um contêiner Docker, com suporte a um banco de dados PostgreSQL.

## Estrutura do Repositório

```plaintext
pingo-odoo-dockercompose/
├── addons/               # Diretório para módulos adicionais do Odoo
├── config/               # Configurações do Odoo e arquivo de senha do PostgreSQL
│   ├── odoo_pg_pass      # Arquivo com a senha do PostgreSQL
│   └── odoo.conf         # Configurações do Odoo
├── odoo-data/            # Dados persistentes do Odoo
│   ├── addons/           # Códigos-fonte de módulos instalados
│   ├── filestore/        # Armazenamento de arquivos do Odoo
│   └── sessions          # Dados de sessões do Odoo
├── docker-compose.yml    # Arquivo principal do Docker Compose
└── README.md             # Documentação do repositório
```

## Configuração e Instalação

Siga os passos abaixo para configurar e executar o ambiente:

### 1. Clonar o Repositório

```bash
git clone https://github.com/pingotecnologia/pingo-odoo-dockercompose.git
cd pingo-odoo-dockercompose
```

### 2. Configurar os Arquivos Necessários

Certifique-se de que os seguintes arquivos e pastas estejam configurados corretamente:

- **`config/odoo_pg_pass`**: Contém a senha para o banco de dados PostgreSQL. (padrão é `odoo`)
- **`config/odoo.conf`**: Arquivo de configuração do Odoo. Personalize conforme as suas necessidades. Já possuí a configuração básica.

### 3. Fornecer permissões ao usuário Odoo para as pastas
```bash
chown -R 101:101 odoo-data/ up -d
chown -R 101:101 addons/ up -d
```

### 4. Executar o Docker Compose

Inicie o ambiente com o comando:

```bash
docker-compose up -d
```

### 5. Acessar o Odoo

Após a inicialização bem-sucedida, o Odoo estará acessível em:

- **Interface Web**: [http://localhost:8069](http://localhost:8069)
- **Longpolling (para chat e notificações)**: Porta `8072`

### 6. Parar o Ambiente

Para parar os contêineres, execute:

```bash
docker-compose down
```

## Detalhes do Docker Compose

### Serviço `db` (PostgreSQL)
- **Imagem**: `postgres:16`
- **Configurações**:
  - Usuário: `odoo`
  - Senha: Definida no arquivo `config/odoo_pg_pass`
  - Banco de Dados: `postgres`
- **Volume Persistente**: `./odoo-db:/var/lib/postgresql/data`

### Serviço `web` (Odoo 17)
- **Imagem**: `odoo:17`
- **Configurações**:
  - Portas: `8069` (web) e `8072` (longpolling)
  - Volumes Persistentes:
    - `./addons:/mnt/extra-addons`
    - `./config:/etc/odoo`
    - `./odoo-data:/var/lib/odoo`
  - Depende do serviço `db`

## Persistência de Dados

Os dados do Odoo e do banco de dados são armazenados localmente nas pastas:
- **Banco de Dados**: `./odoo-db`
- **Dados do Odoo**: `./odoo-data`

Certifique-se de fazer backup dessas pastas regularmente.

## Personalização

- **Módulos Adicionais**: Coloque seus módulos no diretório `./addons`.
- **Configuração do Odoo**: Edite o arquivo `config/odoo.conf` conforme suas necessidades.

## Suporte

Se você encontrar problemas ou tiver dúvidas, entre em contato com a equipe da **Pingo Tecnologia** pelo nosso [site oficial](https://pingotecnologia.com) ou abra uma *issue* neste repositório.

---

**Pingo Tecnologia - Gota de Tecnologia, Mar de Mudanças!**
