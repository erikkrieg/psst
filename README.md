# psst

Potential alternative names:
- Gossip
- Envy
- Pry

A light-weight Bash script that provides a flexible interface for secure and scalable configuration management.

> [A twelve-factor app] requires strict separation of config from code.

_[The Twelve-Factor App](https://12factor.net/config)_

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)

## Installation

Not setup yet.

Reference [nvm's installation implementation](https://github.com/creationix/nvm#installation-and-update).

## Usage

### CLI options

| Option Name | Option Flag | Description |
| --- | --- | --- |
| [Exec](#exec) | `-e` \| `--exec` \| `exec` | Optional command to execute after configuration has be sourced. |
| [File](#file) | `-f` \| `--file` | Optional path to `.env` file to source. Can be used multiple times. |
| [Config](#config) | `-c` \| `--config` | Optional path to config file. Defaults to `.psstrc`. |

#### Exec

Option to provide a command that will be executed after configuration is set in the environment.

##### Exec flags

The `exec` option must be followed by a string. Below are examples of the long and short forms of the flag:

```bash
# Long-form flag
psst --exec 'node index.js'

# Short-form flag
psst -e 'node index.js'
```

##### Exec sub-command

Below is an example of the `exec` sub-command being used:

```bash
psst exec node index.js
```

Using this method, you need to be sure to apply other options before the `exec` sub-command, else they will be considered part of the `exec` argument.

Examples:

```bash
# Good. Picks up .env file and executes `node index.js`
psst -f example.env exec node index.js

# Bad. This would attempt to execute `node index.js -f example.env`
psst exec node index.js -f example.env
```

Another consideration using the `exec` sub-command is that Bash will strip certain characters from arguments, such as quotes, unless they are somehow escaped.

Examples:

```bash
# Good. Escaping the single quotes ensures that they are preserved when executed.
psst exec node -e \'console.log(process.env.SECRET)\'

# Good. Wrapping the command in double quotes is another way to preserve the single quotes.
psst exec "node -e 'console.log(process.env.SECRET)'"

# Bad. This example will attempt to execute `node -e console.log(process.env.SECRET)`, which will fail.
psst exec node -e 'console.log(process.env.SECRET)'
```

##### Implicit exec option

When arguments are present that are not behind a flag or sub-command they are interpreted as part of a command to be executed. This works the same as the `exec` sub-command, just sans `exec`.

Examples:

```bash
# Executes `node index.js`
psst node index.js

# Source example.env then runs `node index.js`
psst -f example.env node index.js

# Executes `node -e \'console.log(process.env.SECRET)\'`. Note the escaped single quotes.
psst node -e \'console.log(process.env.SECRET)\'
```

#### File

A variable number of paths to [`.env` files](https://gist.github.com/ericelliott/4152984). These files are sourced *after* any remote configuration is sourced, which means they take priority because subsequent sources will overwrite eachother on enviroment variable name collisions. This is a good way to customize a centralized set of configurations.

Since multiple files can be sourced and can overwrite eachother, it is important to consider the order this happens in, which is determined by the order the `file` flags are set.

##### File flags

The `file` option must be followed by a resolvable file path. Below are examples of the long and short forms of the flag:

```bash
# Long-form flag
psst --file dev.env

# Short-form flag
psst -f dev.env
```

Here is an example of multiple files being sourced:

```bash
# dev.env is sourced, then test.env.
psst -f dev.env -f test.env
```

Again, the order of the files matters, as they can override eachother.

#### Config

Path to a [`.psstrc` file](#config-file-psstrc) that can be used to configure behaviour of `psst` in addition to the CLI options. Defaults to `.psstrc`.

##### Config flags

The `config` option should be followed by a file path. Below are examples of the long and short forms of the flag:

```bash
# Long-form flag
psst --config test.psstrc

# Short-form flag
psst -c test.psstrc
```

### Config file: `.psstrc`

TODO
