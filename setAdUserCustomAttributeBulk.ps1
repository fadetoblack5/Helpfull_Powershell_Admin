<#
DISCLAIMER
THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
NEVER USE an untested script in Production without testing it in NON-Prod first!
.NOTES
    Author: Michael Russ
    Version: 1.1
    Date: 2024-11-15
	#>
#this script will add values to custom attributes created in the Active Directory schema (userName, and birthDate)
#create a csv with 3 columns titled samAccountName, userName, birthDate
#populate each column with the Active Directory username, Ultipro Username, and birthdate
#run script in batches to minimize possibility of mistakes


$users = import-csv -path c:\temp\hrFullNames.csv 


forEach($user in $users){

$birthDate = $user.birthDate
$userName = $user.userName
$attributes = @{}
$attributes.Add("birthDate", "$birthDate")
$attributes.Add("userName", $userName)

Set-ADUser -identity $user.samAccountName -add $attributes

}
