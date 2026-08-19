class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.3/prismtty-1.2.3-darwin-aarch64.tar.gz"
      sha256 "1673fa376407b4aaf1dcf1b16f1c09ad8b958e9f04ddca2609123d368b8c8c93"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.3/prismtty-1.2.3-darwin-x86_64.tar.gz"
      sha256 "12d05bf810798c502406c95cf72544db35894353ee99db0ec7db3f25d165b3be"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.3/prismtty-1.2.3-linux-x86_64.tar.gz"
      sha256 "7fbad07d51baf8c57a317c2a0a2a1a09cc08b3b6e0ebcbbc8005dcaabdd097ad"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.2.3"
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
