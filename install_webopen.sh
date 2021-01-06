#!/usr/bin/env fish

# echo "Check dependencies"

# if test (gh --version)
# 	echo -e "'gh'\t\tOK."
# else
# 	echo "'gh' not installed."
# end


set -l userBin ~/bin

if not test -d $userBin
	mkdir ~/bin
end

echo "copy 'webopen.sh' to $userBin"
cp webopen.sh ~/bin/webopen

echo "create link to file in '/usr/local/bin' folder as 'webopen'"
if not test -L /usr/local/bin/webopen
	ln -s $userBin/webopen /usr/local/bin/webopen
else
	rm /usr/local/bin/webopen
	ln -s $userBin/webopen /usr/local/bin/webopen
end