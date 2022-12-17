# Contribution Guidelines

## Dev Environment

The fastest way to get a dev environment up is to install this globally, via symlink:

```
sudo ln -s `pwd`/team.bash /usr/lib/password-store/extensions/team.bash 
```

Alternately, you avoid sudo with

```
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
ln -s `pwd`/team.bash ${PASSWORD_STORE_DIR:-~/.password-store}/.extensions/team.bash
```

but then you have to add that first line to your `~/.profile` or remember to run it every time you want to work on this.

Unfortunately there does not seem be be a middle ground where you can install to ~/.local/lib/password-store/extensions.
