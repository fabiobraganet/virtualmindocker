# Virtualmin Docker Container

Este repositório fornece uma imagem Docker para configurar e executar o Virtualmin em um contêiner. Virtualmin é uma ferramenta de administração de sistemas baseada na web para Linux e Unix que oferece gerenciamento simplificado de servidores.

## Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Começando](#começando)
  - [Pré-requisitos](#pré-requisitos)
  - [Instalação](#instalação)
- [Uso](#uso)
- [Scripts](#scripts)
  - [startup.sh](#startupsh)
  - [utils.sh](#utilssh)
  - [configure_initial_setup.sh](#configure_initial_setupsh)
  - [install_virtualmin.sh](#install_virtualminsh)
  - [monitor_apache_config.sh](#monitor_apache_configsh)
  - [check_and_restart_services.sh](#check_and_restart_servicessh)
  - [start_virtualmin.sh](#start_virtualminsh)
- [Contribuição](#contribuição)
- [Licença](#licença)

## Sobre o Projeto

Virtualmin é um poderoso painel de controle de administração de servidores que permite aos usuários gerenciar múltiplos hosts virtuais por meio de uma interface amigável. Ele fornece ferramentas para gerenciar servidores web, correio, DNS, banco de dados e mais. Para mais informações sobre o Virtualmin, visite o [site oficial](https://www.virtualmin.com/).

## Começando

### Pré-requisitos

- Docker instalado em sua máquina.
- Conexão com a internet para baixar as dependências.

### Instalação

Clone este repositório:

```bash
git clone https://github.com/seu-usuario/virtualmin-docker.git
cd virtualmin-docker
```

Construa a imagem Docker:

```bash
docker build -t virtualmin .
```

## Uso

Para executar o contêiner Docker, use o comando:

```bash
docker run -d --name virtualmin --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --mount source=volume_quota,target=/mnt/volume_quota custom-virtualmin
```

Este comando iniciará o Virtualmin acessível através da porta 10000.

## Scripts

### startup.sh

Este script orquestra a execução dos outros scripts no contêiner Docker. Ele chama os scripts de configuração inicial, monitoramento e verificação de serviços, e também inicia o Virtualmin ou realiza sua instalação, se necessário. É o ponto de partida para garantir que todos os componentes estejam configurados e funcionando corretamente.

### utils.sh

Este script contém funções utilitárias que são usadas pelos outros scripts. Ele define variáveis de ambiente, funções para logging, verificação de dependências, verificação de rede e configuração de timers do systemd. Essas funções auxiliares simplificam a implementação das funcionalidades principais nos outros scripts.

### configure_initial_setup.sh

Este script é responsável por configurar o ambiente inicial no contêiner. Ele ajusta o hostname e verifica se todas as dependências necessárias estão presentes. Caso o hostname não esteja configurado, ele o configura adequadamente.

### install_virtualmin.sh

Este script baixa e instala o Virtualmin. Ele verifica se o Virtualmin já está instalado e, se não estiver, realiza o download do instalador e executa o processo de instalação. Também configura timers do systemd para monitorar serviços.

### monitor_apache_config.sh

Este script monitora e atualiza a configuração do Apache. Ele verifica se a linha `ServerName` está presente no arquivo de configuração do Apache e, caso contrário, a adiciona e reinicia o serviço do Apache para aplicar as mudanças.

### check_and_restart_services.sh

Este script verifica o status de vários serviços essenciais como Apache, Dovecot, Postfix e ClamAV. Se algum desses serviços estiver parado, ele tenta reiniciá-los. O script garante que todos os serviços críticos estejam sempre em execução.

### start_virtualmin.sh

Este script inicia o Virtualmin. Ele tenta iniciar o serviço do Virtualmin várias vezes, caso falhe nas primeiras tentativas, garantindo que o serviço esteja ativo e funcionando corretamente.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir um problema ou enviar um pull request.

## Licença

Não reqrer licença `FREE LICENSE`.


