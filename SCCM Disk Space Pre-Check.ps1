<#
DISCLAIMER
THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
NEVER USE an untested script in Production without testing it in NON-Prod first!
.NOTES
    Author: Michael Russ
    Version: 1.1
    Date Uploaded 2026-02-21
	#>
<#
.SYNOPSIS
    Pre-deployment disk space check for SCCM Application.
    Verifies sufficient free space exists on C: drive before installation.

.DESCRIPTION
    If free space is below required threshold, logs:
    "Error Not enough space on C:"
    and exits with code 1.
	#>
<# Run the Powershell script and the installer in the same source directory
 Add this line to run unsigned scripts In Task Sequence or Packages Command Line powershell.exe -executionpolicy Bypass -file ".\SCCM Disk Space Pre-Check.ps1"
	#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [int]$RequiredSpaceGB = 5,   # Change this to required install size in GB

    [string]$LogPath = "C:\Windows\Temp\SCCM_DiskCheck.log"
)

try {

    # Get C: drive information
    $Drive = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:' AND DriveType=3" -ErrorAction Stop

    if (-not $Drive) {
        Add-Content -Path $LogPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error Unable to detect C: drive."
        exit 1
    }

    $FreeSpaceGB = [math]::Round($Drive.FreeSpace / 1GB, 2)

    # Compare free space against required threshold
    if ($FreeSpaceGB -lt $RequiredSpaceGB) {

        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error Not enough space on C: (Available: $FreeSpaceGB GB | Required: $RequiredSpaceGB GB)"
        Add-Content -Path $LogPath -Value $Message

        exit 1   # Fail deployment

    } else {

        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Disk check passed. Available: $FreeSpaceGB GB | Required: $RequiredSpaceGB GB"
        Add-Content -Path $LogPath -Value $Message

        exit 0   # Continue installation
    }

}
catch {

    $ErrorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error $($_.Exception.Message)"
    Add-Content -Path $LogPath -Value $ErrorMessage
    exit 1

}

