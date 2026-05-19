class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  version "0.2.7"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-aarch64.tar.gz"
      sha256 "35f44f5038dcd4e010bc7a19ad69fda2af7b5b836c088e8f28b3f0f4ace63ba8"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-darwin-x86_64.tar.gz"
      sha256 "65df2d72294ebeec1f6a2bce9daf2b8e4cf6fe1b0046db985424f9eb6d5ad3ba"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v#{version}/prismtty-#{version}-linux-x86_64.tar.gz"
      sha256 "2bd053f284abe64b652c4366241cc6515f379b30d9f778db367ab0a0d6913616"
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
