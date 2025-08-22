output "bastion_connection_guide" {
  description = "Step-by-step guide for connecting to VMs via Azure Bastion using Key Vault SSH keys"
  value       = <<EOT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Instructions for connecting to VMs via Azure Bastion                                               
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    1. Access the Azure Portal: https://portal.azure.com
    2. Navigate to the desired VM
    3. Click on "Connect" > "Connect via Bastion"
    4. Authentication type: "SSH private key from Azure Key Vault"
    5. Username: "${var.vm_admin_user}"
    6. Azure Key Vault: "${module.kv.name}"
    7. Key Vault secret: "${var.private_key_name}"
    8. Click on "Connect"

----------------------------------------------------------------------------------------------------
ℹ️  To disable VNET peering, set the variable 'enable_peering' to false in your variables.tf file
----------------------------------------------------------------------------------------------------
EOT
}
