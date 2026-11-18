class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.2/prismtty-1.3.2-darwin-aarch64.tar.gz"
      sha256 "5e0a0dc06faac00c726686e942716787483951b6222af958a4cb17bfc217a2e7"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.2/prismtty-1.3.2-darwin-x86_64.tar.gz"
      sha256 "6cb4b50850e635effcc37f95c24217b9c06e7f3b3ea6b744c35432c20540579a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.3.2/prismtty-1.3.2-linux-x86_64.tar.gz"
      sha256 "f3c0eba5e0112d25c98a3e9b427fea0299c09a8cfdfeedb4be571803cb3dbb5e"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.3.2"
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
