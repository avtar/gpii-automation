$exitCode = 0

cd node_modules\universal
node tests\all-tests.js
if (-not $?)
{
    $exitCode = 1
}

cd ..\..\windows
node tests\acceptanceTests\AcceptanceTests_builtIn.js
if (-not $?)
{
    $exitCode = 1
}

exit $exitCode
