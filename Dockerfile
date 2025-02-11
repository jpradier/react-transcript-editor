# Étape 1 : Utilisation d'une image Node officielle pour le build
FROM node:12-alpine AS build

# Installer les dépendances nécessaires pour node-gyp
RUN apk add --no-cache python2 make g++ bash

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de dépendances dans le conteneur
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du projet dans le conteneur
COPY . .

# Construire l'application Storybook
RUN npm run build:storybook

# Étape 2 : Serveur léger pour servir les fichiers statiques
FROM nginx:alpine AS serve

# Copier les fichiers construits depuis l'étape précédente
COPY --from=build /app/build /usr/share/nginx/html

# Exposer le port 80 pour accéder à l'application
EXPOSE 80

# Commande par défaut pour lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
