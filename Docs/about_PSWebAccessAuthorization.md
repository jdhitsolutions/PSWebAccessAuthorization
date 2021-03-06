# PSWebAccessAuthorization
## about_PSWebAccessAuthorization


# SHORT DESCRIPTION
This is a DSC module with a single resource, PwaAuthorizationRule, which is designed to configure PowerShell Web Access authorization rules. The resource is class-based so target nodes must be running PowerShell v5.0 or later. Due to limitations in the PowerShellWebAccess module, you should use this resource in a DSC configuration to either add or remove a rule. 

# LONG DESCRIPTION
This resource assumes that PowerShell Web Access (PSWA) has already been installed and configured on the target node. If you are using DSC to deploy PSWA and manage authorization rules, you will need to use `DependsOn` for the rule configuration. The `PwaAuthorizationRule` resource has this syntax:

```
RuleName = [string]
Ensure = [string]{ Absent | Present }
[DependsOn = [string[]]]
[Destination = [string]]
[DestinationType = [string]{ Computer | ComputerGroup}]
[Domain = [string]]
[PsDscRunAsCredential = [PSCredential]]
[Username = [string[]]]
[UserType = [string]{ User | UserGroup }]
[Configuration = [string]]
```
The resource relies on commands in the PowerShellWebAccess module

- `Get-PSWAAuthorizationRule` 
- `Add-PSWAAuthorizationRule` 
- `Remove-PSWAAuthorizationRule` 

Because there is not "set" command, the DSC resource can't be used to modify an existing rule. If you truly need to modify, then create two configuration resource settings. The first for ensuring that the rule is absent. The second can then define the rule the way you want it with a dependency on the first resource.

## Details
To create a rule you need to assign it a name (`RuleName`) and set `Ensure` to "Present". It isn't specifically clear, but to add a rule you must also specify the name of a server or an Active Directory group for `Destination`. If the value is a single computer, then set the `DestinationType` to "Computer", otherwise use "ComputerGroup". 

Likewise you need to specify the name of a user or a group for `Username`. As with `Destination` you need to specify either 'User' or 'UserGroup' for `UserType`. You can specify multiple users or groups but you cannot mix and match. Use these formats:

```
Username = @("Company DBA","Company IT")
Username = @('jdoe','jhelmick')
Username = @('jhicks')
```

When defining users or groups do NOT specify a domain or machine name. The `Domain` setting will default to the current user domain on the authoring box. This domain name will be assigned to all users and groups. If you want to create a rule for a local user or group, use the computer name as the domain name. You can't mix domain and local settings in the same resource configuration but you should be able to create multiple configurations.

The last setting is `Configuration`. This is the name of the remoting endpoint. The default is "Microsoft.PowerShell". Change this as needed if you have created custom endpoints or are using something like JEA. 

## Wildcards
If you want to remove multiple rules, you can use a wildcard in the `RuleName` setting. However, do not create any other rules in the same configuration that might also be captured by this pattern, especially if the local configuration manager is set to auto correct.

# EXAMPLES
This resource assumes the PowerShell Web Access feature has already been installed and configured except for authorization rules. Otherwise you would need to include `DependsOn` especially if combining those settings with authorization rules in the same configuration.

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
This will add an authorization rule called "DBA Access" that gives any member of the CompanyDBA domain group, (defaulting to the current domain) access to any server in the SQLServerGroup domain group. The user will have access to the Microsoft.PowerShell endpoint.

```
PwaAuthorizationRule ITHelp {
    RuleName = "Help Desk"
    Ensure = "Present"
    Destination = "Domain Computers"
    DestinationType = "ComputerGroup"
    Username = @("ITHelp")
    UserType = "UserGroup"
    Configuration = "ITHelpDesk"
}
```
Create an access rule for the ITHelp group to access the custom ITHelpDesk endpoint on any server in "Domain Computers" group.

Or you might want to do this in a configuration:

```
PwaAuthorizationRule Remove_PrintOp {
    RuleName = "Print Op"
    Ensure = "Absent"
}

PwaAuthorizationRule PrintOp {
    RuleName = "Print Op v2"
    Ensure = "Present"
    Destination = "PrintServers"
    DestinationType = "ComputerGroup"
    Username = @("jdoe","jsmith")
    UserType = "User"
    Configuration = "JeaPrint"
    DependsOn = "[PwsAuthorizationRule]Remove_PrintOp"
}
```
Let's say you have an existing authorization rule called "Print Op" that grants access to multiple users. You now need to modify that rule to remove one of the users. To accomplish this you will first need to remove the existing rule. Then you can create a second instance of the rule to re-create with the desired settings. You will have to give this rule a new name. One idea is to use some type of versioning, but it is completely up to you.

# NOTE
Don't forget that the user or group must already have permission to connect to that end point. If they cannot connect via a remoting session in the PowerShell console, they will not be able to connect via PowerShell Web Access.

# TROUBLESHOOTING NOTE
Be aware that if you create an access rule for multiple users or groups, PowerShell will create a rule for each user or group. This means if you have a configuration like this:

```
RuleName = "Sales Server"
Ensure = "Present"
Destination = "SALES02"
DestinationType = "Computer"
Username = @("alice","bob","carol")
UserType = "User"
```

It will create 3 rules on the node with the same name and configuration, one for each user. If you decide to remove one of these users, you will need to remove the rule and then recreate it as documented above.

Remember, if you use multiple instances of this resource in the same configuration, the `RuleName` value must be unique.

# SEE ALSO
Here is a list of related material you might find useful.

https://technet.microsoft.com/en-us/library/hh831611(v=ws.11).aspx

https://blogs.technet.microsoft.com/fromthefield/2015/02/18/powershell-web-access-a-walkthrough

https://www.pluralsight.com/courses/powershell-web-access-server-implementing

# KEYWORDS

- PWA
- PSWA
- AuthorizationRule
- PowerShellWebAccess

