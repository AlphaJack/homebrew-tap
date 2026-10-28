class Rusticlone < Formula
  desc "Scheduled 3-2-1-1-0 backups for computers and servers built on rustic profiles, with UI and notifications"
  homepage "https://github.com/AlphaJack/rusticlone"
  version "2.0.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.2/rusticlone-aarch64-apple-darwin.tar.gz"
    sha256 "9f1cd33f0e9f024351647f63e838c8adcae7d66db77eb5f65b88bf2fd20cde27"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.2/rusticlone-aarch64-unknown-linux-musl.tar.gz"
      sha256 "def6414c5118d2651cba217f706341871ad4665f935d81fe7c7cca43d74ebb9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlphaJack/rusticlone/releases/download/v2.0.2/rusticlone-x86_64-unknown-linux-musl.tar.gz"
      sha256 "35d14d2033dd3acc52fe306655c205f0a2ca37306ee4596fa00df9f582110577"
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
