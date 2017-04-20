# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Upgrade chefdk
alias upgrade_chefdk="curl -L https://www.chef.io/chef/install.sh | sudo -E bash -s -- -P chefdk"

# Automated way to increase workspace sizes
alias workspace-hsize="gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize"
alias workspace-vsize="gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize"
