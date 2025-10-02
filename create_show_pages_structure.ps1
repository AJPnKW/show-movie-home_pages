<# ======================================================================
 Script Name : create_show_pages_structure.ps1
 Purpose     : Create GitHub Pages folder/file structure for show/movie pages
 Author      : ChatGPT (for Andrew J. Pearen)
 Creation    : 2025-10-01
 Version     : 1.0.0
 Tested On   : Windows 11 Pro (PowerShell 5/7)

 USAGE:
   Right-click → Run with PowerShell
   or
   pwsh -File "C:\Users\andre\Projects\show-movie-home_pages\create_show_pages_structure.ps1" -RepoRoot "C:\Users\andre\Projects\show-movie-home_pages" -ForceFiles:$false

 PARAMETERS:
   -RepoRoot    : Local path to your repo folder (no trailing slash)
   -SiteTitle   : Title shown on the site (default: "Shows • Home")
   -ForceFiles  : If $true, overwrites existing *template* files
   -VerboseLog  : If $true, include extra details in the log file

 OUTPUT:
   Creates folders and baseline files under: <RepoRoot>\docs
   Logs to: <RepoRoot>\logs\create_show_pages_structure_<yyyyMMdd_HHmmss>.log

 NOTES:
   - Ensures lowercase folder names.
   - Adds .nojekyll for GitHub Pages.
   - Safe to re-run; won’t clobber files unless -ForceFiles is set.
   - Keep all names lowercase with underscores per your standard.
 ====================================================================== #>

param(
  [string]$RepoRoot = "C:\Users\andre\Projects\show-movie-home_pages",
  [string]$SiteTitle = "Shows • Home",
  [bool]$ForceFiles = $false,
  [bool]$VerboseLog = $false
)

# 0) Pre-flight
$ErrorActionPreference = "Stop"
$script:VERSION = "1.0.0"
$startTime = Get-Date
$stamp = $startTime.ToString("yyyyMMdd_HHmmss")

function Write-Info  { param([string]$msg) Write-Host "[INFO ] $msg" }
function Write-Warn  { param([string]$msg) Write-Warning "$msg" }
function Write-Error2{ param([string]$msg) Write-Error "$msg" }

# 1) Resolve paths (lowercase folders per standard)
$repo = (Resolve-Path -LiteralPath $RepoRoot).Path
$docs = Join-Path $repo "docs"
$assets = Join-Path $docs "assets"
$css = Join-Path $assets "css"
$img = Join-Path $assets "img"
$logsDir = Join-Path $repo "logs"

# 2) Ensure folders exist
$folders = @($docs, $assets, $css, $img, $logsDir)
foreach ($f in $folders) {
  if (-not (Test-Path -LiteralPath $f)) {
    New-Item -ItemType Directory -Path $f | Out-Null
    Write-Info "Created: $f"
  } else {
    Write-Info "Exists : $f"
  }
}

# 3) Start logging (file transcript + lightweight console)
$logFile = Join-Path $logsDir ("create_show_pages_structure_{0}.log" -f $stamp)
Start-Transcript -Path $logFile -Append | Out-Null

Write-Host "==============================================================="
Write-Host " Script: create_show_pages_structure.ps1"
Write-Host " Version: $($script:VERSION)"
Write-Host " RepoRoot: $repo"
Write-Host " Started : $startTime"
Write-Host " LogFile : $logFile"
Write-Host "==============================================================="

# 4) Helper: write file only if missing or if ForceFiles = $true
function Ensure-File {
  param(
    [Parameter(Mandatory=$true)][string]$Path,
    [Parameter(Mandatory=$true)][string]$Content,
    [bool]$Force = $false
  )
  if ((Test-Path -LiteralPath $Path) -and -not $Force) {
    Write-Info "Keep   : $Path (exists, not overwritten)"
    return
  }
  $parent = Split-Path -Parent $Path
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent | Out-Null }
  $Content | Out-File -FilePath $Path -Encoding UTF8 -Force
  Write-Info ("Write  : {0} {1}" -f $Path, ($(if($Force){"(overwritten)"}else{"(new)"})))
}

