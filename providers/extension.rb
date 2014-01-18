action :install do
  case node['platform']
  when "windows"
    install_dir = "#{node['firefox']['dir']}/extensions/"
    root_user = "administrator"
    root_group = "administrators"
  when "mac_os_x","mac_os_x_server"
    install_dir ='/Library/Application Support/Mozilla/Extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/'
    root_user = "root"
    root_group = "wheel"
  when "debian","ubuntu"
    install_dir ='/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/'
    root_user = "root"
    root_group = "root"
  end

  directory "#{install_dir}#{new_resource.id}" do
    user root_user
    group root_group
    mode 0755
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{new_resource.name}" do
    source new_resource.uri
    backup false
    user root_user
    group root_group
    mode 0755
    action :create
    notifies :create, "ruby_block[unpack-extension]", :delayed
  end
  
  ruby_block "unpack-extension" do
    block do
      require 'zip'
      require 'fileutils'
      ::File.umask(0022)
      FileUtils.rm_rf(Dir.glob("#{install_dir}#{new_resource.id}/*"))
      Zip::ZipFile.open("#{Chef::Config[:file_cache_path]}/#{new_resource.name}") do |zip_file|
        zip_file.each do |f|
          f_path=::File.join("#{install_dir}#{new_resource.id}", f.name)
          FileUtils.mkdir_p(::File.dirname(f_path))
          zip_file.extract(f, f_path) unless ::File.exist?(f_path)
        end
      end
    end
    if ::File.exists?("#{install_dir}#{new_resource.id}/chrome.manifest") then
      action :nothing
    else
      action :create
    end
  end
  
end

action :remove do
  case node['platform']
  when "windows"
    install_dir = "C:\\Program Files (x86)\\Mozilla Firefox\\extensions\\{ec8030f7-c20a-464f-9b0e-13a3a9e97384}\\"
    root_user = "administrator"
    root_group = "administrators"
  when "mac_os_x","mac_os_x_server"
    install_dir ='/Library/Application Support/Mozilla/Extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/'
    root_user = "root"
    root_group = "wheel"
  when "debian","ubuntu"
    install_dir ='/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/'
    root_user = "root"
    root_group = "root"
  end

  file "#{install_dir}#{new_resource.id}" do
    action :delete
  end
end
