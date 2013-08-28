package 'libfontconfig1-dev'

phantom_package = 'phantomjs-1.9.1-linux-x86_64'
phantom_url = "https://phantomjs.googlecode.com/files/#{phantom_package}.tar.bz2"
phantom_tar = Helper.home('phantomjs.tar.bz2')
phantom_home = Helper.home('.phantomjs')
phantom_unpacked_path = Helper.home(phantom_package)

user_remote_file phantom_tar do
  source phantom_url
  mode '0644'
  not_if "test -e #{phantom_home}"
end

user_directory phantom_home do
  action :delete
  recursive true
  only_if "test -e #{phantom_tar}"
end

user_bash 'unpack phantomjs' do
  code "tar xvjf #{phantom_tar} -C #{Helper.home}"
  only_if "test -e #{phantom_tar}"
end

user_bash 'move phantomjs' do
  code "mv #{phantom_unpacked_path} #{phantom_home}"
  not_if "test -e #{phantom_home}"
end

user_file phantom_tar do
  action :delete
  only_if "test -e #{phantom_tar}"
end

zsh_file 'phantomjs'
