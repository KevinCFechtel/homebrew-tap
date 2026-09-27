cask "brewtifyer" do
  version "1.0.0"
  sha256 "05401c45b22768ce10d4419ef172825ea6f437df4f2dea884e28bddb02d41660"

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
