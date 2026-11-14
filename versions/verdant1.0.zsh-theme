
function theme_precmd {
	PR_FILLBAR=""
	PR_PWDLEN=""

	local promptsize=${#${(%):--(%n@%M:)--(%l)-}}
	local pwdsize=${#${(%):-%~}}
	local gitbranchsize="${#${(%)$(git_prompt_info)}:-}"
	local rvmpromptsize="${#${(%)$(ruby_prompt_info):-}}"

	# Truncate the path if it's too long.
	if (( promptsize + pwdsize + rvmpromptsize + gitbranchsize > COLUMNS )); then
		(( PR_PWDLEN = COLUMNS - promptsize ))
	else
		PR_FILLBAR="\${(l.$(( COLUMNS - (promptsize + pwdsize + rvmpromptsize + gitbranchsize) ))..${PR_SPACE}.)}"
	fi
}

function theme_preexec {
	setopt local_options extended_glob

	if [[ "$TERM" == "screen" ]]; then
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -n "\ek$CMD\e\\"
	fi

	if [[ "$TERM" == "xterm" ]]; then
		print -Pn "\e]0;$1\a"
	fi

	if [[ "$TERM" == "rxvt" ]]; then
		print -Pn "\e]0;$1\a"
	fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
add-zsh-hook preexec theme_preexec

# Set the prompt
setopt prompt_subst

# Load terminal colors
autoload zsh/terminfo

# ==========================================
# DARK KAWAII / SAKURA COLOR PALETTE
# ==========================================

# ==========================================
# DARK KAWAII / SAKURA COLORS
# ==========================================

PR_RED="%{$(printf '\033[38;2;242;167;195m')%}"
PR_GREEN="%{$(printf '\033[38;2;168;220;197m')%}"
PR_YELLOW="%{$(printf '\033[38;2;245;214;165m')%}"
PR_BLUE="%{$(printf '\033[38;2;185;167;232m')%}"
PR_MAGENTA="%{$(printf '\033[38;2;217;160;213m')%}"
PR_CYAN="%{$(printf '\033[38;2;168;216;232m')%}"
PR_WHITE="%{$(printf '\033[38;2;245;234;240m')%}"
PR_GREY="%{$(printf '\033[38;2;120;108;130m')%}"

PR_LIGHT_RED="%{$(printf '\033[38;2;255;190;211m')%}"
PR_LIGHT_GREEN="%{$(printf '\033[38;2;190;235;211m')%}"
PR_LIGHT_YELLOW="%{$(printf '\033[38;2;255;228;185m')%}"
PR_LIGHT_BLUE="%{$(printf '\033[38;2;205;190;250m')%}"
PR_LIGHT_MAGENTA="%{$(printf '\033[38;2;235;185;225m')%}"
PR_LIGHT_CYAN="%{$(printf '\033[38;2;190;230;245m')%}"
PR_LIGHT_WHITE="%{$(printf '\033[38;2;255;245;250m')%}"
PR_LIGHT_GREY="%{$(printf '\033[38;2;155;145;165m')%}"

PR_NO_COLOUR="%{$(printf '\033[0m')%}"

# ==========================================
# PROMPT SYMBOLS
# ==========================================

PR_HBAR="─"
PR_ULCORNER="╭"
PR_LLCORNER="╰"
PR_LRCORNER="╯"
PR_URCORNER="╮"

# ==========================================
# GIT PROMPT
# ==========================================

ZSH_THEME_GIT_PROMPT_PREFIX=" ["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"

# ==========================================
# RVM PROMPT
# ==========================================

ZSH_THEME_RUBY_PROMPT_PREFIX=" ["
ZSH_THEME_RUBY_PROMPT_SUFFIX="]"

# ==========================================
# WINDOW TITLE
# ==========================================

case $TERM in
	xterm*|*rxvt*)
		PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%M:%~ $(git_prompt_info) $(ruby_prompt_info) | ${COLUMNS}x${LINES} | %y\a%}'
		;;
	screen)
		PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
		;;
	*)
		PR_TITLEBAR=""
		;;
esac

# ==========================================
# SCREEN TITLE
# ==========================================

if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
else
	PR_STITLE=""
fi

# ==========================================
# FINAL PROMPT
# ==========================================

PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_RED$PR_ULCORNER$PR_HBAR<\
$PR_BLUE%(!.$PR_RED%SROOT%s.%n)$PR_MAGENTA@$PR_BLUE%M:$PR_GREEN%$PR_PWDLEN<...<%~$PR_CYAN$(git_prompt_info)$(ruby_prompt_info)\
$PR_RED>$PR_HBAR${(e)PR_FILLBAR}\

$PR_RED$PR_LLCORNER$PR_HBAR<\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$PR_LIGHT_BLUE%(!.$PR_RED.$PR_WHITE)%#$PR_RED>$PR_HBAR\
$PR_NO_COLOUR '
