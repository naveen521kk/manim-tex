$ErrorActionPreference = 'stop'; # stop on all errors
 
$toolsDirActual  = "$($PWD)"
$toolsDir = "$($env:TMP)\Texlive"
$texliveInstall = "http://mirrors.ctan.org/systems/texlive/tlnet/install-tl.zip"
$profileUrl = "https://yihui.org/gh/tinytex/tools/tinytex.profile"
$pkgcustom = "https://yihui.org/gh/tinytex/tools/pkgs-custom.txt"
$luatexmirror = "http://mirror.ctan.org/tex-archive/systems/texlive/tlnet/archive/luatex.win32.tar.xz"

mkdir "$toolsDir\manimtex"
Invoke-WebRequest -Uri $texliveInstall -OutFile "$toolsDir\install-tl.zip"

7z x "$toolsDir\install-tl.zip" -o"$toolsDir\manimtex"

#Remove the zip file
Remove-Item "$toolsDir\install-tl.zip"

#download tinytex.profile and modify it (set texdir to ./TinyTeX)
Copy-Item -Path "$PWD\manimtex.profile" -Destination "$toolsDir\manimtex\manimtex.profile"

(gc "$toolsDir\manimtex\manimtex.profile") -replace '\./', './ManimTex/' | Out-File -encoding ASCII "$toolsDir\manimtex\manimtex.profile"

Add-Content -Path "$toolsDir\manimtex\manimtex.profile" -Value 'TEXMFCONFIG $TEXMFSYSCONFIG'
Add-Content -Path "$toolsDir\manimtex\manimtex.profile" -Value 'TEXMFHOME $TEXMFLOCAL'
Add-Content -Path "$toolsDir\manimtex\manimtex.profile" -Value 'TEXMFVAR $TEXMFSYSVAR'

#download the custom package list TODO:Here

Copy-Item -Path "$PWD\pkgs-manim.txt -Destination "$toolsDir\manimtex\pkgs-manim.txt"
foreach ($c in (gc "$toolsDir\manimtex\pkgs-manim.txt").split()){
    $pkgs="$pkgs $c"
}

#an automated installation of TeXLive (infrastructure only)
cd "$($toolsDir)\tinytex"
cd "install-tl-*"

Start-Process -FilePath "$($PWD)\install-tl-windows.bat" -ArgumentList "-no-gui -profile=`"$($toolsDir)\manimtex\manimtex.profile`"" -WorkingDirectory "$($PWD)" -NoNewWindow -Wait

Move-Item "$($PWD)\ManimTex" "$($toolsDirActual)\ManimTex"

cd "$toolsDirActual"

#remove temp directory from path and edelete it
Remove-Item "$toolsDir\" -Recurse

Start-Process -ArgumentList "path add" -FilePath "$($toolsDirActual)\ManimTex\bin\win32\tlmgr.bat" -NoNewWindow -Wait
Start-Process -ArgumentList "install latex-bin xetex $($pkgs)" -FilePath "$($toolsDirActual)\ManimTex\bin\win32\tlmgr.bat" -NoNewWindow -Wait
