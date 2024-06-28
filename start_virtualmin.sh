#start_virtualmin.sh: Contém a lógica para iniciar o Virtualmin.
#!/bin/bash
source ./utils.sh

set_term
check_root
check_dependencies

# Função para iniciar o Virtualmin
start_virtualmin() {
    attempt=0
    max_attempts=5
    until [ $attempt -ge $max_attempts ]
    do
        if systemctl start webmin; then
            break
        fi
        attempt=$((attempt+1))
        sleep 5
    done

    if [ $attempt -ge $max_attempts ]; then
        wlog "O Virtualmin falhou mesmo depois de muitas tentativas de inicia-lo."
        exit 1
    fi
}

# Iniciar o Virtualmin
start_virtualmin

