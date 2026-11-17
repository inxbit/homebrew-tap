class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.1/prismtty-1.3.1-darwin-aarch64.tar.gz"
      sha256 "6c9baded9b380040fd079ebdd3ea4f210e6997f794803bdb44e380a32cc7d2fe"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.1/prismtty-1.3.1-darwin-x86_64.tar.gz"
      sha256 "48ff97feabf9b0c7e017073f4372548880dae43883cc489a470753df719f907a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.1/prismtty-1.3.1-linux-x86_64.tar.gz"
      sha256 "63af23c0c485fd6bae98b75b1779a99559fb520f02f176d6acb931b496660f43"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.1"
    end
  end

  def install
    bin.install "prismtty", "ptty", "ct"
    bash_completion.install "completions/prismtty.bash" => "prismtty"
    fish_completion.install "completions/prismtty.fish"
    # fish loads completions by command name; ptty and ct share prismtty.fish.
    fish_completion.install_symlink fish_completion/"prismtty.fish" => "ptty.fish"
    fish_completion.install_symlink fish_completion/"prismtty.fish" => "ct.fish"
    zsh_completion.install "completions/_prismtty"
    pkgshare.install "profiles"
  end

  test do
    assert_match "prismtty #{version}", shell_output("#{bin}/prismtty --version")
    assert_match "192.0.2.1", pipe_output("#{bin}/prismtty --profile generic", "192.0.2.1 down\n")
  end
end
