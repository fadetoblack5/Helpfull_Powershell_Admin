<#
DISCLAIMER
THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
NEVER USE an untested script in Production without testing it in NON-Prod first!
.NOTES
    Author: Michael Russ
    Version: 1.0
    Date: 2024-11-15
	#>
#Find Stale accounts in 365

Import-Module MSOnline #only run the first time you connect to MSOnline

Connect-MsOlService

#grabs all licensed 365 users who's pw has not been changed in 180 days or more#

Get-MsolUser -All | Where-Object {($_.isLicensed -like $true) -and ($_.LastPasswordChangeTimestamp -lt (Get-Date).AddDays(-180))} | Select DisplayName,UserPrincipalName,LastPasswordChangeTimestamp | export-csv -Path C:\temp\inactive365Accounts06102021.csv

#This script disables the accounts of users from a csv, places mailbox on lit hold, moves account to inactive OU# 
#Create the csv with a row titled samaccountname#
#add the SamAccountName of the users who are to be disabled#
#save the csv in a temp folder on c:\#

Import-Module ActiveDirectory 

$users = import-csv -path C:\temp\Cleanup\usersToDisable-03162022.csv

forEach ($user in $users){Set-ADUser -Identity $user.samaccountname -Enabled $false -description "Termed-271284" -Verbose}


#Place mailboxes on lit hold

#you can use same csv

Connect-ExchangeOnline -UserPrincipalName mruss@gmail.com 

$users = import-csv -path C:\temp\Cleanup\usersToDisable-03162022.csv

forEach ($user in $users){set-mailbox $user.samaccountname -LitigationHoldEnabled $TRUE -LitigationHoldDuration unlimited -Verbose}

#move to inactive OU

$TargetOU =  "OU=InActive Users,DC=xxxxx,DC=local" 

$users = import-csv -path C:\temp\Cleanup\usersToDisable-03162022.csv


$users | ForEach-Object { 
     # Retrieve DN of User. 
     $UserDN  = (Get-ADUser -Identity $_.samaccountname).distinguishedName 
     Write-Host " Moving Accounts ..... " 
     # Move user to target OU. 
     Move-ADObject  -Identity $UserDN  -TargetPath $TargetOU -Verbose
      
 }

 #Revoke sessions of users who have not changed password, but are active
 #need a csv with list of users by userprincipalname

Connect-AzureAD

$users = Import-Csv -Path C:\temp\Cleanup\revokeSessions-1-01042022.csv

forEach ($user in $users){Revoke-AzureADUserAllRefreshToken -ObjectId $user.userprincipalname -Verbose}

