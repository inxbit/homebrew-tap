class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  version "1.0.3"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-aarch64.tar.gz"
      sha256 "05f3d9b9da5ff774144db640e3e3dd3ca2b17decca6f81956ccffb2a864e274f"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-x86_64.tar.gz"
      sha256 "360e0822ad7b1e0fa16851de858185e7ba5e119355c952fde6824e90f64de65f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-linux-x86_64.tar.gz"
      sha256 "c1280b5989e72bd63f9c59710364c53d4bfe4ae39da223a7558ba1c69190cb8d"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY #{version}"
    end
  end

  def install
    bin.install "prismtty", "ptty", "ct"
    bash_completion.install "completions/prismtty.bash" => "prismtty"
    fish_completion.install "completions/prismtty.fish"
    zsh_completion.install "completions/_prismtty"
    pkgshare.install "profiles"
  end

  test do
    assert_match "prismtty #{version}", shell_output("#{bin}/prismtty --version")
    assert_match "192.0.2.1", pipe_output("#{bin}/prismtty --profile generic", "192.0.2.1 down\n")
  end
end
