plugins_dir = Helper.home('.ohmyzsh')

package 'zsh'

home_directory '.zsh'

zsh_files_dir = Helper.home('.zsh')

git plugins_dir do
  repository 'https://github.com/robbyrussell/oh-my-zsh.git'
  reference 'master'
  action :checkout
end

%w(bundler gem git history-substring-search rails4 tmux).each do |plugin|
  bash "link #{plugin}" do
    code <<-EOH
    ln -s #{plugins_dir}/plugins/#{plugin} #{zsh_files_dir}/#{plugin}
    EOH
    not_if "test -e #{zsh_files_dir}/#{plugin}"
  end

  unless %w(history-substring-search gem).include?(plugin)
    file "#{zsh_files_dir}/#{plugin}.zsh" do
      content "source #{zsh_files_dir}/#{plugin}/#{plugin}.plugin.zsh"
      mode "0755"
      action :create_if_missing
    end
  end
end

file "#{zsh_files_dir}/history-substring-search.zsh" do
  content "source #{zsh_files_dir}/history-substring-search/history-substring-search.zsh"
  mode "0755"
  action :create_if_missing
end

git "#{zsh_files_dir}/zsh-syntax-highlighting" do
  repository 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
  reference 'master'
  action :sync
end

zsh_file 'zsh-syntax-highlighting'

zsh_file 'prompt'

user_cookbook_file '.zshrc'

bash 'make ZSH the default login shell' do
  code "sudo chsh -s `which zsh` #{Helper.user}"
end
