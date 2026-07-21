function fish_prompt
	set saved_status $status
	set time $(date "+%T")
	set new_pwd (string replace -r "^$HOME" "~" (pwd))
	# set icons "󱄟" "󰑮" "" " " " " " " " " " " "" " " " " "" "" "󰠬" "󰢯" "󱝄" "󰘈" "󱢺" "󰔁" "󱌄" "󰐛" "󱌇" " " "󱝆" "󰓣" "󱅼" "󰗕" "󰗔" "󱄟" "󱆊" "󱖁" "󱦀" "󱇩" "󱌆" "󰢐" "󱌅"
	set icons "󱄟" "󰑮" "" "" "" "" "󰠬" "󰢯" "󱝄" "󰘈" "󰔁" "󱌄" "󰐛" "󱌇" "󱝆" "󰓣" "󱅼" "󰗕" "󰗔" "󱄟" "󱆊" "󱖁" "󱦀" "󱇩" "󱌆" "󰢐" "󱌅" ""
	set r_ic $icons[(math (random 1 (count $icons)))]

	set NOCOLOR '\033[0m'
	set GREEN '\033[1;96m'
	set ORANGE "\033[33m"
	set BLUE '\033[1;32m'
	set PURPLE '\033[1;35m'
	set YELLOW '\033[1;33m'
	set WHITE '\033[1;37m'
	set REAL_ORANGE "\033[38;2;215;135;95m"

	echo ""
	set partial_text "─( $time )─< $new_pwd >─< $r_ic $saved_status >  "
	set partial_length (string length $partial_text)
	set terminal_width (tput cols)
	set remaining_length (math $terminal_width - $partial_length)
	echo -en "$GREEN─( $PURPLE$time $GREEN)─< $ORANGE$new_pwd $GREEN>"
	echo -n -e "\033[K"  
	for i in (seq 1 $remaining_length)
		echo -n "─"
	end
	echo -en "─{$WHITE $r_ic $saved_status $GREEN}─"
	echo ""

	echo -ne $REAL_ORANGE$(uname -n) $BLUE
	echo -n 󰈑
	echo -ne \ $NOCOLOR
end
