class Agtop < Formula
  desc "htop-like TUI for local AI coding agent sessions (Claude Code, Codex)"
  homepage "https://github.com/d1maash/agtop"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.3/agtop-aarch64-apple-darwin.tar.xz"
      sha256 "ea9939bea098fae2afbc49fbef4b8ce32af4d69917576f0c902d100bcb08c3bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.3/agtop-x86_64-apple-darwin.tar.xz"
      sha256 "f3d49f92bf50a3f6fe3ee95a0553e5787971acb414aa6bf880da16064556d00f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.3/agtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d01026ff9024b67c1a11df344409fbccb614e5de4beae6b5cffc863adbed5e20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.2.3/agtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab328222d23fd04603f7fca573e0418bf307bb0898a94076ac796eece4b60956"
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
