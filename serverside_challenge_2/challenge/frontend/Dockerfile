FROM node:23-bookworm

WORKDIR /app

COPY . .

RUN yarn install
RUN yarn build

CMD ["yarn", "preview", "--host", "0.0.0.0", "--port", "5173"]
