# pingo-odoo-dockercompose

Este repositório fornece um ambiente Docker Compose para a instalação do Odoo 17, criado pela **Pingo Tecnologia**. O ambiente está configurado para facilitar a implantação e manutenção do Odoo em um contêiner Docker, com suporte a um banco de dados PostgreSQL.

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
├── nginx/                # Armazena o nginx.conf e os arquivos de certificado gerados pelo cerbot
│   ├── nginx.conf/       # Arquivo de configuração do Nginx
│   ├── certbot/          # Arquivos de certificados TLS do certbot
│      ├── conf/          # Pasta de arquivos de configuração do certbot
│      ├── www/           # Pasta usada para validação de emissão/renovação de certificados
│   └── renew_certs.sh    # Script de rotação automática de certificados
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
- **`config/odoo.conf`**: Arquivo de configuração do Odoo. Personalize conforme as suas necessidades. Já possui a configuração básica.
- **`nginx/nginx.conf`**: Arquivo de configuração do Odoo. Personalize conforme as suas necessidades. Substitua `yourdomain.com.br` pelo seu domínio.
- **`docker-compose.yml`**: Arquivo de configuração do Docker Compose. Personalize conforme as suas necessidades. Substitua `yourdomain.com.br` pelo seu domínio.
- **`nginx/renew_certs.sh`**: Script de rotação automática de certificados TLS. Personalize conforme as suas necessidades. Substitua `/mnt/odoo` pela pasta raiz deste repositório.

### 3. Fornecer permissões ao usuário Odoo para as pastas

No host, ajuste as permissões para garantir que o usuário do contêiner Odoo tenha acesso:

```bash
sudo chown -R 101:101 odoo-data/
sudo chown -R 101:101 addons/
```

### 4. Executar o Docker Compose para primeiro subir o Nginx, que será usado como base para a emissão do primeiro certificado TLS:

```bash
docker compose up nginx -d
```

### 5. Executar o Docker Compose para emitir o certificado TLS:

> Antes de executar este comando, você deve encaminhar as requisições do seu domínio para o IP ou DNS do servidor que este IP está sendo implementado.

```bash
docker compose up certbot
```

### 6. Agora, você pode criar o Odoo a partir do Docker Compose:

```bash
docker compose up -d odoo
```

### 7. Acessar o Odoo

Após a inicialização bem-sucedida, o Odoo estará acessível em:

- **Interface Web**: [https://yourdomain.com.br](https://yourdomain.com.br)
- **Longpolling (para chat e notificações)**: Porta `8072`

### 8. Parar o Ambiente

Para parar os contêineres, execute:

```bash
docker compose down
```

## Renovação Automática do Certificado TLS

Esta implementação é preparada para a rotação automática de certificados TLS. Para isso, você pode usar o `crontab -e` do Linux com este comando:

```shell
0 3 1 * * /bin/bash -c '/mnt/odoo/nginx/renew-certs.sh >> /mnt/odoo/nginx/logs/renew-$(date +\%F).log 2>&1'
```

> Substitua `/mnt/odoo` pela sua pasta raiz deste repositório. Isso vai usar o crontab do Linux para rotacionar o certificado TLS mensalmente todo dia 1, às 3h.

## Alterar a Versão do Odoo

Para alterar a versão do Odoo utilizada no contêiner:

1. **Editar o arquivo `docker-compose.yml`**:
   Localize a linha abaixo:
   ```yaml
   image: odoo:17
   ```
   Substitua `17` pela versão desejada, como `16` ou outra versão suportada:
   ```yaml
   image: odoo:16
   ```

2. **Recriar os Contêineres**:
   Após salvar o arquivo, execute os comandos abaixo para atualizar o ambiente:
   ```bash
   docker compose down
   docker compose pull odoo
   docker compose up -d
   ```

   Isso garantirá que a nova imagem da versão escolhida seja baixada e utilizada.

3. **Verificar a Compatibilidade**:
   Certifique-se de que os módulos e dados existentes sejam compatíveis com a nova versão do Odoo antes de realizar a alteração.

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

