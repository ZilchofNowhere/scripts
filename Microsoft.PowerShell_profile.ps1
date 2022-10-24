# Imports
Import-Module 'C:\tools\gsudo\Current\gsudoModule.psd1'
Import-Module cd-extras
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -Force

# Aliases and variables
sal -name reboot -value restart-computer
sal -name set-color -value "Set-PSReadLineOption -Colors"
sal -name get-color -value Get-PSReadLineOption
sal -name input -value Read-Host
sal -name msedge -value MicrosoftEdge.exe
$Apps = $env:ProgramFiles
$Appsx86 = ${env:ProgramFiles(x86)}
$Desktop = "~/Desktop"
sal -name ls -value lsd
sal -name adb -value "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
sal -name cmatrix -value "Invoke-Cmatrix"
sal -name vim -value "nvim"
sal -name which -value "find-where"
sal -name neofetch -value winfetch
[System.Environment]::SetEnvironmentVariable("LS_COLORS", "$(vivid generate gruvbox-dark)")

# Theme
# Set-PoshPrompt -Theme aliens

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

function vimconfig {
	nvim $env:localappdata\nvim\init.vim
}

function pwshconfig {
	sudo nvim $profile
}

function find-where {
	param (
		$command
	)
	gcm $command -all | format-table -wrap -autosize
}

function notedit {
	cd $Desktop/Notes
	vim -c "Neotree"
	cd -
}

# winget autocompletion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Instructed to be at the very end
Invoke-Expression (&starship init powershell)
# EOF
