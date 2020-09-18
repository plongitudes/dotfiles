# vim:ft=zsh ts=2 sw=2 sts=2

rbenv_version() {
  rbenv version 2>/dev/null | awk '{print $1}'
}

PROMPT='%{$FG[248]%}%m%{$reset_color%} %{$FG[011]%}[%*]%{$reset_color%} %{$FG[148]%}%~%{$reset_color%}$(git_prompt_info) %{$FG[007]%}[%h]%{$reset_color%} %{$FG[226]%}>%{$reset_color%} '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

