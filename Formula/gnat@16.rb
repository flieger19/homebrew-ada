class GnatAT16 < Formula
  desc "Builds of the GNAT Ada compiler from FSF GCC releases"
  homepage "https://github.com/alire-project/GNAT-FSF-builds"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-rc2/gnat-aarch64-darwin-16.1.0-rc2.tar.gz"
      sha256 "3f2d131d58e2900b42adbd7753f9b89dbaa9cd136e79aa575a51ebb169916c93"
    else
      url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-rc2/gnat-x86_64-darwin-16.1.0-rc2.tar.gz"
      sha256 "f3695dab40555799c56527f9b8ee6d27f23ce0ad05b00ebb3c528ff7e951288b"
    end
  end

  def install
    bin.install Dir["bin/*"] if Dir.exist?("bin")
    include.install Dir["include/*"] if Dir.exist?("include")
    lib.install Dir["lib/*"] if Dir.exist?("lib")
    libexec.install Dir["libexec/*"] if Dir.exist?("libexec")
    share.install Dir["share/*"] if Dir.exist?("share")
  end

  test do
    (testpath/"hello.adb").write <<~ADA
      with Ada.Text_IO;

      procedure Hello is
      begin
        Ada.Text_IO.Put_Line("Hello");
      end Hello;
    ADA

    system bin/"gnatmake", "hello.adb"
    assert_match "Hello", shell_output("./hello")
  end
end
