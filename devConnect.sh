#!/bin/zsh
#####################
# This is aimed to open a bash terminal inside an existing devcontainer (useful to debug or work with vim)
#####################
# Capture the output of the command into a variable
op=$(devcontainer up --workspace-folder . 2>/dev/null)

# Check if 'error' appears after "outcome": in the output
if [[ "$op" =~ '"outcome":"error"' && "$op" =~ 'Dev container config .* not found' ]]; then
    echo "No Dev container config found"
elif [[ "$op" =~ '"outcome":"error"' ]]; then
    echo "Unexpected error"
elif [[ "$op" =~ '"outcome":"success"' ]]; then
    echo "Devcontainer config found!\nInitializing connection"
	
# Extraire l'ID du conteneur
    id=$(echo "$op" | sed -n 's/.*"containerId":"\([^"]*\)".*/\1/p')   
	if [ -n "$id" ]; then
		# Example of devcontainer project PATH "remoteWorkspaceFolder":"/workspaces/<Projet name here>"}
    	workspace=$(echo "$op" | sed -n 's/.*"remoteWorkspaceFolder":"\([^"]*\)".*/\1/p')   
		
		# Connect to the devcontainer using the vscode user with bash or sh shell
        echo "Container ID is: $id"
        docker exec --user vscode -it "$id" sh -c "cd $workspace && /bin/bash || /bin/sh "
    else
        echo "Container ID not found!"
    fi
else
    echo "Unknown output: $op"
fi

