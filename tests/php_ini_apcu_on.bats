#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php_ini_apcu_on.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d --allow-insecure-ssl

  sleep 10
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php: ini: apcu: on" {
  run docker exec "$(container)" /bin/su - root -lc "php -m | grep 'apcu'"

  [ "${status}" -eq 0 ]
}