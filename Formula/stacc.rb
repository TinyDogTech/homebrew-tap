class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.0/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "ae26917a6e12b50ae83e04d8ca42cdb01d54118a16caa50fd2fca9383560b56a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.0/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "5880ee4cf366d01eab24f7d922bc703ad34f81e5600f703c6a39155e05cd900f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.0/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "640246587850c1ba1823db03163377667a2bc0b2a0963f0ece95afb0c32a963c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.0/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad32e337bcfb19e817633be7a39484bf8070711748a695d9065193f870d54161"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "st", "stacc" if OS.mac? && Hardware::CPU.arm?
    bin.install "st", "stacc" if OS.mac? && Hardware::CPU.intel?
    bin.install "st", "stacc" if OS.linux? && Hardware::CPU.arm?
    bin.install "st", "stacc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
