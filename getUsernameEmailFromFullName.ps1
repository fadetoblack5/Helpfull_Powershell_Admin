<#
DISCLAIMER
THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
NEVER USE an untested script in Production without testing it in NON-Prod first!
.NOTES
    Author: Michael Russ
    Version: 1.0
    Date: 2024-11-15
	#>
#create a text file with a list of names. One on each line#
#Save as "dept"Users.txt in the script directory#
#Change script below so the List and CSV have unique names#
#you can use samaccount name or display name interchangeably based on what data you have#

Import-Module ActiveDirectory

$aResults = @()
$List = Get-Content ".\allUsersFullNames.txt"
            
ForEach($Item in $List){
    $Item = $Item.Trim()
    $User = Get-ADUser -Filter{displayName -like $Item -and displayName -notlike "admin-*"} -Properties samaccountname, userprincipalname, GivenName, Surname, mail

    $hItemDetails = New-Object -TypeName psobject -Property @{    
        FullName = $Item
        UserName = $User.SamAccountName
        Email = $User.mail
        UPN = $User.UserPrincipalName
        
    }

    #Add data to array
    $aResults += $hItemDetails
}

$aResults | Export-CSV ".\allUsersFullNames.csv" -NoTypeInformation