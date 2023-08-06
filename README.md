# README

### Dependencies
Install `redis` for rails ActionCable.
You can use docker instance to run redis locally:
```
docker run --rm --name redis-ms -p 6379:6379 redis:6.2.12-alpine3.18
```

### Getting started

Setup application:

```
cd ms
bundle install
yarn install
touch .env
echo "GMAIL_EMAIL=<your email>\nGMAIL_PASSWORD=<your password>" > .env
rails db:create db:migrate
rails s
open http://localhost:3000/
```
