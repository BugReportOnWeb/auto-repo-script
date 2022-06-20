#!/bin/sh

# Author: Dev
# Date: 20/06/2022

# Local project directory name
DIR_NAME=`basename $(pwd)`

preview() {
# Preview of user inputs
cat <<EOF
- Repository Name: $REPO_NAME
- Repository Description: $DESCRIPTION
- Repository Visibility: $STATUS
- GitHub URL: https://github.com/$USERNAME
EOF

    echo; echo -n 'Is this OK [(Y)es/(n)o]? (yes) '
    read confirm
    confirm=`echo $confirm | tr '[:upper:]' '[:lower:]'`

    if [[ $confirm == 'no' || $confirm == 'n' ]]; then
        user_inputs
    fi
}

user_inputs() {
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
    VISIBILITY=`echo $VISIBILITY | tr '[:upper:]' '[:lower:]'`
    if [[ -z $VISIBILITY || $VISIBILITY == 'o' ]]; then
        PRIVATE=false
        STATUS='Open/Public'
    else
        PRIVATE=true
        STATUS='Close/Private'
    fi

    echo -n 'GitHub Username: '
    read USERNAME

    echo -n "Host password for '$USERNAME': "
    read -s PASSWORD; echo -e '\n'
    preview
}

setup() {
    # Quick repository setup
    git init
    echo "# $REPO_NAME" >> README.md
    touch .gitignore
    git add .
    git commit -m "Initial commit"
    git remote add origin https://github.com/$USERNAME/$REPO_NAME.git
    git push -u origin master
}

main() {
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
main

