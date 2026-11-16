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

The [cask update workflow](https://github.com/iain-buchan/homebrew-statsdirect/actions/workflows/update-cask.yml)
checks GitHub's latest stable Mac release every 30 minutes. Before updating the cask, it verifies the versioned
ZIP's SHA-256, the StatsDirect Developer ID signature, and Apple's stapled notarisation ticket.

After promoting a signed release to **Latest**, you can also request an immediate check:

```sh
gh workflow run update-cask.yml --repo iain-buchan/homebrew-statsdirect
```

GitHub can pause recurring checks after 60 days of repository inactivity. Re-enable the workflow from its Actions
page if needed.
