# Imports
Import-Module 'C:\tools\gsudo\Current\gsudoModule.psd1'

# Aliases
sal -name reboot -value restart-computer
sal -name set-color -value "Set-PSReadLineOption -Colors"
sal -name get-color -value Get-PSReadLineOption
sal -name input -value Read-Host
sal -name msedge -value MicrosoftEdge.exe
$Apps = $env:ProgramFiles
$Appsx86 = ${env:ProgramFiles(x86)}
sal -name ls -value logo-ls
sal -name adb -value "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
sal -name cmatrix -value "Invoke-Cmatrix"

# Theme
Set-PoshPrompt -Theme aliens

# Syntax highlighting
Set-PSReadLineOption -Colors @{ Parameter = 'Cyan' }
Set-PSReadLineOption -Colors @{ String = 'DarkYellow' }
Set-PSReadLineOption -Colors @{ Operator = 'DarkCyan' }
Set-PSReadLineOption -Colors @{ ContinuationPrompt = 'Blue' }
Set-PSReadLineOption -Colors @{ Variable = "Magenta"}

# Functions
function Invoke-Cmatrix {
	unimatrix -n -s 96 -l o  # install unimatrix via pip first
}

# EOF
