# Eslintfix

Try to fix as many `eslint` errors as possible.

## Usage

```
$ exlintfix ./input.js [--config=./path/to/.eslintrc]
```

If no `--config` is passed, will use `.eslintrc` in the same dir as the input
file, or go up the tree recursively until it finds one.

## Installation

```
npm install -g jscs to-double-quotes to-single-quotes
bundle install
```

## Internals

`eslintfix` will parse the `.eslintrc` file for config values it knows and then
will try to fix them using multiple tools.


## Development

You can run the test (with an auto-reload) using:

```
bundle exec guard
```
