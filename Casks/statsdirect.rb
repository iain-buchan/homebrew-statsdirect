cask "statsdirect" do
  version "1.1.5"
  sha256 "219a8155f548e37ca2cb85c44a658c244d89600583d2f63758e997fbc14cca85"

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
