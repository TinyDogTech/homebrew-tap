class Stacc < Formula
  desc "Stacked-diff CLI for AI coding agents."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.1.0/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "3f6ee880c6f0c9a2a087332488556e1172dcbb40ffbefa2516fc794dfb1537b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.1.0/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "8045b7cb84af1b9b172860038e15d28b29124d4b3f07a1061bdd960d876eb404"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.1.0/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "945aff9ac286684e49a9be05a3b53f2af7286f4f9d2d6a9c3cbc79b742ba21f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.1.0/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c236e46c2bab985ebeb67fdb2b0ce39f345c67f2692c72474e63fa03d4697eb"
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
