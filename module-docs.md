<!-- BEGIN_TF_DOCS -->
## Required Inputs

The following input variables are required:

### <a name="input_brainstore_license_key"></a> [brainstore\_license\_key](#input\_brainstore\_license\_key)

Description: The license key for the Brainstore instance. You can find this in the Braintrust UI under Settings > Data Plane > Brainstore License Key.

Type: `string`

### <a name="input_braintrust_org_name"></a> [braintrust\_org\_name](#input\_braintrust\_org\_name)

Description: The name of your organization in Braintrust (e.g. acme.com)

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region to deploy resources to

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_aks_system_pool_vm_size"></a> [aks\_system\_pool\_vm\_size](#input\_aks\_system\_pool\_vm\_size)

Description: VM size for the system nodes

Type: `string`

Default: `"Standard_D2as_v6"`

### <a name="input_aks_user_pool_max_count"></a> [aks\_user\_pool\_max\_count](#input\_aks\_user\_pool\_max\_count)

Description: Maximum number of nodes in the user pool

Type: `number`

Default: `10`

### <a name="input_aks_user_pool_vm_size"></a> [aks\_user\_pool\_vm\_size](#input\_aks\_user\_pool\_vm\_size)

Description: VM size for the user nodes that run the application. Must be a SKU with a temporary local storage SSD.

Type: `string`

Default: `"Standard_D16ds_v6"`

### <a name="input_create_aks_cluster"></a> [create\_aks\_cluster](#input\_create\_aks\_cluster)

Description: Create an AKS cluster

Type: `bool`

Default: `false`

### <a name="input_create_storage_container"></a> [create\_storage\_container](#input\_create\_storage\_container)

Description: Create containers for the blobstorage. Defaults to true. Disable this if CI CD cannot reach the storage APIs.

Type: `bool`

Default: `true`

### <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name)

Description: Name of this Braintrust deployment. Will be included in tags and prefixes in resources names. Lowercase letter, numbers, and hyphens only. If you want multiple deployments in your same Azure subscription, use a unique name for each deployment.

Type: `string`

Default: `"braintrust"`

### <a name="input_existing_blob_private_dns_zone_id"></a> [existing\_blob\_private\_dns\_zone\_id](#input\_existing\_blob\_private\_dns\_zone\_id)

Description: Advanced: Use an existing private dns zone id for blob storage private endpoint. Only needed if you want to deploy two data planes into the same VNet.

Type: `string`

Default: `""`

### <a name="input_existing_postgres_private_dns_zone_id"></a> [existing\_postgres\_private\_dns\_zone\_id](#input\_existing\_postgres\_private\_dns\_zone\_id)

Description: Advanced: Use an existing private dns zone id for postgres private endpoint. Only needed if you want to deploy two data planes into the same VNet.

Type: `string`

Default: `""`

### <a name="input_existing_redis_private_dns_zone_id"></a> [existing\_redis\_private\_dns\_zone\_id](#input\_existing\_redis\_private\_dns\_zone\_id)

Description: Advanced: Use an existing private dns zone id for redis private endpoint. Only needed if you want to deploy two data planes into the same VNet.

Type: `string`

Default: `""`

### <a name="input_existing_vnet"></a> [existing\_vnet](#input\_existing\_vnet)

Description: n/a

Type:

```hcl
object({
    id                                         = string
    name                                       = string
    services_subnet_id                         = string
    private_endpoint_subnet_id                 = string
    private_endpoint_network_security_group_id = string
    address_space                              = string
  })
```

Default:

```json
{
  "address_space": "",
  "id": "",
  "name": "",
  "private_endpoint_network_security_group_id": "",
  "private_endpoint_subnet_id": "",
  "services_subnet_id": ""
}
```

### <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id)

Description: Existing Key Vault ID to use for encrypting resources. If not provided, a new Key Vault will be created. DO NOT change this after deployment.

Type: `string`

Default: `null`

### <a name="input_postgres_sku_name"></a> [postgres\_sku\_name](#input\_postgres\_sku\_name)

Description: SKU name for the Azure Database for PostgreSQL instance.

Type: `string`

Default: `"MO_Standard_E2ds_v5"`

### <a name="input_postgres_storage_mb"></a> [postgres\_storage\_mb](#input\_postgres\_storage\_mb)

Description: Storage size (in MB) for the Azure Database for PostgreSQL instance.

Type: `number`

Default: `131072`

### <a name="input_postgres_storage_tier"></a> [postgres\_storage\_tier](#input\_postgres\_storage\_tier)

Description: Storage tier for the Azure Database for PostgreSQL instance.

Type: `string`

Default: `"P20"`

### <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version)

Description: PostgreSQL engine version for the Azure Database for PostgreSQL instance.

Type: `string`

Default: `"15"`

### <a name="input_private_endpoint_subnet_cidr"></a> [private\_endpoint\_subnet\_cidr](#input\_private\_endpoint\_subnet\_cidr)

Description: CIDR block for the private endpoint subnet. Leave blank to auto-calculate one.

Type: `string`

Default: `null`

### <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity)

Description: Capacity for the Azure Cache for Redis instance

Type: `number`

Default: `1`

### <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family)

Description: Family for the Azure Cache for Redis instance

Type: `string`

Default: `"C"`

### <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name)

Description: SKU name for the Azure Cache for Redis instance

Type: `string`

Default: `"Standard"`

### <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version)

Description: Redis engine version

Type: `string`

Default: `"6"`

### <a name="input_services_subnet_cidr"></a> [services\_subnet\_cidr](#input\_services\_subnet\_cidr)

Description: CIDR block for the services subnet. Leave blank to auto-calculate one.

Type: `string`

Default: `null`

