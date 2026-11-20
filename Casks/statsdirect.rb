cask "statsdirect" do
  version "1.1.7"
  sha256 "6851060495da83b7817a3356f43de409d6ee762b476bad621d772d6a4c068766"

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
