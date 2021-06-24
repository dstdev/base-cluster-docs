# Environment

## NERSC User Environment

### Home Directories, Shells and Dotfiles

All NERSC systems use global home directories.  NERSC supports `bash`,
`csh`, and `tcsh` as login shells.  Other shells (`ksh`, `sh`, and
`zsh`) are also available. The default login shell at NERSC is bash.
NERSC does not populate shell initialization files (also known as
dotfiles) on users' home directories.  You can create dotfiles (e.g.,
`~/.bashrc`, `~/.bash_profile`, etc.)  as needed to put your personal shell
modifications.

!!! warning "No more .ext dotfiles at NERSC since February 21, 2020."
	NERSC used to reserve the standard dotfiles (`~/.bashrc`,
    `~/.bash_profile`, `~/.cshrc`, `~/.login`, etc.) for system use so
    that users had to use the corresponding `.ext` files (e.g.,
    `~/.bshrc.ext`, `~/.bash_profile.ext`, etc.)  for their shell
    modifications.  **This is not the case anymore!**  You can modify
    those standard dotfiles for your personal use now.

	The actual dotfile transition occurred during the center maintenance
    on February 21-25, 2020. To mitigate the interruptions to existing
    workloads, we have preserved shell environments by replacing
    dotfiles with template dotfiles that source .ext files. For
    example, if you are an existing user at NERSC, here is how your
    `~/.bashrc` file would look like,

    ```shell
    # begin .bashrc
    if [ -z "$SHIFTER_RUNTIME" ]
    then
        . $HOME/.bashrc.ext
    fi
    # end .bashrc
    ```

	You are recommended to move the contents of your `~/.bashrc.ext` file
    into your `~/.bashrc` file after the transition (and remove the
    .ext files afterwards).

### Changing Default Login Shell

Use [**Iris**](https://iris.nersc.gov/login) to change your default
login shell. Log in, then under the "Details" tab look for the "Server
Logins" section. Click on "Edit" under the "Actions" column.

### Customizing Shell Environment

You can create dotfiles (e.g., `.bashrc`, `.bash_profile`, or
`.profile`, etc) in your `$HOME` directory to put your personal shell
modifications.

!!! note
	On Cori `~/.bash_profile` and `~/.profile` are sourced by
	login shells, while `~/.bashrc` is sourced by most of the shell
	invocations including the login shells.  In general you can put
	the environment variables, such as `PATH`, which are inheritable
	to subshells in `~/.bash_profile` or `~/.profile` and functions
	and aliases in the `~/.bashrc` file in order to make them
	available in subshells.

#### System specific customizations

All NERSC systems share the [Global HOME](../filesystems/global-home);
the same `$HOME` is available regardless of the platform. To make
system specific customizations use the pre-defined environment
variable `NERSC_HOST`.

!!! example

	```shell
	case $NERSC_HOST in
		"cori")
			: # settings for Cori
			export MYVARIABLE="value-for-cori"
			;;
		"datatran")
			: # settings for DTN nodes
			export MYVARIABLE="value-for-dtn"
			;;
		*)
			: # default value for other nodes
			export MYVARIABLE="default-value"
			;;
	esac
	```

#### darshan and altd

NERSC loads a light I/O profiling
tool, [darshan](https://www.mcs.anl.gov/research/projects/darshan/),
and altd (a library tracking tool) on Cori by default.  If you
encounter any problems with them, you can unload them in your
`~/.bash_profile`, or `~/.login` file:

```shell
module unload darshan
module unload altd
```

#### shifter

If you run [shifter](../development/shifter/how-to-use.md) applications,
you may want to skip the dotfiles.  You can use the
following *if block* in your dotfiles:

```shell
if [ -z "$SHIFTER_RUNTIME" ]; then
	: # Settings for when *not* in shifter
fi
```

#### missing NERSC variables

If any of the NERSC defined environment variables such as `$SCRATCH`,
are missing in your shell invocations, you can add them in your
`~/.bashrc` file as follows:

```shell
if [ -z "$SCRATCH" ]; then
	export SCRATCH=/global/cscratch1/sd/$USER
fi
```

#### crontabs

If you run bash scripts in crontabs, you may want to invoke a login
shell (*`#!/bin/bash -l`*) in order to get the NERSC defined
environment variables, such as `NERSC_HOST`, `SCRATCH`, `CSCRATCH`,
and to get the module command defined.
