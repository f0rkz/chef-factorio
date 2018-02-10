name 'chef-factorio'
maintainer 'Nick Gray'
maintainer_email 'f0rkz@f0rkznet.net'
license 'Apache-2.0'
description 'Installs and configures a Factorio dedicated server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/f0rkz/chef-factorio/issues'
source_url 'https://github.com/f0rkz/chef-factorio'

%w(ubuntu debian).each do |os|
  supports os
end
