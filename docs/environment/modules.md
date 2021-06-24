# Modules Environment

NERSC uses the [module](http://modules.readthedocs.io) utility to
manage nearly all software. There are two advantages of the module
approach:

1. NERSC can provide many different versions and/or installations of a
   single software package on a given machine, including a default
   version as well as several older and newer version.
2. Users can easily switch to different versions or installations
   without having to explicitly specify different paths. With modules,
   the `MANPATH` and related environment variables are automatically
   managed.

## What is module

module is a shell function that modifies user shell upon load of a modulefile.
The module function is defined as follows

```console
$ type module
module is a function
module () 
{ 
    eval `/opt/cray/pe/modules/3.2.11.4/bin/modulecmd bash $*`
}
```

!!! note
	module is not a program 

## Module Commands

!!! note

    Cray default module is modules/3.2.11.4 and documentation is based on this version
    
    `modules/4.1.3.1` is also available to support non-Cray modulefiles that require 
    Modules 4.x. While most modulefiles at NERSC should work with Modules 4.x, there are
    some compatibility issue with PrgEnv- modules, and we don't recommend 
    `modules/4.1.3.1` for "normal" use.

General usage:

```console
nersc$ module [ switches ] [ subcommand ] [subcommand-args ]
```

Further reading:

 * `module help`
 * `man module`
 * `man modulefile`
 * [Online manual](http://modules.readthedocs.io) (note: some features
   may only be available in later versions than what is installed on
   NERSC systems)

## Module Usage

List currently loaded modules:

```shell
module list
```

List all available modules:

```shell
module avail 
module av
```

Show availability of specific module:

```shell
module avail <module-name>
```

Show availability of all modules containing a substring:

```shell
module avail -S <substring>
```

Display what changes are made when a module is loaded:

```shell
module display <module-name>
module show <module-name>
```

Add a module to your current environment:

```shell
module load <module-name>
module add <module-name>
```

!!! note
	This command is silent unless there are problems with the
	module.

!!! tip
	If you load then generic name of a module, you will get the
	default version.

	```shell
	module load gcc
	```

	To load a specific version use the full name

	```shell
	module load gcc/8.1.0
	```

Remove module from the current environment:

```shell
module unload <module-name>
module rm <module-name>
```

!!! note
	This command will fail *silently* if the specified module is not loaded.

Switch currently loaded module with a new module:

```shell
module swap <old-module> <new-module>
module switch <old-module> <new-module>
```

To purge all modules::

!!! note

    this will remove all your modules from active environment including startup modules
    loaded in your shell. To restore your environment with startup modules, its best to relogin 
         
```shell
module purge
```

To view help for a particular module:: 

```shell
module help <module-name>
```

To see a condensed list of module you can use `module -t` and use this with `list` or `avail`

```
$ module -t list
Currently Loaded Modulefiles:
modules/3.2.11.4
nsg/1.2.0
altd/2.0
darshan/3.1.7
intel/19.0.3.199
craype-network-aries
craype/2.6.2
cray-libsci/19.06.1
udreg/2.3.2-7.0.1.1_3.29__g8175d3d.ari
ugni/6.0.14.0-7.0.1.1_7.32__ge78e5b0.ari
pmi/5.0.14
dmapp/7.1.1-7.0.1.1_4.43__g38cf134.ari
gni-headers/5.0.12.0-7.0.1.1_6.27__g3b1768f.ari
xpmem/2.2.20-7.0.1.1_4.8__g0475745.ari
job/2.2.4-7.0.1.1_3.34__g36b56f4.ari
dvs/2.12_2.2.156-7.0.1.1_8.6__g5aab709e
alps/6.6.57-7.0.1.1_5.10__g1b735148.ari
rca/2.2.20-7.0.1.1_4.42__g8e3fb5b.ari
atp/2.1.3
PrgEnv-intel/6.0.5
craype-haswell
cray-mpich/7.7.10
craype-hugepages2M
```

At NERSC three Cray `PrgEnv-` modules are available: ``PrgEnv-cray``, ``PrgEnv-gnu``
and ``PrgEnv-intel`` (the default). These modules provide respectively the Cray, GNU 
or Intel compiler via the compiler wrappers `cc` (C) `CC` (C++) and `ftn` (Fortran). 
You can only have one `PrgEnv` module loaded at a time: for instance if we load 
`PrgEnv-gnu` without first unloading `PrgEnv-intel`
we get the following message. 

```console
    $ module load PrgEnv-gnu
    PrgEnv-gnu/6.0.5(77):ERROR:150: Module 'PrgEnv-gnu/6.0.5' conflicts with the currently loaded module(s) 'PrgEnv-intel/6.0.5'
    PrgEnv-gnu/6.0.5(77):ERROR:102: Tcl command execution failed: conflict PrgEnv-intel
```

To circumvent this you must swap or unload modules as follows

```
    # swap modules
    module swap PrgEnv-intel PrgEnv-gnu

    # unload + load
    module unload PrgEnv-intel
    module load PrgEnv-gnu
```

## Creating a Custom Module Environment

You can modify your environment so that certain modules are loaded
whenever you log in.

The first option is to use shell commands.

### bash

In `~/.bash_profile`

```bash
module swap PrgEnv-${PE_ENV,,} PrgEnv-gnu
```

### csh

In `~/.login`

```csh
set pe = ` echo $PE_ENV | tr "[:upper:]" "[:lower:]" `
module swap PrgEnv-${pe} PrgEnv-gnu
```

#### snapshots

The second option is to use the "snapshot" feature of `modules`.

1. swap and load modules to your desired configuration
2. save a "snapshot" with `module snapshot <snapshot-filename>`

Then at any time later restore the environment with
`module restore <snapshot-filename>`.

### Install Your Own Customized Modules

You can create and install your own modules for your convenience or
for sharing software among collaborators. See the `man modulefile` or
the
[modulefile documentation](https://modules.readthedocs.io/en/latest/modulefile.html#) for
details of the required format and available commands.  These custom
modulefiles can be made visible to the `module` command by `module use
/path/to/the/custom/modulefiles`.

!!! tip
	[Global Common](../filesystems/global-common.md) is the
	recommended location to install software.

!!! note
	Make sure the **UNIX** file permissions grant access to all users who
	want to use the software.

!!! warning
	Do not give write permissions to your home directory to anyone else.

!!! note
	The `module use` command adds new directories before
	other module search paths (defined as `$MODULEPATH`), so modules
	defined in a custom directory will have precedence if there are
	other modules with the same name in the module search paths. If
	you prefer to have the new directory added at the end of
	`$MODULEPATH`, use `module use -a` instead of `module use`.

## Known issues with modules

### Zero exit code for invalid modules

```console
$ module load X
ModuleCmd_Load.c(244):ERROR:105: Unable to locate a modulefile for 'X'
$ echo $?
0
```

This means that module commands often return a "success" code (0) even 
if the command failed, which can lead to surprising errors in eg job scripts.

### Incompatibilities with `modules/4.1.3.1`

`modules/4.1.3.1` is available but not recommended. If you do need Modules 4.x,
you can access it with `module swap modules modules/4.1.3.1` (note that 
`module load modules/4.1.3.1` will abort with an error). If using Modules 4.x, 
we recommend carefully checking that your script or usage has the correct outcome. 

### Module FAQ 

1. Is there an environment variable that captures loaded modules?

Yes, active modules can be retrieved via `$LOADEDMODULES`, this environment variable is 
automatically changed to reflect active loaded modules that is reflected via `module list`.
If you want to access modulefile path for loaded modules you can retrieve via `$_LM_FILES`

2. How to restore MODULEPATH in user session?

If you run into an error such as following::

```
$ module avail
ModuleCmd_Avail.c(217):ERROR:107: 'MODULEPATH' not set
```

You should try a new login shell and see if it fixes the issue. Check to see if your startup 
scripts (`~/.bashrc`, `~/.bash_profile`) or `~/.cshrc` for tcsh/csh 
