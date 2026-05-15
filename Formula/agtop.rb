class Agtop < Formula
  desc "htop-like TUI for local AI coding agent sessions (Claude Code, Codex)"
  homepage "https://github.com/d1maash/agtop"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.4/agtop-aarch64-apple-darwin.tar.xz"
      sha256 "71bdb1a285d05c3eec58046f5bf882512c99d6fc90a4d2c357671abca186a074"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.4/agtop-x86_64-apple-darwin.tar.xz"
      sha256 "4c0a5b67199dd87cdb0028410c1925da301234d0acbe68d6b025c856e9512d9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.4/agtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb4751aca29222911b795dbf66b572971c2c687a6ffd231e75d628e8be19b7f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.4/agtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "becc10a2f26bdfc5a8937a4adbdafec6e35915339774195d9d371bc3db260a42"
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