### <a name="input_vnet_address_space_cidr"></a> [vnet\_address\_space\_cidr](#input\_vnet\_address\_space\_cidr)

Description: Address space for the VNet

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name)

Description: The AKS cluster name

### <a name="output_aks_identity_client_id"></a> [aks\_identity\_client\_id](#output\_aks\_identity\_client\_id)

Description: The client ID of the AKS identity

### <a name="output_aks_identity_object_id"></a> [aks\_identity\_object\_id](#output\_aks\_identity\_object\_id)

Description: The object ID of the AKS identity

### <a name="output_azure_tenant_id"></a> [azure\_tenant\_id](#output\_azure\_tenant\_id)

Description: The tenant ID of the Azure subscription

### <a name="output_brainstore_container_name"></a> [brainstore\_container\_name](#output\_brainstore\_container\_name)

Description: The name of the brainstore container

### <a name="output_braintrust_org_name"></a> [braintrust\_org\_name](#output\_braintrust\_org\_name)

Description: The name of the Braintrust organization

### <a name="output_code_bundles_container_name"></a> [code\_bundles\_container\_name](#output\_code\_bundles\_container\_name)

Description: The name of the code-bundles container

### <a name="output_key_vault_application_security_group_name"></a> [key\_vault\_application\_security\_group\_name](#output\_key\_vault\_application\_security\_group\_name)

Description: Name of the key vault application security group

### <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id)

Description: The ID of the Key Vault

### <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name)

Description: The name of the Key Vault

### <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri)

Description: The URI of the Key Vault

### <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config)

Description: The AKS cluster kubeconfig

### <a name="output_main_vnet_address_space"></a> [main\_vnet\_address\_space](#output\_main\_vnet\_address\_space)

Description: Address space of the main VNet

### <a name="output_main_vnet_id"></a> [main\_vnet\_id](#output\_main\_vnet\_id)

Description: ID of the main VNet that contains the Braintrust resources

### <a name="output_main_vnet_name"></a> [main\_vnet\_name](#output\_main\_vnet\_name)

Description: Name of the main VNet that contains the Braintrust resources

### <a name="output_postgres_application_security_group_name"></a> [postgres\_application\_security\_group\_name](#output\_postgres\_application\_security\_group\_name)

Description: Name of the postgres application security group

### <a name="output_postgres_database_fqdn"></a> [postgres\_database\_fqdn](#output\_postgres\_database\_fqdn)

Description: FQDN of the PostgreSQL database

### <a name="output_postgres_database_id"></a> [postgres\_database\_id](#output\_postgres\_database\_id)

Description: ID of the main Braintrust Postgres database

### <a name="output_postgres_database_name"></a> [postgres\_database\_name](#output\_postgres\_database\_name)

Description: Name of the PostgreSQL database

### <a name="output_postgres_database_username"></a> [postgres\_database\_username](#output\_postgres\_database\_username)

Description: Username for the PostgreSQL database

### <a name="output_postgres_password_secret_id"></a> [postgres\_password\_secret\_id](#output\_postgres\_password\_secret\_id)

Description: ID of the Key Vault secret for the PostgreSQL database

### <a name="output_postgres_password_secret_name"></a> [postgres\_password\_secret\_name](#output\_postgres\_password\_secret\_name)

Description: Name of the Key Vault secret for the PostgreSQL database

### <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint)

Description: The primary blob endpoint URL

### <a name="output_private_endpoint_network_security_group_id"></a> [private\_endpoint\_network\_security\_group\_id](#output\_private\_endpoint\_network\_security\_group\_id)

Description: ID of the private endpoint subnet's network security group

### <a name="output_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#output\_private\_endpoint\_subnet\_id)

Description: ID of the private endpoint subnet

### <a name="output_redis_application_security_group_name"></a> [redis\_application\_security\_group\_name](#output\_redis\_application\_security\_group\_name)

Description: Name of the redis application security group

### <a name="output_redis_hostname"></a> [redis\_hostname](#output\_redis\_hostname)

Description: The hostname of the Redis Cache

### <a name="output_redis_id"></a> [redis\_id](#output\_redis\_id)

Description: ID of the Redis instance

### <a name="output_redis_password_secret_id"></a> [redis\_password\_secret\_id](#output\_redis\_password\_secret\_id)

Description: The ID of the Key Vault secret for the Redis Cache password

### <a name="output_redis_password_secret_name"></a> [redis\_password\_secret\_name](#output\_redis\_password\_secret\_name)

Description: The name of the Key Vault secret for the Redis Cache password

### <a name="output_redis_ssl_port"></a> [redis\_ssl\_port](#output\_redis\_ssl\_port)

Description: The SSL port of the Redis Cache

### <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name)

Description: Name of the resource group containing Braintrust resources

### <a name="output_responses_container_name"></a> [responses\_container\_name](#output\_responses\_container\_name)

Description: The name of the responses container

### <a name="output_services_network_security_group_id"></a> [services\_network\_security\_group\_id](#output\_services\_network\_security\_group\_id)

Description: ID of the services network security group

### <a name="output_services_subnet_id"></a> [services\_subnet\_id](#output\_services\_subnet\_id)

Description: ID of the services subnet

### <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id)

Description: The ID of the storage account

### <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name)

Description: The name of the storage account

### <a name="output_storage_identity_id"></a> [storage\_identity\_id](#output\_storage\_identity\_id)

Description: The ID of the user-assigned managed identity used by the storage account

### <a name="output_storage_identity_principal_id"></a> [storage\_identity\_principal\_id](#output\_storage\_identity\_principal\_id)

Description: The principal ID of the user-assigned managed identity used by the storage account
<!-- END_TF_DOCS -->