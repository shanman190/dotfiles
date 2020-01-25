# To get started run the following:
#
# (iwr https://raw.githubusercontent.com/shanman190/dotfiles/master/setup.ps1).Content | iex

cd $env:USERPROFILE

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest https://chocolatey.org/install.ps1 | Invoke-Expression

# Setup MSYS to allow symlinks
[System.Environment]::SetEnvironmentVariable('MSYS', 'winsymlinks:nativestrict', [System.EnvironmentVariableTarget]::User)

# Reconfigure default apps
If ((Get-ItemProperty "HKCU:\Software\Microsoft\windows\Shell\Associations\UrlAssociations\https\UserChoice").ProgId -ne "ChromeHTML") {
	control.exe /name Microsoft.DefaultPrograms /page pageDefaultProgram
	pause
}

# Install bash/git for Windows
choco install git --yes --force --params "/WindowsTerminal"

# Start main installation script
Invoke-WebRequest https://raw.githubusercontent.com/shanman190/dotfiles/master/setup.sh -OutFile $TEMP\setup.sh
& 'C:\Program Files\git\bin\bash.exe' -i $TEMP\setup.sh
del $TEMP\setup.sh