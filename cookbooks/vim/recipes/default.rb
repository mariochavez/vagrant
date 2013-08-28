vimrc_dir = Helper.home('.vimrc')
vim_dir = Helper.home('.vim')
vim_dotfiles_dir = Helper.home('.vim_dotfiles')
user_directory vim_dotfiles_dir

powerline_font_url = 'https://github.com/Lokaltog/powerline-fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf'
powerline_font_home = Helper.home('.fonts')
powerline_font_file = Helper.home('Inconsolata-Powerline.otf')

package 'vim-nox'

git vim_dotfiles_dir do
  user 'vagrant'
  repository 'https://github.com/mariochavez/vim-dot-files.git'
  reference 'master'
  action :checkout
  enable_submodules true
end

bash "link #{vimrc_dir}" do
  code <<-EOH
  ln -s #{vim_dotfiles_dir}/vimrc #{vimrc_dir}
  EOH
  not_if "test -e #{vimrc_dir}"
end

bash "link #{vim_dir}" do
  code <<-EOH
  ln -s #{vim_dotfiles_dir} #{vim_dir}
  EOH
  not_if "test -e #{vim_dir}"
end

bash 'build command-t' do
  code <<-EOH
  cd #{vim_dotfiles_dir}/bundle/command-t/ruby/command-t
  ruby extconf.rb
  make clean
  make
  EOH
end

%w{python python-pip}.each do |pkg|
  package pkg
end

bash 'install powerline' do
  code <<-EOH
  pip install --user git+git://github.com/Lokaltog/powerline
  EOH
end

user_directory powerline_font_home do
  action :create
  not_if "test -e #{powerline_font_home}"
end

user_remote_file powerline_font_file do
  source powerline_font_url
  mode '0644'
  not_if "test -e #{powerline_font_home}"
end

user_bash 'move powerline font' do
  code "mv #{powerline_font_file} #{powerline_font_home}; fc-cache -vf #{powerline_font_home}"
  only_if "test -e #{powerline_font_file}"
end
