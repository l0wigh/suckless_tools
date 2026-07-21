function fish_right_prompt
    if test -d .git
        set git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set git_status (git status --porcelain)

        # Set color for Git info to gray

        # Check if there are changes (modified files)
        if test (count $git_status) -gt 0
			set_color red  # Set color to gray (color 8)
		else
			set_color white  # Set color to gray (color 8)
		end

        echo -n $git_branch
        
        # Reset color back to normal after Git status
        set_color normal
        echo -n " "
    end
end
