class Pji < Formula
  desc "A CLI for managing, finding, and opening Git repositories."
  homepage "https://github.com/zhanba/pji"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.9/pji-aarch64-apple-darwin.tar.xz"
      sha256 "7b914ed4749feea61201f5302014203117431f5f65e7479fcf39dfcb7e0a8aeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.9/pji-x86_64-apple-darwin.tar.xz"
      sha256 "81251c277c71d2c0f5a97d9b743b5aba6dd29b3e5ee9613ca44283115dda4135"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.9/pji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1602eb781463c2b88fa9fe4b05a0f035bcf23b835f179c4c990f077080e26733"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.9/pji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f65d1bdadddee921f8e4515f953a150b295212d0973cc487b70f95dea93a0c3e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "pji" if OS.mac? && Hardware::CPU.arm?
    bin.install "pji" if OS.mac? && Hardware::CPU.intel?
    bin.install "pji" if OS.linux? && Hardware::CPU.arm?
    bin.install "pji" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
