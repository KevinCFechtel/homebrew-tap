# Contributing

Casks are **not** written or maintained in this repository. Each app repository
owns its own cask definition in `Build/cask.sh` and pushes the generated `.rb`
here on release. Editing a generated file here has no lasting effect: the next
release overwrites it silently.

This document is the contract an app repository has to meet so that its
generated cask works in this tap and passes CI.

## Target path and token

Write to `Casks/<token>.rb`.

The token is lowercase with no separators: `brewtifyer`, `colimastatus` — not
`Brewtifyer`, not `colima-status`. The filename and the `cask "<token>" do`
header must agree, and the token is what users type:
`brew install --cask kevincfechtel/tap/brewtifyer`.

## Release artifact

One **universal binary** per release, named:

```
<AppName>-<version>-macos-universal.zip
```

Per-architecture releases are not acceptable. `brew install --cask` does not
report an architecture mismatch — it installs whatever the URL returns. A user
on the wrong architecture gets an app that fails to launch with no explanation,
and nothing in the Homebrew output hints at why.

## Required stanzas

```ruby
cask "brewtifyer" do
  version "1.2.3"
  sha256 "…"

  url "https://github.com/KevinCFechtel/Brewtifyer/releases/download/v#{version}/Brewtifyer-#{version}-macos-universal.zip"
  name "Brewtifyer"
  desc "Menu bar app for Homebrew updates"
  homepage "https://github.com/KevinCFechtel/Brewtifyer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Brewtifyer.app"

  zap trash: [
    "~/Library/Application Support/Brewtifyer",
    "~/Library/Logs/Brewtifyer",
    "~/Library/Preferences/com.kevincfechtel.Brewtifyer.plist",
  ]
end
```

Notes on the individual stanzas, all of them things CI will fail on:

- **`sha256`** must be the real checksum of the uploaded artifact, computed
  after upload. `brew audit --online` downloads the artifact and compares. Never
  emit a placeholder: a wrong hash does not just fail, it fails in the shape of
  a tampered download.
- **`url`** is a plain single-line URL. Do **not** add `verified:` — it is
  deprecated in current Homebrew, accepted only as a no-op, and it makes every
  `brew` command that loads the cask print a deprecation warning. Default URL
  verification covers the case where the download host matches the homepage,
  which it does here.
- **`desc`** must not name the platform. `brew style` rejects
  `"Menu bar app for Homebrew updates on macOS"` — the tap is macOS-only, so
  saying so is redundant. Start with a capital, no trailing period.
- **`livecheck`** with `strategy :github_latest` is what lets `brew livecheck`
  see new releases.
- **`depends_on macos:`** takes a bare symbol and means *that release or newer*:
  `depends_on macos: :sonoma`. Do not write `">= :sonoma"` — `brew style`
  flags it. The value must match the app's actual `LSMinimumSystemVersion`;
  `brew audit --online` reads it out of the built app and fails on a mismatch,
  so it has to track the deployment target, not a guess.
- **`app`** names the `.app` bundle exactly as it appears inside the zip.
- **`zap trash:`** must list every path the app creates — Application Support,
  Logs, Preferences, and anything else. Paths missing here are paths
  `brew uninstall --cask --zap` leaves behind, which is the one thing `--zap`
  exists to prevent.

## Do not include `auto_updates`

`auto_updates true` tells Homebrew the app updates itself and that `brew upgrade`
should leave it alone. These apps do not update themselves — Homebrew is the
update mechanism. Setting it would stop `brew upgrade` from ever updating them.

## Verifying before you push

From the app repository, generate the cask and check it against a real tap
checkout:

```sh
brew style --cask kevincfechtel/tap
brew audit --cask --online --strict --tap=kevincfechtel/tap
```

Both pass on an empty `Casks/` directory, so they are safe to run before the
first cask exists. `--online` needs network access and downloads the artifact,
so run it after the release is published, not before.
