require 'spec_helper'

describe 'heat::cache' do

  let :params do
    { }
  end

  shared_examples_for 'heat-cache' do

    context 'with default parameters' do
      it 'configures cache' do
        is_expected.to contain_heat_config('cache/config_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/expiration_time').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/backend').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/backend_argument').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/proxies').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/debug_cache_backend').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_servers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_dead_retry').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_socket_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_pool_maxsize').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_pool_unused_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/memcache_pool_connection_get_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_oslo__cache('heat_config').with_manage_backend_package(true)
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :config_prefix                        => 'prefix',
          :expiration_time                      => '3600',
          :backend                              => 'oslo_cache.memcache_pool',
          :proxies                              => ['proxy01:8888', 'proxy02:8888'],
          :enabled                              => true,
          :debug_cache_backend                  => false,
          :memcache_servers                     => ['memcached01:11211', 'memcached02:11211'],
          :memcache_dead_retry                  => '60',
          :memcache_socket_timeout              => '300.0',
          :memcache_pool_maxsize                => '10',
          :memcache_pool_unused_timeout         => '120',
          :memcache_pool_connection_get_timeout => '360',
          :manage_backend_package               => false,
        }
      end

      it 'configures cache' do
        is_expected.to contain_heat_config('cache/config_prefix').with_value('prefix')
        is_expected.to contain_heat_config('cache/expiration_time').with_value('3600')
        is_expected.to contain_heat_config('cache/backend').with_value('oslo_cache.memcache_pool')
        is_expected.to contain_heat_config('cache/backend_argument').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_heat_config('cache/proxies').with_value('proxy01:8888,proxy02:8888')
        is_expected.to contain_heat_config('cache/enabled').with_value('true')
        is_expected.to contain_heat_config('cache/debug_cache_backend').with_value('false')
        is_expected.to contain_heat_config('cache/memcache_servers').with_value('memcached01:11211,memcached02:11211')
        is_expected.to contain_heat_config('cache/memcache_dead_retry').with_value('60')
        is_expected.to contain_heat_config('cache/memcache_socket_timeout').with_value('300.0')
        is_expected.to contain_heat_config('cache/memcache_pool_maxsize').with_value('10')
        is_expected.to contain_heat_config('cache/memcache_pool_unused_timeout').with_value('120')
        is_expected.to contain_heat_config('cache/memcache_pool_connection_get_timeout').with_value('360')
        is_expected.to contain_oslo__cache('heat_config').with_manage_backend_package(false)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'heat-cache'
    end
  end

end
