class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.5/prismtty-1.2.5-darwin-aarch64.tar.gz"
      sha256 "ddb4c5fc93fc0486a345a59012ccf6452fa311d17a6d4bb53071666c3dba97e4"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.5/prismtty-1.2.5-darwin-x86_64.tar.gz"
      sha256 "441d819f4c39faad02c67968edb1d4d964e01a666976fedc99c82bfd158271d8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.5/prismtty-1.2.5-linux-x86_64.tar.gz"
      sha256 "8fc99d9d30caeb368b907c3c2729babeb8819bcb96b602e8227939ed80aa89d1"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.2.5"
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
