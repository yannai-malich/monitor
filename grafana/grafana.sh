#!/bin/bash
docker_name="grafana"
con(){
    echo -e "\nPress any key to continue.\n"
    read c
}
first_run(){
    clear
    echo -e "The container $docker_name not exsit.\n1. Run a new $docker_name container.\n2. Remove $docker_name containers.\n0. EXIT.\n"
    read temp
    case $temp in
        1)
            sudo docker run -d -p 3000:3000 --name=grafana -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" grafana/grafana
            echo -e "\nThe ip adress: `ip add | grep enp0s8 | awk 'NR==2 {print $2}' | cut -d"/" -f1`:3000."
            con
            main
        ;;
        2)
            clear
            echo -e "Removing $docker_name container.\n"
            sudo docker image rm grafana/grafana
            con
            main
        ;;
        0)
            clear
            echo "Good bey"
            sleep 1
            clear
            exit
        ;;
        *)
            echo "1 or 0 only!"
            sleep 1
            first_run
        ;;
    esac
}
main(){
    clear
    if [ $(sudo docker ps -a | grep $docker_name | wc -l) -gt 0 ] ; then
        echo -e "The $docker_name container status is: $(sudo docker container inspect -f '{{.State.Status}}' $docker_name)"
    else
        first_run
    fi
    echo -e "Main menu:\n1. Restart the $docker_name container.\n2. stop $docker_name containers.\n3. Remove $docker_name containers.\n4. Remove $docker_name image.\n0. EXIT.\n"
    read temp
    case $temp in
        1)
            clear
            echo -e "Restarting $docker_name container.\n"
            sudo docker restart $docker_name &>/dev/null
            echo -e "\nThe ip adress: `ip add | grep enp0s8 | awk 'NR==2 {print $2}' | cut -d"/" -f1`:3000."
            con
            main
        ;;
        2)
            clear
            echo -e "Stoping $docker_name container.\n"
            sudo docker container stop $docker_name &>/dev/null
            con
            main
        ;;
        3)
            clear
            echo -e "Removing $docker_name container.\n"
            sudo docker container rm -f $docker_name &>/dev/null
            con
            main
        ;;
        0)
            clear
            echo "Good bey"
            sleep 1
            clear
            exit
        ;;
        *)
            echo "1-4 or 0 only!"
            sleep 1
            main
        ;;
    esac 
}
main