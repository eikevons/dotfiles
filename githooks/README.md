# Helpful hooks for `git`

## Usage

This directory will be linked to `~/.githooks/`. To use the hooks, you must link
`~/.githooks/run-all-hooks` as e.g. `pre-commit`. This will then run all
`pre-commit.*` files.

## Available hooks

- `pre-commit.max-size`: Check that no file larger than `$GIT_MAX_MIB`
  (default 5 MiB) is committed.
