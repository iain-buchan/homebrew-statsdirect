# StatsDirect Homebrew tap

Install StatsDirect on an Apple Silicon Mac with macOS 14 or later.

```sh
brew install --cask iain-buchan/statsdirect/statsdirect
```

The cask uses the same signed and notarised ZIP as the [StatsDirect Mac release](https://github.com/iain-buchan/statsdirect-mac/releases/latest). R is optional. StatsDirect guides you through installing it when an analysis needs it.

StatsDirect checks for app updates. To request an update through Homebrew, run:

```sh
brew upgrade --cask --greedy iain-buchan/statsdirect/statsdirect
```

For each new stable Mac release, update the cask's version and SHA-256 using that release's versioned signed ZIP.
