# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
set -o vi
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
#export LC_ALL="en_US"
export QUOTING_STYLE=literal
export LC_ALL="es_MX.utf8"
alias ls='ls --color=auto'                              # long list
alias ll='ls -l --color=auto'                              # long list
alias Emacs='emacs-nox'

function find_aix()
{
	ops1="dv|ut|st|mo|pr"
    if [[ $1 =~ ^($ops1)$ && -n $2 ]]; then
#		ssh -q aix find /Pathfinder/$1 -name "*$2*"|grep -v '.bak\|tmp'
		ssh2 XertixAIX find /Pathfinder/$1 -name "*$2*"|grep -v '.bak\|tmp'
	else
		echo "faix = Busca elemento en el ambiente($ops1) especificado"
		echo "Uso: faix {$ops1} {elemento}"
	fi
}

function dirs_aix()
{
	ops1="dv|ut|pr"
	ops2="presentation|server|webservices"
    if [[ $1 =~ ^($ops1)$ && $2 =~ ^($ops2)$ ]]; then
#       ssh -q aix find /Pathfinder/$1/$2 -type d |grep -v '.bak\|french\|japanese\|logs\|work\|Utility'
        ssh2 XertixAIX find /Pathfinder/$1/$2 -type d |grep -v '.bak\|french\|japanese\|logs\|work\|Utility'
    else
		echo "daix = Lista los directorios dentro de /Pathfinder/($ops1)/($ops2)"
        echo "Uso: daix {$ops1} {$ops2}"
    fi
}

function ls_l_aix()
{
	if [[ -n $1 ]]; then
#	    ssh -q aix ls -l $1
	    ssh2 XertixAIX ls -l $1
	else
		echo "laix = Ejecuta 'ls -l elemento'"
		echo "Uso: laix {elemento}"
	fi
}

function grep_aix()
{
	if [[ $# -ne 2 ]]; then
		echo "gaix = Ejecuta 'grep cadena elemento'"
		echo "Uso: gaix {cadena} {elemento}"
	else
#	    ssh -q aix grep $1 $2
	    ssh2 XertixAIX grep $1 $2
	fi
}

function calls_prog()
{
	echo $1
	cat $1|grep "^.\{6\}\ \+\(CALL\ '*[A-Z0-9-]\+'*\ \+\|MOVE\ \+'[A-Z0-9]*'\ \+TO\ \+WPGWS-CALL-PGM-ID\)"|sed -e 's/^[0-9A-Z\/]\+//g' -e 's/\(MOVE\|\ CALL\ \)//g' -e 's/^\ \+//g' -e "s/'//g"|cut -d' ' -f1|grep -v 'WPGWS-CALL-PGM-ID\|ILBOABN0\|WTIMR-TIMER-PROGRAM'|sort|uniq|grep -v 'CSI\|XSD\|SSD\|FSD'
}

function copys_prog()
{
	echo $1
	grep '^.\{6\}\ \+COPY\ [A-Z0-9]\+\.' $1|sed -e 's/^[A-Z0-9]\+//g' -e 's/^\ \+//g' -e 's/COPY\ //g'|grep -v 'CSI\|XSD\|SSD\|FSD\|XC\|SQL'|grep '^..PL'
}

function uso_ambiente
{
	echo "Uso: ambiente [ |DV|DVX|UT|UTB|ST|MO|PR|CPR]"
}

function ambiente()
{
	if [[ $# -eq 0 ]]; then
		uso_ambiente
		echo "ambiente = $AMB"
	else
		if [[ $# -eq 1 ]]; then
			if [[ $1 =~ ^(DV|DVX|UT|UTB|ST|MO|PR|CPR)$ ]]; then
				export AMB=$1
				echo "ok, ambiente = $AMB"
			else
				uso_ambiente
			fi
		else
			uso_ambiente
		fi
	fi
}

function uso_ftp
{
	echo "Uso: ftp400 xertix|antara"
}

function ftp400
{
	if [[ $# -eq 0 ]]; then
		uso_ftp
	else
		if [[ $# -eq 1 ]]; then
			if [[ $1 =~ ^(xertix|antara)$ ]]; then
				ip=$(grep $1 $HOME/.conexiones|cut -d$'\t' -f3)
				ftp -i $ip
			else
				uso_ftp
			fi
		else
			uso_ftp
		fi
	fi
}

strc=$(cat $HOME/scripts/data/struc.txt|sed -e "s|HOME|$HOME|g")
export STRUC=$strc
export -f ambiente

alias rm='rm -I'
alias daix=dirs_aix
alias faix=find_aix
alias laix=ls_l_aix
alias gaix=grep_aix
alias calls=calls_prog
alias copys=copys_prog
alias hf=headlessflow.sh
alias ff='find . -type f'
alias ffp='find presentation -type f'
alias ffs='find server -type f'
alias ffw='find webservices -type f'
alias fd='find . -type d'
alias wos='ls -ldSrt [0-9][0-9][0-9][0-9]'
#export aix="scp://aix/"
export aix="scp2://XertixAIX/"

eval `dircolors -b /etc/DIR_COLORS`
#export PATH=$PATH:./:/home/xm731011:/home/xm731011/WO
#export PATH=$PATH:./:/home/xm731011:/home/xm731011/sources/scripts/cli
export PATH=$PATH:./:/home/xm731011/scripts
export PATH=$PYTHONHOME:$PATH:/cygdrive/c/Program\ Files/Firebird/Firebird_2_5/bin
export TERM=xterm
export AMB=DV
export USER=''
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func
