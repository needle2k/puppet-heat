# == Class: heat::engine
#
#  Installs & configure the heat engine service
#
# === Parameters
# [*auth_encryption_key*]
#   (required) Encryption key used for authentication info in database
#   Must be either 16, 24, or 32 bytes long.
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to 'present'
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to 'true'
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*heat_stack_user_role*]
#   (optional) Keystone role for heat template-defined users.
#   This setting does not actually create the role. If you change
#   this to a different value you should also set
#   heat::keystone::auth::heat_stack_user_role if you want the
#   correct role created.
#   Defaults to $::os_service_default.
#
# [*heat_metadata_server_url*]
#   (optional) URL of the Heat metadata server
#   Defaults to $::os_service_default.
#
# [*heat_waitcondition_server_url*]
#   (optional) URL of the Heat waitcondition server
#   Defaults to $::os_service_default.
#
# [*engine_life_check_timeout*]
#   (optional) RPC timeout (in seconds) for the engine liveness check that is
#   used for stack locking
#   Defaults to $::os_service_default.
#
# [*deferred_auth_method*]
#   (optional) Select deferred auth method.
#   Can be "password" or "trusts".
#   Defaults to $::os_service_default.
#
# [*default_software_config_transport*]
#   (optional) Template default for how the server should receive the metadata
#   required for software configuration. POLL_SERVER_CFN will allow calls to the
#   cfn API action DescribeStackResource authenticated with the provided keypair
#   (requires enabled heat-api-cfn). POLL_SERVER_HEAT will allow calls to the
#   Heat API resource-show using the provided keystone credentials (requires
#   keystone v3 API, and configured stack_user_* config options). POLL_TEMP_URL
#   will create and populate a Swift TempURL with metadata for polling (requires
#   object-store endpoint which supports TempURL). (string value)
#   Allowed values: POLL_SERVER_CFN, POLL_SERVER_HEAT, POLL_TEMP_URL
#   Defaults to $::os_service_default.
#
# [*default_deployment_signal_transport*]
#   (optional) Template default for how the server should signal to heat with
#   the deployment output values. CFN_SIGNAL will allow an HTTP POST to a CFN
#   keypair signed URL (requires enabled heat-api-cfn). TEMP_URL_SIGNAL will
#   create a Swift TempURL to be signaled via HTTP PUT (requires object-store
#   TempURL). HEAT_SIGNAL will allow calls to the Heat API resource-signal using
#   endpoint which supports the provided keystone credentials (string value)
#   Allowed values: CFN_SIGNAL, TEMP_URL_SIGNAL, HEAT_SIGNAL
#   Defaults to $::os_service_default.
#
# [*default_user_data_format*]
#   (optional) Template default for how the user_data should be
#   formatted for the server. For HEAT_CFNTOOLS, the
#   user_data is bundled as part of the heat-cfntools
#   cloud-init boot configuration data. For RAW the
#   user_data is passed to Nova unmodified. For
#   SOFTWARE_CONFIG user_data is bundled as part of the
#   software config data, and metadata is derived from any
#   associated SoftwareDeployment resources.
#   Allowed values: HEAT_CFNTOOLS, RAW, SOFTWARE_CONFIG
#   Defaults to $::os_service_default.

# [*trusts_delegated_roles*]
#   (optional) Array of trustor roles to be delegated to heat.
#   This value is also used by heat::keystone::auth if it is set to
#   configure the keystone roles.
#   Defaults to $::os_service_default.
#
# [*instance_connection_is_secure*]
#   (Optional) Instance connection to CFN/CW API via https.
#   Defaults to $::os_service_default
#
# [*instance_connection_https_validate_certificates*]
#   (Optional) Instance connection to CFN/CW API validate certs if SSL is used.
#   Defaults to $::os_service_default
#
# [*max_resources_per_stack*]
#   (Optional) Maximum resources allowed per top-level stack.
#   Defaults to $::os_service_default
#
# [*num_engine_workers*]
#   (Optional) The number of workers to spawn.
#   Defaults to $::os_workers_heat_engine
#
# [*convergence_engine*]
#   (Optional) Enables engine with convergence architecture.
#   Defaults to $::os_service_default.
#
# [*reauthentication_auth_method*]
#   (Optional) Re-authentication method on token expiry.
#   Defaults to $::os_service_default.
#
# [*environment_dir*]
#   (Optional) The directory to search for environment files.
#   Defaults to $::os_service_default
#
# [*template_dir*]
#   (Optional) The directory to search for template files.
#   Defaults to $::os_service_default
#
# [*max_nested_stack_depth*]
#   (Optional) Maximum depth allowed when using nested stacks.
#   Defaults to $::os_service_default
#
# [*plugin_dirs*]
#   (Optional) List of directories to search for plug-ins.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*heat_watch_server_url*]
#   (optional) URL of the Heat cloudwatch server
#   Defaults to undef.

