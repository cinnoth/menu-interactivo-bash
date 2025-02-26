const { Given, When, Then, After } = require("@cucumber/cucumber");
const { Builder, By, until } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");
const assert = require("assert").strict;

let driver;

Given("el usuario abre la página Angular", async function () {
  const options = new chrome.Options();
  const uniqueUserDir = `/tmp/chrome-profile-${Date.now()}`;
  options.addArguments(`--user-data-dir=${uniqueUserDir}`);

  options.addArguments('--headless'); 
  options.addArguments('--disable-gpu');
  options.addArguments('--no-sandbox');
  options.addArguments('--disable-dev-shm-usage');


  driver = await new Builder().forBrowser("chrome").setChromeOptions(options).build();
  await driver.get("http://localhost:4200");
});

When("el usuario hace clic en 'Learn with Tutorials'", async function () {
  const link = await driver.wait(
    until.elementLocated(By.linkText("Learn with Tutorials")),
    5000
  );
  await link.click();
});

Then("el usuario es redirigido a la página de tutoriales", async function () {
  await driver.wait(until.urlContains("/tutorials"), 15000);
  const url = await driver.getCurrentUrl();
  assert.ok(url.includes("/tutorials"), "No se redirigió correctamente");
});

After(async function () {
  if (driver) {
    await driver.quit();
  }
});
