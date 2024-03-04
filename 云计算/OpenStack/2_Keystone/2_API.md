# Mapping of policy target to API 策略目标到 API 的映射

​                                          

The following table shows the target in the policy.yaml file for each API.
下表显示了每个 API 的 policy.yaml 文件中的目标。

| Target 目标                                                  | API                                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| identity:get_region 身份：get_region                         | GET /v3/regions/{region_id} 获取 /v3/regions/{region_id}     |
| identity:list_regions 身份：list_regions                     | GET /v3/regions 获取 /v3/regions                             |
| identity:create_region 身份：create_region                   | POST /v3/regions POST /v3/区域                               |
| identity:update_region 身份：update_region                   | PATCH /v3/regions/{region_id} 补丁 /v3/regions/{region_id}   |
| identity:delete_region 身份：delete_region                   | DELETE /v3/regions/{region_id} 删除 /v3/regions/{region_id}  |
| identity:get_service 身份：get_service                       | GET /v3/services/{service_id} 获取 /v3/services/{service_id} |
| identity:list_services 身份：list_services                   | GET /v3/services 获取 /v3/services                           |
| identity:create_service 身份：create_service                 | POST /v3/services POST /v3/服务                              |
| identity:update_service 身份：update_service                 | PATCH /v3/services/{service__id} 补丁 /v3/services/{service__id} |
| identity:delete_service 身份：delete_service                 | DELETE /v3/services/{service__id} 删除 /v3/services/{service__id} |
| identity:get_endpoint 身份：get_endpoint                     | GET /v3/endpoints/{endpoint_id} 获取 /v3/endpoints/{endpoint_id} |
| identity:list_endpoints 身份：list_endpoints                 | GET /v3/endpoints GET /v3/端点                               |
| identity:create_endpoint 身份：create_endpoint               | POST /v3/endpoints POST /v3/端点                             |
| identity:update_endpoint 身份：update_endpoint               | PATCH /v3/endpoints/{endpoint_id} 补丁 /v3/endpoints/{endpoint_id} |
| identity:delete_endpoint 身份：delete_endpoint               | DELETE /v3/endpoints/{endpoint_id} 删除 /v3/endpoints/{endpoint_id} |
| identity:get_registered_limit 身份：get_registered_limit     | GET /v3/registered_limits/{registered_limit_id} 获取 /v3/registered_limits/{registered_limit_id} |
| identity:list_registered_limits 身份：list_registered_limits | GET /v3/registered_limits 获取 /v3/registered_limits         |
| identity:create_registered_limits 身份：create_registered_limits | POST /v3/registered_limits 开机自检 /v3/registered_limits    |
| identity:update_registered_limit 身份：update_registered_limit | PATCH /v3/registered_limits/{registered_limit_id} 补丁 /v3/registered_limits/{registered_limit_id} |
| identity:delete_registered_limit 身份：delete_registered_limit | DELETE /v3/registered_limits/{registered_limit_id} 删除 /v3/registered_limits/{registered_limit_id} |
| identity:get_limit 身份：get_limit                           | GET /v3/limits/{limit_id} 获取 /v3/limits/{limit_id}         |
| identity:list_limits 身份：list_limits                       | GET /v3/limits 获取 /v3/限制                                 |
| identity:create_limits 身份：create_limits                   | POST /v3/limits 开机自检 /v3/限制                            |
| identity:update_limit 身份：update_limit                     | PATCH /v3/limits/{limit_id} 补丁 /v3/limits/{limit_id}       |
| identity:delete_limit 身份：delete_limit                     | DELETE /v3/limits/{limit_id} 删除 /v3/limits/{limit_id}      |
| identity:get_limit_model 身份：get_limit_model               | GET /v3/limits/model HEAD /v3/limits/model 获取 /v3/limits/model HEAD /v3/limits/model |
| identity:get_domain 身份：get_domain                         | GET /v3/domains/{domain_id} 获取 /v3/domains/{domain_id}     |
| identity:list_domains 身份：list_domains                     | GET /v3/domains GET /v3/域                                   |
| identity:create_domain 身份：create_domain                   | POST /v3/domains POST /v3/域                                 |
| identity:update_domain 身份：update_domain                   | PATCH /v3/domains/{domain_id} 补丁 /v3/domains/{domain_id}   |
| identity:delete_domain 身份：delete_domain                   | DELETE /v3/domains/{domain_id} 删除 /v3/domains/{domain_id}  |
| identity:get_project 身份：get_project                       | GET /v3/projects/{project_id} 获取 /v3/projects/{project_id} |
| identity:list_projects 身份：list_projects                   | GET /v3/projects 获取 /v3/projects                           |
| identity:list_user_projects 身份：list_user_projects         | GET /v3/users/{user_id}/projects 获取 /v3/users/{user_id}/projects |
| identity:create_project 身份：create_project                 | POST /v3/projects 发布 /v3/projects                          |
| identity:update_project 身份：update_project                 | PATCH /v3/projects/{project_id} 补丁 /v3/projects/{project_id} |
| identity:delete_project 身份：delete_project                 | DELETE /v3/projects/{project_id} 删除 /v3/projects/{project_id} |
| identity:get_project_tag 身份：get_project_tag               | GET /v3/projects/{project_id}/tags/{tag_name} HEAD /v3/projects/{project_id}/tags/{tag_name} |
| identity:list_project_tags 身份：list_project_tags           | GET /v3/projects/{project_id}/tags HEAD /v3/projects/{project_id}/tags |
| identity:create_project_tag 身份：create_project_tag         | PUT /v3/projects/{project_id}/tags/{tag_name}                |
| identity:update_project_tags 身份：update_project_tags       | PUT /v3/projects/{project_id}/tags                           |
| identity:delete_project_tag 身份：delete_project_tag         | DELETE /v3/projects/{project_id}/tags/{tag_name} 删除 /v3/projects/{project_id}/tags/{tag_name} |
| identity:delete_project_tags 身份：delete_project_tags       | DELETE /v3/projects/{project_id}/tags 删除 /v3/projects/{project_id}/tags |
| identity:get_user 身份：get_user                             | GET /v3/users/{user_id} 获取 /v3/users/{user_id}             |
| identity:list_users 身份：list_users                         | GET /v3/users 获取 /v3/用户                                  |
| identity:create_user 身份：create_user                       | POST /v3/users POST /v3/用户                                 |
| identity:update_user 身份：update_user                       | PATCH /v3/users/{user_id} 补丁 /v3/users/{user_id}           |
| identity:delete_user 身份：delete_user                       | DELETE /v3/users/{user_id} 删除 /v3/users/{user_id}          |
| identity:get_group 身份：get_group                           | GET /v3/groups/{group_id} 获取 /v3/groups/{group_id}         |
| identity:list_groups 身份：list_groups                       | GET /v3/groups 获取 /v3/组                                   |
| identity:list_groups_for_user 身份：list_groups_for_user     | GET /v3/users/{user_id}/groups 获取 /v3/用户/{user_id}/组    |
| identity:create_group 身份：create_group                     | POST /v3/groups POST /v3/组                                  |
| identity:update_group 身份：update_group                     | PATCH /v3/groups/{group_id} 补丁 /v3/groups/{group_id}       |
| identity:delete_group 身份：delete_group                     | DELETE /v3/groups/{group_id} 删除 /v3/groups/{group_id}      |
| identity:list_users_in_group 身份：list_users_in_group       | GET /v3/groups/{group_id}/users 获取 /v3/groups/{group_id}/users |
| identity:remove_user_from_group 身份：remove_user_from_group | DELETE /v3/groups/{group_id}/users/{user_id} 删除 /v3/groups/{group_id}/users/{user_id} |
| identity:check_user_in_group 身份：check_user_in_group       | GET /v3/groups/{group_id}/users/{user_id} 获取 /v3/groups/{group_id}/users/{user_id} |
| identity:add_user_to_group 身份：add_user_to_group           | PUT /v3/groups/{group_id}/users/{user_id}                    |
| identity:get_credential 身份：get_credential                 | GET /v3/credentials/{credential_id} 获取 /v3/凭据/{credential_id} |
| identity:list_credentials 身份：list_credentials             | GET /v3/credentials 获取 /v3/凭据                            |
| identity:create_credential 身份：create_credential           | POST /v3/credentials POST /v3/凭据                           |
| identity:update_credential 身份：update_credential           | PATCH /v3/credentials/{credential_id} 补丁 /v3/credentials/{credential_id} |
| identity:delete_credential 身份：delete_credential           | DELETE /v3/credentials/{credential_id} 删除 /v3/credentials/{credential_id} |
| identity:ec2_get_credential 身份：ec2_get_credential         | GET /v3/users/{user_id}/credentials/OS-EC2/{credential_id} 获取 /v3/users/{user_id}/credentials/OS-EC2/{credential_id} |
| identity:ec2_list_credentials 身份：ec2_list_credentials     | GET /v3/users/{user_id}/credentials/OS-EC2 获取 /v3/users/{user_id}/credentials/OS-EC2 |
| identity:ec2_create_credential 身份：ec2_create_credential   | POST /v3/users/{user_id}/credentials/OS-EC2 开机自检 /v3/users/{user_id}/credentials/OS-EC2 |
| identity:ec2_delete_credential 身份：ec2_delete_credential   | DELETE /v3/users/{user_id}/credentials/OS-EC2/{credential_id} 删除 /v3/users/{user_id}/credentials/OS-EC2/{credential_id} |
| identity:get_role 身份：get_role                             | GET /v3/roles/{role_id} 获取 /v3/roles/{role_id}             |
| identity:list_roles 身份：list_roles                         | GET /v3/roles 获取 /v3/roles                                 |
| identity:create_role 身份：create_role                       | POST /v3/roles POST /v3/角色                                 |
| identity:update_role 身份：update_role                       | PATCH /v3/roles/{role_id} 补丁 /v3/roles/{role_id}           |
| identity:delete_role 身份：delete_role                       | DELETE /v3/roles/{role_id} 删除 /v3/roles/{role_id}          |
| identity:get_domain_role 身份：get_domain_role               | GET /v3/roles/{role_id} where role.domain_id is not null GET /v3/roles/{role_id}，其中 role.domain_id 不为空 |
| identity:list_domain_roles 身份：list_domain_roles           | GET /v3/roles?domain_id where role.domain_id is not null GET /v3/roles？domain_id其中 role.domain_id 不为 null |
| identity:create_domain_role 身份：create_domain_role         | POST /v3/roles where role.domain_id is not null POST /v3/roles，其中 role.domain_id 不为 null |
| identity:update_domain_role 身份：update_domain_role         | PATCH /v3/roles/{role_id} where role.domain_id is not null PATCH /v3/roles/{role_id}，其中 role.domain_id 不为空 |
| identity:delete_domain_role 身份：delete_domain_role         | DELETE /v3/roles/{role_id} where role.domain_id is not null 删除 /v3/roles/{role_id}，其中 role.domain_id 不为空 |
| identity:get_implied_role 身份：get_implied_role             | GET /v3/roles/{prior_role_id}/implies/{implied_role_id} 获取 /v3/roles/{prior_role_id}/implies/{implied_role_id} |
| identity:list_implied_roles 身份：list_implied_roles         | GET /v3/roles/{prior_role_id}/implies GET /v3/roles/{prior_role_id}/暗示 |
| identity:create_implied_role 身份：create_implied_role       | PUT /v3/roles/{prior_role_id}/implies/{implied_role_id}      |
| identity:delete_implied_role 身份：delete_implied_role       | DELETE /v3/roles/{prior_role_id}/implies/{implied_role_id} 删除 /v3/roles/{prior_role_id}/implies/{implied_role_id} |
| identity:list_role_inference_rules 身份：list_role_inference_rules | GET /v3/role_inferences 获取 /v3/role_inferences             |
| identity:check_implied_role 身份：check_implied_role         | HEAD /v3/roles/{prior_role_id}/implies/{implied_role_id}     |
| identity:check_grant 身份：check_grant                       | GET [grant_resources](https://docs.openstack.org/keystone/yoga/getting-started/policy_mapping.html#grant-resources) 获取grant_resources |
| identity:list_grants 身份：list_grants                       | GET [grant_collections](https://docs.openstack.org/keystone/yoga/getting-started/policy_mapping.html#grant-collections) 获取grant_collections |
| identity:create_grant 身份：create_grant                     | PUT [grant_resources](https://docs.openstack.org/keystone/yoga/getting-started/policy_mapping.html#grant-resources) 放grant_resources |
| identity:revoke_grant 身份：revoke_grant                     | DELETE [grant_resources](https://docs.openstack.org/keystone/yoga/getting-started/policy_mapping.html#grant-resources) 删除grant_resources |
| identity:list_system_grants_for_user 身份：list_system_grants_for_user | GET /v3/system/users/{user_id}/roles 获取 /v3/system/users/{user_id}/roles |
| identity:check_system_grant_for_user 身份：check_system_grant_for_user | GET /v3/system/users/{user_id}/roles/{role_id} 获取 /v3/system/users/{user_id}/roles/{role_id} |
| identity:create_system_grant_for_user 身份：create_system_grant_for_user | PUT /v3/system/users/{user_id}/roles/{role_id}               |
| identity:revoke_system_grant_for_user 身份：revoke_system_grant_for_user | DELETE /v3/system/users/{user_id}/roles/{role_id} 删除 /v3/system/users/{user_id}/roles/{role_id} |
| identity:list_system_grants_for_group 身份：list_system_grants_for_group | GET /v3/system/groups/{group_id}/roles 获取 /v3/system/groups/{group_id}/roles |
| identity:check_system_grant_for_group 身份：check_system_grant_for_group | GET /v3/system/groups/{group_id}/roles/{role_id} 获取 /v3/system/groups/{group_id}/roles/{role_id} |
| identity:create_system_grant_for_group 身份：create_system_grant_for_group | PUT /v3/system/groups/{group_id}/roles/{role_id}             |
| identity:revoke_system_grant_for_group 身份：revoke_system_grant_for_group | DELETE /v3/system/groups/{group_id}/roles/{role_id} 删除 /v3/system/groups/{group_id}/roles/{role_id} |
| identity:list_role_assignments 身份：list_role_assignments   | GET /v3/role_assignments 获取 /v3/role_assignments           |
| identity:list_role_assignments_for_tree 身份：list_role_assignments_for_tree | GET /v3/role_assignments?include_subtree GET /v3/role_assignments？include_subtree |
| identity:get_policy 身份：get_policy                         | GET /v3/policy/{policy_id} 获取 /v3/policy/{policy_id}       |
| identity:list_policies 身份：list_policies                   | GET /v3/policy 获取 /v3/策略                                 |
| identity:create_policy 身份：create_policy                   | POST /v3/policy POST /v3/策略                                |
| identity:update_policy 身份：update_policy                   | PATCH /v3/policy/{policy_id} 补丁 /v3/policy/{policy_id}     |
| identity:delete_policy 身份：delete_policy                   | DELETE /v3/policy/{policy_id} 删除 /v3/policy/{policy_id}    |
| identity:check_token 身份：check_token                       | HEAD /v3/auth/tokens                                         |
| identity:validate_token 身份：validate_token                 | GET /v3/auth/tokens 获取 /v3/auth/tokens                     |
| identity:revocation_list 身份：revocation_list               | GET /v3/auth/tokens/OS-PKI/revoked                           |
| identity:revoke_token 身份：revoke_token                     | DELETE /v3/auth/tokens 删除 /v3/auth/tokens                  |
| identity:create_trust 身份：create_trust                     | POST /v3/OS-TRUST/trusts POST /v3/OS-TRUST/信任              |
| identity:list_trusts 身份：list_trusts                       | GET /v3/OS-TRUST/trusts 获取 /v3/OS-TRUST/信任               |
| identity:list_trusts_for_trustor 身份：list_trusts_for_trustor | GET /v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id} GET /v3/OS-TRUST/trusts？trustor_user_id={trustor_user_id} |
| identity:list_trusts_for_trustee 身份：list_trusts_for_trustee | GET /v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id} 获取 /v3/OS-TRUST/trusts？trustee_user_id={trustee_user_id} |
| identity:list_roles_for_trust 身份：list_roles_for_trust     | GET /v3/OS-TRUST/trusts/{trust_id}/roles 获取 /v3/OS-TRUST/trusts/{trust_id}/roles |
| identity:get_role_for_trust 身份：get_role_for_trust         | GET /v3/OS-TRUST/trusts/{trust_id}/roles/{role_id} 获取 /v3/OS-TRUST/trusts/{trust_id}/roles/{role_id} |
| identity:delete_trust 身份：delete_trust                     | DELETE /v3/OS-TRUST/trusts/{trust_id} 删除 /v3/OS-TRUST/trusts/{trust_id} |
| identity:get_trust 身份：get_trust                           | GET /v3/OS-TRUST/trusts/{trust_id} 获取 /v3/OS-TRUST/trusts/{trust_id} |
| identity:create_consumer 身份：create_consumer               | POST /v3/OS-OAUTH1/consumers POST /v3/OS-OAUTH1/消费者       |
| identity:get_consumer 身份：get_consumer                     | GET /v3/OS-OAUTH1/consumers/{consumer_id} 获取 /v3/OS-OAUTH1/消费者/{consumer_id} |
| identity:list_consumers 身份：list_consumers                 | GET /v3/OS-OAUTH1/consumers 获取 /v3/OS-OAUTH1/消费者        |
| identity:delete_consumer 身份：delete_consumer               | DELETE /v3/OS-OAUTH1/consumers/{consumer_id} 删除 /v3/OS-OAUTH1/consumers/{consumer_id} |
| identity:update_consumer 身份：update_consumer               | PATCH /v3/OS-OAUTH1/consumers/{consumer_id} 补丁 /v3/OS-OAUTH1/consumers/{consumer_id} |
| identity:authorize_request_token 身份：authorize_request_token | PUT /v3/OS-OAUTH1/authorize/{request_token_id}               |
| identity:list_access_token_roles 身份：list_access_token_roles | GET /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles 获取 /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles |
| identity:get_access_token_role 身份：get_access_token_role   | GET /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id} 获取 /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id} |
| identity:list_access_tokens 身份：list_access_tokens         | GET /v3/users/{user_id}/OS-OAUTH1/access_tokens 获取 /v3/users/{user_id}/OS-OAUTH1/access_tokens |
| identity:get_access_token 身份：get_access_token             | GET /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id} 获取 /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id} |
| identity:delete_access_token 身份：delete_access_token       | DELETE /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id} 删除 /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id} |
| identity:list_projects_for_endpoint 身份：list_projects_for_endpoint | GET /v3/OS-EP-FILTER/endpoints/{endpoint_id}/projects 获取 /v3/OS-EP-FILTER/endpoints/{endpoint_id}/projects |
| identity:add_endpoint_to_project 身份：add_endpoint_to_project | PUT /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id} |
| identity:check_endpoint_in_project 身份：check_endpoint_in_project | GET /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id} 获取 /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id} |
| identity:list_endpoints_for_project 身份：list_endpoints_for_project | GET /v3/OS-EP-FILTER/projects/{project_id}/endpoints 获取 /v3/OS-EP-FILTER/projects/{project_id}/endpoints |
| identity:remove_endpoint_from_project 身份：remove_endpoint_from_project | DELETE /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id} 删除 /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id} |
| identity:create_endpoint_group 身份：create_endpoint_group   | POST /v3/OS-EP-FILTER/endpoint_groups 发布 /v3/OS-EP-FILTER/endpoint_groups |
| identity:list_endpoint_groups 身份：list_endpoint_groups     | GET /v3/OS-EP-FILTER/endpoint_groups 获取 /v3/OS-EP-FILTER/endpoint_groups |
| identity:get_endpoint_group 身份：get_endpoint_group         | GET /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} 获取 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} |
| identity:update_endpoint_group 身份：update_endpoint_group   | PATCH /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} 补丁 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} |
| identity:delete_endpoint_group 身份：delete_endpoint_group   | DELETE /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} 删除 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id} |
| identity:list_projects_associated_with_endpoint_group 身份：list_projects_associated_with_endpoint_group | GET /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects 获取 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects |
| identity:list_endpoints_associated_with_endpoint_group 身份：list_endpoints_associated_with_endpoint_group | GET /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints 获取 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints |
| identity:get_endpoint_group_in_project 身份：get_endpoint_group_in_project | GET /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} 获取 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} |
| identity:list_endpoint_groups_for_project 身份：list_endpoint_groups_for_project | GET /v3/OS-EP-FILTER/projects/{project_id}/endpoint_groups 获取 /v3/OS-EP-FILTER/projects/{project_id}/endpoint_groups |
| identity:add_endpoint_group_to_project 身份：add_endpoint_group_to_project | PUT /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} 放置 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} |
| identity:remove_endpoint_group_from_project 身份：remove_endpoint_group_from_project | DELETE /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} 删除 /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id} |
| identity:create_identity_provider 身份：create_identity_provider | PUT /v3/OS-FEDERATION/identity_providers/{idp_id}            |
| identity:list_identity_providers 身份：list_identity_providers | GET /v3/OS-FEDERATION/identity_providers 获取 /v3/OS-FEDERATION/identity_providers |
| identity:get_identity_provider 身份：get_identity_provider   | GET /v3/OS-FEDERATION/identity_providers/{idp_id} 获取 /v3/OS-FEDERATION/identity_providers/{idp_id} |
| identity:update_identity_provider 身份：update_identity_provider | PATCH /v3/OS-FEDERATION/identity_providers/{idp_id} 补丁 /v3/OS-FEDERATION/identity_providers/{idp_id} |
| identity:delete_identity_provider 身份：delete_identity_provider | DELETE /v3/OS-FEDERATION/identity_providers/{idp_id} 删除 /v3/OS-FEDERATION/identity_providers/{idp_id} |
| identity:create_protocol 身份：create_protocol               | PUT /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} |
| identity:update_protocol 身份：update_protocol               | PATCH /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} 补丁 /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} |
| identity:get_protocol 身份：get_protocol                     | GET /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} 获取 /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} |
| identity:list_protocols 身份：list_protocols                 | GET /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols 获取 /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols |
| identity:delete_protocol 身份：delete_protocol               | DELETE /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} 删除 /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id} |
| identity:create_mapping 身份：create_mapping                 | PUT /v3/OS-FEDERATION/mappings/{mapping_id}                  |
| identity:get_mapping 身份：get_mapping                       | GET /v3/OS-FEDERATION/mappings/{mapping_id} 获取 /v3/OS-FEDERATION/mappings/{mapping_id} |
| identity:list_mappings 身份：list_mappings                   | GET /v3/OS-FEDERATION/mappings 获取 /v3/操作系统联合/映射    |
| identity:delete_mapping 身份：delete_mapping                 | DELETE /v3/OS-FEDERATION/mappings/{mapping_id} 删除 /v3/OS-FEDERATION/mappings/{mapping_id} |
| identity:update_mapping 身份：update_mapping                 | PATCH /v3/OS-FEDERATION/mappings/{mapping_id} 补丁 /v3/OS-FEDERATION/mappings/{mapping_id} |
| identity:create_service_provider 身份：create_service_provider | PUT /v3/OS-FEDERATION/service_providers/{sp_id}              |
| identity:list_service_providers 身份：list_service_providers | GET /v3/OS-FEDERATION/service_providers 获取 /v3/OS-FEDERATION/service_providers |
| identity:get_service_provider 身份：get_service_provider     | GET /v3/OS-FEDERATION/service_providers/{sp_id} 获取 /v3/OS-FEDERATION/service_providers/{sp_id} |
| identity:update_service_provider 身份：update_service_provider | PATCH /v3/OS-FEDERATION/service_providers/{sp_id} 补丁 /v3/OS-FEDERATION/service_providers/{sp_id} |
| identity:delete_service_provider 身份：delete_service_provider | DELETE /v3/OS-FEDERATION/service_providers/{sp_id} 删除 /v3/OS-FEDERATION/service_providers/{sp_id} |
| identity:get_auth_catalog 身份：get_auth_catalog             | GET /v3/auth/catalog 获取 /v3/auth/catalog                   |
| identity:get_auth_projects 身份：get_auth_projects           | GET /v3/auth/projects 获取 /v3/auth/projects                 |
| identity:get_auth_domains 身份：get_auth_domains             | GET /v3/auth/domains 获取 /v3/auth/domains                   |
| identity:get_auth_system 身份：get_auth_system               | GET /v3/auth/system 获取 /v3/auth/system                     |
| identity:list_projects_for_user 身份：list_projects_for_user | GET /v3/OS-FEDERATION/projects 获取 /v3/OS-FEDERATION/projects |
| identity:list_domains_for_user 身份：list_domains_for_user   | GET /v3/OS-FEDERATION/domains 获取 /v3/OS-FEDERATION/域      |
| identity:list_revoke_events 身份：list_revoke_events         | GET /v3/OS-REVOKE/events 获取 /v3/OS-REVOKE/事件             |
| identity:create_policy_association_for_endpoint 身份：create_policy_association_for_endpoint | PUT /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id} |
| identity:check_policy_association_for_endpoint 身份：check_policy_association_for_endpoint | GET /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id} 获取 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id} |
| identity:delete_policy_association_for_endpoint 身份：delete_policy_association_for_endpoint | DELETE /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id} 删除 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id} |
| identity:create_policy_association_for_service 身份：create_policy_association_for_service | PUT /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id} |
| identity:check_policy_association_for_service 身份：check_policy_association_for_service | GET /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id} 获取 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id} |
| identity:delete_policy_association_for_service 身份：delete_policy_association_for_service | DELETE /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id} 删除 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id} |
| identity:create_policy_association_for_region_and_service 身份：create_policy_association_for_region_and_service | PUT /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id} |
| identity:check_policy_association_for_region_and_service 身份：check_policy_association_for_region_and_service | GET /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id} 获取 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id} |
| identity:delete_policy_association_for_region_and_service 身份：delete_policy_association_for_region_and_service | DELETE /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id} 删除 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id} |
| identity:get_policy_for_endpoint 身份：get_policy_for_endpoint | GET /v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy 获取 /v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/策略 |
| identity:list_endpoints_for_policy 身份：list_endpoints_for_policy | GET /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints 获取 /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints |
| identity:create_domain_config 身份：create_domain_config     | PUT /v3/domains/{domain_id}/config                           |
| identity:get_domain_config 身份：get_domain_config           | GET /v3/domains/{domain_id}/config GET /v3/domains/{domain_id}/config/{group} GET /v3/domains/{domain_id}/config/{group}/{option} |
| identity:get_security_compliance_domain_config 身份：get_security_compliance_domain_config | GET /v3/domains/{domain_id}/config/security_compliance GET /v3/domains/{domain_id}/config/security_compliance/{option} GET /v3/domains/{domain_id}/config/security_compliance GET /v3/domains/{domain_id}/config/security_compliance/{选项} |
| identity:update_domain_config 身份：update_domain_config     | PATCH /v3/domains/{domain_id}/config PATCH /v3/domains/{domain_id}/config/{group} PATCH /v3/domains/{domain_id}/config/{group}/{option} 补丁 /v3/domains/{domain_id}/config 补丁 /v3/domains/{domain_id}/config/{group} 补丁 /v3/domains/{domain_id}/config/{group}/{选项} |
| identity:delete_domain_config 身份：delete_domain_config     | DELETE /v3/domains/{domain_id}/config DELETE /v3/domains/{domain_id}/config/{group} DELETE /v3/domains/{domain_id}/config/{group}/{option} |
| identity:get_domain_config_default 身份：get_domain_config_default | GET /v3/domains/config/default GET /v3/domains/config/{group}/default GET /v3/domains/config/{group}/{option}/default |
| identity:get_application_credential 身份：get_application_credential | GET /v3/users/{user_id}/application_credentials/{application_credential_id} 获取 /v3/users/{user_id}/application_credentials/{application_credential_id} |
| identity:list_application_credentials 身份：list_application_credentials | GET /v3/users/{user_id}/application_credentials 获取 /v3/users/{user_id}/application_credentials |
| identity:create_application_credential 身份：create_application_credential | POST /v3/users/{user_id}/application_credential              |
| identity:delete_application_credential 身份：delete_application_credential | DELETE /v3/users/{user_id}/application_credential/{application_credential_id} 删除 /v3/users/{user_id}/application_credential/{application_credential_id} |
| identity:get_access_rule 身份：get_access_rule               | GET /v3/users/{user_id}/access_rules/{access_rule_id} 获取 /v3/users/{user_id}/access_rules/{access_rule_id} |
| identity:list_access_rules 身份：list_access_rules           | GET /v3/users/{user_id}/access_rules 获取 /v3/users/{user_id}/access_rules |
| identity:delete_access_rule 身份：delete_access_rule         | DELETE /v3/users/{user_id}/access_rules/{access_rule_id} 删除 /v3/users/{user_id}/access_rules/{access_rule_id} |

*grant_resources* are: grant_resources是：

- /v3/projects/{project_id}/users/{user_id}/roles/{role_id}
- /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}
- /v3/domains/{domain_id}/users/{user_id}/roles/{role_id}
- /v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}
- /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
- /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
- /v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
- /v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects

*grant_collections* are: grant_collections是：

- /v3/projects/{project_id}/users/{user_id}/roles
- /v3/projects/{project_id}/groups/{group_id}/roles
- /v3/domains/{domain_id}/users/{user_id}/roles
- /v3/domains/{domain_id}/groups/{group_id}/roles
- /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects
- /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects