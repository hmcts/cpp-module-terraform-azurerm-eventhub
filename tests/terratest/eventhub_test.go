package test

import (
	"context"
	"path/filepath"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/eventhub/mgmt/2017-04-01/eventhub"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// Testing the Event Hub Module
func TestTerraformAzureEventHub(t *testing.T) {
	t.Parallel()

	// Copy the Terraform folder to a temporary directory
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../..", "example/")
	planFilePath := filepath.Join(exampleFolder, "plan.out")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../../example/",
		Upgrade:      true,

		// Variables to pass to your Terraform code
		VarFiles: []string{"for_terratest.tfvars"},

		// Configure a plan file path so we can introspect the plan and make assertions about it
		PlanFilePath: planFilePath,
	})

	// Run terraform init and plan, and show the plan
	terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs from Terraform
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	eventHubNamespaceName := terraform.Output(t, terraformOptions, "eventhub_namespace_name")
	eventHubName := terraform.OutputList(t, terraformOptions, "eventhub_name")
	subscriptionID := terraform.Output(t, terraformOptions, "subscription_id")

	// Check if the Event Hub Namespace exists
	namespaceExists := EventHubNamespaceExists(t, resourceGroupName, eventHubNamespaceName, subscriptionID)
	assert.True(t, namespaceExists, "Event Hub Namespace does not exist")

	// Get the Event Hub Namespace details
	namespace := GetEventHubNamespace(t, resourceGroupName, eventHubNamespaceName, subscriptionID)

	// Assert properties of the Event Hub Namespace
	assert.Equal(t, eventHubNamespaceName, *namespace.Name)
	assert.Equal(t, "Standard", string(namespace.Sku.Name))

    for _, eventHubName := range eventHubNames {
        // Check if the Event Hub exists within the namespace
        eventHubExists := EventHubExists(t, resourceGroupName, eventHubNamespaceName, eventHubName, subscriptionID)
        assert.True(t, eventHubExists, "Event Hub does not exist")

        // Get the Event Hub details
        eventHub := GetEventHub(t, resourceGroupName, eventHubNamespaceName, eventHubName, subscriptionID)

        // Assert properties of the Event Hub
        assert.Equal(t, eventHubName, *eventHub.Name)
        // For example, check the partition count
        assert.Equal(t, int64(2), *eventHub.PartitionCount)
	}
}

// Custom function to check if Event Hub Namespace exists
func EventHubNamespaceExists(t *testing.T, resourceGroupName, namespaceName, subscriptionID string) bool {
	namespacesClient := getEventHubNamespacesClient(subscriptionID)
	_, err := namespacesClient.Get(context.Background(), resourceGroupName, namespaceName)
	return err == nil
}

// Custom function to get Event Hub Namespace details
func GetEventHubNamespace(t *testing.T, resourceGroupName, namespaceName, subscriptionID string) *eventhub.EHNamespace {
	namespacesClient := getEventHubNamespacesClient(subscriptionID)
	namespace, err := namespacesClient.Get(context.Background(), resourceGroupName, namespaceName)
	if err != nil {
		t.Fatalf("Failed to get Event Hub Namespace: %v", err)
	}
	return &namespace
}

// Custom function to check if Event Hub exists
func EventHubExists(t *testing.T, resourceGroupName, namespaceName, eventHubName, subscriptionID string) bool {
	eventHubsClient := getEventHubsClient(subscriptionID)
	_, err := eventHubsClient.Get(context.Background(), resourceGroupName, namespaceName, eventHubName)
	return err == nil
}

// Custom function to get Event Hub details
func GetEventHub(t *testing.T, resourceGroupName, namespaceName, eventHubName, subscriptionID string) *eventhub.Model {
	eventHubsClient := getEventHubsClient(subscriptionID)
	eventHub, err := eventHubsClient.Get(context.Background(), resourceGroupName, namespaceName, eventHubName)
	if err != nil {
		t.Fatalf("Failed to get Event Hub: %v", err)
	}
	return &eventHub
}

// Helper function to get Event Hub Namespaces Client
func getEventHubNamespacesClient(subscriptionID string) eventhub.NamespacesClient {
	namespacesClient := eventhub.NewNamespacesClient(subscriptionID)
	authorizer, err := auth.NewAuthorizerFromCLI()
	if err != nil {
		panic(err)
	}
	namespacesClient.Authorizer = authorizer
	return namespacesClient
}

// Helper function to get Event Hubs Client
func getEventHubsClient(subscriptionID string) eventhub.EventHubsClient {
	eventHubsClient := eventhub.NewEventHubsClient(subscriptionID)
	authorizer, err := auth.NewAuthorizerFromCLI()
	if err != nil {
		panic(err)
	}
	eventHubsClient.Authorizer = authorizer
	return eventHubsClient
}
