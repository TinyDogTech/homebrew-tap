class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.3.0/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "6ae449f2a24e97085d45b2d64e891df6389bc6fbccd2c4641e45aef16c0613d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.3.0/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "c8b743de80ec18e167210495b00f4a31f66f6d474d49ea95a64947fe357d0e4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.3.0/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "871d27082efa8cbc1b886f6ba853c54c0acb516e7805ba7bb08e6b07c2547d5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.3.0/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3e28dfff26fa24ab8ab8b2d0f85d0cbc8c7766f41268769b6c610e8df3d05af"
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
