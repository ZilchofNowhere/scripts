param (
    [Parameter(Mandatory)]
    [String]$fileName
)

[String[]]$parts = $fileName.Split(".")
[String]$lang = $parts[$parts.Count - 1]

if ($lang -eq "cpp") {
    g++ $fileName -o $fileName.Replace(".cpp", ".exe") -std=c++20
    Invoke-Expression ("./" + ($fileName.Replace(".cpp", "")))
} elseif ($lang -eq "c") {
    gcc $fileName -o $fileName.Replace(".c", ".exe") -std=c17
    Invoke-Expression ("./" + ($fileName.Replace(".c", "")))
} elseif ($lang -eq "py") {
    python $fileName
} elseif ($lang -eq "js") {
    node $fileName
} elseif ($lang -eq "java") {
    java $fileName
} elseif ($lang -eq "kt") {
    kotlinc $fileName -include-runtime -d $fileName.Replace(".kt", ".jar")
    kotlin $fileName.Replace(".kt", ".jar")
} elseif ($lang -eq "cs") {
    dotnet run
} elseif ($lang -eq "ts") {
    ts-node $fileName
} elseif ($lang -eq "pl") {
    perl $fileName
} elseif ($lang -eq "sh") {
    bash $fileName
} elseif ($lang -eq "rs") {
    rustc $fileName
    Invoke-Expression ("./" + ($fileName.Replace(".rs", "")))
} else {
    try {
        Invoke-Expression ("./" + ($fileName.Replace("." + $lang, "")))
    } catch {
        echo "Unrecognized file, are you sure this file exists?"
    }
}