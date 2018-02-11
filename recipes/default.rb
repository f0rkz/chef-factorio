#
# Cookbook:: chef-factorio
# Recipe:: default
#
# Author:: Nick Gray (f0rkz@f0rkznet.net)
#
# Copyright:: 2018 f0rkznet.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

factorio_bin = "#{node['factorio']['install_dir']}/factorio/bin/x64/factorio"
server_conf = "#{node['factorio']['config_dir']}/server-settings.json"
map_gen_conf = "#{node['factorio']['config_dir']}/map-gen-settings.json"

package 'wget'
package 'curl'

if node['factorio']['version'] == 'stable'
  doc = `(curl --url "#{node['factorio']['download_url']}")`
else
  doc = `(curl --url "#{node['factorio']['download_url']}/experimental")`
end

version_url = doc[%r{/get-download\/[\S]+\/headless\/linux64}]
version = version_url[/[0-9]+\.+[0-9]+\.+[0-9]+/]
download_url = "https://www.factorio.com/get-download/#{version}/headless/linux64"

user node['factorio']['user'] do
  comment 'Factorio gameserver user'
  system true
  shell '/bin/bash'
  home node['factorio']['install_dir']
  manage_home false
end

directory node['factorio']['install_dir'] do
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0755'
  recursive true
  action :create
end

directory node['factorio']['save_dir'] do
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0755'
  recursive true
  action :create
end

directory node['factorio']['log_dir'] do
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0755'
  recursive true
  action :create
end

directory node['factorio']['config_dir'] do
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0755'
  recursive true
  action :create
end

remote_file "#{node['factorio']['install_dir']}/factorio.tar.xz" do
  source download_url
  owner node['factorio']['user']
  group node['factorio']['user']
  notifies :run, 'execute[extract factorio]', :immediately
end

execute 'extract factorio' do
  command "tar xf #{node['factorio']['install_dir']}/factorio.tar.xz"
  cwd node['factorio']['install_dir']
  user node['factorio']['user']
  group node['factorio']['user']
  action :nothing
end

template map_gen_conf do
  source 'map-gen-settings.json.erb'
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0744'
  variables({
    map_settings: node['factorio']['map_gen_settings'],
    coal: node['factorio']['map_gen_settings']['autoplace_controls']['coal'],
    copper_ore: node['factorio']['map_gen_settings']['autoplace_controls']['copper_ore'],
    crude_oil: node['factorio']['map_gen_settings']['autoplace_controls']['crude_oil'],
    enemy_base: node['factorio']['map_gen_settings']['autoplace_controls']['enemy_base'],
    iron_ore: node['factorio']['map_gen_settings']['autoplace_controls']['iron_ore'],
    stone: node['factorio']['map_gen_settings']['autoplace_controls']['stone'],
    uranium: node['factorio']['map_gen_settings']['autoplace_controls']['uranium']
  })
end

template server_conf do
  source 'server-settings.json.erb'
  owner node['factorio']['user']
  group node['factorio']['user']
  mode '0744'
  variables({
    game_settings: node['factorio']['game_settings']
  })
end

unless File.exist?("#{node['factorio']['save_dir']}/#{node['factorio']['save_name']}.zip")
  execute 'create map' do
    command <<-EOL
    #{factorio_bin} --map-gen-settings #{map_gen_conf} --create #{node['factorio']['save_dir']}/#{node['factorio']['save_name']}
    EOL
    user node['factorio']['user']
    group node['factorio']['user']
    action :run
  end
end

template '/etc/systemd/system/factorio.service' do
  source 'factorio.service.erb'
  owner 'root'
  group 'root'
  mode '0744'
  variables({
    working_directory: node['factorio']['install_dir'],
    exec_start: factorio_bin,
    save_dir: node['factorio']['save_dir'],
    save_name: node['factorio']['save_name'],
    config_dir: node['factorio']['config_dir'],
    server_options: node['factorio']['server_options'],
    user: node['factorio']['user'],
    group: node['factorio']['user']
  })
end

service 'factorio' do
  supports status: true
  action [:enable, :start]
end
