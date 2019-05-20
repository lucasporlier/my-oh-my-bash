#!/usr/bin/env bash

# add a function path
fpath=($OSH/functions $fpath)

# Set OSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$OSH_CUSTOM" ]]; then
    OSH_CUSTOM="$OSH/custom"
fi

# Set OSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$OSH_CACHE_DIR" ]]; then
  OSH_CACHE_DIR="$OSH/cache"
fi

# Load all of the config files in ~/.oh-my-bash/lib that end in .sh
# TIP: Add files you don't want in git to .gitignore
for config_file in $OSH/lib/*.sh; do
  custom_config_file="${OSH_CUSTOM}/lib/${config_file:t}"
  [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
  source $config_file
done

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.sh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin in ${plugins[@]}; do
  if is_plugin $OSH_CUSTOM $plugin; then
    fpath=($OSH_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $OSH $plugin; then
    fpath=($OSH/plugins/$plugin $fpath)
  fi
done

is_completion() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/completions/$name/$name.completion.sh
}

# Add all defined completions to fpath. This must be done
# before running compinit.
for completion in ${completions[@]}; do
  if is_completion $OSH_CUSTOM $completion; then
    fpath=($OSH_CUSTOM/completions/$completion $fpath)
  elif is_completion $OSH $completion; then
    fpath=($OSH/completions/$completion $fpath)
  fi
done

# sets the SHORT hostname
SHORT_HOST=${HOST/.*/}

# Load all of the plugins that were defined in ~/.bashrc
for plugin in ${plugins[@]}; do
  if [ -f $OSH_CUSTOM/plugins/$plugin/$plugin.plugin.sh ]; then
    source $OSH_CUSTOM/plugins/$plugin/$plugin.plugin.sh
  elif [ -f $OSH/plugins/$plugin/$plugin.plugin.sh ]; then
    source $OSH/plugins/$plugin/$plugin.plugin.sh
  fi
done

# Load all of the completions that were defined in ~/.bashrc
for completion in ${completions[@]}; do
  if [ -f $OSH_CUSTOM/completions/$completion.completion.sh ]; then
    source $OSH_CUSTOM/completions/$completion.completion.sh
  elif [ -f $OSH/completions/$completion.completion.sh ]; then
    source $OSH/completions/$completion.completion.sh
  fi
done

# Load all of your custom configurations from custom/
for config_file in $OSH_CUSTOM/*.sh; do
  if [ -f $config_file ]; then
    source $config_file
  fi
done
unset config_file

# Load colors first so they can be use in base theme
source "${OSH}/themes/colours.theme.sh"
source "${OSH}/themes/base.theme.sh"

# Load the theme
if [ ! "$OSH_THEME" = ""  ]; then
  if [ -f "$OSH_CUSTOM/$OSH_THEME/$OSH_THEME.theme.sh" ]; then
    source "$OSH_CUSTOM/$OSH_THEME/$OSH_THEME.theme.sh"
  elif [ -f "$OSH_CUSTOM/themes/$OSH_THEME/$OSH_THEME.theme.sh" ]; then
    source "$OSH_CUSTOM/themes/$OSH_THEME/$OSH_THEME.theme.sh"
  elif [ -f "$OSH_CUSTOM/themes/$OSH_THEME/$OSH_THEME.base.sh" ]; then
    source "$OSH_CUSTOM/themes/$OSH_THEME/$OSH_THEME.base.sh"
  else
    # source "$OSH/themes/$OSH_THEME/$OSH_THEME.theme.sh"
    source "$OSH/themes/$OSH_THEME/$OSH_THEME.base.sh"
  fi
fi

if ! type_exists '__git_ps1' ; then
  source "$OSH/tools/git-prompt.sh"
fi

# Adding Support for other OSes
[ -s /usr/bin/gloobus-preview ] && PREVIEW="gloobus-preview" || 
[ -s /Applications/Preview.app ] && PREVIEW="/Applications/Preview.app" || PREVIEW="less"
