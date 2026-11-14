# ==========================================
#  🌿 VERDANT — Oh My Zsh theme
# ==========================================
#
# Options (to put in ~/.zshrc BEFORE the line `source $ZSH/oh-my-zsh.sh`):
#
#   VERDANT_LEAF=$''          # leaf shown in front of every command (Nerd Font)
#                                   #   ex: VERDANT_LEAF="🌿" if you have no Nerd Font
#   VERDANT_ARROW="↳"               # arrow that replaces the header of old prompts
#   VERDANT_TRANSIENT_PROMPT=true   # false = keep the full header on every old line
#   VERDANT_LS_ICONS=true           # false = keep the normal `ls`
#

: ${VERDANT_LEAF:=$''}
: ${VERDANT_ARROW:=↳}
: ${VERDANT_TRANSIENT_PROMPT:=true}
: ${VERDANT_LS_ICONS:=true}

function theme_precmd {
	# Restore the full prompt (the previous one has been shrunk to an arrow)
	PROMPT=$_VERDANT_PROMPT_FULL

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

# Full prompt: big header with a leaf in front of the user name.
# The leaf turns pink when the last command failed.
_VERDANT_PROMPT_FULL='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_RED$PR_ULCORNER$PR_HBAR%(?.$PR_GREEN.$PR_LIGHT_RED)${VERDANT_LEAF}$PR_RED<\
$PR_BLUE%(!.$PR_RED%SROOT%s.%n)$PR_MAGENTA@$PR_BLUE%M:$PR_GREEN%$PR_PWDLEN<...<%~$PR_CYAN$(git_prompt_info)$(ruby_prompt_info)\
$PR_RED>$PR_HBAR${(e)PR_FILLBAR}\

$PR_RED$PR_LLCORNER$PR_HBAR<\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$PR_LIGHT_BLUE%(!.$PR_RED.$PR_WHITE)%#$PR_RED>$PR_HBAR\
$PR_NO_COLOUR '

# Compact prompt: what old lines turn into once the command is sent.
_VERDANT_PROMPT_SHORT='$PR_RED${VERDANT_ARROW} $PR_GREEN${VERDANT_LEAF}$PR_NO_COLOUR '

PROMPT=$_VERDANT_PROMPT_FULL

# ==========================================
# TRANSIENT PROMPT
# (old prompts shrink to "↳ <leaf> command")
# ==========================================

function _verdant_transient_prompt {
	[[ $VERDANT_TRANSIENT_PROMPT == true ]] || return 0
	[[ $PROMPT == "$_VERDANT_PROMPT_SHORT" ]] && return 0
	PROMPT=$_VERDANT_PROMPT_SHORT
	zle .reset-prompt
	zle -R
}

if zmodload zsh/zle 2>/dev/null && autoload -Uz add-zle-hook-widget; then
	add-zle-hook-widget zle-line-finish _verdant_transient_prompt

	# Ctrl-C: shrink the abandoned line too (unless you already have a TRAPINT)
	if (( ! ${+functions[TRAPINT]} )) || [[ $functions[TRAPINT] == *_verdant_transient_prompt* ]]; then
		function TRAPINT {
			zle && _verdant_transient_prompt
			return $(( 128 + $1 ))
		}
	fi
fi

# ==========================================
# LS WITH ICONS
# (needs a Nerd Font in your terminal)
# ==========================================

zmodload -F zsh/stat b:zstat 2>/dev/null
zmodload zsh/datetime 2>/dev/null

typeset -gA _VLS_C
_VLS_C=(
	red     $'\e[38;2;242;167;195m'
	green   $'\e[38;2;168;220;197m'
	yellow  $'\e[38;2;245;214;165m'
	blue    $'\e[38;2;185;167;232m'
	magenta $'\e[38;2;217;160;213m'
	cyan    $'\e[38;2;168;216;232m'
	white   $'\e[38;2;245;234;240m'
	grey    $'\e[38;2;120;108;130m'
	lgrey   $'\e[38;2;155;145;165m'
	bold    $'\e[1m'
	reset   $'\e[0m'
)

# Special folders
typeset -gA _VLS_DIRS
_VLS_DIRS=(
	.git            $':red'
	.github         $':white'
	.config         $':blue'
	.vscode         $':blue'
	.oh-my-zsh      $':green'
	node_modules    $':green'
	Desktop         $':blue'
	Bureau          $':blue'
	Documents       $':blue'
	Downloads       $':cyan'
	Téléchargements $':cyan'
	Music           $':magenta'
	Musique         $':magenta'
	Pictures        $':magenta'
	Images          $':magenta'
	Videos          $':magenta'
	Vidéos          $':magenta'
	Public          $':cyan'
	Templates       $':yellow'
	Modèles         $':yellow'
	Github          $':white'
	GitHub          $':white'
	goinfre         $':yellow'
	sgoinfre        $':yellow'
)

# Special file names
typeset -gA _VLS_NAMES
_VLS_NAMES=(
	Makefile           $':red'
	makefile           $':red'
	GNUmakefile        $':red'
	CMakeLists.txt     $':red'
	Dockerfile         $':cyan'
	docker-compose.yml $':cyan'
	.gitignore         $':red'
	.gitmodules        $':red'
	.gitattributes     $':red'
	.gitconfig         $':red'
	.zshrc             $':green'
	.zprofile          $':green'
	.zsh_history       $':lgrey'
	.bashrc            $':green'
	.bash_profile      $':green'
	.bash_history      $':lgrey'
	.profile           $':green'
	.vimrc             $':green'
	.env               $':yellow'
	LICENSE            $':yellow'
	README             $':yellow'
	README.md          $':yellow'
	package.json       $':green'
)

# Extensions
typeset -gA _VLS_EXT
_VLS_EXT=(
	c     $':blue'     h     $':magenta'
	cpp   $':blue'     cc    $':blue'     hpp  $':magenta'
	py    $':yellow'   ipynb $':yellow'
	js    $':yellow'   ts    $':blue'
	html  $':red'      css   $':blue'     scss $':magenta'
	json  $':yellow'   xml   $':cyan'
	md    $':white'    txt   $':white'    log  $':lgrey'
	pdf   $':red'
	doc   $':blue'     docx  $':blue'
	xls   $':green'    xlsx  $':green'    csv  $':green'
	ppt   $':red'      pptx  $':red'
	png   $':magenta'  jpg   $':magenta'  jpeg $':magenta'
	gif   $':magenta'  svg   $':magenta'  webp $':magenta'
	bmp   $':magenta'  ico   $':magenta'
	mp4   $':magenta'  mkv   $':magenta'  mov  $':magenta'
	avi   $':magenta'  webm  $':magenta'
	mp3   $':cyan'     wav   $':cyan'     flac $':cyan'
	ogg   $':cyan'
	zip   $':red'      tar   $':red'      gz   $':red'
	tgz   $':red'      xz    $':red'      bz2  $':red'
	7z    $':red'      rar   $':red'
	deb   $':yellow'   rpm   $':yellow'   iso  $':yellow'
	sh    $':green'    bash  $':green'    zsh  $':green'
	fish  $':green'
	rs    $':red'      go    $':cyan'     java $':red'
	rb    $':red'      php   $':magenta'  lua  $':blue'
	swift $':red'      vim   $':green'
	yml   $':lgrey'    yaml  $':lgrey'    toml $':lgrey'
	ini   $':lgrey'    conf  $':lgrey'    cfg  $':lgrey'
	sql   $':yellow'   db    $':yellow'   sqlite $':yellow'
	lock  $':yellow'   key   $':yellow'   pem  $':yellow'
	o     $':grey'     a     $':grey'     so   $':grey'
	out   $':green'    exe   $':green'    bin  $':grey'
	ttf   $':white'    otf   $':white'
	woff  $':white'    woff2 $':white'
)

# Color flag of the system `ls` (GNU vs macOS), used for the fallback
if command ls --color=auto -d / >/dev/null 2>&1; then
	_VLS_LSCOLOR=--color=auto
else
	_VLS_LSCOLOR=-G
fi

# Pick icon + colors for one entry → _vls_icon, _vls_ic, _vls_nc
function _verdant_ls_style {
	local f=$1 name=$2 spec ext
	if [[ -L $f ]]; then
		if [[ -e $f ]]; then
			[[ -d $f ]] && spec=$':cyan' || spec=$':cyan'
			_vls_nc=$_VLS_C[cyan]
		else
			spec=$':red'
			_vls_nc=$_VLS_C[red]
		fi
	elif [[ -d $f ]]; then
		spec=${_VLS_DIRS[${name:t}]:-$':red'}
		_vls_nc=$_VLS_C[bold]$_VLS_C[red]
	else
		ext=${(L)name:e}
		spec=${_VLS_NAMES[${name:t}]}
		[[ -z $spec && -n $ext ]] && spec=${_VLS_EXT[$ext]}
		if [[ -x $f ]]; then
			: ${spec:=$':green'}
			_vls_nc=$_VLS_C[bold]$_VLS_C[green]
		else
			: ${spec:=$':white'}
			[[ ${name:t} == .* ]] && _vls_nc=$_VLS_C[lgrey] || _vls_nc=$_VLS_C[white]
		fi
	fi
	_vls_icon=${spec%%:*}
	_vls_ic=$_VLS_C[${spec##*:}]
}

# Multi-column output (like plain `ls`)
function _verdant_ls_grid {
	local -a cells widths colw
	local -i n i c r w total cols rows prevcols=0 term=${COLUMNS:-80} minw maxcols
	for (( i = 1; i <= ${#_vls_paths}; i++ )); do
		_verdant_ls_style "$_vls_paths[i]" "$_vls_names[i]"
		cells+=("$_vls_ic$_vls_icon $_vls_nc$_vls_names[i]$_VLS_C[reset]")
		widths+=( $(( ${(m)#_vls_names[i]} + 2 )) )
	done
	n=${#cells}
	(( n )) || return 0

	if (( one )); then
		print -rl -- $cells
		return 0
	fi

	minw=${${(n)widths}[1]}
	maxcols=$(( term / (minw + 2) ))
	(( maxcols < 1 )) && maxcols=1
	(( maxcols > n )) && maxcols=n

	# Find the smallest number of rows that fits in the terminal width
	for (( rows = (n + maxcols - 1) / maxcols; rows <= n; rows++ )); do
		cols=$(( (n + rows - 1) / rows ))
		(( cols == prevcols && rows < n )) && continue
		prevcols=cols
		colw=()
		total=0
		for (( c = 0; c < cols; c++ )); do
			w=0
			for (( r = 0; r < rows; r++ )); do
				i=$(( c * rows + r + 1 ))
				(( i > n )) && break
				(( widths[i] > w )) && w=widths[i]
			done
			colw+=( $w )
			(( total += w + (c < cols - 1 ? 2 : 0) ))
		done
		(( total <= term )) && break
	done
	(( rows > n )) && rows=n

	local line pad
	for (( r = 0; r < rows; r++ )); do
		line=
		for (( c = 0; c < cols; c++ )); do
			i=$(( c * rows + r + 1 ))
			(( i > n )) && break
			line+=$cells[i]
			if (( c < cols - 1 && (c + 1) * rows + r + 1 <= n )); then
				pad=$(( colw[c + 1] - widths[i] + 2 ))
				line+=${(l:pad:: :)}
			fi
		done
		print -r -- "$line"
	done
}

function _verdant_ls_hsize {
	local -F s=$1
	local -a u=(B K M G T P)
	local -i k=1
	if (( s < 1024 )); then
		REPLY=$1
		return
	fi
	while (( s >= 1024 && k < 6 )); do
		(( s /= 1024.0, k++ ))
	done
	if (( s < 10 )); then
		REPLY=$(printf '%.1f%s' $s $u[k])
	else
		REPLY=$(printf '%.0f%s' $s $u[k])
	fi
}

function _verdant_ls_mode {
	local m=$1 out= ch
	local -i k
	for (( k = 1; k <= ${#m}; k++ )); do
		ch=$m[k]
		case $ch in
			d)         out+=$_VLS_C[blue]$ch ;;
			l)         out+=$_VLS_C[cyan]$ch ;;
			r)         out+=$_VLS_C[yellow]$ch ;;
			w)         out+=$_VLS_C[red]$ch ;;
			[xsStT])   out+=$_VLS_C[green]$ch ;;
			-)         out+=$_VLS_C[grey]$ch ;;
			*)         out+=$_VLS_C[white]$ch ;;
		esac
	done
	REPLY=$out$_VLS_C[reset]
}

# Long output (`ls -l`, `ls -la`, `ls -lah`…)
function _verdant_ls_long {
	local -a modes links users groups sizes dates targets keep
	local -A st
	local -i i n=${#_vls_paths} blocks=0 wl=0 wu=0 wg=0 ws=0 wd=0 now=$EPOCHSECONDS mt
	local fmt d s
	for (( i = 1; i <= n; i++ )); do
		st=()
		zstat -L -s -F '%s' -H st -- "$_vls_paths[i]" 2>/dev/null || continue
		keep+=( $i )
		modes+=( "$st[mode]" )
		links+=( "$st[nlink]" )
		users+=( "$st[uid]" )
		groups+=( "$st[gid]" )
		if (( human )); then
			_verdant_ls_hsize $st[size]; sizes+=( "$REPLY" )
		else
			sizes+=( "$st[size]" )
		fi
		mt=$st[mtime]
		if (( now - mt < 15552000 && mt <= now + 3600 )); then
			fmt='%b %e %H:%M'
		else
			fmt='%b %e  %Y'
		fi
		strftime -s d "$fmt" $mt
		dates+=( "$d" )
		targets+=( "$st[link]" )
		(( blocks += st[blocks] ))
		(( ${#links[-1]} > wl )) && wl=${#links[-1]}
		(( ${#users[-1]} > wu )) && wu=${#users[-1]}
		(( ${#groups[-1]} > wg )) && wg=${#groups[-1]}
		(( ${#sizes[-1]} > ws )) && ws=${#sizes[-1]}
		(( ${#dates[-1]} > wd )) && wd=${#dates[-1]}
	done

	if (( is_dir )); then
		if (( human )); then
			_verdant_ls_hsize $(( blocks * 512 )); s=$REPLY
		else
			s=$(( (blocks + 1) / 2 ))
		fi
		print -r -- "$_VLS_C[lgrey]total $s$_VLS_C[reset]"
	fi

	local -i j
	local line
	for (( j = 1; j <= ${#keep}; j++ )); do
		i=$keep[j]
		_verdant_ls_mode "$modes[j]"
		line="$REPLY "
		line+="$_VLS_C[grey]${(l:wl:)links[j]} "
		line+="$_VLS_C[yellow]${(r:wu:)users[j]} ${(r:wg:)groups[j]} "
		line+="$_VLS_C[green]${(l:ws:)sizes[j]} "
		line+="$_VLS_C[cyan]${(r:wd:)dates[j]}$_VLS_C[reset] "
		_verdant_ls_style "$_vls_paths[i]" "$_vls_names[i]"
		line+="$_vls_ic$_vls_icon $_vls_nc$_vls_names[i]$_VLS_C[reset]"
		[[ -n $targets[j] ]] && line+=" $_VLS_C[grey]->$_VLS_C[reset] $_VLS_C[cyan]$targets[j]$_VLS_C[reset]"
		print -r -- "$line"
	done
}

function _verdant_ls_render {
	local -i is_dir=$1
	if (( long )); then
		_verdant_ls_long
	else
		_verdant_ls_grid
	fi
}

function _verdant_ls {
	emulate -L zsh
	setopt extended_glob

	local -a targets files dirs ent _vls_paths _vls_names
	local a flags t d
	local -i all=0 almost=0 one=0 long=0 human=0 opts_done=0 ret=0

	for a in "$@"; do
		if (( opts_done )) || [[ $a != -?* ]]; then
			targets+=("$a")
			continue
		fi
		case $a in
			--)                 opts_done=1 ;;
			--color*|--colour*) ;;
			--all)              all=1 ;;
			--almost-all)       almost=1 ;;
			--human-readable)   human=1 ;;
			--*)                command ls $_VLS_LSCOLOR "$@"; return ;;
			*)
				flags=${a#-}
				# Unknown option (-t, -R, -S…) → normal ls
				if [[ $flags != [aA1lh]## ]]; then
					command ls $_VLS_LSCOLOR "$@"
					return
				fi
				[[ $flags == *a* ]] && all=1
				[[ $flags == *A* ]] && almost=1
				[[ $flags == *1* ]] && one=1
				[[ $flags == *l* ]] && long=1
				[[ $flags == *h* ]] && human=1
				;;
		esac
	done

	(( ${#targets} )) || targets=(.)

	for t in $targets; do
		if [[ ! -e $t && ! -L $t ]]; then
			print -u2 -r -- "ls: cannot access '$t': No such file or directory"
			ret=2
		elif [[ -d $t ]] && { (( ! long )) || [[ ! -L $t ]] }; then
			dirs+=("$t")
		else
			files+=("$t")
		fi
	done

	if (( ${#files} )); then
		_vls_paths=( $files )
		_vls_names=( $files )
		_verdant_ls_render 0
	fi

	local -i first=$(( ${#files} == 0 )) multi=$(( ${#targets} > 1 ))
	for d in $dirs; do
		(( first )) || print
		first=0
		(( multi )) && print -r -- "$_VLS_C[bold]$_VLS_C[blue]${d}:$_VLS_C[reset]"
		if [[ ! -r $d || ! -x $d ]]; then
			print -u2 -r -- "ls: cannot open directory '$d': Permission denied"
			ret=2
			continue
		fi
		if (( all || almost )); then
			ent=( ${d%/}/*(ND) )
		else
			ent=( ${d%/}/*(N) )
		fi
		ent=( ${(oi)ent} )
		(( all )) && ent=( ${d%/}/. ${d%/}/.. $ent )
		_vls_paths=( $ent )
		_vls_names=( ${ent:t} )
		(( all )) && _vls_names[1,2]=( . .. )
		_verdant_ls_render 1
	done

	return ret
}

if [[ $VERDANT_LS_ICONS == true ]]; then
	unalias ls 2>/dev/null
	function ls {
		if [[ -t 1 ]]; then
			_verdant_ls "$@"
		else
			command ls "$@"   # pipes / redirections: untouched output
		fi
	}
fi
