class Pji < Formula
  desc "A CLI for managing, finding, and opening Git repositories."
  homepage "https://github.com/zhanba/pji"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.6/pji-aarch64-apple-darwin.tar.xz"
      sha256 "8014ef4a38fb9ea69eca267284391f3fd33f7dcbd8f8e3a72dd7c563fa81d35f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.6/pji-x86_64-apple-darwin.tar.xz"
      sha256 "249a438837e721877b8ca5c93f44c90d256118ac505d7b36a2804ff94c864206"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.6/pji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c246159386069c947e978f97cd3b15247550c461ff6396dbc9fa61d7d2ddf685"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.6/pji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5ac9b472f9561e3ae779a59a0ae5d5f74c73c9c4f2ca2d3efd375cbddcf20b3"
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
