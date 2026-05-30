class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  version "1.0.8"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-aarch64.tar.gz"
      sha256 "53f6bb9e9a196e930aec8690db5f9b28c0a21a7895271facccba42c35f7f3bef"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-x86_64.tar.gz"
      sha256 "55a9378fac566f0157f2777c012a198994f49de579830e48072d0303d4cff479"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-linux-x86_64.tar.gz"
      sha256 "e6a81c6857dd4828dda51915bca34babf0ad91a59f91b0fe47cfbd39d27ee6b7"
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
