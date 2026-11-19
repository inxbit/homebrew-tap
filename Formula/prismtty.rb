class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.4/prismtty-1.3.4-darwin-aarch64.tar.gz"
      sha256 "35f721be85664c22c7fb31ada6b9ff7b665e9eaecc6f27aa1fd44e5c30e1667a"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.4/prismtty-1.3.4-darwin-x86_64.tar.gz"
      sha256 "8f2191a9f60d7d27bad4acd67bea14e7fa3ab4f05fd38b9f6932b2be2fb2c0ac"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.4/prismtty-1.3.4-linux-x86_64.tar.gz"
      sha256 "530f1608f7769c1bf9a5eebbd402b0a2ee103efdc32881834f3c88fff4bb6e5b"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.4"
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
