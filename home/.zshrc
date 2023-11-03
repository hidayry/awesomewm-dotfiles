#export BAT_THEME="Dracula"
#. "$HOME/.cargo/env"
export FZF_BASE="/usr/bin/fzf"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export ZSH="$HOME/.oh-my-zsh"

#if [ -d "$HOME/.local/bin" ] ;
#then PATH="$HOME/.local/bin:$PATH"
#fi

#load compinit
autoload -Uz compinit
for dump in ~/.zcompdump-Pacman-Linux-5.9(N.mh+24); do
    compinit -d ~/.zcompdump-Pacman-Linux-5.9
done
compinit -C -d ~/.zcompdump-Pacman-Linux-5.9

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

#waiting dots
expand-or-complete-with-dots() {
    echo -n "\e[31m…\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#history
#HISTFILE=~/.config/zsh/zhistory
#HISTSIZE=5000
#SAVEHIST=5000

#zsh option
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt HIST_IGNORE_DUPS	   # Do not write events to history that are duplicates of previous events
setopt HIST_FIND_NO_DUPS   # When searching history don't display results already cycled through twice
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
stty start undef
stty stop undef
setopt noflowcontrol

#prompt
function dir_icon {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%B%F{blue}%f%b"
    else
        echo "%B%F{cyan}%f%b"
    fi
}
PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green} .%F{red} )%f%b '

#plugin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#bindkey '^A' history-substring-search-up
#bindkey '^B' history-substring-search-down

#terminal title
function xterm_title_precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
    [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (kitty*|alacritty*|termite*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*|kgx*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

plugins=(git fzf cp sudo colored-man-pages command-not-found dirhistory)

source $ZSH/oh-my-zsh.sh

##alias
#pacman
alias mirrors="sudo reflector -c ID,SG -l 7 -f 7 -p https --sort rate --save /etc/pacman.d/mirrorlist"
alias init="sudo mkinitcpio -P linux-lts"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias clean="yay -Scc && sudo pacman -Scc"
alias autoremove="sudo pacman -R $(pacman -Qdtq)"
alias update="yay -Syu"
#music&video
alias music="ncmpcpp"
alias youtube="ytfzf -f -t -T sixel search_pattern"
alias download="ytfzf -d -f"
alias ytmusic="ytfzf --audio-only search_pattern"
alias downloadmp3="yt-dlp --extract-audio --audio-format mp3 --audio-quality 0"
#other
alias tree='eza -a --tree --color always --icons --group-directories-first'
alias treell='eza -a -l -b --tree --color always --icons --group-directories-first'
alias ls='eza -a --color always --icons --group-directories-first'
alias ll='eza -a -l -b --color always --icons --group-directories-first'
alias cat="bat"
alias mem="echo tami | sudo -S ps_mem"
