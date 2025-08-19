FROM alpine:3.22

# Installe les dépendances nécessaires
RUN apk add --no-cache \
    nodejs \
    npm \
    oath-toolkit

# Crée un utilisateur dédié pour des raisons de sécurité
RUN adduser -D appuser
USER appuser
WORKDIR /home/appuser
COPY package.json .
RUN npm install
EXPOSE 3005
CMD ["tail", "-f", "/dev/null"]