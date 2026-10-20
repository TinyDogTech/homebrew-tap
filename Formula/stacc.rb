class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.3/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "f56c328f72485c202fc4f4d6d62dd4f3fb00d5bfc04fea96f91b30c12f2de240"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.3/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "a97eb6d1811a1d7258b1e1af9a213b88077c27a38cec1d98639195f45541104d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.3/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6c65d5370eb2228b065e7b013d3dcaae2cfab95f4eafda6b18c2fbfae8c4ac8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.3/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ac9fd6f618ef41daaf319f9fa53bcedea462b6643bd85a61604b300c2315fdf"
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
