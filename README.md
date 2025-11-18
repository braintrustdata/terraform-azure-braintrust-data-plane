# Braintrust Data Plane for Azure

This Terraform module deploys the Braintrust data plane on Azure. It creates all the necessary core infrastructure to run Braintrust in your own Azure subscription.

After spinning up the data plane, you will need to deploy the Braintrust services to the AKS cluster using the [Braintrust Helm chart](https://github.com/braintrustdata/helm/tree/main/braintrust).

## Resources

This module creates the following resources by default:
- Virtual Network
- Azure Key Vault for encryption and secrets management
- Azure Database for PostgreSQL
- Azure Cache for Redis
- Azure Storage Account for blob storage
- AKS Kubernetes Cluster
- Azure Front Door for ingress to the API service

The VNet and AKS cluster can be optionally disabled so you can bring your own network and cluster.

## Usage
See the [examples](examples) for usage examples.

## Steps

Initial creation of the data plane:
1. Configure your TF module and apply with `enable_front_door` set to false
2. Create your helm values.yaml
  a. Configure values as needed setting orgName, clientIds, sizing, etc.
  b. Set the braintrust-api to be service.type: LoadBalancer.
  ```yaml
  service:
    type: LoadBalancer
  annotations:
    service:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  ```
3. Install the helm chart
4. Set `enable_front_door` to true in your terraform configuration
  a. Get the IP address of the AKS generated internal load balancer
  b. Set `front_door_api_backend_address` to the IP address of the AKS internal load balancer
  c. Set `front_door_load_balancer_frontend_ip_config_id` to the resource ID of the AKS internal load balancer frontend IP configuration
  d. Apply terraform
5. Manually approve the private link service in the Azure portal
