set fish_greeting

function man
	command env LESS_TERMCAP_mb=(set_color normal) \
	LESS_TERMCAP_md=(set_color -o cyan) \
	LESS_TERMCAP_me=(set_color normal) \
	LESS_TERMCAP_se=(set_color normal) \
	LESS_TERMCAP_so=(set_color white) \
	LESS_TERMCAP_ue=(set_color normal) \
	LESS_TERMCAP_us=(set_color -u white) \
	man "$argv"
end

