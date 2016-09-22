#
# .bash_profile
#
# See also https://github.com/geerlingguy/dotfiles/ for reference on much of
# this configuration.
#
# @author Jeff Beeman
#

# Custom $PATH with extra locations.
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# Setup various environment variables.
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
export PHP_ID="php5_6"
export PHP_PATH="/Applications/DevDesktop/$PHP_ID/bin"
export DRUSH_PHP="/Applications/DevDesktop/$PHP_ID/bin/php"
export DEVDESKTOP_DRUPAL_SETTINGS_DIR="$HOME/.acquia/DevDesktop/DrupalSettings"

# Path setup broken out for readability.
export PATH=$PHP_PATH:/usr/local/bin:~/bin:$PATH
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
export PATH="/Applications/DevDesktop/$PHP_ID/bin:/Applications/DevDesktop/mysql/bin:$PATH"
export PATH="$PATH:/Applications/DevDesktop/drush"

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.bash_aliases ]
then
  source ~/.bash_aliases
fi

# Include bashrc file (if present).
if [ -f ~/.bashrc ]
then
  source ~/.bashrc
fi

# Include Drush rc file (if present).
if [ -f ~/.drush_bashrc ] ; then
  . ~/.drush_bashrc
fi

#
# Aliases and shortcuts
#

# Flush DNS cache (See: http://support.apple.com/kb/ht5343).
alias flush-dns='sudo killall -HUP mDNSResponder'

function homestead() {
  ( cd ~/Homestead && vagrant $* )
}

function blt() {
  if [ "`git rev-parse --show-cdup 2> /dev/null`" != "" ]; then
    GIT_ROOT=$(git rev-parse --show-cdup)
  else
    GIT_ROOT="."
  fi

  if [ -f "$GIT_ROOT/vendor/bin/blt" ]; then
    $GIT_ROOT/vendor/bin/blt "$@"
  else
    echo "You must run this command from within a BLT-generated project repository."
  fi
}

# Turn on bash autocomplete.
brew_prefix=`brew --prefix`
if [ -f $brew_prefix/etc/bash_completion ]; then
  . $brew_prefix/etc/bash_completion
fi

#
# Terminal / Prompt / PS1 configuration.
#

# Use colors.
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export PS1="☀️ \D{%I:%M %p}:\w $ "
export GIT_PS1_SHOWDIRTYSTATE=true

if [ "\$(type -t __git_ps1)" ]; then
  PS1='\[\e[1;31m\]\w\[\e[m\]\[\e[0;32m\]\n$(__git_ps1 "(%s)")\[\e[m\]\$ '
fi

if [ "\$(type -t __git_ps1)" ] && [ "\$(type -t __drush_ps1)" ]; then
  PS1='\[\e[1;31m\]\w\[\e[m\]\[\e[0;32m\]\n$(__git_ps1 "(%s)")\[\e[m\] \[\e[1;34m\]$(__drush_ps1 "[%s]")\[\e[m\] $ '
fi

gitprompt='$(__git_ps1 "(%s)")'

# Override the default pwd display.
prompt_pwd() {
  local pwd_symbol="$"
  local pwd_length=30
  newPWD="${PWD/#$HOME/~}"
  [ ${#newPWD} -gt ${pwd_length} ] && newPWD=${newPWD:0:12}${pwd_symbol}${newPWD:${#newPWD}-15}
  echo $newPWD
}
