class OslogCollector < Formula
  homepage 'https://github.com/mrtc0/oslog-collector'
  version '0.0.2'

  if Hardware::CPU.arm?
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.2/oslog-collector_v0.0.2_darwin_arm64.zip'
    sha256 '4339a7870d949d4b004b0034207851d17b55cd17bb45997caa1e224f4d5d57b2'
  else
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.2/oslog-collector_v0.0.2_darwin_amd64.zip'
    sha256 '16c2a4ae496d743126f49f9ccff926e54a434eb3f075b176e5fba68e504d1811'
  end

  head do
    url 'https://github.com/mrtc0/oslog-collector.git'
    depends_on 'go' => :build
  end

  def install
    if build.head?
      system 'make', 'build'
      bin.install 'bin/oslog-collector'
      etc.install 'oslog-collector.sample.conf' => 'oslog-collector.conf'
    else
      bin.install 'oslog-collector'
      etc.install 'oslog-collector.sample.conf' => 'oslog-collector.conf'
    end

    mkdir_p "#{var}/oslog-collector"
  end

  service do
    run ["#{opt_bin}/oslog-collector", "#{etc}/oslog-collector.conf"]
    keep_alive true
    working_dir "#{var}/oslog-collector"
    error_log_path "#{var}/log/oslog-collector.log"
  end
end
