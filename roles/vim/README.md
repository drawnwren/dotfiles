Role Name
=========
Installs Vim and Neovim after detecting which OS the system is running. Symlinks .vimrc from ~/dotfiles/ to init.vim and .vimrc

Role Variables
--------------
Uses ansible\_env.HOME to determine where the home directory is.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - wren.vim

License
-------

BSD
