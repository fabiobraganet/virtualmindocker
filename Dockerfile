# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Atualizar pacotes e instalar dependências
RUN apt-get update && apt-get install -y wget curl vim systemd iproute2 inotify-tools

# Definir o sinal de parada para o systemd
STOPSIGNAL SIGRTMIN+3

# Definir a variável de ambiente TERM
ENV TERM xterm

# Copiar o script de inicialização
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Definir ponto de entrada
ENTRYPOINT ["/usr/local/bin/startup.sh"]
