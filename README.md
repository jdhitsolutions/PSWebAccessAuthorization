# PSWebAccessAuthorization #

A DSC resource for managing PowerShell Web Access (PSWA) authorization rules

## Current version
The currently release version is 0.5.0.

## Background
This PowerShell module describes a Desired State Configuration (DSC) resource for managing PowerShell Web Access authorization rules. You can use this resource in a DSC configuration to control rules. You can create or remove rules.

```
PwaAuthorizationRule DBA {
    RuleName = "DBA Access"
    Ensure = "Present"
    Destination = "SqlServerGroup"
    DestinationType = "ComputerGroup"
    Username = @("CompanyDBA")
    UserType = "UserGroup"
}
```

The assumption is that PowerShell Web Access has already been configured and installed. If you are using this resource in the same configuration that is creating a new PSWA server, then make sure you use `DependsOn` for the PwaAuthorizationRule resource.

Detailed information can be found in [about_PSWebAccessAuthorization](.\Docs\about_pswebaccessauthorization.md) 

****************************************************************

_last updated 01/13/2017 09:31:28_