# 5) Baseline content (minimal but functional)
$readme = @"
# show-movie-home_pages

Static show/movie landing pages served by **GitHub Pages** from the `/docs` folder.

**Live site:** https://ajpnkw.github.io/show-movie-home_pages/

## Structure
- /docs
  - index.html
  - only-murders-s01.html
  - /assets/css/style.css
  - /assets/img/
  - .nojekyll

## Edit workflow
- Update HTML in `/docs`
- Commit & push to `main`
- GitHub Pages auto-deploys

"@

$nojekyll = "" # presence of this file is enough

$style = @"
:root { --bg:#0b0b0d; --card:#16161a; --text:#eaeaea; --muted:#a0a0a0; --accent:#4da3ff; }
*{box-sizing:border-box} body{margin:0;background:var(--bg);color:var(--text);font:16px/1.5 system-ui,Segoe UI,Roboto,Arial}
.container{max-width:1080px;margin:32px auto;padding:0 16px}
h1{margin:0 0 16px}
.card-list{list-style:none;padding:0;margin:0;display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:12px}
.card-list a{display:block;background:var(--card);padding:14px 16px;border-radius:14px;text-decoration:none;color:var(--text);border:1px solid #222}
.card-list a:hover{outline:2px solid var(--accent)}
.header{display:grid;grid-template-columns:140px 1fr;gap:16px;margin:12px 0 20px}
.header img{width:140px;height:auto;border-radius:12px;border:1px solid #222}
.grid{display:grid;grid-template-columns:1fr 360px;gap:16px}
.table{width:100%;border-collapse:separate;border-spacing:0}
.table th,.table td{padding:10px 12px;border-bottom:1px solid #222}
.table tr:nth-child(even){background:#131318}
.badge{font-size:12px;color:var(--muted)}
a.inline{color:var(--accent);text-decoration:none}
.stills{display:grid;grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:8px}
.stills img{width:100%;height:auto;border-radius:8px;border:1px solid #222}
"@

$index = @"
<!doctype html>
<html lang=""en"">
<head>
  <meta charset=""utf-8"" />
  <title>$SiteTitle</title>
  <meta name=""viewport"" content=""width=device-width, initial-scale=1"" />
  <link rel=""stylesheet"" href=""./assets/css/style.css"" />
</head>
<body>
  <main class=""container"">
    <h1>Shows</h1>
    <ul class=""card-list"">
      <li><a href=""./only-murders-s01.html"">Only Murders in the Building — Season 1</a></li>
    </ul>
  </main>
</body>
</html>
"@

$sampleSeason = @"
<!doctype html>
<html lang=""en"">
<head>
  <meta charset=""utf-8"" />
  <title>Only Murders in the Building — S01</title>
  <meta name=""viewport"" content=""width=device-width, initial-scale=1"" />
  <link rel=""stylesheet"" href=""./assets/css/style.css"" />
</head>
<body>
  <main class=""container"">
    <a class=""inline"" href=""./index.html"">← Back</a>
    <div class=""header"">
      <img alt=""Poster"" src=""https://image.tmdb.org/t/p/w500/4XddcRDtnNjYM5r9G1K2wQXd3QQ.jpg"" />
      <div>
        <h1>Only Murders in the Building <span class=""badge"">S01 • 2021 • TMDB: 107113</span></h1>
        <p>A trio obsessed with true crime podcasts find themselves wrapped up in a murder in their own apartment building.</p>
        <p>
          Watch:
          <a class=""inline"" href=""https://nunflix.org/watch/tv/107113/1/1"">Nunflix</a> ·
          <a class=""inline"" href=""https://vidsrc.net/embed/tv?tmdb=107113&season=1"">VidSrc</a> ·
          <a class=""inline"" href=""https://www.themoviedb.org/tv/107113"">TMDB</a>
        </p>
      </div>
    </div>

    <div class=""grid"">
      <section>
        <h2>Episodes</h2>
        <table class=""table"">
          <thead><tr><th>#</th><th>Title</th><th>Links</th></tr></thead>
          <tbody>
            <tr>
              <td>S01E01</td>
              <td>True Crime</td>
              <td>
                <a class=""inline"" href=""https://nunflix.org/watch/tv/107113/1/1"">Nunflix</a> ·
                <a class=""inline"" href=""https://vidsrc.net/embed/tv?tmdb=107113&season=1&episode=1"">VidSrc</a> ·
                <a class=""inline"" href=""https://image.tmdb.org/t/p/w300/eK1l0iG6xXQ8bR9KZ1G1Eo2O9oP.jpg"">Still</a>
              </td>
            </tr>
            <tr>
              <td>S01E02</td>
              <td>Who Is Tim Kono?</td>
              <td>
                <a class=""inline"" href=""https://nunflix.org/watch/tv/107113/1/2"">Nunflix</a> ·
                <a class=""inline"" href=""https://vidsrc.net/embed/tv?tmdb=107113&season=1&episode=2"">VidSrc</a> ·
                <a class=""inline"" href=""https://image.tmdb.org/t/p/w300/9p5iYxKqf8D4gM2N0X3m7Qq2gqP.jpg"">Still</a>
              </td>
            </tr>
          </tbody>
        </table>

        <h3>Episode Stills</h3>
        <div class=""stills"">
          <img alt=""E01 still"" src=""https://image.tmdb.org/t/p/w300/eK1l0iG6xXQ8bR9KZ1G1Eo2O9oP.jpg"" />
          <img alt=""E02 still"" src=""https://image.tmdb.org/t/p/w300/9p5iYxKqf8D4gM2N0X3m7Qq2gqP.jpg"" />
        </div>
      </section>

      <aside>
        <h2>Season 1</h2>
        <p>10 episodes · Comedy, Crime, Mystery.</p>
        <p><strong>Open externally:</strong><br/>
           <a class=""inline"" href=""https://ajpnkw.github.io/show-movie-home_pages/index.html"">Home</a><br/>
           <a class=""inline"" href=""https://www.themoviedb.org/tv/107113/season/1"">TMDB Season</a>
        </p>
      </aside>
    </div>
  </main>
</body>
</html>
"@

# 6) Write files  (FIXED: create .nojekyll without empty -Content)
Ensure-File -Path (Join-Path $repo "README.md") -Content $readme -Force:$ForceFiles
# .nojekyll: create zero-byte file safely (no empty -Content)
$nojekyllPath = Join-Path $docs ".nojekyll"
if (-not (Test-Path -LiteralPath $nojekyllPath)) {
  New-Item -ItemType File -Path $nojekyllPath | Out-Null
  Write-Info ("Write  : {0} (new)" -f $nojekyllPath)
} else {
  Write-Info ("Keep   : {0} (exists, not overwritten)" -f $nojekyllPath)
}

Ensure-File -Path (Join-Path $css "style.css") -Content $style -Force:$ForceFiles
Ensure-File -Path (Join-Path $docs "index.html") -Content $index -Force:$ForceFiles
Ensure-File -Path (Join-Path $docs "only_murders_s01.html") -Content $sampleSeason -Force:$ForceFiles

# 7) Optional: create .gitignore for local logs
$gitignore = @"
# local logs not needed in repo
/logs/
"@
Ensure-File -Path (Join-Path $repo ".gitignore") -Content $gitignore -Force:$false


# 8) Summary
$endTime = Get-Date
Write-Host "---------------------------------------------------------------"
Write-Host " Completed in $([int]($endTime - $startTime).TotalSeconds) sec"
Write-Host " Docs path : $docs"
Write-Host " Try URL   : https://ajpnkw.github.io/show-movie-home_pages/"
Write-Host "---------------------------------------------------------------"

Stop-Transcript | Out-Null
