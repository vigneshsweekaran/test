FROM node:14.15-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ARG environment=dev

RUN if [[ "$environment" == "dev" || "$environment" == "staging" ]] ; then mv .env-dev .env ; elif [[ "$environment" == "main" ]]; then mv .env-prod .env ; fi

EXPOSE 3000

CMD ["npm", "start"]
