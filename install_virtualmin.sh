#install_virtualmin.sh: Contém a lógica para instalar o Virtualmin.
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies
check_network

# Função para instalar o Virtualmin
install_virtualmin() {
    wlog "Virtualmin - Downloading"
    if ! wget "$VIRTUALMIN_INSTALL_URL" -O /root/install.sh; then
        wlog "Erro ao baixar o instalador do Virtualmin."
        exit 1
    fi
    chmod +x /root/install.sh
    
    # Configurar os timers do systemd antes de iniciar a instalação
    setup_check_services_timer
    setup_monitor_apache_timer
    wlog "Systemd timers configurados e iniciados"
    
    wlog "Virtualmin - Running installer"
    if ! /root/install.sh -f; then
        wlog "Erro durante a instalação do Virtualmin."
        exit 1
    fi
}

# Verifica se o Virtualmin já está instalado e, em caso negativo, inicia a instalação
if [ -f /usr/sbin/virtualmin ]; then
    wlog "Virtualmin already installed"
else
    install_virtualmin
    wlog "Virtualmin installed successfully"
fi

