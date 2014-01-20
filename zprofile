#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Conditional rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi # rbenv
