#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='subl'
export VISUAL='subl'
export PAGER='less'
export BUNDLER_EDITOR='subl'

#
# Language
#

if [[ -z "$LANG" ]]; then
  eval "$(locale)"
fi

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Paths
#

typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that info searches for manuals.
infopath=(
  /usr/local/share/info
  /usr/share/info
  $infopath
)

# Set the list of directories that man searches for manuals.
manpath=(
  /usr/local/share/man
  /usr/share/man
  $manpath
)

for path_file in /etc/manpaths.d/*(.N); do
  manpath+=($(<$path_file))
done
unset path_file

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  $path
)

for path_file in /etc/paths.d/*(.N); do
  path+=($(<$path_file))
done
unset path_file

#
# Temporary Files
#

if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

#
# Amazon EC2 settings
# 
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export AWS_AUTO_SCALING_HOME="/usr/local/Library/LinkedKegs/auto-scaling/jars"
export AWS_CLOUDWATCH_HOME="/usr/local/Library/LinkedKegs/cloud-watch/jars"
export SERVICE_HOME="$AWS_CLOUDWATCH_HOME"

#export AWS_CLOUDWATCH_URL=https://monitoring.us-west-2.amazonaws.com
#export AWS_AUTO_SCALING_URL=https://autoscaling.us-west-2.amazonaws.com
#export EC2_URL=https://us-west-2.ec2.amazonaws.com

#
# Other
#
export NODE_PATH=/usr/local/lib/node
path+=/usr/local/heroku/bin
