class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.5/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "6f7dcc7e971a753e42449aee6ce00157df5fcae9bc5a44411a1c6e9af1da8148"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.5/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "09b72cfa33b043589005625b4fbc3047e407c3bbe476602ba632b37beb6e2a1e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.5/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "992ba6e09bb6a9a6119f3f67fc9bdd795db4b41d82f752386fcd29c1463ccea4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.5/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "798e82ce19a1d27e47c53fff7bba745a65ad75597a8d3cf4aa59fbba7bbfa289"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "st", "stacc"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "st", "stacc"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "st", "stacc"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "st", "stacc"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
