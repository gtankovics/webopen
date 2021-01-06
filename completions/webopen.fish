

set -l webopen_commands git gcp gke gle gs

complete -x -c webopen -n "not __fish_seen_subcommand_from $webopen_commands" -a gh -d "Open GitHub"
complete -x -c webopen -n "not __fish_seen_subcommand_from $webopen_commands" -a gcp -d "Open GCP project's HOME"
complete -x -c webopen -n "not __fish_seen_subcommand_from $webopen_commands" -a gke -d "Open GCP project's Kubernete Engine"
complete -x -c webopen -n "not __fish_seen_subcommand_from $webopen_commands" -a gle -d "Open GCP project's Log Explorer"
complete -x -c webopen -n "not __fish_seen_subcommand_from $webopen_commands" -a gs -d "Open GCP project's Cloud Storage"