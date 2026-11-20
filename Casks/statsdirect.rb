cask "statsdirect" do
  version "1.1.6"
  sha256 "4d578c5010496b9082d2e630bf591543a4d1008de55bcadb190d1cf7880920d0"

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
