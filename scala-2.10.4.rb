require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.10.4.tgz'
  sha1 '970f779f155719838e81a267a7418a958fd4c13f'

  bottle do
    cellar :any
    sha1 "da4919e3f11b1d10923e12c20ba50f738db58380" => :mavericks
    sha1 "15ecc67ac62795c1ae7a9fae01838bea412df6ec" => :mountain_lion
    sha1 "10784c54d59746277a6f0535ef9d3ff4974fad56" => :lion
  end

  option 'with-docs', 'Also install library documentation'
  option 'with-src', 'Also install sources for IDE support'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.10.4.zip'
    sha1 '7ad47f9634fd2f452cadf35f7241102207c1a1cc'
  end

  resource 'src' do
    url 'https://github.com/scala/scala/archive/v2.11.2.tar.gz'
    sha1 '52654124565a1706e9e6d0ad7b0969d319628847'
  end

  resource 'completion' do
    url 'https://raw.githubusercontent.com/scala/scala-dist/v2.11.2/bash-completion/src/main/resources/completion.d/2.9.1/scala'
    sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource('completion')
    doc.install resource('docs') if build.with? 'docs'
    libexec.install resource('src').files('src') if build.with? 'src'

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/'idea'
    idea.install_symlink libexec/'src', libexec/'lib'
    (idea/'doc/scala-devel-docs').install_symlink doc => 'api'
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/'hello.scala'
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(2 + 2)
        }
      }
    EOS
    output = `'#{bin}/scala' #{file}`
    assert_equal "4", output.strip
    assert $?.success?
  end
end
