class Agtop < Formula
  desc "htop-like TUI for local AI coding agent sessions (Claude Code, Codex)"
  homepage "https://github.com/d1maash/agtop"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.2/agtop-aarch64-apple-darwin.tar.xz"
      sha256 "953a5aaac1462dc51feba9b9284e9a735c7b2a21c70024631a59ac3e64b90709"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.2/agtop-x86_64-apple-darwin.tar.xz"
      sha256 "269e751da42b223f38f61b4ad3c1aa6b1991c0ef1a38467f5db732830fe020a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.2/agtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a098574ca0bb21605b14d81044fc35b8c9cf08f55f3f1f154507a982a5b43d9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.2/agtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02c77629f2573b1bb5bb0cc1ba890ac15f6aa5d980ebdf7b9c7571a4b6bfbc9b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "agtop" if OS.mac? && Hardware::CPU.arm?
    bin.install "agtop" if OS.mac? && Hardware::CPU.intel?
    bin.install "agtop" if OS.linux? && Hardware::CPU.arm?
    bin.install "agtop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
