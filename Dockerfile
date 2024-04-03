# /app
# FROM  --platform=linux/arm64 node:alpine3.16
# FROM --platform=$BUILDPLATFORM node:alpine3.16
#? Definimos la primera etapa
FROM node:alpine3.16 as deps

#! cd /app
WORKDIR /app

#! Copiamos los archivos necesarios
COPY package.json ./

#! Instalamos las dependencias
RUN npm install

#? Nueva etapa en nuestro multi-stage build
FROM node:alpine3.16 as builder

#! volvemos a definir el directorio de trabajo en este paso
WORKDIR /app

#! Copiamos los archivos necesarios
COPY --from=deps /app/node_modules ./node_modules

#! Copiamos los archivos necesarios
COPY . .

#! Realizart testing
RUN npm run test

#! Eliminar archivos y directorios no necesarios en PROD
RUN rm -rf tests && rm -rf node_modules

#! Instalamos las dependencias en producción
RUN npm install --prod

#? Definimos la última etapa llamada Runner
FROM node:alpine3.16 as runner

#! Trabajamos en el directorio /app
WORKDIR /app

COPY --from=builder /app .

#TODO Comando para ejecutar la aplicación
CMD [ "node", "app.js" ]