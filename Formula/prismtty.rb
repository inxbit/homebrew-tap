class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.5/prismtty-1.3.5-darwin-aarch64.tar.gz"
      sha256 "c67b0baaef2fecdadf226dbcfba1cfe86a0bd4ef581e71fd8d7f7d4b79f7d892"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.5/prismtty-1.3.5-darwin-x86_64.tar.gz"
      sha256 "37a97e66153997b645ac21eb356b7cdd09f58d3bdf0ca57a90c21f52406031a7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.5/prismtty-1.3.5-linux-x86_64.tar.gz"
      sha256 "49d9b62bc4cc8bfcf70823846206d22400bd45f348338e8feb28999626d45539"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.5"
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
