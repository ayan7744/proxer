#!/bin/bash
# Script to set system-wide proxy in arch or arch based distributions

# read NUMth line from filename: sed "${NUM}q;d" filename
# get bssid of current network: nmcli -f IN-USE,BSSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'

# if IS_PROXY_SET env var doesn't exist, then export it.
[ -z "$IS_PROXY_SET" ] && export IS_PROXY_SET=0


# set configuration directory
if [ -z "$XDG_CONFIG_HOME" ]; then
    configDir="$HOME/.config/proxer/"
else 
    configDir="$XDG_CONFIG_HOME/proxer/"
fi

main() {
    for sh in $configDir; do source "$sh"; done
    source "$configFile"
    conSsid="$(nmcli -t -f NAME connection show --active)"
    # conBssid="$(nmcli -f IN-USE,BSSID device wifi | awk '/^\*/{if (NR!=1) {print $2}})"
    for ((i=0 ; i++)); do
        # fix the following line to take, problems when empty ssid
        [ -z ${con[$i,id]} ] && break 
        if [ "${con[$i,id]}" = "$conSsid" ]
            set_all_proxy "${con[$i,host]}" "${con[$i,port]}" "${con[$i,username]}" "${con[$i,password]}"
            break
        fi
    done
}

check_su() {
    if [ `id -u` -ne 0 ]; then 
        echo "Must be run with root privileges. Exiting..."
        exit 1
    fi
}

_exit() {
    echo "proxer: invalid option"
    echo "Usage: proxer -h [PROXY HOST] -p [PROXY PORT]"
    echo "Try 'proxer --help' for more information."
    exit 1
}

# setting system wide proxy
# gsettings_proxy [ --set | --unset ] PROXY_HOST PROXY_PORT USERNAME PASSWORD
gsettings_proxy () {
    if [ "$1" = "--set" ]; then 
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy.http enabled true
        gsettings set org.gnome.system.proxy.http host "$2"
        gsettings set org.gnome.system.proxy.http port "$3"
        gsettings set org.gnome.system.proxy use-same-proxy true
        [ -z "$4" ] || gsettings set org.gnome.system.proxy.http authentication-user "$4"
        [ -z "$5" ] || gsettings set org.gnome.system.proxy.http authentication-password "$5"
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.1', 'localaddress','.localdomain.com', '::1', '10.*.*.*']"
    elif [ "$1" = "--unset" ]; then
        gsettings set org.gnome.system.proxy mode none
    else 
        exit 1
    fi 
}

# setting APT-conf proxy

## in /etc/apt/apt.conf.d/70debconf
# apt_proxy [ --set | --unset ] PROXY_HOST PROXY_PORT USERNAME PASSWORD
apt_proxy () {
}

# setting environment variables
# env_proxy [ --set | --unset ] PROXY_SERVER
env_proxy () { 
    if [ "$1" = "--set" ]; then 
        export http_proxy="$2"
        export HTTP_PROXY="$http_proxy"
        export https_proxy="$http_proxy"
        export HTTPS_PROXY="$http_proxy"
        export ftp_proxy="$http_proxy"
        export FTP_PROXY="$http_proxy"
        export rsync_proxy="$http_proxy"
        export RSYNC_PROXY="$http_proxy"
        export all_proxy="$http_proxy"
        export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    elif [ "$1" = "--unset" ]; then
        unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY rsync_proxy RSYNC_PROXY all_proxy no_proxy
    else 
        exit 1
    fi 
}

# manage git proxy
# git_proxy [ --set | --unset ] PROXY_SERVER
git_proxy () {
    if [ "$1" = "--set" ]; then 
        if hash git 2>/dev/null; then
          git config --global http.proxy "$2"
          git config --global https.proxy "$2"
        fi
    elif [ "$1" = "--unset" ]; then
        if hash git 2>/dev/null; then
          git config --global --unset http.proxy
          git config --global --unset https.proxy
        fi
    else 
        exit 1
    fi 
}

# set_all_proxy PROXY_HOST PROXY_PORT USERNAME PASSWORD
set_all_proxy() {
    [ "$IS_PROXY_SET" = "1" ] && return 0   
    # define proxyServer properly
    if [ -z "$3" ]; then 
        proxyServer="http://$1:$2/"
    elif [ -z "$4" ]; then 
        proxyServer="http://$3@$1:$2/"
    else 
        proxyServer="http://$3:$4@$1:$2/"
    fi
    gsettings_proxy --set "$1" "$2" "$3" "$4"
    git_proxy --set "$proxyServer"
    env_proxy --set "$proxyServer"
    export IS_PROXY_SET=1
}

unset_all_proxy() {
    [ "$IS_PROXY_SET" = "0" ] && return 0   
    gsettings_proxy --unset
    git_proxy --unset
    env_proxy --unset
    export IS_PROXY_SET=0
}

auto_proxy() {
    if [ "$connectedWifi" = "$ssid" ]
        set_proxy "$proxyServer"
    else
        unset_proxy
    fi
}

reset_proxy() {
    unset_all_proxy
}

if [ "$#" -eq 1 ]; then
  case $1 in    
    -u| --unset)    
      reset_proxy
      exit 0
      ;;
    *)          
      exit_with_usage 
      ;;
  esac
fi

if [ "$#" -eq 4 ]; then
  while [ "$1" != "" ]; do
    case $1 in
      -h| --host)
        shift
        PROXY_HOST=$1
        echo $PROXY_HOST
        shift
        case $1 in
          -p| --port)
            shift
            PROXY_PORT=$1
            echo $PROXY_PORT
            shift
            ;;
          *) 
            exit_with_usage 
            ;;
        esac
        ;;
      *) 
        exit_with_usage 
        ;;
    esac
  done
  else
    exit_with_usage
fi
