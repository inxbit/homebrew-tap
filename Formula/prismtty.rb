class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.7/prismtty-1.3.7-darwin-aarch64.tar.gz"
      sha256 "ff808b22eef312c0c939dc4b801e7eed6887222eddb9e44734dd870b2dceb9cf"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.7/prismtty-1.3.7-darwin-x86_64.tar.gz"
      sha256 "4fa7f2b0aae73d3985068122a87cdb4026aa268c26f9b86423b4b12d6048d5f0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.7/prismtty-1.3.7-linux-x86_64.tar.gz"
      sha256 "61957aa6303bb65320454498df8cc4ca31328dd07f29bc43732da0cacda5b190"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.7"
    end
  end

  def install
    bin.install "prismtty", "ptty", "ct"
    bash_completion.install "completions/prismtty.bash" => "prismtty"
    # bash-completion loads a file on demand by command name; ptty and ct
    # share the prismtty one.
    bash_completion.install_symlink bash_completion/"prismtty" => "ptty"
    bash_completion.install_symlink bash_completion/"prismtty" => "ct"
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
