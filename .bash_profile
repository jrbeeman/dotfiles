#
# .bash_profile
#
# See also https://github.com/geerlingguy/dotfiles/ for reference on much of
# this configuration.
#
# @author Jeff Beeman
#

# Setup various environment variables.
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.composer/vendor/bin:$PATH"

# Add Dev Desktop settings and paths.
# Does not add Dev Desktop's PHP path; PHP is installed via Homebrew.
export DD_PHP_ID="php7_1"
export PHP_ID=$DD_PHP_ID
export DRUSH_PHP="/Applications/DevDesktop/$DD_PHP_ID/bin/php"
export MYSQL_PATH="/Applications/DevDesktop/mysql/bin"
export DEVDESKTOP_DRUPAL_SETTINGS_DIR="$HOME/.acquia/DevDesktop/DrupalSettings"
export PATH="$PATH:$MYSQL_PATH"
export PATH="$PATH:/Applications/DevDesktop/tools"


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

# Restart core audio
alias restart-audio='sudo killall coreaudiod'

# Setup thefuck.
eval $(thefuck --alias)

# Reload Bash profile.
function rebash() {
  source ~/.bash_profile
}

# Homestead wrapper
function homestead() {
  ( cd ~/Homestead && vagrant $* )
}

# BLT wrapper.
function blt() {
  if [[ ! -z ${AH_SITE_ENVIRONMENT} ]]; then
    PROJECT_ROOT="/var/www/html/${AH_SITE_GROUP}.${AH_SITE_ENVIRONMENT}"
  elif [ "`git rev-parse --show-cdup 2> /dev/null`" != "" ]; then
    PROJECT_ROOT=$(git rev-parse --show-cdup)
  else
    PROJECT_ROOT="."
  fi

  if [ -f "$GIT_ROOT/vendor/bin/blt" ]; then
    $GIT_ROOT/vendor/bin/blt "$@"

  # Check for local BLT.
  elif [ -f "./vendor/bin/blt" ]; then
    ./vendor/bin/blt "$@"

  else
    echo "You must run this command from within a BLT-generated project."
    return 1
  fi
}


# Utility for managing updates to Homebrew, Node, NPM, Composer.
function update-package-managers() {
  echo "----------------------------------------------"
  echo "Updating Homebrew"
  echo "----------------------------------------------"
  brew update
  brew upgrade
  brew cleanup
  echo "----------------------------------------------"
  echo "Updating Node and NPM global packages"
  echo "----------------------------------------------"
  n lts
  npm --global update
  echo "----------------------------------------------"
  echo "Updating Composer and global packages"
  echo "----------------------------------------------"
  composer self-update
  composer global update
  echo "----------------------------------------------"
  echo "Done!"
  echo "----------------------------------------------"
}

# Fix permissions in /usr/local
function fix-usr-permissions() {
  sudo chown -R $(whoami) /usr/local
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

source /usr/local/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_UNTRACKEDFILES=true
# Prompt output looks like:
#     [current path]
#     [date] [git status] $
PROMPT_COMMAND='__git_ps1 "\[\e[0;31m\]\w\n\[\e[0;2m\][\D{%F %T}]\[\e[m\]\[\e[0;32m\]" "\[\e[m\] $ "'
