require 'open-uri'
require_relative 'tar'

include Util::Tar

class JdkHelper

  def self.extract_jdk path, extract_folder
    FileUtils.remove_dir extract_folder, :force => true
    io = ungzip File.new(path, "r")
    untar io, Dir.tmpdir
    jdk_bin_dir = "#{extract_folder}/bin"
    File.chmod(0755, "#{jdk_bin_dir}/jjs")
    File.chmod(0755, "#{jdk_bin_dir}/javac")
    File.chmod(0755, "#{jdk_bin_dir}/java")
  end

  def self.download_binary_file url, destination_file
    puts "Downloading #{url}..."
    bindata = open(url, 'rb') {|file| file.read }
    IO.binwrite(destination_file, bindata)
  end

  def self.get_jdk9_linux64_download_url
    get_jdk_download_url 'lin64JDKrpm', 'https://jdk9.java.net/download/'
  end

  def self.get_jdk8_linux64_download_url
    get_jdk_download_url 'lin64JDKrpm', 'https://jdk8.java.net/download.html'
  end

  def self.get_jdk_download_url jdk_id, url
    html = open(url) {|file| file.read }
    jdk_url_regexp = /document\.getElementById\(\"#{jdk_id}\"\)\.href = \"http:\/\/www.java.net\/download\/(.*)\";/
    # Avoid redirection http -> https
    "http://download.java.net/#{html.match(jdk_url_regexp).captures[0]}"
  end
end
