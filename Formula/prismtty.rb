class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.3/prismtty-1.3.3-darwin-aarch64.tar.gz"
      sha256 "81084110847cc1d303425608d73791243af44b50f94d07f4bba8ffcf81e2697b"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.3/prismtty-1.3.3-darwin-x86_64.tar.gz"
      sha256 "de24c9e8d2786360112adfdb3426db7ec13a6e9cb5c54f4196448a2e20931e84"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.3/prismtty-1.3.3-linux-x86_64.tar.gz"
      sha256 "aa4a539705809308be977d6495fec408249a8625070246aa8d287cedb35d3c54"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.3"
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
