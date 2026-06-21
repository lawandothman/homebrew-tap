class Kp < Formula
  desc "Kill whatever is listening on a port — fast."
  homepage "https://github.com/lawandothman/kp"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lawandothman/kp/releases/download/v0.1.0/kp-aarch64-apple-darwin.tar.xz"
      sha256 "d30b801dbdebcfb0a8f94a5f33c1bc0a36f1a92ec0aa34a7f817b0be8b1af236"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lawandothman/kp/releases/download/v0.1.0/kp-x86_64-apple-darwin.tar.xz"
      sha256 "3eeb686b00aeccb9f9fb81d2cc505e085eee4e39d64bb10dc3582197960a8c2a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "kp" if OS.mac? && Hardware::CPU.arm?
    bin.install "kp" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
