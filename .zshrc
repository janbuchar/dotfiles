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
setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
#setopt correctall # spelling correction for arguments
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}

setopt prompt_subst
setopt autopushd
setopt auto_cd

# Prompt
if [ $EUID -ne 0 ]; then
	color="blue"
else
	color="red"
fi

if [ -n "$SSH_CLIENT" ]; then
        host="%F{white}@%F{$color}%m%f"
else
        host=""
fi

PROMPT="%B%(!.%F{red}.%F{$color})%n%F{red}$host %F{white}%~%F{$color} %(!.#.$)%f%b "

# Ctrl+arrow bindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

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

ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=39,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=39,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=39,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=39,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=39,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=39,bold

# Suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Accepting suggestions
bindkey "^ " autosuggest-execute
