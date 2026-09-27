cask "colimastatus" do
  version "1.0.0"
  sha256 "6f4f2149e2a47b47b8211e668550a2fed7e4270997b34b94fb212d2e043cc291"

  url "https://github.com/KevinCFechtel/ColimaStatus/releases/download/v#{version}/ColimaStatus-#{version}-macos-universal.zip"
  name "ColimaStatus"
  desc "Menu bar app for the Colima container runtime"
  homepage "https://github.com/KevinCFechtel/ColimaStatus"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ColimaStatus.app"

  zap trash: [
    "~/Library/Application Support/ColimaStatus",
    "~/Library/Logs/ColimaStatus",
    "~/Library/Preferences/dev.kevincfechtel.ColimaStatus.plist",
  ]
end
