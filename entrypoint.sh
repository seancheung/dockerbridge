#!/bin/bash
set -e

function config_nginx()
{
    proxy_exp=$1
    proxy_dir=$2
    proxy_temp=$3

    if [ -n "$proxy_exp" ]; then
        IFS=';'; entries=($proxy_exp); unset IFS;
        for entry  in "${entries[@]}"; do
            IFS=':'; sub=($entry); unset IFS;
            if [ ${#sub[@]} -eq 3 ]; then
                proxy_host=${sub[0]}
                proxy_port=${sub[1]}
                listen_port=${sub[2]}
            elif [ ${#sub[@]} -eq 2 ]; then
                proxy_host=${sub[0]}
                proxy_port=${sub[1]}
                listen_port=$proxy_port
            else
                echo "Invalid proxy entry in ${proxy_exp}"
                exit 1
            fi
            proxy_file="$proxy_dir/${proxy_host}_${proxy_port}_${listen_port}.conf"
            if [ ! -f "$proxy_file" ]; then
                echo "Create config $proxy_file"
                cat "$proxy_temp" | sed -e "s/proxy_host/$proxy_host/g" | sed -e "s/proxy_port/$proxy_port/g" | sed -e "s/listen_port/$listen_port/g" | tee "$proxy_file" > /dev/null
            fi
        done
    fi
}

if [ -n "$PROXY_STREAM" ]; then
    config_nginx "$PROXY_STREAM" "/etc/nginx/stream" "/etc/nginx/stream.conf"
fi

if [ -n "$PROXY_HTTP" ]; then
    config_nginx "$PROXY_HTTP" "/etc/nginx/http" "/etc/nginx/http.conf"
fi

exec "$@"