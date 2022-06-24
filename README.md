<h1 id="header" align="center">
    Auto Repo Script
    <div id="badge">
        <img id="last-commit" src="https://img.shields.io/github/last-commit/BugReportOnWeb/auto-repo-script" />
    </div>
</h1>

Shell script to automate the process of creating a remote repository and linking the same to the local repository just from the single command in the CLI.

## Installation
Clone this repository to a desired destination and head inside the directory
```bash
$ git clone https://github.com/BugReportOnWeb/auto-repo-script.git
$ cd auto-repo-script
```

Copy the main script to the `/usr/local/bin/` directory. Here `<cmd-name>` refers to the name you give to the command. Executing it will run the script.
```bash
$ sudo cp src/main.sh /usr/local/bin/<cmd-name>
```

## Usage
Head inside directory you want to start your project in (local repository without any git initialization).
```bash
$ cd <project-dir-path>
```

Run the command in the project directory.
```bash
$ <cmd-name>
```

## Uninstallation
Just remove the script from `/usr/local/bin/` directory
```bash
$ sudo rm /usr/local/bin/<cmd-name>
```

## Dependency
- [curl](https://curl.se/) - command line tool and library for transferring data with URLs

```
-> Ubuntu/Debian:               $ sudo apt install curl
-> RHEL/CentOS/Fedora:          $ sudo yum install curl
-> Arch Linux:                  $ sudo pacman -S curl
```

## Setup options
After running the script, you will go through a short questionnaire about the information regarding the remote repository. Those questions are as follow:
* Name of the Repository
* Descption of the Repository
* Visibility of the Repository (o = Open/Public OR c = Close/Private)
* GitHub credentials (Username and Password)

## Find a bug?
Well that goes without saying that this piece of code is not optimised at its best. Without even looking it up, I can surely say numerous bugs might pop up in certain edge cases. Well if you find one, feel free to open an issue about it. Our team (yeah just me) will try to fix it as soon as possible. You can even open a PR if you already have a solution in your mind. Thank you!

## Known issues (Work in progress)
- Error handling for none output in GitHub crendentials.
- Excpection for wrong Github credentials and Visibility option (links to first point).
- [NOT-A-BUG] Outputing stderr of cURL to `/dev/null`
- [FEATURE] Config files for GitHub credentials for auto fill

