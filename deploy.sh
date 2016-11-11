#!/bin/bash
usage() { echo "Usage: $0 [-s <path>] [-f <file_name>] [-a <up|stop|restart>] [-d <daemon mode>]" 1>&2; exit 1; }

reload_balancer() {
	cd /usr/local/opt/load-balancer
	docker-compose stop
	docker-compose rm -f
	docker-compose up -d
}

while getopts ":s:f:a:d" o; do
    case "${o}" in
        s)
            source=${OPTARG}
            ;;
        f)
            file=${OPTARG}
            ;;
        a)
            action=${OPTARG}
            ;;
	d)
	    if [ -z "${OPTARG}" ]; then
	    	daemon='-d'
	    fi
	    ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${source}" ] || [ -z "${file}" ] || [ -z "${action}" ]; then
    usage
fi

cd ${source}
docker-compose -f ${file} ${action} ${daemon}

if [ ${action} == "up" ] || [ ${action} == "restart" ]; then
	reload_balancer
fi 
