class Pji < Formula
  desc "A CLI for managing, finding, and opening Git repositories."
  homepage "https://github.com/zhanba/pji"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.10/pji-aarch64-apple-darwin.tar.xz"
      sha256 "71bb4b8dc229e2d97675ac68f353dc192c98ad29cffce2b0ee57621ad8542b45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.10/pji-x86_64-apple-darwin.tar.xz"
      sha256 "09ab85841e5c8cc0ebe4187ab3f2f76f8a1eb63168d613418f50cb95ff73a308"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/pji/releases/download/v0.1.10/pji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b7c200bda3e61931ef8237cb504f7cac19a72aca0233879373c887a56dc4a79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/pji/releases/download/v0.1.10/pji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25a2c65929bfd2cbf894aabf105140fc24dc35b74b1704a6028ddbd17e79f13d"
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
