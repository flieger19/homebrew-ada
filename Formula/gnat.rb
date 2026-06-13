class Gnat < Formula
  desc "Builds of the GNAT Ada compiler from FSF GCC releases"
  homepage "https://github.com/alire-project/GNAT-FSF-builds"
  url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-15.2.0-1/gnat-x86_64-darwin-15.2.0-1.tar.gz"
  sha256 "fffe07e8732738a33e6ddc209debc23640e9e629584d30ad8ebee278999c7a0f"
  license "MIT"

  depends_on arch: :x86_64

  def install
    bin.install Dir["bin/*"] if Dir.exist?("bin")
    include.install Dir["include/*"] if Dir.exist?("include")
    lib.install Dir["lib/*"] if Dir.exist?("lib")
    libexec.install Dir["libexec/*"] if Dir.exist?("libexec")
    share.install Dir["share/*"] if Dir.exist?("share")

    wrap_with_sysroot "gcc"
    wrap_with_sysroot "g++"
    wrap_with_sysroot "x86_64-apple-darwin22.6.0-gcc"
    wrap_with_sysroot "x86_64-apple-darwin22.6.0-g++"
  end

  def wrap_with_sysroot(name)
    return unless (bin/name).exist?

    mv bin/name, bin/"#{name}.real"
    (bin/name).write <<~EOS
      #!/bin/sh
      exec "#{bin}/#{name}.real" "$@" -isysroot "$(xcrun --sdk macosx --show-sdk-path)"
    EOS
    chmod 0755, bin/name
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
