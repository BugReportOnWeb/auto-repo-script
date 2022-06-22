#!/bin/sh

# Author: Dev
# Date: 20/06/2022

# Global Constants
REPO_NAME="$(basename $(pwd))"
CMD_NAME="$(basename $0)"
STATUS='Open/Public'
DESCRIPTION=''

PUSH='true'
AUTO='false'
EXIT='false'
PRIVATE='false'

RED='\033[0;31m'
NC='\033[0m'
BOLD="$(tput bold)"
NORM="$(tput sgr0)"

########################################
# Preview the options from user inputs.
# Globals:
#   REPONAME, DESCRIPTION, STATUS, username
# Outputs:
#   Details preview and step over user_input()
#   if affirmative CONFIRM, else recurse preview()
########################################
preview() {
  local confirm

cat <<EOF
- Repository Name: ${REPO_NAME}
- Repository Description: ${DESCRIPTION}
- Repository Visibility: ${STATUS}
- GitHub URL: https://github.com/${username}
EOF

  echo; echo -n 'Is this OK [(Y)es/(n)o]? (yes) '
  read confirm
  confirm=$(echo "${confirm}" | tr '[:upper:]' '[:lower:]')

  if [[ "${confirm}" == 'no' || "${confirm}" == 'n' ]]; then
    user_inputs
  fi
}

########################################
# Takes user inputs for repository details
# GLOBAL:
#   AUTO, DIR_NAME
# Returns:
#   User input values and run preview()
########################################
user_inputs() {
  if [[ "${AUTO}" == 'false' ]]; then
    local visibility

    echo -n "Repository Name: (${REPO_NAME}) "
    read REPO_NAME
    if [[ -z "${REPO_NAME}" ]]; then
      REPO_NAME="$(basename $(pwd))"
    fi

    echo -n 'Repository Description: '
    read DESCRIPTION

    echo -n "Repository Visibility [(O)pen/(c)lose]: (Public) "
    read visibility
    visibility=$(echo "${visibility}" | tr '[:upper:]' '[:lower:]')
    if [[ "${visibility}" == 'c' ]]; then
      PRIVATE='true'
      STATUS='Close/Private'
    fi
  fi

  echo -n 'GitHub Username: '
  read username

  echo -n "Host password for '${username}': "
  read -s password; echo -e '\n'
  preview
}

########################################
# Help page for (-h | --help) flag
# Globals:
#   CMD_NAME
# Outputs:
#   Help message
########################################
help_page() {
cat << EOL
Info: A shell script to automate GitHub repository process
Usage: ${CMD_NAME} [OPTIONS...]

OPTIONS:
  -h, --help        Print this help message
  -y, --yes         Autofills default values
  --no-push         Won't push commits after repo setup

EOL
}

########################################
# Flags/Options for the main sciprt
# Globals:
#   RED, NC, BOLD, NORM, CMD_NAME
# Arguments:
#   -h/--help, -y/--yes, --no-push, None
# Returns:
#   Help page for -h/--help, auto fill
#   inputs by default for -y/--yes and
#   --no-push to not push files after setup()
########################################
flags() {
  for option in "$@"; do
    case "$option" in
      -h|--help)
        help_page
        exit 0
        ;;
      -y|--yes) AUTO='true' ;;
      --no-push) PUSH='false' ;;
      *)
        if [[ -n "$option" ]]; then
          echo -e "${BOLD}${CMD_NAME}${NORM} \
${RED}${BOLD}Unrecognized option argument:${NORM}${NC} \
${BOLD}'$1'${NORM}
Try '${CMD_NAME} --help' for more information." >&2
          exit 1
        fi
        ;;
    esac
  done

}

########################################
# A quick remote repository setup
# Globals:
#   REPO_NAME, username, PUSH
# Returns:
#   README.md file with repo name as the
#   title and an empty .gitignore
########################################
setup() {
  git init
  echo "# ${REPO_NAME}" >> README.md
  touch .gitignore
  git add .
  git commit -m "Initial commit"
  git remote add origin https://github.com/${username}/${REPO_NAME}.git

  if [[ "${PUSH}" == 'true' ]]; then
    git push -u origin master
  fi
}

########################################
# The main function that goes through
# flags > user_inputs > cURL > setup
# Globals:
#   password, REPO_NAME, DESCIPTION, PRIVATE
# Arguments:
#   Available flags that goes to flags()
# Returns:
#   stderr fro cURL && git initilization
########################################
main() {
  flags "$@"
  user_inputs; echo

  # GitHub API call using cURL
  curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${password}" \
    -d "{ \
      \"name\": \"${REPO_NAME}\", \
      \"description\": \"${DESCRIPTION}\", \
      \"private\": ${PRIVATE} \
    }" \
    https://api.github.com/user/repos >> /dev/null; echo

  setup
}
main "$@"

