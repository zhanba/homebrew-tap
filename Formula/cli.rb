class Cli < Formula
  desc "Loka command-line server for the mobile app"
  homepage "https://github.com/zhanba/loka"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/loka/releases/download/cli/v0.1.3/cli-aarch64-apple-darwin.tar.xz"
      sha256 "6a079fbbe4833fa3750656a942c591bd95760aba77221e264fdbae4bdb035608"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/loka/releases/download/cli/v0.1.3/cli-x86_64-apple-darwin.tar.xz"
      sha256 "ca4006c322af89c8c32143d8d1e1c2cf460c19a67ba8c97f2f76afc07d00d96f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/loka/releases/download/cli/v0.1.3/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b68556a855047c1763caf25576cce551ce0b2615902fdfca4e53155c7612d01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/loka/releases/download/cli/v0.1.3/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a65b66c31f667d6f07c1c1acd0cf5bc5191a788afe34b51256700b504f7c9fd"
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
    bin.install "loka" if OS.mac? && Hardware::CPU.arm?
    bin.install "loka" if OS.mac? && Hardware::CPU.intel?
    bin.install "loka" if OS.linux? && Hardware::CPU.arm?
    bin.install "loka" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
