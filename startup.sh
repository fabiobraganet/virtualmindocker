#startup.sh: Orquestra a execução dos scripts, garantindo que todas as operações sejam executadas conforme necessário dentro do contêiner Docker.
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies
check_network

# Iniciar a configuração inicial
./configure_initial_setup.sh

# Iniciar o systemd
exec /lib/systemd/systemd --system &

# Iniciar a observação do arquivo de configuração do Apache em segundo plano
./monitor_apache_config.sh &

# Iniciar a verificação dos serviços em segundo plano
./check_and_restart_services.sh &

# Verifica se o Virtualmin já está instalado e, em caso negativo, inicia a instalação. Caso contrário, inicia o Virtualmin.
if [ -f /usr/sbin/virtualmin ]; then
    wlog "Virtualmin already installed"
    ./start_virtualmin.sh
else
    ./install_virtualmin.sh &
fi

# Esperar que todos os processos em segundo plano terminem
wait

# Remover os timers do systemd
remove_systemd_timers
