class Pji < Formula
  desc "A CLI for managing, finding, and opening Git repositories."
  homepage "https://github.com/zhanba/pji"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.2.0/pji-aarch64-apple-darwin.tar.xz"
      sha256 "dec03f2b1e7b411aa992f2f3f6f3e43fdfbd96708f7b4c35bb75a13f74e8a657"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.2.0/pji-x86_64-apple-darwin.tar.xz"
      sha256 "6a3cd78300f5215f822d4428aaf15f4f35912629158f108350a1c7e4de96f652"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.2.0/pji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3ee708174bb2f175987aef90a8b330bc9eaa93cee7b4eae3ea13e92555d0815"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.2.0/pji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88fbeb048416f7af6b9932c2402c83ac3c2b6b21d95de58df54dcacd691d7b99"
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
