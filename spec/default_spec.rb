# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'opsmatic_support::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }  

  it 'creates a template /root/hosts-config.sh' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_template('/root/hosts-config.sh').with(
      mode:   0700
    )
    resource = chef_run.template('/root/hosts-config.sh')
    expect(resource).to notify('execute[run hosts-config]').to(:run).immediately
  end

  it 'runs execute on hosts-config' do
    chef_run.converge(described_recipe)
    expect(chef_run).to_not run_execute('/root/./hosts-config.sh')
  end

  it 'reloads ohai' do
    chef_run.converge(described_recipe)
    expect(chef_run).to reload_ohai('reload').with(
      action: [:reload]
    )
  end

  it 'creates a template /root/user-data.sh' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_template('/root/user-data.sh').with(
      mode:   0700
    )
    resource = chef_run.template('/root/user-data.sh')
    expect(resource).to notify('execute[replicate user-data]').to(:run).immediately
  end

  it 'runs execute on replicate user-data' do
    chef_run.converge(described_recipe)
    expect(chef_run).to_not run_execute('/root/./user-data.sh')
  end

  it 'creates a cron job for replicate user-data' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_cron_d('replicate user-data').with(
      predefined_value: '@reboot',
      command: '/root/./user-data.sh',
      action: [:create]
    )
  end

  it 'creates a cron job add_hostname_to_hosts' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_cron_d('add_hostname_to_hosts').with(
      predefined_value: '@reboot',
      command: '/root/./hosts-config.sh',
      action: [:create]
    )
  end
  it 'creates a template /root/opsmatic_config.sh' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_template('/root/opsmatic_config.sh').with(
      mode:   0700
    )
    resource = chef_run.template('/root/opsmatic_config.sh')
    expect(resource).to notify('execute[run opsmatic config]').to(:run).immediately
  end

  it 'runs execute on run opsmatic config' do
    chef_run.converge(described_recipe)
    expect(chef_run).to_not run_execute('/root/./opsmatic_config.sh')
  end

  it 'creates a cron job opsmatic_config_reboot_command' do
    chef_run.converge(described_recipe)
    expect(chef_run).to create_cron_d('opsmatic_config_reboot_command').with(
      predefined_value: '@reboot',
      command: '/root/./opsmatic_config.sh',
      action: [:create]
    )
  end
end

