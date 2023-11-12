all: build.prod up.prod
build.dev:
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev build
build.prod:
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod build
up.dev:
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev up
up.prod:
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up
down:
    docker-compose down
test:
    docker-compose --env-file .env.dev exec web rspec
bash.dev:
    docker-compose --env-file .env.dev exec web sh
bash.prod:
    docker-compose --env-file .env.prod exec web sh
dev: build.dev up.dev