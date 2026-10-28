class Rusticlone < Formula
  desc "Scheduled 3-2-1-1-0 backups for computers and servers built on rustic profiles, with UI and notifications"
  homepage "https://github.com/AlphaJack/rusticlone"
  version "2.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.1/rusticlone-aarch64-apple-darwin.tar.gz"
      sha256 "b248e64977c68b54fb74758d14dba48293a60705f56f189de851da6e9e442e9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.1/rusticlone-x86_64-apple-darwin.tar.gz"
      sha256 "a2e171b80364a127a3d050c1937bbd86c8be4b34270aba226baa3c800315989e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.1/rusticlone-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9e6d90e5c2da653e2fa90826e082a18a822ce418af80fa84cb81b4671fa346f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.1/rusticlone-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4cb90ab8fe724594140500c5b3841d9051915767ae1d722c0b69ffdba7fd18f9"
    end
  end
  license "AGPL-3.0-or-later"
  depends_on "rustic"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-unknown-linux-gnu":              {},
    "aarch64-unknown-linux-musl-dynamic":     {},
    "aarch64-unknown-linux-musl-static":      {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
    "x86_64-apple-darwin":                    {},
    "x86_64-pc-windows-gnu":                  {},
    "x86_64-unknown-linux-gnu":               {},
    "x86_64-unknown-linux-musl-dynamic":      {},
    "x86_64-unknown-linux-musl-static":       {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rusticlone"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rusticlone"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rusticlone"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rusticlone"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
