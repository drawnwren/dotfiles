Dotfile repository. 

# Work in Progress
Rewriting to ansible roles, excuse the dust.

# Variables used
Generally, the local obj stores variables which must be specified and the role specific variable objects have sane defaults.

local = {
  user: "the username that will get all profile specific installs i.e. the correct node version aliased and appropriate .profile changes",
}

nvm = {
  version: "the version of nvm to install and alias, defaults to 0.33.2",
  node_version: "version of node to install, defaults to latest"
}
# To install: 
ansible-playbook -i "localhost," main.yml
