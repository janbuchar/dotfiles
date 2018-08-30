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

# Start pyenv
if which pyenv > /dev/null 2> /dev/null; then
	export PYENV_VIRTUALENV_DISABLE_PROMPT=1
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# Prompt
source $HOME/.zsh/oh-my-zsh/plugins/shrink-path/shrink-path.plugin.zsh

if [ $EUID -ne 0 ]; then
	color="blue"
else
	color="red"
fi

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

VI_NORMAL="%B[%F{default}N%f]%b "
VI_INSERT="%B[%F{$color}I%f]%b "

ZLE_RPROMPT_INDENT=0

function right-prompt {
	if which pyenv > /dev/null 2> /dev/null; then
		if [ $( pyenv version-name ) != system ]; then
			venv_name=$(pyenv version-name)
		fi
	fi

	if which pipenv > /dev/null 2> /dev/null; then
		if [ -n "$PIPENV_ACTIVE" ]; then
			venv_name=$(basename $(pipenv --where))
		fi
	fi

	if [ -n "$venv_name" ]; then
		RPROMPT="%F{green}[py: $venv_name]"
	else
		RPROMPT=""
	fi
}

precmd() { 
	PROMPT=$VI_INSERT$_PROMPT
	right-prompt
}

function zle-line-init zle-keymap-select {
	PREFIX="${${KEYMAP/vicmd/$VI_NORMAL}/(main|viins)/$VI_INSERT}"
	PROMPT=$PREFIX$_PROMPT
	right-prompt
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

bindkey -M vicmd "H" beginning-of-line
bindkey -M vicmd "L" end-of-line

# Page Up/Down
bindkey "\033[5~" beginning-of-line
bindkey -M vicmd "\033[5~" beginning-of-line
bindkey "\033[6~" end-of-line
bindkey -M vicmd "\033[6~" end-of-line

# Ctrl+arrow bindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Home/End
bindkey "\033[1~" beginning-of-line
bindkey -M vicmd "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line
bindkey -M vicmd "\033[4~" end-of-line

# Delete
bindkey "\033[3~" delete-char
bindkey -M vicmd "\033[3~" delete-char

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

color_command=green
color_path=default
color_string=magenta
color_option=cyan
color_keyword=yellow

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
