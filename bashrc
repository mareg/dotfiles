# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git\:\1) /'
}

function git_unadded_new {
	if git rev-parse --is-inside-work-tree &> /dev/null
	then
		if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]
		then
			echo ""
		else
			echo "a "
		fi
	fi
}

function git_needs_commit {
	if [[ "git rev-parse --is-inside-work-tree &> /dev/null)" != 'true' ]] && git rev-parse --quiet --verify HEAD &> /dev/null
	then
		# Default: off - these are potentially expensive on big repositories
		git diff-index --cached --quiet --ignore-submodules HEAD 2> /dev/null
		(( $? && $? != 128 )) && echo "c "
	fi
}

function git_modified_files {
        if [[ "git rev-parse --is-inside-work-tree &> /dev/null)" != 'true' ]] && git rev-parse --quiet --verify HEAD &> /dev/null
        then
                # Default: off - these are potentially expensive on big repositories
                git diff --no-ext-diff --ignore-submodules --quiet --exit-code || echo "m "
        fi
}

if [ `id -u` = 0 ]; then
	COLOUR="04;01;31m"
	PATH_COLOUR="01;31m"
	TIME_COLOUR="0;31m"
else
	COLOUR="04;01;38;32m"
	PATH_COLOUR="01;34m"
	TIME_COLOUR="38;5;156m"
fi

BOLD_RED="01;31m"
BOLD_GREEN="01;32m"
BOLD_BLUE="01;34m"

# User specific aliases and functions
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]\\$ '

PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\] $(parse_git_branch)\[\033[00m\]\[\033[$BOLD_RED\]$(git_unadded_new)\[\033[00m\]\[\033[$BOLD_GREEN\]$(git_needs_commit)\[\033[00m\]\[\033[$BOLD_BLUE\]$(git_modified_files)\[\033[00m\]\\$ '

alias phpunit='phpunit --colors'
alias pa='app/console'
