source $HOME/.profile

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*:approximate:*' max-errors 1 # limit to 1 error
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt histignorespace
setopt inc_append_history # Add commands as they are typed, do not wait until shell exit
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
#setopt correctall # spelling correction for arguments
bindkey -v
# End of lines configured by zsh-newuser-install

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}

setopt prompt_subst
setopt autopushd
setopt auto_cd
export KEYTIMEOUT=1

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export BAT_THEME="Nord"

# Prompt
source $HOME/.zsh/oh-my-zsh/plugins/shrink-path/shrink-path.plugin.zsh

if [ $EUID -ne 0 ]; then
	color="cyan"
else
	color="red"
fi

color2="black"

if [ -n "$SSH_CLIENT" ]; then
        host="%F{default}@%F{$color}%m%f"
else
        host=""
fi

if [ -n "$TMUX" ]; then
	_PROMPT='%B%F{default}$(shrink_path -l -t)%F{$color} %(!.#.$)%f%b '
else
	_PROMPT='%B%(!.%F{red}.%F{$color})%n%F{red}$host %F{default}$(shrink_path -l -t)%F{$color} %(!.#.$)%f%b '
fi

ZLE_RPROMPT_INDENT=0

function right-prompt {
	RPROMPT=""

	if which mise > /dev/null 2> /dev/null && which jq > /dev/null 2> /dev/null; then
		version_count=$(mise ls --current --json | jq --raw-output 'length')
		versions=$(mise ls --current --json | jq --raw-output 'to_entries | map("\(.key): \(.value[0].requested_version)") | join(", ")')
		if [ $version_count -gt 0 ]; then
			RPROMPT="%F{cyan}[$versions]"
		fi
	elif which pyenv > /dev/null 2> /dev/null; then
		if [ $( pyenv version-name ) != system ]; then
			RPROMPT="%F{cyan}[py: $( pyenv version-name )]"
		fi
	fi
}

precmd() { 
	PROMPT=$VI_INSERT$_PROMPT
	right-prompt
}

function zle-line-init zle-keymap-select {
	right-prompt
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

alias vim=nvim

# Vim mode
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh

VI_NORMAL="%B%F{$color2}[%F{default}N%F{$color2}]%b "
VI_INSERT="%B%F{$color2}[%F{$color}I%F{$color2}]%b "
VI_VISUAL="%B%F{$color2}[%F{$color}V%F{$color2}]%b "
VI_VISUAL_LINE="%B%F{$color2}[%F{$color}VL%F{$color2}]%b "
VI_REPLACE="%B%F{$color2}[%F{$color}R%F{$color2}]%b "

ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
PROMPT=$VI_INSERT$_PROMPT

function zvm_after_select_vi_mode() {
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL)
			PROMPT=$VI_NORMAL$_PROMPT
		;;
		$ZVM_MODE_INSERT)
			PROMPT=$VI_INSERT$_PROMPT
		;;
		$ZVM_MODE_VISUAL)
			PROMPT=$VI_VISUAL$_PROMPT
		;;
		$ZVM_MODE_VISUAL_LINE)
			PROMPT=$VI_VISUAL_LINE$_PROMPT
		;;
		$ZVM_MODE_REPLACE)
			PROMPT=$VI_REPLACE$_PROMPT
		;;
	esac
}

bindkey -M vicmd "gh" beginning-of-line
bindkey -M vicmd "gl" end-of-line

# Clear screen with "K"
bindkey -M vicmd "K" clear-screen

# Colorized manpages
man() {
        env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

# Create a directory and change into it
mkcd() {
	mkdir -p "$@"
	cd "$@"
}

# Syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

color_command=cyan
color_path=default
color_string=green
color_option=yellow
color_keyword=blue

ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=$color_keyword,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=$color_keyword,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=$color_command,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=$color_command,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=$color_command,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=$color_command,bold
ZSH_HIGHLIGHT_STYLES[path]=fg=$color_path
ZSH_HIGHLIGHT_STYLES[wildcard]=fg=$color_path,bold
ZSH_HIGHLIGHT_STYLES[globbing]=fg=$color_path,bold
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=$color_string
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=$color_string
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=$color_option
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=$color_option

# Auto-add matching braces
source ~/.zsh/zsh-autopair/autopair.zsh

# Suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Accepting suggestions
bindkey "^ " autosuggest-execute

# Start direnv
if which direnv > /dev/null 2>&1; then
	eval "$(direnv hook zsh)"
fi

# Start mise
if which mise > /dev/null 2>&1; then
	eval "$(mise activate zsh)"
fi
