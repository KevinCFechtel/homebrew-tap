# kevincfechtel/tap

A [Homebrew](https://brew.sh) tap distributing macOS apps and command line tools
by Kevin C. Fechtel.

These apps are not in the official [homebrew-cask](https://github.com/Homebrew/homebrew-cask)
registry, and not because of anything about the apps themselves: homebrew-cask
requires a project to clear a notability threshold of 75 stars, 30 forks or
30 watchers, and triple that (225 / 90 / 90) when the maintainer submits their
own software. These projects are below it. This tap is the supported way to
install them, and it uses the same Cask format, the same `brew` commands, and
the same audits.

## Install

```sh
brew install --cask kevincfechtel/tap/<token>
```

There is no need to run `brew tap` first. A fully qualified name
(`<owner>/<tap>/<token>`) makes Homebrew tap this repository automatically, and
it also marks the cask as trusted, which Homebrew requires before it will load
anything from a non-official tap.

If you prefer to tap explicitly, the short name works afterwards — but note that
`brew tap` does not imply trust, and an unqualified install from a tapped but
untrusted tap is refused. So trust it once:

```sh
brew tap kevincfechtel/tap
brew trust kevincfechtel/tap
brew install --cask <token>
```

## Contents

| Cask | Description |
| ---- | ----------- |
| _empty_ | The first entries arrive with the first app release. |

Planned: `brewtifyer` (menu bar app for Homebrew updates), `colimastatus`
(menu bar app for Colima status). A `Formula/` directory is reserved for Go
command line tools.

## Update

```sh
brew update
brew upgrade --cask <token>
```

These apps do not update themselves — that is exactly what this tap is for, so
`brew upgrade` is the update mechanism rather than a second, in-app one.

## Uninstall

```sh
brew uninstall --cask <token>
```

That removes the app but leaves the data it created behind. To remove
everything the cask knows about — application support files, logs, preferences:

```sh
brew uninstall --cask --zap <token>
```

`--zap` may remove files shared with other applications, which is why it is not
the default.

## How casks get here

**The files in `Casks/` are generated. Do not edit them here.**

Each cask is defined in its own app repository, in that repository's
`Build/cask.sh`. When that app cuts a release, its GitHub Actions workflow
generates the `.rb` file and pushes it into this repository. This repository is
purely a distribution point plus CI.

So a hand-made change here is not a fix — the next release regenerates the file
and overwrites it silently, with no warning and no merge conflict. Corrections
belong in the app repository's `Build/cask.sh`, which is the only place a change
survives.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the contract an app repository has to
meet for its cask to work here.

## CI

[`.github/workflows/audit.yml`](.github/workflows/audit.yml) runs on every pull
request, on every push to `main` (which is where the app repositories' release
workflows land), and on demand. It runs:

- `brew style --cask` — RuboCop over the cask files
- `brew audit --cask --online --strict` — the check that matters

`--online` downloads the release artifact, verifies the `sha256` against it and
extracts it. That is what catches a release URL that 404s, a checksum that no
longer matches the artifact, or a `depends_on macos:` that contradicts the app's
own `LSMinimumSystemVersion`. Without it, users find those first.

## License

[MIT](LICENSE). The license covers the cask and formula definitions in this
repository, not the applications they install, which carry their own licenses.
