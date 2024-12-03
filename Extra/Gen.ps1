$mdTemplate = @'
# [COMMAND_NAME]

## SYNOPSIS
[SYNOPSIS]

## SYNTAX
```
[SYNTAX]
```

## DESCRIPTION
[DESCRIPTION]

## EXAMPLES
```powershell
[EXAMPLES]
```

## PARAMETERS
[PARAMETERS]

## INPUTS
[INPUTS]

## OUTPUTS
[OUTPUTS]

## RELATED LINKS
[LINKS]
'@

$basePath = "./Documentation"
$modulePath = "./PSIdentityNow/PSIdentityNow.psd1"
$module = Import-Module $modulePath -Force -PassThru
$commands = get-command -Module $module | Sort-Object -Descending CommandType

foreach ($command in $commands) {
    Write-Log -Message ("Writing documentation for command: {0}" -f $command.Name)
    $help = get-help $command.Name
    $Template = $mdTemplate.Replace("[COMMAND_NAME]", $help.Name)
    $Template = $Template.Replace("[SYNOPSIS]", $help.Synopsis)
    $syntax = Get-Command $command.Name -Syntax
    $Template = $Template.Replace("[SYNTAX]", $syntax.Trim())
    $exampleString = @()
    foreach ($example in $help.examples.example) {
        $exampleString += $example.title
        $exampleString += ("{1}" -f $example.introduction.text, $example.code)
        $exampleString += ""
        $exampleString += ""
    }
    $count = ($exampleString.Count - 3)
    $exampleString = $exampleString[0..$count]
    $Template = $Template.Replace("[EXAMPLES]", ($exampleString | Out-String))
    $Template = $Template.Replace("[DESCRIPTION]", $help.description.text)
    $parameterText = ""
    foreach ($parameter in $help.parameters.parameter) {
        $parameterText += (@'
### -{0} <{1}>
{2}
```
Required?                    {3}
Position?                    {4}
Default value                {5}
Accept pipeline input?       {6}
Accept wildcard characters?  {7}
```

'@ -f
        $parameter.name,
        $parameter.parameterValue,
        $(if ($parameter.description.text) { $parameter.description.text.Replace("`n", "<br>") }),
        $parameter.required,
        $parameter.position,
        $parameter.defaultValue,
        $parameter.pipelineInput,
        $parameter.globbing)
    }

    $Template = $Template.Replace("[PARAMETERS]", $parameterText)
    $Template = $Template.Replace("[INPUTS]", $help.inputTypes.inputType.type.name)
    $Template = $Template.Replace("[OUTPUTS]", $help.returnValues.returnValue.type.name)
    $linkString = @()
    foreach ($link in $help.relatedLinks.navigationlink.uri) {
        $linkString += $link
        $linkString += ""
    }
    $count = ($linkString.Count - 2)
    $linkString = $linkString[0..$count]
    $Template = $Template.Replace("[LINKS]", ($linkString | Out-String))
    $Template | Out-File ("{0}/{1}.md" -f $basePath, $command.Name)
}