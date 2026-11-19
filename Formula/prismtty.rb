class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.6/prismtty-1.3.6-darwin-aarch64.tar.gz"
      sha256 "e552ff05ddd103f187bdd2196c4b01b995d025dc7f6d790083d43b7a86513bde"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.6/prismtty-1.3.6-darwin-x86_64.tar.gz"
      sha256 "7830b109bfc07de610e77543c90785885b2fba109d9c0a32f51adf289f5e24e7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.6/prismtty-1.3.6-linux-x86_64.tar.gz"
      sha256 "29713a9d5d83b88c5cc0b977bf70fb84d1c21ded8a85613ca319bd567a293205"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.6"
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
