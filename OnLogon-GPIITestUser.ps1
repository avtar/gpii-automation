cd C:\Users\GPIITestUser

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

# Run Tests

cd windows
node tests\acceptanceTests\AcceptanceTests_builtIn.js

Pause
