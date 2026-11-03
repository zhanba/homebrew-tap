class Loka < Formula
  desc "Loka command-line server for the mobile app"
  homepage "https://tryloka.dev"
  version "1.14.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/zhanba/loka/releases/download/cli/v1.14.0/cli-aarch64-apple-darwin.tar.xz"
    sha256 "3776ae4939c0f9a79bf22d19fa9caa59168af830c6fd29300db42fc34112b350"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.14.0/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e19c380c2058ef38ae457e38fedc760b7b826d6f857f10453314fe872d5d698"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zhanba/loka/releases/download/cli/v1.14.0/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea9be4031466764b4215740df28c79752225d7f0c99b118927307dc258976916"
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
