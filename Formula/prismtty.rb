class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.4/prismtty-1.2.4-darwin-aarch64.tar.gz"
      sha256 "a477edb60c0c5ae82c24db1fd074e8a5d57ec1e903da752715ed9447b1d21c79"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.4/prismtty-1.2.4-darwin-x86_64.tar.gz"
      sha256 "6539117b0154063d81ca0e545a5e37d9d396a893927b4a62ae59cecd8ee6eade"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.2.4/prismtty-1.2.4-linux-x86_64.tar.gz"
      sha256 "971bff59c202d91f4bfcdb93c3847740a3ec68a49cdc9ecfb7b6509d54f688c3"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.2.4"
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
