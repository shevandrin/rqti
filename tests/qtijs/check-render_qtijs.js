const { chromium } = require("playwright");

(async () => {
  const url = process.argv[2];
  const expectedTitle = "sc1d";

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  try {
    await page.goto(url, { waitUntil: "domcontentloaded" });
    await page.waitForFunction(
      (title) => document.title.trim() === title,
      expectedTitle,
      { timeout: 5000 }
    );

    const actualTitle = await page.title();
    if (actualTitle.trim() !== expectedTitle) {
      console.error(`Expected title "${expectedTitle}", got "${actualTitle}".`);
      process.exitCode = 1;
    } else {
      console.log(`Title matched: ${actualTitle}`);
    }
  } catch (error) {
    const actualTitle = await page.title().catch(() => "");
    console.error(`Expected title "${expectedTitle}", got "${actualTitle}".`);
    console.error(error.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
