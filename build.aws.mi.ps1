[CmdletBinding()]
param (
    $Configuration,
    $PackageVersion,
    $AssemblyVersion,
    $PackageOutput
)

$slnFile = Join-Path $PSScriptRoot "Application\Ed-Fi-ODS-AdminApi.sln"
$prjFile = Join-Path $PSScriptRoot "Application\EdFi.Ods.AdminApi\EdFi.Ods.AdminApi.csproj"
$publishDir = Join-Path $PSScriptRoot "Application\EdFi.Ods.AdminApi\publish"

$nuspecTemplate = Join-Path $publishDir "EdFi.Ods.AdminApi.nuspec"
$nuspecFinal = Join-Path $publishDir "MIDH.Ods.AdminApi.nuspec"

dotnet build $slnFile -c $Configuration --no-restore -p:InformationalVersion=$PackageVersion -p:FileVersion=$AssemblyVersion
dotnet publish $prjFile -c $Configuration --no-restore --no-build /p:EnvironmentName=Production -o $publishDir

$nuspecContent = Get-Content $nuspecTemplate -Raw
$nuspecContent = $nuspecContent.Replace('<id>EdFi.Suite3.ODS.AdminApi</id>','<id>MIDH.Ods.AdminApi</id>')
$nuspecContent = $nuspecContent.Replace('<version>1.0.0.0</version>',"<version>$PackageVersion</version>")
$nuspecContent = $nuspecContent.Replace('exclude="AppCommon/**/*.*;E2E Tests/**;Docker/**;Compose/**"','exclude="AppCommon/**/*.*;E2E Tests/**;Docker/**;Compose/**;**/.*"')
Set-Content -Path $nuspecFinal -Value $nuspecContent

dotnet pack $prjFile -c $Configuration --no-restore --no-build -o $PackageOutput -p:NuspecFile=$nuspecFinal -p:NoWarn=NU5100%3BNU5110%3BNU5111
