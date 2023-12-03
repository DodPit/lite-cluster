# Utilitários

Estão presentes sobre o diretório root e foram pensados para facilitar algumas ações dentro do cluster. 


### Reinício do Ganglia
- Necessário executar `restart-ganglia.sh` para reiniciar o monitor Ganglia em todos os nós.
- Reinicia o Servidor acessível na URL <http://IP-do-mestre/ganglia/>

### Mount Point compartilhado
- Necessário executar `mount-cifs.sh` para reiniciar o CIFS (*File System*) para acesso ao diretório compartilhado de rede sobre o mount point `/mnt/cifs_shared/`

### Desliga Cluster
- Necessário executar `shutdown-cluster.sh` para desligar todas as máquinas do cluster a partir da máquina mestre