<#
DISCLAIMER
THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
NEVER USE an untested script in Production without testing it in NON-Prod first!
.NOTES
    Author: Michael Russ
    Version: 1.0
    Date: 2024-11-15
	#>
#Allows you to remotely reboot a PC 
$system = Read-Host "Enter the PC Name you wish to reboot and connect to
(Must be logged on as an Administrator"

Restart-Computer $system -Force -Verbose
Do {
	$connection = Test-Connection $system -Count 1 -ErrorAction SilentlyContinue
	$connection
	timeout 3 /nobreak > 0
}
Until (non ($connection))

"
$system is offline....
"

Do {
	$connection = Test-Connection $system -Count 1 -ErrorAction SilentlyContinue
	$connection
	"Testing connection..."
	timeout 2 /nobreak > 0
}
Until ($connection)
"
$system is back online!
"
timeout 2 /nobreak > 0

mstsc.exe /v:$system