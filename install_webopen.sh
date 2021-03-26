#!/usr/bin/env fish

set -l userBin ~/bin
set -l execName "webopen"
set -l execScript $execName".sh"

function checkLink
	if not test -L /usr/local/bin/$execName
		if yesno "Create link in '/usr/local/bin' (sudo required) ?"
			sudo ln -s $userBin/$execName /usr/local/bin/$execName
		else
			echo "Link creation skipped."
		end
	end
end

if not test -d $userBin
	mkdir ~/bin
end

if not test -f "$userBin/$execName"
	echo "copy '$execName' to $userBin"
	cp $execScript ~/bin/$execName
	checkLink
else
	if not diff -y -q ./$execScript $userBin/$execName
		if yesno "Show differencies?"
			diff ./$execScript $userBin/$execName
		end
		if yesno "Do you want to create $execName?"
			cp ./$execScript $userBin/$execName
			echo "$execName copied."
			checkLink
		else
			echo "$execName skipped."
		end
	else
		echo "$execName is the latest."
	end
end






# echo "create link to file in '/usr/local/bin' folder as 'webopen'"
# if not test -L /usr/local/bin/webopen
# 	ln -s $userBin/webopen /usr/local/bin/webopen
# else
# 	rm /usr/local/bin/webopen
# 	ln -s $userBin/webopen /usr/local/bin/webopen
# end

# echo "upsert autocomplete file"
# if test -d $__fish_config_dir/functions
# 	cp ./completions/webopen.fish $__fish_config_dir/functions
# else
# 	echo "fish functions path unknown."
# end
