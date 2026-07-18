class Orca < Formula
  desc "Local evidence-gated mission control for AI coding work"
  homepage "https://henryvn27.github.io/orca-framework/"
  url "https://github.com/henryvn27/orca-framework/releases/download/v1.0.0/orca-1.0.0.tar.gz"
  sha256 "972bc7733c04f8267404ccb25014332c31a34bca4cea9f1a874b866f5d160fc8"
  license "MIT"

  depends_on "ruby"

  def install
    libexec.install Dir["*"]
    (bin/"orca").write_env_script libexec/"bin/orca", PATH: "#{Formula["ruby"].opt_bin}:$PATH"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/orca version").strip
    mkdir testpath/"project" do
      system bin/"orca", "mission", "create", "Verify the Homebrew install",
             "--criterion", "The formula lifecycle passes", "--by", "Homebrew test"
      system bin/"orca", "mission", "satisfy", "AC-1",
             "--evidence", "Installed formula executed", "--by", "Homebrew test"
      system bin/"orca", "mission", "complete", "--by", "Homebrew test"
      system bin/"orca", "mission", "validate"
    end
  end
end
