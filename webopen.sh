#!/usr/bin/env fish

set GCP_CONSOLE_BASE_URL "https://console.cloud.google.com"
set GCP_PROJECT_QUERY "?project=$GOOGLE_PROJECT"
set -q JIRA_BASE_URL || set JIRA_BASE_URL "[add the url here]"

function _showHelp
	echo "Show Help"
end

# function _doGKEOpen
# 	set -l _project $GOOGLE_PROJECT
# 	open https://console.cloud.google.com/kubernetes/list\?project=$_project
# end

# function _doGSOpen
# 	set -l _project $GOOGLE_PROJECT
# 	open https://console.cloud.google.com/storage/browser\?project=$_project
# end

function _checkIsGitRepository
	if git rev-parse --absolute-git-dir > /dev/null
		return 0
	else
		return 1
	end
end

function _doOpen
	set -l _url $argv[1]
	set -l _query $argv[2]
	if test -n "$_query"
		set _url (string join "?" $_url $_query)
	end
	echo $_url
	open $_url
end

function _doGitHubOpen
	if _checkIsGitRepository
		set -l _remoteUrl (git remote -v | awk '/fetch/{print $2}' | sed 's/git@/https:\/\//' | sed 's/com:/com\//' | sed 's/\.git//')
		if test -n "$_remoteUrl"
			switch "$argv[1]"
				case "pullrequests"
					set -l _url (string join "/" $_remoteUrl "pulls")
					_doOpen $_url
				case "releases"
					set -l _url (string join "/" $_remoteUrl "releases")
					_doOpen $_url
				case \*
					set -l _branch (git branch --show-current)
					set -l remoteUrl (string join "/" "$_remoteUrl" "tree" "$_branch")
					_doOpen $_remoteUrl
			end
		else
			echo "There is no remote. It's a local git repo."
		end
	else
		echo "This is not a git repository."
	end
end

if test -n "$argv[1]"
	switch "$argv[1]"
		case "gh"
			# Open GitHub
			if test -n "$argv[2]"
				switch "$argv[2]"
					case "pr" or "pullrequests"
						echo "open pull requests"
						if not string match -r "^no\sopen.*" (gh pr view)
							_doGitHubOpen pullrequests
						else
							gh pr view --web
						end
					case "rel" or "releases"
						_doGitHubOpen releases
					case "ji" or "jira"
						if string match -q -r ".*BIMC|bimc-[0-9].*" (git branch --show-current)
							set -l _issueNumber (git branch --show-current | sed -n 's/.*\(BIMC-[0-9]*\).*/\1/p')
							set -l _url (string join "/" $JIRA_BASE_URL "browse" $_issueNumber)
							_doOpen $_url
						else
							echo "JIRA issue number is missing from branch name."
						end
					case \*
						echo "[$argv[2]] is unknown."
				end
			else
				_doGitHubOpen
			end
		case "gcp"
			# Open Google Cloud Project's Home
			echo "Open Google Cloud Platform Console [$GOOGLE_PROJECT]"
			set -l _baseUrl (string join "/" $GCP_CONSOLE_BASE_URL "home" "dashboard")
			set -l _query "project=$GOOGLE_PROJECT"
			_doOpen $_baseUrl $_query
		case "gke"
			# Open Google Kubernetes Engine
			set -l _baseUrl (string join "/" $GCP_CONSOLE_BASE_URL "kubernetes" "list")
			if test -n "$argv[2]"
				switch "$argv[2]"
					# TODO handling nodes, workflows, etc.
					case \*
						echo "$argv[2] is unknown."
				end
			else
				_doOpen $_baseUrl
			end
		case "gle"
			# Open Google Cloud Logging Explorer
			set -l _baseUrl (string join "/" $GCP_CONSOLE_BASE_URL "logs" "query")
			# TODO open exact filter
			_doOpen $_baseUrl
		case "gs"
			# Open Google Cloud Storage
			set -l _baseUrl (string join "/" $GCP_CONSOLE_BASE_URL "storage" "browser")
			_doOpen $_baseUrl $_query
			# TODO open exact bucket exp. 
			# webopen gs [TENANT_ID] or webopen gs [domainPrefix]
		case "jira"
			if test -n $argv[2]
				switch $argv[2]
					case "ss" or "saas-structure"
						set -l _url (string join "/" $JIRA_BASE_URL "secure" "StructureBoard.jspa")
						set -l _query "s=50#"
						_doOpen $_url $_query
					case \*
						echo "$argv[2] is unknown."
				end
			else
				_doOpen $JIRA_BASE_URL
			end
		case \*
			_showHelp
	end
else
	echo "There's nothing to open."
end