class heat::engine (
  $auth_encryption_key,
  $package_ensure                                  = 'present',
  $manage_service                                  = true,
  $enabled                                         = true,
  $heat_stack_user_role                            = $::os_service_default,
  $heat_metadata_server_url                        = $::os_service_default,
  $heat_waitcondition_server_url                   = $::os_service_default,
  $engine_life_check_timeout                       = $::os_service_default,
  $deferred_auth_method                            = $::os_service_default,
  $default_software_config_transport               = $::os_service_default,
  $default_deployment_signal_transport             = $::os_service_default,
  $default_user_data_format                        = $::os_service_default,
  $trusts_delegated_roles                          = $::os_service_default,
  $instance_connection_is_secure                   = $::os_service_default,
  $instance_connection_https_validate_certificates = $::os_service_default,
  $max_resources_per_stack                         = $::os_service_default,
  $num_engine_workers                              = $::os_workers_heat_engine,
  $convergence_engine                              = $::os_service_default,
  $reauthentication_auth_method                    = $::os_service_default,
  $environment_dir                                 = $::os_service_default,
  $template_dir                                    = $::os_service_default,
  $max_nested_stack_depth                          = $::os_service_default,
  $plugin_dirs                                     = $::os_service_default,
  # DEPRECATED PARAMETERS
  $heat_watch_server_url                           = undef,
) {

  include ::heat::deps

  if $heat_watch_server_url {
    warning('heat_watch_server_url has no effect and will be removed in a future release.')
  }

  # Validate Heat Engine AES key
  # must be either 16, 24, or 32 bytes long
  # https://bugs.launchpad.net/heat/+bug/1415887
  $allowed_sizes = ['16','24','32']
  $param_size = size($auth_encryption_key)
  if ! (member($allowed_sizes, "${param_size}")) { # lint:ignore:only_variable_string
    fail("${param_size} is not a correct size for auth_encryption_key parameter, it must be either 16, 24, 32 bytes long.")
  }

  include ::heat
  include ::heat::params

  # plugin_dirs value follows these rules:
  # - default is $::os_service_default so Puppet won't try to configure it.
  # - if set, array validation will be done for not empty and then configure the parameter.
  # - Otherwise, fallback to default.
  if !is_service_default($plugin_dirs) and !empty($plugin_dirs) {
    validate_legacy(Array, 'validate_array', $plugin_dirs)

    $plugin_dirs_real = join($plugin_dirs, ',')
  } else {
    $plugin_dirs_real = $::os_service_default
  }

  package { 'heat-engine':
    ensure => $package_ensure,
    name   => $::heat::params::engine_package_name,
    tag    => ['openstack', 'heat-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'heat-engine':
    ensure     => $service_ensure,
    name       => $::heat::params::engine_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'heat-service',
  }

  heat_config {
    'DEFAULT/auth_encryption_key':                             value => $auth_encryption_key, secret => true;
    'DEFAULT/heat_stack_user_role':                            value => $heat_stack_user_role;
    'DEFAULT/heat_metadata_server_url':                        value => $heat_metadata_server_url;
    'DEFAULT/heat_waitcondition_server_url':                   value => $heat_waitcondition_server_url;
    'DEFAULT/engine_life_check_timeout':                       value => $engine_life_check_timeout;
    'DEFAULT/default_software_config_transport':               value => $default_software_config_transport;
    'DEFAULT/default_deployment_signal_transport':             value => $default_deployment_signal_transport;
    'DEFAULT/default_user_data_format':                        value => $default_user_data_format;
    'DEFAULT/trusts_delegated_roles':                          value => $trusts_delegated_roles;
    'DEFAULT/deferred_auth_method':                            value => $deferred_auth_method;
    'DEFAULT/max_resources_per_stack':                         value => $max_resources_per_stack;
    'DEFAULT/instance_connection_https_validate_certificates': value => $instance_connection_https_validate_certificates;
    'DEFAULT/instance_connection_is_secure':                   value => $instance_connection_is_secure;
    'DEFAULT/num_engine_workers':                              value => $num_engine_workers;
    'DEFAULT/convergence_engine':                              value => $convergence_engine;
    'DEFAULT/reauthentication_auth_method':                    value => $reauthentication_auth_method;
    'DEFAULT/environment_dir':                                 value => $environment_dir;
    'DEFAULT/template_dir':                                    value => $template_dir;
    'DEFAULT/max_nested_stack_depth':                          value => $max_nested_stack_depth;
    'DEFAULT/plugin_dirs':                                     value => $plugin_dirs_real;
  }
}
