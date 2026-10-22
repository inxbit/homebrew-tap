class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.0/prismtty-1.3.0-darwin-aarch64.tar.gz"
      sha256 "0d099bafd1e364857047836405be0ccd7bc1f1a08d28b537ba8ca8baa9ed0272"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.0/prismtty-1.3.0-darwin-x86_64.tar.gz"
      sha256 "9f172f5709f7cfc95d26bf3ef84c0c433e59baf81efa5df7cbb337a21fe1a9ce"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.0/prismtty-1.3.0-linux-x86_64.tar.gz"
      sha256 "bf3049dbe08c74e7e0f6b734e1e7b17a92119d5a55845b22681803641086ffbc"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.0"
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
