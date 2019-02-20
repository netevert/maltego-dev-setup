function Test-Already-Installed {
    Param ([String] $software)

    $x86_check = ((Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") | Where-Object { $_."DisplayName" -like "*$software*" } ) -ne $null;
    if(Test-Path 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
        $x64_check = ((Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*") | Where-Object { $_."DisplayName" -like "*$software*" } ) -ne $null;
    }
    return $x86_check -or $x64_check;
}   

# Fix SSL/TLS connection issue
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Notepad++
If (Test-Already-Installed "Notepad++") {
    Write-Output "[*] Notepad++ is already installed"
} else {
    Write-Output "[*] Notepad++ 7.6.3 (x64)"
    $outfile = "npp-x64.7.6.3.exe"
    Write-Output "      Downloading..."
    Invoke-RestMethod -Uri https://notepad-plus-plus.org/repository/7.x/7.6.3/npp.7.6.3.Installer.x64.exe -OutFile $outfile
    Write-Output "      Downloading DONE"
    Write-Output "      Installing..."
    start-process -FilePath $outfile -ArgumentList '/S' -wait
    Write-Output "      Installing DONE"
    Remove-Item $outfile
}

# Install Python 3.7
If (Test-Already-Installed "Python 3.7") {
    Write-Output "[*] Python 3.7 is already installed"
} else {
    Write-Output "[*] Python 3.7.2 (x64)"
    $outfile = "python3.7.2.exe"
    Write-Output "      Downloading..."
    Invoke-RestMethod -Uri https://www.python.org/ftp/python/3.7.2/python-3.7.2-amd64.exe -OutFile $outfile
    Write-Output "      Downloading DONE"
    # Command line options at https://docs.python.org/3.7/using/windows.html#installing-without-ui
    Write-Output "      Installing..."
    start-process -FilePath $outfile -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' -wait
    # Refresh path
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Output "      Installing DONE"
    Remove-Item $outfile
}

# Install Maltego Transform Library for Python
Write-Output "[*] Maltego-trx"
Write-Output "      Installing..."
pip install maltego-trx
Write-Output "      Installing DONE"

# Install Maltego
If (Test-Already-Installed "Maltego") {
    Write-Output "[*] Maltego is already installed"
} else {
    Write-Output "[*] Maltego 4.2.1.12167 + JRE (x64)"
    $outfile = 'maltego-4.2.1-jre-x64.exe'
    Write-Output "      Downloading..."
    Invoke-RestMethod -Uri https://www.paterva.com/malv421/MaltegoSetup.JRE64.v4.2.1.12167.exe -OutFile $outfile
    Write-Output "      Downloading DONE"
    Write-Output "      Installing..."
    start-process -FilePath $outfile -ArgumentList "/S" -wait
    Write-Output "      Installing DONE"
    Remove-Item $outfile
}