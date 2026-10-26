class Loka < Formula
  desc "Loka command-line server for the mobile app"
  homepage "https://tryloka.dev"
  version "1.13.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/zhanba/loka/releases/download/cli/v1.13.0/cli-aarch64-apple-darwin.tar.xz"
    sha256 "0261e5bad4a5f93a77cc7aaa57ec66d0afe225987971a3c5f64801e69d8fca07"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.13.0/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d85c57d95774c62aff9b5fa9d3b5725dc608658b39a726582a37f138369104b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.13.0/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2afc9f60d9379b6a8240026c419fd0c2c3ac8b3d75a210f53e6d83f3c3bec241"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "loka"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "loka"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "loka"
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
