#requires -version 5.0

#region Main

Function Get-Foo {
[cmdletbinding()]
Param(

)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {


} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #close Get-Foo Function Set-Foo {
[cmdletbinding()]
Param(

)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {


} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #close Set-Foo Function remove-foo {
[cmdletbinding()]
Param(

)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {


} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #close remove-foo

#endregion

#define aliases


