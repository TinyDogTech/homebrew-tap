class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.1/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "d2bf3e8f17804daf22943935f8dda8aab2cae74e372308cf9638d74ef598d89e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.1/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "d3cafe3bae146de7467bd2e9624780075a0690cab148eaf23dfb1684d4705417"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.1/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b67a4cfc42c498e1cad8820486c18bf9c6a87c5b35c8f829101793e2d924fc89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.1/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5390f807c1d465a11057d7a478a6c5297d86ceaabb5ec688e4723702a3d96b85"
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
