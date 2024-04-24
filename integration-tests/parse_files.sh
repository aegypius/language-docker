#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly CWD="$PWD"
readonly TESTS_DIR="integration-tests/Dockerfiles"
BLACKLIST=""

function git_clone() {
    local git_url="$1"
    git clone --quiet --depth 1 "$git_url"
}

function git_named_clone() {
    local git_url="$1"
    local dir="$2"
    git clone --quiet --depth 1 "$git_url" "$dir"
}

function clone_repos() {
    rm -rf "$TESTS_DIR" && mkdir -p "$TESTS_DIR" && cd "$TESTS_DIR"
    # offical docker images
    git_clone https://github.com/docker-library/ruby.git &
    git_clone https://github.com/docker-library/mariadb.git &
    git_clone https://github.com/docker-library/ghost.git &
    git_clone https://github.com/docker-library/redis.git &
    git_clone https://github.com/docker-library/python.git &
    git_clone https://github.com/docker-library/buildpack-deps.git &
    git_clone https://github.com/docker-library/postgres.git &
    git_clone https://github.com/docker-library/rabbitmq.git &
    git_clone https://github.com/docker-library/redmine.git &
    git_clone https://github.com/docker-library/mysql.git &
    git_clone https://github.com/docker-library/golang.git &
    git_clone https://github.com/docker-library/drupal.git &
    git_clone https://github.com/docker-library/haproxy.git &
    git_clone https://github.com/docker-library/elasticsearch.git &
    git_clone https://github.com/docker-library/kibana.git &
    git_clone https://github.com/docker-library/php.git &
    git_clone https://github.com/docker-library/mongo.git &
    git_clone https://github.com/docker-library/gcc.git &
    git_clone https://github.com/docker-library/httpd.git &
    git_clone https://github.com/docker-library/java.git &
    git_clone https://github.com/docker-library/wordpress.git &
    git_clone https://github.com/docker-library/tomcat.git &
    git_clone https://github.com/docker-library/logstash.git &
    git_clone https://github.com/docker-library/julia.git &
    git_clone https://github.com/docker-library/busybox.git &
    git_clone https://github.com/docker-library/percona.git &
    git_clone https://github.com/docker-library/django.git &
    git_clone https://github.com/docker-library/memcached.git &
    git_clone https://github.com/docker-library/docker.git &
    git_clone https://github.com/docker-library/rails.git &
    git_clone https://github.com/docker-library/pypy.git &
    git_clone https://github.com/docker-library/hello-world.git &
    git_clone https://github.com/docker-library/celery.git &
    git_clone https://github.com/nodejs/docker-node.git &
    git_clone https://github.com/nginxinc/docker-nginx.git &


    # popular Dockerfile repos
    git_clone https://github.com/wking/dockerfile.git &
    git_clone https://github.com/eugeneware/docker-wordpress-nginx.git &
    git_clone https://github.com/CentOS/CentOS-Dockerfiles.git &
    git_clone https://github.com/octohost/octohost.git &
    git_clone https://github.com/komljen/dockerfile-examples.git &
    git_clone https://github.com/tianon/dockerfiles.git &
    git_clone https://github.com/Netflix-Skunkworks/zerotodocker.git &
    git_clone https://github.com/amplab/docker-scripts.git &
    git_clone https://github.com/oracle/docker-images.git &
    git_clone https://github.com/dockerfile/ubuntu-desktop.git &
    git_clone https://github.com/yesnault/docker-phabricator.git &
    git_clone https://github.com/mattgruter/dockerfile-guacamole.git &
    git_clone https://github.com/uzyexe/dockerfile-terraform.git &
    git_clone https://github.com/mattgruter/dockerfile-doubledocker.git &
    git_clone https://github.com/mattgruter/dockerfile-drone.git &
    git_clone https://github.com/ArchiveTeam/warrior-dockerfile.git &
    git_clone https://github.com/wckr/wocker-dockerfile.git &
    git_clone https://github.com/kartoza/docker-postgis.git &
    git_clone https://github.com/andrericardo/docker-subtitleedit &

    # colliding names
    git_named_clone https://github.com/yaronr/dockerfile.git yaronr-dockerfile &
    git_named_clone https://github.com/seapy/dockerfiles.git seapy-dockerfiles &
    git_named_clone https://github.com/nickstenning/dockerfiles.git nickstenning-dockerfiles &
    git_named_clone https://github.com/crosbymichael/Dockerfiles.git crosbymichael-dockerfiles &
    git_named_clone https://github.com/codenvy/dockerfiles.git codenvy-dockerfiles &
    git_named_clone https://github.com/couchbase/docker.git couchbase-docker &
    git_named_clone https://github.com/EvaEngine/Dockerfiles.git evaengine-dockerfiles &
    git_named_clone https://github.com/yankcrime/dockerfiles.git yankcrime-dockerfiles &
    git_named_clone https://github.com/voxxit/dockerfiles.git voxxit-dockerfiles &
    git_named_clone https://github.com/mikz/dockerfiles.git mikz-dockerfiles &
    git_named_clone https://github.com/ksoichiro/dockerfiles.git ksoichiro-dockerfiles &
    git_named_clone https://github.com/jgautheron/dockerfiles.git jgautheron-dockerfiles &
    git_named_clone https://github.com/coderstephen/dockerfiles.git coderstephen-dockerfiles &
    git_named_clone https://github.com/ehazlett/dockerfiles.git ehazlett-dockerfiles &
    git_named_clone https://github.com/Evlos/dockerfile.git evlos-dockerfile &

    wait
}

function parse_dockerfiles() {
    local dockerfiles
    local result="true"
    stack ghc parseFile.hs --package language-docker
    dockerfiles=$(find . -name 'Dockerfile')
    for dockerfile in $dockerfiles; do
        if [[ "$BLACKLIST" == *$dockerfile* ]]; then
            continue;
        fi

        if ./parseFile "$dockerfile" > /dev/null; then
            echo "$dockerfile"
        else
            result="false"
        fi
    done
    if [[ ${result} == "false" ]]; then false; fi
}

function main() {
    clone_repos
    cd "${CWD}/integration-tests/"
    parse_dockerfiles
}

main
