# == Class: heat::policy
#
# Configure the heat policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for heat
#   Example :
#     {
#       'heat-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'heat-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the heat policy.json file
#   Defaults to /etc/heat/policy.json
#
class heat::policy (
  $policies    = {},
  $policy_path = '/etc/heat/policy.json',
) {

  include ::heat::deps
  include ::heat::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::heat::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'heat_config': policy_file => $policy_path }

}
