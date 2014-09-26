# Use ASCII characters for the npm tree drawing

$env:npm_config_unicode = "false"

# Build GPII

cd windows
npm install --ignore-scripts=true
grunt --no-color build
cd ..

# Patch jqUnit-node.js

& 'C:\Program Files (x86)\Git\bin\patch.exe' -u node_modules\universal\node_modules\jqUnit\lib\jqUnit-node.js $Home\gpii-automation\gpii-win-8.1\jqUnit-node.js.patch
