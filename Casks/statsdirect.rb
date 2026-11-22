cask "statsdirect" do
  version "1.1.10"
  sha256 "ac5f0f6cc24d52eeb81e42d14c49c2be19b2e7fbba0ba6bddbec3be766ece99e"

  url "https://github.com/iain-buchan/statsdirect-mac/releases/download/v#{version}/StatsDirect-#{version}-macOS-arm64.zip"
  name "StatsDirect"
  desc "Statistical analysis and biostatistics learning"
  homepage "https://www.statsdirect.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "StatsDirect.app"
end
