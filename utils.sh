# utils.sh: 
#!/bin/bash
set -e

# Definir o caminho base do script
BASE_DIR=$(dirname "$0")

# Definir variáveis de ambiente
HOSTNAME=${HOSTNAME:-"server1.fabiobraga.dev"}
APACHE_CONFIG_FILE=${APACHE_CONFIG_FILE:-"/etc/apache2/apache2.conf"}
VIRTUALMIN_INSTALL_URL=${VIRTUALMIN_INSTALL_URL:-"http://software.virtualmin.com/gpl/scripts/install.sh"}

# Função para definir a variável TERM
set_term() {
  if [ -z "$TERM" ]; then
    export TERM=xterm
  fi
}

# Função para fazer log e print na tela ao mesmo tempo
wlog() {
    local MSG="$1"
    logger "$MSG"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $MSG" >> /var/log/virtualmin_start.log
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $MSG"
}

# Função para verificar se o script está sendo executado como root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    wlog "Este script deve ser executado como root"
    exit 1
  fi
}

# Função para verificar conectividade de rede
check_network() {
    if ! ping -c 1 google.com &> /dev/null; then
        wlog "Sem conectividade de rede. Verifique sua conexão e tente novamente."
        exit 1
    fi
}

# Função para verificar se todas as dependências necessárias estão disponíveis
check_dependencies() {
    dependencies=("systemctl" "wget" "grep" "hostname" "echo")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            wlog "$dep não encontrado. Este script requer $dep."
            exit 1
        fi
    done
}

# Função para configurar e ativar o timer do systemd para serviços
setup_check_services_timer() {
  # Criação do arquivo de serviço
  cat <<EOF > /etc/systemd/system/check_services.service
[Unit]
Description=Check and Restart Services

[Service]
Type=oneshot
ExecStart=$BASE_DIR/check_and_restart_services.sh
EOF

  # Criação do arquivo de timer
  cat <<EOF > /etc/systemd/system/check_services.timer
[Unit]
Description=Check and Restart Services Timer

[Timer]
OnBootSec=0
OnUnitActiveSec=20s

[Install]
WantedBy=timers.target
EOF

  # Habilitar e iniciar o timer
  systemctl enable check_services.timer
  systemctl start check_services.timer
  wlog "Systemd timer para check_and_restart_services configurado e iniciado"
}

# Função para configurar e ativar o timer do systemd para monitorar arquivos
setup_monitor_apache_timer() {
  # Criação do arquivo de serviço
  cat <<EOF > /etc/systemd/system/monitor_apache.service
[Unit]
Description=Monitor Apache Configuration

[Service]
Type=simple
ExecStart=$BASE_DIR/monitor_apache_config.sh
EOF

  # Criação do arquivo de timer
  cat <<EOF > /etc/systemd/system/monitor_apache.timer
[Unit]
Description=Monitor Apache Configuration Timer

[Timer]
OnBootSec=0
OnUnitActiveSec=20s

[Install]
WantedBy=timers.target
EOF

  # Habilitar e iniciar o timer
  systemctl enable monitor_apache.timer
  systemctl start monitor_apache.timer
  wlog "Systemd timer para monitor_apache_config configurado e iniciado"
}

# Função para desativar e remover os timers do systemd
remove_systemd_timers() {
  systemctl stop check_services.timer
  systemctl disable check_services.timer
  rm /etc/systemd/system/check_services.service
  rm /etc/systemd/system/check_services.timer

  systemctl stop monitor_apache.timer
  systemctl disable monitor_apache.timer
  rm /etc/systemd/system/monitor_apache.service
  rm /etc/systemd/system/monitor_apache.timer
  
  systemctl daemon-reload
  wlog "Systemd timers desativados e removidos"
}
