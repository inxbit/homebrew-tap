class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.9/prismtty-1.3.9-darwin-aarch64.tar.gz"
      sha256 "7d4a937cd714a1c9a5aaf220938d2268121090afa088a1029234f705c0913070"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.9/prismtty-1.3.9-darwin-x86_64.tar.gz"
      sha256 "da22fb1e133a2b94c7af12172e6bb8f532e72f61e6c85ac60dcc9b6cdffbe6bd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.9/prismtty-1.3.9-linux-x86_64.tar.gz"
      sha256 "52718e15926d1879bf763c218a2b2b3755f8319e39301535e00da06848d0f9a4"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.9"
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
