class Mercurio < Formula
  desc "Apprise-compatible Rust library, CLI and HTTP server to send notifications to 150+ services via a single URL."
  homepage "https://alphajack.github.io/mercurio"
  version "0.2.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.5/mercurio-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8cc218e0803454b3ffde4d9f18faabaa85ca7a4c44e8ffda214bd6dadba9a8cd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.5/mercurio-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "623ee88a563f36badaaa2d17f985522322a748f1c8c0f9263a67c90c2f3710f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/mercurio/releases/download/v0.2.5/mercurio-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f8a514f40862bf9220f260bb3c58cfb566457485bc788deb15542f0f9ce6ad53"
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
