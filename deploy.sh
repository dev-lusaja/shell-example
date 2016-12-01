#!/bin/bash
usage() { 
echo "Usage: $0 [-s <path>] [-f <file_name> **optional] [-a <up|stop|restart|build>] [-d <daemon mode> **only up] [-i <service_name>]  [-c <no cache> **only build]" 1>&2; exit 1; 
}

reload_balancer() {
	cd /usr/local/opt/load-balancer
	docker-compose stop
	docker-compose rm -f
	docker-compose up -d
}

verify_parameters() {
	if [ -z "${source}" ] || [ -z "${action}" ]; then
    		usage
	fi
}

reload_service() {
	cd ${source}

	command="docker-compose -f ${file} ${action} ${daemon} ${service} ${nocache}"
	echo "Execute the command: ${command}"
	$command

	if [ ${action} == "up" ] || [ ${action} == "restart" ]; then
        	reload_balancer
	fi
}

while getopts ":s:f:a:d:c:i:b:" o; do
    case "${o}" in
        s)
            source=${OPTARG}
            ;;
        f)
            if [ -z "${OPTARG}" ]; then
	        file="docker-compose.yml"
	    else
		file=${OPTARG}
	    fi
            ;;
        a)
            action=${OPTARG}
            ;;
	d)
	    if [ -z "${OPTARG}" ]; then
	    	daemon="-d"
	    fi
	    ;;
	c)
	    if [ -z "${OPTARG}"]; then
		nocache="--no-cache"
	    fi
	    ;;
	i)
	    service=${OPTARG}
	    ;;
    esac
done
shift $((OPTIND-1))

verify_parameters

echo "Start proccess"

reload_service
 
echo "End process."
