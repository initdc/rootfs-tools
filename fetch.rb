# frozen_string_literal: true

REL = "22.04"
CODENAME = "jammy"
ARCH = "amd64"

def fetch_ubuntu_base(cache_dir)
    url = "https://cdimage.ubuntu.com/ubuntu-base/releases/#{REL}/release"
    file = "ubuntu-base-#{REL}-base-#{ARCH}.tar.gz"
    sha256 = "#{url}/SHA256SUMS"

    unless File.exist?("#{cache_dir}/#{file}")
        `wget #{url}/#{file} -P #{cache_dir}`
    end

    `curl -L #{sha256} >> #{cache_dir}/SHA256SUMS`
end

def fetch_ubuntu_minimal(cache_dir)
    url = "https://cloud-images.ubuntu.com/minimal/releases/#{CODENAME}/release/"
    file = "ubuntu-#{REL}-minimal-cloudimg-#{ARCH}-root.tar.xz"
    sha256 = "#{url}/SHA256SUMS"

    unless File.exist?("#{cache_dir}/#{file}")
        `wget #{url}/#{file} -P #{cache_dir}`
    end

    `curl -L #{sha256} >> #{cache_dir}/SHA256SUMS`
end
