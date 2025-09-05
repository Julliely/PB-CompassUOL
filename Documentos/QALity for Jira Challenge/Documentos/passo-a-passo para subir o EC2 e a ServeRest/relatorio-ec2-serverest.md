# Relatório – Subida de Instância EC2 e Deploy da ServeRest

## 1. Orientações Gerais Seguidas
Durante a execução da atividade, foram seguidas as diretrizes fornecidas no documento oficial:

- **Não criação de usuários IAM** (uso apenas quando solicitado).  
- **Acesso exclusivo via Single Sign-on (SSO)** utilizando o usuário do domínio `@compasso.com.br`.  
- **Desligamento dos recursos após uso** para evitar custos desnecessários.  
- **Uso de instâncias permitidas** (`t3.micro`, `t2.micro`, `t3.small`, `t2.small`) na região **us-east-1 (Virgínia)**.  
- **Aplicação obrigatória de tags**: `Project`, `CostCenter`, `Name`.  

---

## 2. Acesso ao Ambiente
1. Acessar o link: [https://academy-compass.awsapps.com/start#/](https://academy-compass.awsapps.com/start#/)  
2. Realizar login com o usuário `xxxxxx@compasso.com.br`.  
3. Selecionar a conta de **lab** com o próprio nome.  
4. Entrar no **Management Console**.  

---

## 3. Criação do Par de Chaves (Key Pair)
1. No Console da AWS, pesquisar por **EC2**.  
2. No menu lateral, acessar **Redes e Segurança → Pares de Chaves**.  
3. Clicar em **Criar par de chaves**.  
4. Definir um nome para o par de chaves.  
5. Selecionar o tipo **RSA**.  
6. Selecionar o formato de arquivo de chave privada **.pem**.  
7. Fazer o download do arquivo `.pem`.  
8. Criar uma pasta local para armazenar o par de chave com segurança.  

---

## 4. Criação do Internet Gateway
1. Pesquisar por **Internet Gateway** no console da AWS.  
2. Clicar em **Criar gateway** e dar um nome (ex.: `igw-serverest`).  
3. Após criado, clicar em **Ações → Anexar a VPC**.  
4. Selecionar a **VPC padrão** ou a criada pelo grupo.  
5. Confirmar a associação.  

---

## 5. Associação da Gateway à VPC
1. No menu **VPC**, acessar **Rotas (Route Tables)**.  
2. Selecionar a tabela de rotas da VPC associada.  
3. Editar as rotas e adicionar:  
   - **Destino**: `0.0.0.0/0`  
   - **Alvo**: Internet Gateway criado anteriormente.  
4. Salvar as alterações.  

---

## 6. Criação da Instância EC2
1. Acessar **EC2 → Instâncias → Executar instância**.  
2. Definir um nome e adicionar as **tags obrigatórias**:  
   - `Project`  
   - `CostCenter`  
   - `Name`  
3. Selecionar a **AMI Amazon Linux 2**.  
4. Escolher o tipo de instância permitido (ex.: `t2.micro`).  
5. Associar o **par de chaves criado** para conexão SSH.  
6. Configurar rede para permitir **IP público**.  
7. Definir regras do **Security Group**:  
   - **HTTP (80)**  
   - **HTTPS (443)**  
   - **Personalizado – TCP 3000** (porta da ServeRest)  
   - **SSH (22)** para acesso via terminal.  
8. Confirmar e lançar a instância.  

---

## 7. Conexão na Instância EC2
1. Selecionar a instância criada e clicar em **Conectar**.  
2. No terminal local, garantir que o arquivo `.pem` está com permissão adequada:  

   ```bash
   chmod 400 chave.pem
   ```
3. Conectar à instância:  

   ```bash
   ssh -i chave.pem ec2-user@<IP_Público>
   ```

---

## 8. Instalação da ServeRest
Dentro da instância, seguir os comandos na ordem:

```bash
# Atualizar pacotes
sudo yum update -y

# Instalar compiladores necessários
sudo yum install gcc-c++ make -y

# Checar se o curl está instalado
curl --version

# Criar diretório da aplicação
mkdir serverestApi
cd serverestApi

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo yum install -y nodejs

# Caso ocorra erro, utilizar:
sudo yum install -y nodejs

# Executar a ServeRest
npx serverest@latest
```

A ServeRest estará disponível no **IP público da instância** na porta **3000**.  

---

## 9. Encerrando a Instância (para evitar custos)
1. Acessar **EC2 → Instâncias**.  
2. Selecionar a instância criada.  
3. Clicar em **Estado da Instância → Interromper instância**.  
4. Confirmar a ação.  

---

## 10. Desafios Enfrentados
O único desafio encontrado foi a **dificuldade inicial em conectar na AWS**, resolvida com o auxílio dos **vídeos tutoriais**, que foram claros e explicativos.  

---
