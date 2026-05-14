class Agtop < Formula
  desc "htop-like TUI for local AI coding agent sessions (Claude Code, Codex)"
  homepage "https://github.com/d1maash/agtop"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.0/agtop-aarch64-apple-darwin.tar.xz"
      sha256 "8e606a3f65b3e1ee80f896b8e3bd3a91ffef573d9229df9f910484cf8ef31528"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.0/agtop-x86_64-apple-darwin.tar.xz"
      sha256 "f6d0d3d1258236f33d05a0e184b96fef6e115ebfe319155c56471cbdcd0c3bd1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.0/agtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c70e3d4b8542fdcbd92d197df14befe37b4f2f89a7118992a03f62a4494e288"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.0/agtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3cdc65f2cd212b79b4ec3e76ea5b59d70f36d59fae50f96cb821d8e7b563c824"
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
