class Pji < Formula
  desc "A CLI for managing, finding, and opening Git repositories."
  homepage "https://github.com/zhanba/pji"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.7/pji-aarch64-apple-darwin.tar.xz"
      sha256 "f3d9dbc6c87fd9ad163154bce4d432314e0b52ed22bb9131fbae22a150f1f343"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.7/pji-x86_64-apple-darwin.tar.xz"
      sha256 "2a8419479954f51c3544410ec12766d4eff3d93bc3d9f17f04d8cde024985b2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.7/pji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ecd86f615cf042b2902d80b0b4a4d07918f1e6d64d6fb6602bbe694d58886f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.7/pji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "57ba62c3de351a0862e3861e45ef0a81d4d8ddde5312bfced2fd725891011499"
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
