#configure_initial_setup.sh: Contém a lógica para configurar o ambiente.
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies

# Função para configurar o hostname
configure_hostname() {
    echo "$HOSTNAME" > /etc/hostname
    echo "127.0.0.1 $HOSTNAME $(hostname)" >> /etc/hosts
    hostname "$HOSTNAME"
}

# Verifica se o hostname já está configurado
if grep -q "$HOSTNAME" /etc/hosts; then
    wlog "Hostname already configured"
else
    configure_hostname
    wlog "Hostname configured successfully"
fi

