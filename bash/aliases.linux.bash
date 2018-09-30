# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Upgrade chefdk
alias upgrade_chefdk="curl -L https://www.chef.io/chef/install.sh | sudo -E bash -s -- -P chefdk"

# Automated way to increase workspace sizes
alias workspace-hsize="gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize"
alias workspace-vsize="gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize"

function lattice() {
    local command=$1
    local latticeDirectory="/home/shannon/opt/lattice-bundle-v0.6.0"
    local originalDirectory=$(pwd)
    case $command in
        status)    cd "${latticeDirectory}/vagrant/"
                   vagrant status
        ;;
        start)     cd "${latticeDirectory}/vagrant/"
                   vagrant up
        ;;
        stop)      cd "${latticeDirectory}/vagrant/"
                   vagrant destroy --force
        ;;
        restart)   cd "${latticeDirectory}/vagrant/"
                   vagrant destroy --force
                   vagrant up
        ;;
        fixpath)   if [ "$(which ltc)" != "" ]; then
                       echo "ltc is already configured."
                   else 
                       export PATH=~/opt/ltc/:$PATH
                   fi
        ;;
        *)         echo "Usage: lattice (status|start|stop|restart|fixpath|upgrade)"
                   return 1
        ;;
    esac
    cd $originalDirectory
}