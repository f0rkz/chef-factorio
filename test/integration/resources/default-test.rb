describe user('factorio') do
  its('home') { should eq '/opt/factorio' }
  its('shell') { should eq '/bin/bash' }
end

describe directory('/opt/factorio/factorio') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'factorio' }
  its('group') { should eq 'factorio' }
end

describe service('factorio') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe command('ps -ef | grep factorio') do
  its('exit_status') { should eq 0 }
end
