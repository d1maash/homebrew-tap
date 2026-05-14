class Agtop < Formula
  desc "htop-like TUI for local AI coding agent sessions (Claude Code, Codex)"
  homepage "https://github.com/d1maash/agtop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.1.0/agtop-aarch64-apple-darwin.tar.xz"
      sha256 "44c88c5cee35326dca37b2909b562f306d0d440748d7a2ca49895f141fab5aa6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.1.0/agtop-x86_64-apple-darwin.tar.xz"
      sha256 "a534f68515174683bc7075e917707c2343f3c18bf26daa40cad0bc857aeab398"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/d1maash/agtop/releases/download/v0.1.0/agtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72f21d6591480e8c39743a2cf5913a98286599915c300d910e456e10782f74f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/d1maash/agtop/releases/download/v0.1.0/agtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d3f609559c16fba7e8f6e9f8f59daff3d30a7ce1c41d49d6bdef0f0653246dd3"
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
