class Stacc < Formula
  desc "A stacked-diff CLI."
  homepage "https://github.com/TinyDogTech/stacc"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.2/stacc-aarch64-apple-darwin.tar.xz"
      sha256 "ae5fdeec358fe91aa0cf01328ca38ac6875d839525e8ff71d0324b526e7c1814"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.2/stacc-x86_64-apple-darwin.tar.xz"
      sha256 "06b72b7b981715c5d3bae3fee2bedaf8a83d541831ee8ead3ab4616def9f1b70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.2/stacc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a36dff3fa668208a1730a3a44d2887a2a03751d34babd356fa915e595e5fa25f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TinyDogTech/stacc/releases/download/v0.4.2/stacc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51142878e5a8b986f16884abfde844b632d91e22a35e7c5cd7cc031cec7a0732"
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
