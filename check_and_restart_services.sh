#check_and_restart_services.sh: Contém a lógica para verificar e reiniciar os serviços.#!/bin/bash
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies

# Função para verificar e reiniciar serviços se necessário
check_and_restart_services() {
    local services=("apache2" "dovecot" "postfix" "clamav-daemon")

    for service in "${services[@]}"; do
        if systemctl status "$service" &> /dev/null; then
            if ! systemctl is-active --quiet "$service"; then
                wlog "Serviço $service está parado. Reiniciando..."
                if ! systemctl restart "$service"; then
                    wlog "Falha ao reiniciar o serviço $service."
                else
                    wlog "Serviço $service reiniciado com sucesso."
                fi
            else
                wlog "Serviço $service está em execução."
            fi
        fi
    done
}

# Chamar a função uma vez (será agendada pelo systemd timer)
check_and_restart_services

#Nota/Explicações
# systemctl status "$service" &> /dev/null: Verifica o status do serviço, redirecionando toda a saída (stdout e stderr) para /dev/null para suprimir a saída.
# &> /dev/null: Redireciona toda a saída para /dev/null, efetivamente suprimindo-a.
# if: Se o comando systemctl status retorna um código de saída 0, significa que o serviço existe no sistema.
# ! systemctl is-active --quiet "$service": Verifica se o serviço não está ativo.
# systemctl is-active --quiet "$service": Comando que verifica se o serviço está ativo (em execução).
# systemctl: Comando utilizado para gerenciar serviços no sistema.
# is-active: Parâmetro que verifica se o serviço está ativo.
# --quiet: Suprime a saída do comando, retornando apenas o código de saída.
# "$service": Nome do serviço atual sendo verificado (iterado pelo loop).