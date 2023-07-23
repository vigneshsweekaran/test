# Set the path to the .gitattributes file (adjust the path if necessary)
$gitAttributesFile = ".gitattributes"

# Check if the file exists
if (Test-Path $gitAttributesFile) {
    # Read the contents of the .gitattributes file
    $gitAttributesContent = Get-Content $gitAttributesFile -Raw

    # Extract the section between the comments
    $startComment = "#exclude_file_list_start"
    $endComment = "#exclude_file_end"
    $startIndex = $gitAttributesContent.IndexOf($startComment)
    $endIndex = $gitAttributesContent.IndexOf($endComment, $startIndex)
    
    if ($startIndex -ge 0 -and $endIndex -ge 0) {
        $fileListSection = $gitAttributesContent.Substring($startIndex + $startComment.Length, $endIndex - ($startIndex + $startComment.Length))
        
        # Extract the paths defined in the section
        $filePaths = $fileListSection | ForEach-Object {
            # Skip comments and empty lines
            if ($_ -match '^\s*(?!#)\s*([^\s#]+)') {
                $matches[1]
            }
        }

        # Output the list of file paths
        if ($filePaths.Count -gt 0) {
            Write-Host "Files defined between '#exclude_file_list_start' and '#exclude_file_end' in .gitattributes:"
            $filePaths | ForEach-Object {
                Write-Host "- $_"
            }
        } else {
            Write-Host "No files defined between '#exclude_file_list_start' and '#exclude_file_end' in .gitattributes."
        }
    } else {
        Write-Host "No section found between '#exclude_file_list_start' and '#exclude_file_end' in .gitattributes."
    }
} else {
    Write-Host "The .gitattributes file does not exist in the current directory."
}
$Patterns = @("private", "pets*", "tracker*")
$PathToCheck = $env:GITHUB_WORKSPACE
$WordExcludeList = @("snippet")
$Matches = @()
# Find matches in directory names and file names
Get-ChildItem -Path $PathToCheck -Recurse | ForEach-Object {
    $Type = if ($_.PSIsContainer) { "dir" } else { "filename" }
    $Name = $_.FullName
    foreach ($Pattern in $Patterns) {
        # Check if the current pattern is not in the word exclude list
        if ($WordExcludeList -notcontains $Pattern) {
            if ($Name -like "*$Pattern*") {
                $Matches += New-Object PSObject -Property @{
                    Type = $Type
                    Match = $Pattern
                    Name = $Name
                }
            }
        }
    }
}