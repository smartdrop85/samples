const { After, Status } = require('cucumber');
const fs = require('fs');
const path = require('path');
const sanitizeFileName = require('sanitize-filename');

After(async function (scenarioResult) {
  const { result, pickle } = scenarioResult;
  if (result.status === 'failed') {
    const screenshot = await this.driver.takeScreenshot();
    const base64Data = screenshot.replace(/^data:image\/png;base64,/, '');
    await this.attach(screenshot, 'image/png');
    const screenshotPath = path.join(
      this.CONFIG.screenshotDir,
      sanitizeFileName(`${pickle.name}_${(new Date()).toISOString()}.png`.replace(/ /g, '_')),
    );
    console.log(`screenshot was saved as ${screenshotPath}`);
    fs.writeFileSync(screenshotPath, base64Data, 'base64');
  }
  return this.driver.quit();
});
