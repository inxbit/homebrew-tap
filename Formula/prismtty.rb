class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.8/prismtty-1.3.8-darwin-aarch64.tar.gz"
      sha256 "59e767963f97e6ef8b577bc2af4582506e71ec77b65826e3b0ff0f270956ef69"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.8/prismtty-1.3.8-darwin-x86_64.tar.gz"
      sha256 "f01c43bb0f1d46ac096e0a2b5472c569e49b3f9b550656dd8038f70397b8ec24"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.8/prismtty-1.3.8-linux-x86_64.tar.gz"
      sha256 "480693fc62e61ec6d07faab3b1617f038f7005aa7bd9a8f8d9f20a604e358552"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.8"
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
