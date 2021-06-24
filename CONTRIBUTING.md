# Contribution guide

This guide outlines how to contribute to this project and standards
which should be observed when adding to this repository. This repository contains 
NERSC technical documentation written in Markdown which is converted to html/css/js with the
[mkdocs](http://www.mkdocs.org) static site generator. The theme
is based on [mkdocs-material](https://github.com/squidfunk/mkdocs-material)
with NERSC customizations such as the colors.

## Prerequisites

* [Anaconda](https://docs.anaconda.com/anaconda/install/) or Python [virtual environments](https://docs.python.org/3/tutorial/venv.html)
* [git](https://git-scm.com/downloads)
* You will need an [account](https://gitlab.com/users/sign_up) on https://gitlab.com 


### Cloning repository

To get started you can clone the repository, however it's best you create
a fork and clone your fork. 

```
# SSH method
git clone git@gitlab.com:NERSC/nersc.gitlab.io.git

# HTTP method
git clone https://gitlab.com/NERSC/nersc.gitlab.io.git
```

You will need to install some dependencies in order to build
documentation locally. This step is optional but highly
encouraged. This example uses a conda environment, but you are free to
choose any python3 environment. 

```
cd nersc.gitlab.io
conda create -n docs pip
conda activate docs
pip install -r requirements.txt
```

## Web GUI

Gitlab provides a [web editor](https://docs.gitlab.com/ee/user/project/repository/web_editor.html) and
[web ide](https://docs.gitlab.com/ee/user/project/web_ide/) to make *minor*
changes to the documentation (e.g fixing a typo). 
Even minor changes must be submitted via Merge Request.

When browsing https://docs.nersc.gov there is a pencil icon next to the header
of each page. This pencil is a link to edit the current page. When
using this feature make sure to update the commit message (required)
and new branch name (suggested).

For more substantial changes it is recommended to develop changes in
either a fork or branch. Creating new branches is restricted to NERSC
staff only.

## Sync Branches (Recommended)

It's important to keep your `main` branch in sync with upstream when you are 
working on documentation locally. To get started you will need to do the following:

1. Add a remote `upstream` to point to upstream repository

```
git remote add upstream git@gitlab.com:NERSC/nersc.gitlab.io.git
```

You should see two remote endpoints, `origin` points to your fork and `upstream` at main
repo.

```shell
$ git remote -v
origin	git@gitlab.com:<username>/nersc.gitlab.io.git (fetch)
origin	git@gitlab.com:<username>/nersc.gitlab.io.git (push)
upstream	git@gitlab.com:NERSC/nersc.gitlab.io.git (fetch)
upstream	git@gitlab.com:NERSC/nersc.gitlab.io.git (push)
```

2. Checkout `main` and sync `main` branch locally from upstream endpoint

```
git checkout main
git pull upstream main
```

To push your sync changes to your fork you can do the following:

```
git push origin main
```

!!! note
    Please don't use your `main` branch to make any changes, this branch is used
    to sync changes from upstream because all merge requests get pushed to main 
    branch. Instead, create a feature branch from main as follows:


### Typical workflow

The user workflow can be described in the following steps assuming you are using upstream repo. 
Please make sure you sync your `main` branch prior to creating a branch from `main`.
  

```shell
git checkout main
git checkout -b <BRANCH>
git add <file1> <file2>
git commit -m <COMMIT MESSAGE>
git push origin <BRANCH>
```


Next create a [merge request](https://gitlab.com/NERSC/nersc.gitlab.io/-/merge_requests/new) to 
the `main` branch with your newly created branch. Please make sure the [markdownlint check](#markdown-lint) and [continuous integration checks](https://gitlab.com/NERSC/nersc.gitlab.io/-/pipelines) have **passed** for your merge request.

    * It is possible the GitLab shared runners will fail for an opaque
      reason (e.g. issues with the cloud provider where they are hosted).
      Hitting the **Retry** button may resolve this problem.

## Resolve Merge Conflicts

Often times, you will be working on a feature branch and your MR get’s out of sync with `main` branch which may lead to conflicts, 
this is a result of merging incoming MRs that may cause upstream HEAD to change over time which can cause merge conflicts. 
This may be confusing at first, but don’t worry we are here to help. For more details about merge conflicts see [merge request conflict resolution](https://docs.gitlab.com/ee/user/project/merge_requests/resolve_conflicts.html).

Merge Conflicts can be fixed interactive mode or inline editor in Gitlab UI. If you want to resolve merge conflict in your local copy, you should first 
sync `main` branch from upstream and merge your changes in your feature branch. If you want to resolve merge conflicts locally
see https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/resolving-a-merge-conflict-using-the-command-line
  

### Edit with live preview

Open a terminal session with the appropriate conda environment
activated, navigate to the root directory of the repository (where
`mkdocs.yml` is located) and run the command `mkdocs serve`. This will
start a live-reloading local web server. You can then open
[http://127.0.0.1:8000](http://127.0.0.1:8000) in a web browser to
see your local copy of the site.

In another terminal (or with a GUI editor) edit existing files, add
new pages to `mkdocs.yml`, etc. As you save your changes the local
web serve will automatically re-render and reload the site.

### Output a static site

To build a self-contained directory containing the full html/css/js
of the site:

```
mkdocs build
```

## Guidelines

### Adding new pages

For a newly added page to appear in the navigation edit the top-level
`mkdocs.yml` file. If you are unsure about the best location for a new
page please open an issue or (if staff) start a discussion in #docs on
nersc.slack.com. Note that duplication of information in discouraged,
so enhancing an existing page may be preferable to creating a new
page.

### Relative links

Always use relative links for internal links.

This allows the mkdocs link checker to ensure links remain valid.

#### Example

To make a link to `docs/x/y/b.md` from `docs/z/a.md` use

```
[link_name](../../x/y/b.md)
```

not

```
[link_name](/x/y/b.md)
```

[Details and examples](https://www.mkdocs.org/user-guide/writing-your-docs/#linking-to-pages)

### Command prompts

#### with output

When showing a command and sample result, include a prompt and use
the `console` annotation for the code block.

```console
$ sqs
JOBID   ST  USER   NAME         NODES REQUESTED USED  SUBMIT               PARTITION SCHEDULED_START      REASON
864933  PD  elvis  first-job.*  2     10:00     0:00  2018-01-06T14:14:23  regular   avail_in_~48.0_days  None
```

#### without output

Commands shown without output can omit the prompt to facilitate
copy/paste.

```
sqs
```

1. When showing a command and sample result, include a prompt 
indicating where the command is run, eg for a command valid on any
NERSC system, use `nersc$`:

    ```console
    nersc$ sqs
    JOBID   ST  USER   NAME         NODES REQUESTED USED  SUBMIT               PARTITION SCHEDULED_START      REASON
    864933  PD  elvis  first-job.*  2     10:00     0:00  2018-01-06T14:14:23  regular   avail_in_~48.0_days  None
    ```

    But if the command is cori-specific, use `cori$`:
    ```console
    cori$ sbatch -Cknl ./first-job.sh
    Submitted batch job 864933
    ```

2. Where possible, replace the username with `elvis`
(i.e. a clearly-arbitrary-but-fake user name)

3. If pasting a snippet of a long output, indicate cuts with `[snip]`:
    ```console
    nersc$ ls -l
    total 23
    drwxrwx--- 2 elvis elvis  512 Jan  5 13:56 accounts
    drwxrwx--- 3 elvis elvis  512 Jan  5 13:56 data
    drwxrwx--- 3 elvis elvis  512 Jan  9 15:35 demo
    drwxrwx--- 2 elvis elvis  512 Jan  5 13:56 img
    -rw-rw---- 1 elvis elvis  407 Jan  9 15:35 index.md
    [snip]
    ```

### Identifiable information 

Where possible, replace the username, project name, etc with clearly
arbitrary fake data. For usernames `elvis` is a popular choice:

```console
$ ls -l
total 23
drwxrwx--- 2 elvis elvis  512 Jan  5 13:56 accounts
drwxrwx--- 3 elvis elvis  512 Jan  5 13:56 data
drwxrwx--- 3 elvis elvis  512 Jan  9 15:35 demo
drwxrwx--- 2 elvis elvis  512 Jan  5 13:56 img
-rw-rw---- 1 elvis elvis  407 Jan  9 15:35 index.md
[snip]
```

#### placeholders

* `<must supply a value>`
  
  Example: In `ssh_job <jobid>` `<jobid>` is required.
  
* `[optional value]`
  
  Example 1: `iris [-h]` The `-h` is optional.
  
  Example 2: `iris user [username]` The `[username]` is optional.
	
* `{choice1|choice2|choice3}` choose one from set of items
  
  Example 1: `iris {user|qos|project}` Can only choose one of the
  valid sub-commands.
  
  Example 2: `sbatch --qos={debug|regular|premium}`. Can only choose
  one QOS.

* `<value>...` Ellipsis for items that can be repeated.
  
  Example: `ls [file]...` It is allowed to add any number of "file"
  arguments ie `ls afile anotherfile another`. This is optional since
  `ls` works without any parameters so `[]` is used.


### Writing Style

When adding a page think about your audience.

* Are they new or advanced expert users?
* What is the goal of this content?

* [Grammatical Person](https://en.wikiversity.org/wiki/Technical_writing_style#Grammatical_person)
* [Active Voice](https://en.wikiversity.org/wiki/Technical_writing_style#Use_active_voice)

### `bash` not `csh`

All examples should be given in `bash` when possible.

### Terms

* I/O not IO
* NERSC Project not NERSC repo.

### ambiguous terms

In some cases a term may be used differently in related contexts. Be
sure to clarify when there could be doubt.

### Examples

- Slurm allocation vs NERSC allocation
- Slurm account vs NERSC username

## How to

### Review a Merge Request from a private fork

1.  Modify `.git/config` so merge requests are visible

    ```text
    ...
    [remote "origin"]
	        url = git@gitlab.com:NERSC/documentation.git
	        fetch = +refs/heads/*:refs/remotes/origin/*
	        fetch = +refs/merge-requests/*/head:refs/remotes/origin/pr/*
	...
	```

2.  Check for any Merge Requests

    ```shell
    git fetch
    ```

3.  Checkout a specific Merge Request for review (merge request `N`
	in this example)

    ```shell
    git checkout origin/pr/N
    ```

## Rules

1.  Follow this [Markdown styleguide](https://github.com/google/styleguide/blob/3591b2e540cbcb07423e02d20eee482165776603/docguide/style.md).
1.  Do not commit large files (e.g. very high-res images, binary data, executables) [Image optimization](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/image-optimization)
1.  No commits directly to the `main` branch

### Merge Requests

#### NERSC Staff 

Please assign appropriate individuals to review your merge request. If you are not,
leave the MR **unassigned** . You can join the [NERSC slack channel](nersc.slack.com)
at `#docs` workspace to get support on documentation. 

#### External Contributors

Leave MRs unassigned and one of the NERSC staff will review our contribution.


Please review the automated CI checks when working on an active MR. 

**Your pipeline must pass CI check in order to be merged in**

- Pipeline: https://gitlab.com/NERSC/nersc.gitlab.io/pipelines
- Jobs: https://gitlab.com/NERSC/nersc.gitlab.io/-/jobs

## Markdown lint

We are using [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) package to run
lint checks on all markdown files. This check is enforced in Gitlab CI ([.gitlab-ci.yml](https://gitlab.com/NERSC/nersc.gitlab.io/-/blob/main/.gitlab-ci.yml)).

### Installation via npm

This can be installed on your machine via [nodejs](https://nodejs.org/en/)) as follows:

```shell
npm install -g markdownlint-cli
```

### Installation via brew

On macOS, you can install view [Homebrew](https://brew.sh/) as follows:

```shell
brew install markdownlint-cli
```

### Installation in conda environment

If you are using a conda environment to provision your python instance, 
you will need [nodejs](https://anaconda.org/conda-forge/nodejs) package which provides `npm` command. 
Assuming you have a conda environment named **docs** you can activate the conda 
environment and install the packages as follows:

```shell 
source activate docs
conda install nodejs
npm install -g markdownlint-cli
```

Upon installation the command `markdownlint` should be in your $PATH. If you encounter
issues during installation please see https://github.com/igorshubovych/markdownlint-cli
or report issue at https://github.com/igorshubovych/markdownlint-cli/issues. 

### Usage

You can run the linter from the base directory of the repository which will validate 
all markdown files. The markdown files are found in `docs` so run the following:

```shell
markdownlint docs
```

Alternately, you can run the markdown linter on a specific file as follows:

```
$ markdownlint docs/index.md
docs/index.md: 8: MD009/no-trailing-spaces Trailing spaces [Expected: 0 or 2; Actual: 1]
docs/index.md: 9: MD009/no-trailing-spaces Trailing spaces [Expected: 0 or 2; Actual: 1]
```


!!! note
	It is important to run the linter from the base directory so
	that the correct configuration file (`.markdownlint.json`) is
	used.

Please take note of [.markdownlint.json](https://gitlab.com/NERSC/nersc.gitlab.io/-/blob/main/.markdownlint.json) for list of markdown rules configured
for this project. Please refer to https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md for description of markdown rules 
that the correct configuration file (`.markdownlint.json`) is used.

