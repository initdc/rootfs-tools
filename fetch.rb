CACHE_DIR = "cache"

REL = "20.04.4"
ARCH = "arm64"
FILE = "ubuntu-base-#{REL}-base-#{ARCH}.tar.gz"

URL = "https://cdimage.ubuntu.com/ubuntu-base/releases/#{REL}/release"

UBUNTU_BASE = "#{URL}/#{FILE}"
SHA256SUMS = "#{URL}/SHA256SUMS"

def fetch_ubuntu
    if !File.exist?("#{CACHE_DIR}/#{FILE}")
        `wget #{UBUNTU_BASE} -P #{CACHE_DIR}`
    end

    if !File.exist?("#{CACHE_DIR}/SHA256SUMS")
        `wget #{SHA256SUMS} -P #{CACHE_DIR}`
    end
end
