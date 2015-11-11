<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function New-IBNetwork {
    <#
    .SYNOPSIS
        Adds a network to an Infoblox Gridserver

    .DESCRIPTION
        Adds a network to an Infoblox Gridserver

    .EXAMPLE
        New-IBNetwork -GridServer myinfoblox.mydomain.com -Credential $Credential -Network '10.10.1.0/24' -Comment 'My New Network'

    .PARAMETER GridServer
        The name of the infoblox appliance.

    .PARAMETER Credential
        The credential to authenticate to the grid server with.

    .PARAMETER Network
        The network to create

    .PARAMETER Comment
        The description/comment to add
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GridServer,

        [Parameter(Mandatory)]
        [pscredential]$Credential,

        [Parameter(Mandatory)]
        [string]$Network,

        [Parameter(Mandatory)]
        [string]$Comment
    )

    begin {
        $uri = "https://$GridServer/wapi/v$script:apiVersion/network"
    }

    process {
        $data = @{
            network = $Network
            comment = $Comment.Trim()
        }

        $json = $data | ConvertTo-Json

        $request = Invoke-RestMethod -Uri $uri -Method Post -Credential $Credential -ContentType 'application/json' -Body $json

        return $request
    }

    end {}
}