#!/usr/bin/env bash
#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}
# The list of remotes
function current_repository() {
  if ! $_omb_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omb_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias gst='git status'
alias gci='git commit -m'
alias gd='git diff'
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcod='git checkout develop'

alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gcount='git shortlog -sn'

alias gcf='git config --list'
alias gignore='git update-index --assume-unchanged'

alias gsta='git stash'
alias gm='git merge'
alias grb='git rebase'
alias gf='git fetch'

alias gl='git pull'
alias gp='git push'
