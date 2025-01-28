class OslogCollector < Formula
  homepage 'https://github.com/mrtc0/oslog-collector'
  version '0.0.1'

  if Hardware::CPU.arm?
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.1/oslog-collector_v0.0.1_darwin_arm64.zip'
    sha256 '327dd4cb94c6674d131a595939c0e8bca18365997d80f39763c9556f318797bb'
  else
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.1/oslog-collector_v0.0.1_darwin_amd64.zip'
    sha256 '47b6eeb45be22f444ee37b3bcf9683d60e3f504729718cff9d97f1ce3e091805'
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
