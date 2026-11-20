cask "statsdirect" do
  version "1.1.8"
  sha256 "fce4262be344e6e9a7af6dc0bc0d0003302fbbbfe668d19be99de9be7e0b2e98"

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
