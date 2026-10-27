class Mercurio < Formula
  desc "Apprise-compatible Rust library, CLI and HTTP server to send notifications to 150+ services via a single URL."
  homepage "https://alphajack.github.io/mercurio"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.4/mercurio-cli-aarch64-apple-darwin.tar.xz"
    sha256 "17b5febc9d6a8c7370265e622b332146a7e4330ee7d59aaf47efacab34443339"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.4/mercurio-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b6972fa86526de1886bc98bf91ec5266fee3698376be5a003f401e152689509b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.4/mercurio-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e3fd15c17d3868201e8dc95d5f782f5f1d9e0773fb15f94bb002a601da9f9c4a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-pc-windows-gnu":                 {},
    "aarch64-unknown-linux-gnu":              {},
    "aarch64-unknown-linux-musl-dynamic":     {},
    "aarch64-unknown-linux-musl-static":      {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
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
      bin.install "mercurio"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mercurio"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mercurio"
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
