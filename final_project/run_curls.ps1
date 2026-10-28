$base = "http://localhost:5000"
$outputDir = "C:\Users\ASUS\.gemini\antigravity-ide\scratch\expressBookReview\final_project\outputs"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# Q1 - GitHub repo info (shows fork from ibm-developer-skills-network/expressBookReview)
$cmd1 = 'curl -s https://api.github.com/repos/afikque23/Backend-Node.js-Express.js-Final'
$out1 = Invoke-RestMethod -Uri "https://api.github.com/repos/afikque23/Backend-Node.js-Express.js-Final" | ConvertTo-Json -Depth 10
"Command: $cmd1`nOutput:`n$out1" | Out-File "$outputDir\githubrepo" -Encoding utf8
Write-Host "Q1 done: githubrepo"

# Q2 - Get all books
$cmd2 = "curl -s $base/"
$out2 = Invoke-RestMethod -Uri "$base/" | ConvertTo-Json -Depth 10
"Command: $cmd2`nOutput:`n$out2" | Out-File "$outputDir\getallbooks" -Encoding utf8
Write-Host "Q2 done: getallbooks"

# Q3 - Get book by ISBN (ISBN=1)
$cmd3 = "curl -s $base/isbn/1"
$out3 = Invoke-RestMethod -Uri "$base/isbn/1" | ConvertTo-Json -Depth 10
"Command: $cmd3`nOutput:`n$out3" | Out-File "$outputDir\getbooksbyISBN" -Encoding utf8
Write-Host "Q3 done: getbooksbyISBN"

# Q4 - Get books by author
$author = "Unknown"
$cmd4 = "curl -s `"$base/author/$author`""
$out4 = Invoke-RestMethod -Uri "$base/author/$author" | ConvertTo-Json -Depth 10
"Command: $cmd4`nOutput:`n$out4" | Out-File "$outputDir\getbooksbyauthor" -Encoding utf8
Write-Host "Q4 done: getbooksbyauthor"

# Q5 - Get books by title
$title = "Fairy"
$cmd5 = "curl -s `"$base/title/$title`""
$out5 = Invoke-RestMethod -Uri "$base/title/$title" | ConvertTo-Json -Depth 10
"Command: $cmd5`nOutput:`n$out5" | Out-File "$outputDir\getbooksbytitle" -Encoding utf8
Write-Host "Q5 done: getbooksbytitle"

# Q6 - Get book review (ISBN=1)
$cmd6 = "curl -s $base/review/1"
$out6 = Invoke-RestMethod -Uri "$base/review/1" | ConvertTo-Json -Depth 10
"Command: $cmd6`nOutput:`n$out6" | Out-File "$outputDir\getbookreview" -Encoding utf8
Write-Host "Q6 done: getbookreview"

# Q7 - Register a user
$cmd7 = 'curl -s -X POST http://localhost:5000/register -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"password\":\"testpass123\"}"'
$body7 = '{"username":"testuser","password":"testpass123"}'
$out7 = Invoke-RestMethod -Uri "$base/register" -Method POST -ContentType "application/json" -Body $body7 | ConvertTo-Json -Depth 10
"Command: $cmd7`nOutput:`n$out7" | Out-File "$outputDir\register" -Encoding utf8
Write-Host "Q7 done: register"

# Q8 - Login
$cmd8 = 'curl -s -X POST http://localhost:5000/customer/login -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"password\":\"testpass123\"}"'
$body8 = '{"username":"testuser","password":"testpass123"}'
$out8 = Invoke-RestMethod -Uri "$base/customer/login" -Method POST -ContentType "application/json" -Body $body8 | ConvertTo-Json -Depth 10
"Command: $cmd8`nOutput:`n$out8" | Out-File "$outputDir\login" -Encoding utf8
Write-Host "Q8 done: login"

Write-Host "All basic tasks done!"
