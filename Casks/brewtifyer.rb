cask "brewtifyer" do
  version "1.1.0"
  sha256 "1825162c00fa0ed052f18c8535616ba020b107690885704cbd8637dfc8b9cf15"

  url "https://github.com/KevinCFechtel/Brewtifyer/releases/download/v#{version}/Brewtifyer-#{version}-macos-universal.zip"
  name "Brewtifyer"
  desc "Menu bar app for Homebrew formula and cask updates"
  homepage "https://github.com/KevinCFechtel/Brewtifyer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Brewtifyer.app"

  zap trash: [
    "~/Library/Application Support/Brewtifyer",
    "~/Library/Logs/Brewtifyer",
    "~/Library/Preferences/dev.kevincfechtel.Brewtifyer.plist",
  ]
end
