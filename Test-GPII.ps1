# Clone and build GPII

mkdir gpii
cd gpii
git clone git://github.com/GPII/windows.git

# TODO build UsbUserListener

mkdir node_modules
cd node_modules
git clone git://github.com/GPII/universal.git
cd universal
npm install
cd ..\..

# Remove the extra infusion

rmdir -Recurse -Force node_modules\universal\node_modules\jqUnit\node_modules\infusion

# Patch jqUnit-node.js

& 'C:\Program Files (x86)\Git\bin\patch.exe' -u node_modules\universal\node_modules\jqUnit\lib\jqUnit-node.js $Home\gpii-automation\jqUnit-node.js.patch

# Run Tests

cd windows
node tests\acceptanceTests\AcceptanceTests_builtIn.js

exit $LastExitCode
