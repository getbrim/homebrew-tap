cask "brim" do
  version "1.0.10"
  sha256 "a522ea888074c5a6dd5466ca2fe990cb66be3941490bf2f5327e5612183e4476"

  url "https://brim-ehw.pages.dev/downloads/Brim-#{version}.zip"
  name "Brim"
  desc "Notch app for meetings, music, a file shelf and Claude Code sessions"
  homepage "https://brim-ehw.pages.dev/"

  livecheck do
    url "https://brim-ehw.pages.dev/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Brim.app"
  binary "#{appdir}/Brim.app/Contents/Helpers/brim"

  # Brim is signed with its own certificate but not notarized (that needs a paid Apple account),
  # so Gatekeeper would block the first launch of a quarantined copy. Same result as the curl installer.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "Brim.app"],
        chdir:          "{{appdir}}",
        writable_paths: ["Brim.app"],
        writable_base:  :appdir
  end

  uninstall quit: "dev.daniel.brim"

  zap trash: [
    "~/Library/Application Support/Brim",
    "~/Library/Preferences/dev.daniel.brim.plist",
  ]

  caveats <<~EOS
    Brim is not notarized by Apple; this cask removes the quarantine flag after install
    so it opens without the "Apple could not verify" dialog.
    It updates itself from the menu-bar icon → Check for Updates….
  EOS
end
