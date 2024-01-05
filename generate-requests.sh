#!/usr/bin/env bash

args=$(getopt \
    -o d:l:m:p:r:s: \
    --long delay:,latency:,method:,path:,request-count:,status: \
    -n "$(basename $0)" \
    -- "$@")

if [ $? != 0 ] ; then
    # TODO: Write usage.
    exit 1
fi

random_u8() {
    min=0
    max="$(echo -n $'\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF' | od -t u8 -An)"
    if [ "$#" -gt 0 ]; then
        min="$1"
        if [ "$#" -gt 1 ]; then
            max="$2"
        fi
    fi
    range="$(echo "${max} - ${min}" | bc)"
    seed="$(head -c 8 < /dev/urandom | od -t u8 -An)"
    offset="$(echo "${seed} % ${range}" | bc)"
    echo "${min} + ${offset}" | bc
}

delay=0
declare -a latencies
declare -a methods
declare -a paths
request_count=1
declare -a statuses
url="http://localhost:8080"

while true; do
  case "$1" in
    -d | --delay ) delay="$2"; shift 2 ;;
    -l | --latency ) latencies+=("$2"); shift 2 ;;
    -m | --method ) methods+=("$2"); shift 2 ;;
    -p | --paths ) paths+=("$2"); shift 2 ;;
    -r | --request-count ) request_count="$2"; shift 2 ;;
    -s | --status ) statuses+=("$2"); shift 2 ;;
    -u | --url ) url="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ "${#latencies[@]}" = "0" ]; then
    latencies=(5 7 15)
fi

if [ "${#methods[@]}" = "0" ]; then
    methods=(GET)
fi

if [ "${#paths[@]}" = "0" ]; then
    paths=(foo bar baz)
fi

if [ "${#statuses[@]}" = "0" ]; then
    statuses=(200)
fi

latencies_count="${#latencies[@]}"
methods_count="${#methods[@]}"
paths_count="${#paths[@]}"
statuses_count="${#statuses[@]}"

for x in $(seq 1 ${request_count}); do

    latency=${latencies[$(random_u8 0 ${latencies_count})]}
    method=${methods[$(random_u8 0 ${methods_count})]}
    path=${paths[$(random_u8 0 ${paths_count})]}
    status=${statuses[$(random_u8 0 ${statuses_count})]}

    curl -H "X-ECHO-CODE: ${status}" -H "X-ECHO-TIME: ${latency}" -X $method "${url}/${path}"

    sleep ${delay}s
done
