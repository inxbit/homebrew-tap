# Inxbit Homebrew Tap

Homebrew formulae for Inxbit projects.

## Install

Install a formula directly:

```sh
brew install inxbit/tap/prismtty
brew install inxbit/tap/pinghue
```

Or tap this repository first:

```sh
brew tap inxbit/tap
brew install prismtty
brew install pinghue
```

## Formulae

| Formula | Description | Upstream |
| --- | --- | --- |
| `pinghue` | Colored, concurrent ICMP/TCP ping monitor for the terminal | <https://github.com/inxbit/pinghue> |
| `prismtty` | Fast terminal highlighter focused on network devices and Unix administration | <https://github.com/inxbit/prismtty> |

## pinghue Notes

`pinghue` works out of the box for TCP checks:

```sh
pinghue -p 443 example.com
```

ICMP mode may need extra privileges on Linux. Run the built-in doctor for exact guidance:

```sh
pinghue --check
```

## PrismTTY Notes

`prismtty` installs the main command plus the short aliases `ptty` and `ct`:

```sh
prismtty --version
ptty --help
ct --help
```

The formula also installs shell completions for Bash, Fish, and Zsh, plus the bundled syntax profiles.

Quick smoke test:

```sh
printf '192.0.2.1 down\n' | prismtty --profile generic
```

Published artifacts currently cover macOS Apple Silicon, macOS Intel, and Linux x86_64.
