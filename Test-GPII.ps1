Set-PSDebug -Trace 2

if (Test-Path gpii) {
    rmdir -Recurse -Force gpii
}

# Use ASCII characters for the npm tree drawing

$env:npm_config_unicode = "false"

# Clone and build GPII

mkdir gpii
cd gpii
git clone https://github.com/GPII/windows.git
cd windows
npm install --ignore-scripts=true
grunt --no-color build
cd ..

# Patch jqUnit-node.js

& 'C:\Program Files (x86)\Git\bin\patch.exe' -u node_modules\universal\node_modules\jqUnit\lib\jqUnit-node.js $Home\gpii-automation\jqUnit-node.js.patch

# Run Tests

cd windows
node tests\acceptanceTests\AcceptanceTests_builtIn.js

exit $LastExitCode
