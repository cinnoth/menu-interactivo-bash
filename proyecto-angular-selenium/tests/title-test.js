const { Builder, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');

(async function example() {
  let options = new chrome.Options();
  
  
  const uniqueUserDir = `/tmp/chrome-profile-${Date.now()}`;
  options.addArguments(`--user-data-dir=${uniqueUserDir}`);

  options.addArguments('--headless'); 
  options.addArguments('--disable-gpu');
  options.addArguments('--no-sandbox');
  options.addArguments('--disable-dev-shm-usage');

  let driver = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(options)
    .build();

  try {
    await driver.get('http://localhost:4200');
    await driver.wait(until.elementLocated(By.css('app-root h1')), 5000);
    let title = await driver.findElement(By.css('app-root h1')).getText();
    console.log('✅ Título de la página:', title);
  } catch (error) {
    console.error('Error en la prueba:', error);
  } finally {
    await driver.quit();
  }
})();
