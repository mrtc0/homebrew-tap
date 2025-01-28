class OslogCollector < Formula
  homepage 'https://github.com/mrtc0/oslog-collector'
  version '0.0.1'

  if Hardware::CPU.arm?
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.1/oslog-collector_v0.0.1_darwin_arm64.zip'
    sha256 '8e7ae963f1680a03386ec59a3be18f215a23e4f826e49b36095d6ed12ee48850'
  else
    url 'https://github.com/mrtc0/oslog-collector/releases/download/v0.0.1/oslog-collector_v0.0.1_darwin_amd64.zip'
    sha256 '6f9737d777b8f9781d20f27593262f32da6b29ca3250c9a4fe9022fc69411efb'
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
