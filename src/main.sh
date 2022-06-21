#!/bin/sh

# Author: Dev
# Date: 20/06/2022

########################################
# Preview the options from user inputs.
# Globals:
#   REPONAME, DESCRIPTION, STATUS, USERNAME
# Outputs:
#   Details preview and step over user_input()
#   if affirmative CONFIRM, else recurse preview()
########################################
preview() {
cat <<EOF
- Repository Name: $REPO_NAME
- Repository Description: $DESCRIPTION
- Repository Visibility: $STATUS
- GitHub URL: https://github.com/$USERNAME
EOF

    echo; echo -n 'Is this OK [(Y)es/(n)o]? (yes) '
    read CONFIRM
    CONFIRM=$(echo $CONFIRM | tr '[:upper:]' '[:lower:]')

    if [[ $CONFIRM == 'no' || $CONFIRM == 'n' ]]; then
        user_inputs
    fi
}

########################################
# Takes user inputs for repository details
# GLOBAL:
#   DIR_NAME
# Returns:
#   User input values and run preview()
########################################
user_inputs() {
    if [[ $AUTO == true ]]; then
        REPO_NAME=$DIR_NAME
        DESCRIPTION=''
        PRIVATE=false
    else
        echo -n "Repository Name: ($DIR_NAME) "
        read REPO_NAME
        if [[ -z $REPO_NAME ]]; then
            REPO_NAME=$DIR_NAME
        fi

        echo -n 'Repository Description: '
        read DESCRIPTION

        # o == Open/Public && c == Close/Private
        echo -n "Repository Visibility [(O)pen/(c)lose]: (Public) "
        read VISIBILITY
        VISIBILITY=$(echo $VISIBILITY | tr '[:upper:]' '[:lower:]')
        if [[ -z $VISIBILITY || $VISIBILITY == 'o' ]]; then
            PRIVATE=false
            STATUS='Open/Public'
        else
            PRIVATE=true
            STATUS='Close/Private'
        fi
    fi

    echo -n 'GitHub Username: '
    read USERNAME

    echo -n "Host password for '$USERNAME': "
    read -s PASSWORD; echo -e '\n'
    preview
}

########################################
# Flags/Options for the main sciprt
# Arguments:
#   -h/--help, -y/--yes, --no-push, None
# Returns:
#   Help page for -h/--help, auto fill
#   inputs by default for -y/--yes and
#   --no-push to not push files after setup()
########################################
flags() {
    case $1 in
        -h|--help)
            echo 'Help page' 
            ;;
        -y|--yes)
            AUTO=true
            ;;
        --no-push)
            PUSH=false
            ;;
        *)
            if [[ -n $1 ]]; then
                echo "$0: cannot use $1: Invalid option" >&2
                exit 1
            fi
            ;;
    esac
}

########################################
# A quick remote repository setup
# Globals:
#   REPO_NAME, USERNAME, PUSH
# Returns:
#   README.md file with repo name as the
#   title and an empty .gitignore
########################################
setup() {
    # Quick repository setup
    git init
    echo "# $REPO_NAME" >> README.md
    touch .gitignore
    git add .
    git commit -m "Initial commit"
    git remote add origin https://github.com/$USERNAME/$REPO_NAME.git

    if [[ $PUSH == true ]]; then
        git push -u origin master
    fi
}

########################################
# The main function that goes through
# flags > user_inputs > cURL > setup
# Arguments:
#   Available flags that goes to flags()
# Returns:
#   stderr fro cURL && git initilization
########################################
main() {
    DIR_NAME=$(basename $(pwd))
    AUTO=false
    PUSH=true
    EXIT=false

    flags $1
    user_inputs; echo

    # GitHub API call using cURL
    curl \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $PASSWORD" \
        -d "{ \
            \"name\": \"$REPO_NAME\", \
            \"description\": \"$DESCRIPTION\", \
            \"private\": $PRIVATE \
        }" \
        https://api.github.com/user/repos >> /dev/null; echo

    setup
}
main $1

