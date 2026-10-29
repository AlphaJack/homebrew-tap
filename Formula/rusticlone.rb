class Rusticlone < Formula
  desc "Scheduled 3-2-1-1-0 backups for computers and servers built on rustic profiles, with UI and notifications"
  homepage "https://github.com/AlphaJack/rusticlone"
  version "2.0.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.3/rusticlone-aarch64-apple-darwin.tar.gz"
    sha256 "3c509dfa8820ecbb53ee7bdeaa7e2b6fa9fe15ba51a07b56ba6df60663dc82d9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.3/rusticlone-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2b8ecffcc97651c955dfe5f8abd663f04c26487750bc4311f4a6b4972fe69d91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.3/rusticlone-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b2f776d75bbbbc082f0614c590a761fa1f15f453c99c9f70eb743e33b42bb2a7"
    end
  end
  license "AGPL-3.0-or-later"
  depends_on "rustic"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
