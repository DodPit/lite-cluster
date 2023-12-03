# lite-cluster


## Instalação e Configuração do Cluster via Imagem.

Utilize algum Software Etcher para montar uma imagem bootavel em Cartão SD. 

1. 
   - Se instalação para máquina **Master**:
      - Utilze o arquivo [lite_cluster_master.img.xz](https://)

   - Se instalação para máquina **Worker**:
      - Utilze o arquivo [lite_cluster_worker.img.xz](https://)

2. Insira o cartao SD no TVBox e reinicie o dispositivo. 


3. Uma vez dentro do dispositivo use as credenciais abaixo para logar. 
   - user: root
   - password: 0880
   - ![Página Inicial](doc/img/initial_page.png)


4. Execute o camando `armbian-config` e a interface gráfica irá iniciar.
   - ![Menu Inicial](doc/img/menu_inicial.png)

4.1. Navegue até Personal

4.2. Selecione a opção Hostname e mude para um nome desejado
   - ![Hostname](doc/img/mudando_hostname.png)

4.3. Retorne até o menu Iniciar

4.4. Entre na opçao *System*

4.5. Selecione Install
   - ![Hostname](doc/img/system.png)

4.6. Selecione a opção *Boot from eMMC - system on eMMC* 
   - ![Hostname](doc/img/installation_option.png)

4.7. Selecione *Yes* para formatar instalar.
   - ![Hostname](doc/img/formatacao.png)

5. Após a instalacao remova o cartao SD e reinicie o dispositivo 


### Passos Adicionais

6. Se foi feita instalação na máquina Master altere arquivos de configuracao do spark com os IPs corretos das maquinas trabalhadoras, 

Isso pode ser feito por meio da funcao scripts.setup.master.copy_ssh_keys

```shell
copy_ssh_keys() {
  for IP in "${IPS[@]}"; do
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$IP "
      mkdir -p /root/.ssh/ &&
      mkdir -p /home/s2p/.ssh/
      exit " && 
    sshpass -p $PASSWORD scp ~/.ssh/id_rsa.pub root@$IP:/root/.ssh/authorized_keys &&
    sshpass -p $PASSWORD scp ~/.ssh/id_rsa.pub root@$IP:/home/s2p/.ssh/authorized_keys
  done
}

IPS=("192.168.15.120" "192.168.15.110"  .... ) # Mude para os seus IPS de nós trabalhadores
PASSWORD='0880' # Senha padrão para máquinas com a Imagem

copy_ssh_keys

```

7. Altere o arquivo `/opt/spark/conf/workers` com os IPs corretos das máquinas trabalhadoras. 

   - ![Hostname](doc/img/workers.png)


## Guia de Instalação Manual e Configuração do Cluster

Tenha em mente que é mais simples utilizar o método de instalação seguido no passo anterior.
Este guia fornece instruções passo a passo para configurar um ambiente de cluster incluindo Spark 3.4.1, CIFS para compartilhamento de arquivos, e Ganglia para monitoramento.

### Pré-requisitos
- Todos os nós devem estar executando [Debian 12 Bookworm Armbian-Sunvell r69](https://).
- O usuário deve ter privilégios de sudo em todos os nós.

**Altere dentro dos Scripts os trechos referentes aos IPS do nó mestre e dos nós trabalhadores**

### Instalação em Todas as Máquinas (Mestres e Trabalhadores)
1. **Configuração Inicial**:
   - Execute `initial_setup.sh` em todos os nós.
   - Este script instala pacotes necessários como Java e configura SSH.

### Configuração do Nó Mestre
1. **Instalação do Spark**:
   - Execute `spark_install_master.sh`.
   - Referência: [Spark Standalone Mode](https://spark.apache.org/docs/3.4.1/spark-standalone)

2. **Configuração do CIFS**:
   - Execute `setup_cifs_master.sh`.
   - Referências: [CIFS on Linux](https://linuxize.com/post/how-to-mount-cifs-windows-share-on-linux/)

3. **Instalação do Ganglia**:
   - Execute `install_ganglia_master.sh`.
   - Referências: [Ganglia on Ubuntu 18.04](https://www.atlantic.net/vps-hosting/how-to-install-ganglia-monitoring-server-on-ubuntu-18-04/), [Ganglia Official Documentation](https://github.com/ganglia/monitor-core/wiki)

4. **Atualização do `.bashrc`**:
   - Execute `update_bashrc_master.sh` para adicionar variáveis de ambiente e aliases.

### Configuração dos Nós Trabalhadores
1. **Configuração SSH**:
   - Execute `configure_ssh_worker.sh`.

2. **Instalação do Spark**:
   - Execute `spark_install_worker.sh`.

3. **Instalação do Ganglia**:
   - Execute `install_ganglia_worker.sh`.

4. **Atualização do `.bashrc`**:
   - Execute `update_bashrc_worker.sh`.



### Notas Finais
- Teste cada script em um ambiente controlado antes de implantar em produção.
- Certifique-se de que as configurações de rede e segurança estão de acordo com as políticas do seu ambiente.
