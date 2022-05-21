param (
    [Parameter(Mandatory)]
    [String]$fileName
)

g++ $fileName -o $fileName.Replace(".cpp", ".exe") -std=c++17
Invoke-Expression ("./" + ($fileName.Replace(".cpp", "")))