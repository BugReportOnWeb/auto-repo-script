<h1 id="header" align="center">
    Auto Repo Script
    <div id="badge">
        <img id="last-commit" src="https://img.shields.io/github/last-commit/BugReportOnWeb/auto-repo-script" />
    </div>
</h1>

Shell script to automate the process of creating and linking remote repository to the local repository just from the CLI

## Installation
Clone this repository to a desired destination and head inside the directory
```bash
$ git clone https://github.com/BugReportOnWeb/auto-repo-script.git
$ cd book-finder
```

Copy the main script to the `/usr/bin/` directory. Here `<cmd-name>` refers to the name you give to the command. Executing it will run the script.
```bash
# cp src/main.sh <cmd-name>
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

## Options/Setup
After running the script, you will go through a short questionnaire about the information regarding the remote repository. Those questions are as follow:
- Name of the Repository
- Descption of the Repository
- Visibility of the Repository (o = Open/Public OR c = Close/Private)
- GitHub credentials

