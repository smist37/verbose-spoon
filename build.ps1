

$rg = @{
  Name = "CLI-rg"
  Location = "eastus"
  # this way the variable can be referenced with $rg.Name for "CLI-rg"
}

$myrg = New-AzResourceGroup @rg -Force
Get-AzResourceGroup -Name $rg.Name -Location $rg.Location -ErrorAction SilentlyContinue

Write-Output ""

$vnet = @{
  Name = "CLI-vnet"
  Location = "eastus"
  ResourceGroupName = $rg.Name
  AddressPrefix = "10.10.0.0/16"
}

$myvnet = New-AzVirtualNetwork @vnet -Force
Get-AzResource -Name $myvnet.Name -ErrorAction SilentlyContinue

$myvnet | Set-AzVirtualNetwork

$subnet1 = @{
  Name = "My Subnet 1"
  VirtualNetwork = $myvnet
  AddressPrefix = "10.10.10.0/24"
}
$mysubnet1config = Add-AzVirtualNetworkSubnetConfig @subnet1

$subnet2 = @{
  Name = "My Subnet 2"
  VirtualNetwork = $myvnet
  AddressPrefix = "10.10.10.1/24"
}
$mysubnet2config = Add-AzVirtualNetworkSubnetConfig @subnet2



#############################################
# Now that the networks are created
# Build the VMs
#############################################

$vmAdminUsername = "LocalAdmin"
$vmAdminPassword = ConvertTo-SecureString "password" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$vm1 = @{
  ResourceGroup = $rg.Name
  Location = $rg.Location
  Name = "my VM 1"
  VirtualNetwork = $vnet.Name
  SubnetName = $subnet1.Name
  VMSize = "Standard_B1s"
  Credential = $Credential
  # more like size, disk, username, password
}

New-AzVM @vm1
