const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // Load your QTIJS-rendered page
    await page.goto(process.argv[2]); // URL passed as first argument
    await page.waitForTimeout(1000);  // Wait for JS rendering

    // Query for element with title="sc1d"
    const element = await page.$('[title="sc1d"]');

    if (element) {
        console.log("FOUND");
        process.exit(0);
    } else {
        console.log("NOT FOUND");
        process.exit(1);
    }
})();
