class Prismtty < Formula
  desc "Fast terminal highlighter focused on network devices and Unix administration"
  homepage "https://github.com/inxbit/prismtty"
  license "MIT"

  depends_on "pcre2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/inxbit/prismtty/releases/download/v1.5.1/prismtty-1.5.1-darwin-aarch64.tar.gz"
      sha256 "8288ecc0cc5613169f79dbc59fbbcb2f398a04afe56b6922bdb26138c4afb7b1"
    else
      url "https://github.com/inxbit/prismtty/releases/download/v1.5.1/prismtty-1.5.1-darwin-x86_64.tar.gz"
      sha256 "5c7a5346d6316a29f036a8381884e8837124a00936462205a7733b6c6c41bc52"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/inxbit/prismtty/releases/download/v1.5.1/prismtty-1.5.1-linux-x86_64.tar.gz"
      sha256 "985a392fad638e5eae19fd405fb2128c61be648c8d3f41617141a351432b9e8f"
    else
      odie "Linux ARM release artifacts are not published for PrismTTY 1.5.1"
    end
  end

  def install
    # Another package may already own ct in the prefix (chart-testing and
    # coreos-ct install one). Homebrew's link step fails on such a file and
    # then unlinks this whole formula, prismtty and ptty included, so ct and
    # everything that claims its name stay out of the linked directories.
    ct_taken = ct_owned_elsewhere?
    if ct_taken
      inreplace "completions/_prismtty", "#compdef prismtty ptty ct", "#compdef prismtty ptty"
      inreplace "completions/prismtty.bash", /^ +complete -F _ct .* ct\n/, "    :\n"
      inreplace "completions/prismtty.fish", /^complete -c ct .*\n/, ""
    end

    bin.install "prismtty", "ptty"
    bash_completion.install "completions/prismtty.bash" => "prismtty"
    # bash-completion loads a file on demand by command name; ptty and ct
    # share the prismtty one.
    bash_completion.install_symlink bash_completion/"prismtty" => "ptty"
    fish_completion.install "completions/prismtty.fish"
    # fish loads completions by command name; ptty and ct share prismtty.fish.
    fish_completion.install_symlink fish_completion/"prismtty.fish" => "ptty.fish"
    if ct_taken
      (libexec/"bin").install "ct"
    else
      bin.install "ct"
      bash_completion.install_symlink bash_completion/"prismtty" => "ct"
      fish_completion.install_symlink fish_completion/"prismtty.fish" => "ct.fish"
    end
    zsh_completion.install "completions/_prismtty"
    pkgshare.install "profiles"
  end

  # Whether bin/ct in the Homebrew prefix belongs to something other than this
  # formula. Homebrew unlinks the old keg before an upgrade or a reinstall, so
  # its own link is normally gone by now; the test for it covers the cases
  # where it is not. The answer is about the machine the install runs on: a
  # bottle would carry the answer of the machine that built it.
  def ct_owned_elsewhere?
    target = HOMEBREW_PREFIX/"bin/ct"
    if target.symlink?
      destination = (target.dirname/target.readlink).cleanpath.to_s
      return false if destination.start_with?("#{HOMEBREW_CELLAR}/#{name}/")
    end
    target.stat
    true
  rescue Errno::ENOENT
    # Nothing there, or a dangling link, which the link step replaces.
    false
  rescue SystemCallError
    # Something is there that the install cannot inspect.
    true
  end

  def caveats
    return unless (libexec/"bin/ct").exist?

    <<~EOS
      Another package already provides ct in #{HOMEBREW_PREFIX}/bin, so
      PrismTTY's ct was not linked. prismtty and ptty work as usual.
      To run PrismTTY as ct, put this directory first in your PATH:
        #{opt_libexec}/bin
      or remove the other ct and run:
        brew reinstall #{full_name}
    EOS
  end

  test do
    assert_match "prismtty #{version}", shell_output("#{bin}/prismtty --version")
    assert_match "192.0.2.1", pipe_output("#{bin}/prismtty --profile generic", "192.0.2.1 down\n")
  end
end
