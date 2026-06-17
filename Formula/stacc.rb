class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.2.0/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "2d3eb3c0dcfd9522780eb60009fb509b245822ef1f07781243a23ee162806b85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.2.0/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "8c087eb68ed20df3e48bd5ca770fafe74abdfc659faf73aae0862979afd433d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.2.0/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd43d15aef3cd7b546b333716b964f0f9d3c4c263fb6c02ae4c03d2c827f1394"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.2.0/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8942bfb901cb5f600ae61a59723b7140b0a37645c447b5cb041abd7fc2234eb6"
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
