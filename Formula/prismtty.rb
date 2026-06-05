class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  version "1.0.10"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-aarch64.tar.gz"
      sha256 "e26e54770eb133bcfa1bfdebf5a3e97669bc5893e9891ec48f3863939762292e"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-x86_64.tar.gz"
      sha256 "7919968d6470ae00d031781d0c5d2633e269708fc99c4c7119e6a29858a0af66"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-linux-x86_64.tar.gz"
      sha256 "6974ca3b791abf146c33f6a558a02b8399e4b26fe36dc938bb3b57460ea4ba3d"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY #{version}"
    end
  end

  def install
    bin.install "prismtty", "ptty", "ct"
    bash_completion.install "completions/prismtty.bash" => "prismtty"
    fish_completion.install "completions/prismtty.fish"
    zsh_completion.install "completions/_prismtty"
    pkgshare.install "profiles"
  end

  test do
    assert_match "prismtty #{version}", shell_output("#{bin}/prismtty --version")
    assert_match "192.0.2.1", pipe_output("#{bin}/prismtty --profile generic", "192.0.2.1 down\n")
  end
end
