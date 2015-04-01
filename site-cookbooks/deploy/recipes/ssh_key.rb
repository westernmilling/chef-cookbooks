ruby_block 'to add local user ssh key' do
  block do
    key = File.read("#{ENV['HOME']}/.ssh/id_rsa.pub")

    file = Chef::Util::FileEdit.new("/home/deploy/.ssh/authorized_keys")
    file.insert_line_if_no_match("/#{key}/", key)
    file.write_file
  end
end
