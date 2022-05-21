param (
    [Parameter(Mandatory=$true)][string]$name
)

nasm -fwin32 $name`.asm
link /subsystem:console /nodefaultlib /entry:main ./$name`.obj kernel32.lib
