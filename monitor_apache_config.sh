#monitor_apache_config.sh: Contém a lógica para monitorar a configuração do Apache.#!/bin/bash
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies

# Função para adicionar uma linha ao arquivo de configuração do Apache
add_config_line() {
    if ! grep -q "ServerName $HOSTNAME" "$APACHE_CONFIG_FILE"; then
        cp "$APACHE_CONFIG_FILE" "$APACHE_CONFIG_FILE.bak"
        echo "ServerName $HOSTNAME" >> "$APACHE_CONFIG_FILE"
        if systemctl restart apache2; then
            wlog "Linha adicionada ao arquivo de configuração do Apache e serviço reiniciado."
        else
            cp "$APACHE_CONFIG_FILE.bak" "$APACHE_CONFIG_FILE"
            wlog "Falha ao reiniciar o Apache. Configuração revertida."
            exit 1
        fi
    fi
}

# Verificar e adicionar linha de configuração ao Apache se necessário
add_config_line


