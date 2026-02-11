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

setopt prompt_subst
setopt autopushd
setopt auto_cd
export KEYTIMEOUT=1

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export BAT_THEME="Nord"

ZLE_RPROMPT_INDENT=0

alias vim=nvim

# Vim mode
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh

ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# Initialize starship inside zvm_after_init so zsh-vi-mode doesn't clobber it
function zvm_after_init() {
	if command -v starship > /dev/null 2>&1; then
		eval "$(starship init zsh)"
	else
		PROMPT='%B%F{cyan}%n %F{default}%~ %F{cyan}$%f%b '
	fi
}

# Update vi mode indicator for starship's env_var modules
# STARSHIP_VI_INSERT (cyan) is set for insert mode, STARSHIP_VI_OTHER (white) for everything else
# Only one is non-empty at a time so only one renders
export STARSHIP_VI_INSERT='I'
export STARSHIP_VI_OTHER=''
function zvm_after_select_vi_mode() {
	STARSHIP_VI_INSERT=''
	STARSHIP_VI_OTHER=''
	case $ZVM_MODE in
		$ZVM_MODE_INSERT)
			STARSHIP_VI_INSERT='I'
		;;
		$ZVM_MODE_NORMAL)
			STARSHIP_VI_OTHER='N'
		;;
		$ZVM_MODE_VISUAL)
			STARSHIP_VI_OTHER='V'
		;;
		$ZVM_MODE_VISUAL_LINE)
			STARSHIP_VI_OTHER='VL'
		;;
		$ZVM_MODE_REPLACE)
			STARSHIP_VI_OTHER='R'
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
