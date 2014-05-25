set fish_greeting

set fish_color_autosuggestion 666666
set fish_color_command '5FAFFF' '--bold'
set fish_color_param normal

function man
	command env LESS_TERMCAP_mb=(set_color normal) \
	LESS_TERMCAP_md=(set_color -o $fish_color_command) \
	LESS_TERMCAP_me=(set_color normal) \
	LESS_TERMCAP_se=(set_color normal) \
	LESS_TERMCAP_so=(set_color white) \
	LESS_TERMCAP_ue=(set_color normal) \
	LESS_TERMCAP_us=(set_color -u white) \
	man "$argv"
end

function fish_prompt
	echo -n (set_color -o blue)(whoami) \
	(set_color -o white)(prompt_pwd) \
	(set_color -o blue)\$ (set_color normal)
end
