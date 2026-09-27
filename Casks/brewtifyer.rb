cask "brewtifyer" do
  version "1.0.1"
  sha256 "7ebf3465fd03fa5bc810378257382849c6896948a200a27c3e0e726f48aadd9e"

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
