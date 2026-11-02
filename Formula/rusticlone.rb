class Rusticlone < Formula
  desc "Scheduled 3-2-1-1-0 backups for desktops and servers built on rustic profiles, with UI and notifications"
  homepage "https://github.com/AlphaJack/rusticlone"
  version "2.0.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.4/rusticlone-aarch64-apple-darwin.tar.gz"
    sha256 "3e139c034b43b752d61be6a9b7514a5371f8608ab009b5a3f69ec00e4ef8b5fa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.4/rusticlone-aarch64-unknown-linux-musl.tar.gz"
      sha256 "87a1f9276ae1e5ed0abc9f3af23f07383f9adefcd0b1a21e2687ab14493da8a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.4/rusticlone-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1daca177034b04b00dba99ee1f1a99cbaf37aafb2f2ee618eac8afe88d4cca39"
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
