class Loka < Formula
  desc "Loka command-line server for the mobile app"
  homepage "https://tryloka.dev"
  version "1.14.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/zhanba/loka/releases/download/cli/v1.14.1/cli-aarch64-apple-darwin.tar.xz"
    sha256 "2e30105ad1abc303ab792f40dd04caf4c93e9ca00a66a6bb93683989d9d01267"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.14.1/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a59c40acf13c9f04f62170dbbd7fee8ebcb35d47847b429b03f1f6392719cbae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.14.1/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f793254c7449990e44c5747f21b1f169b2d6ba2108eb74816268cbd67a181bf0"
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
