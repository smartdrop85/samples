const { Given, When, Then } = require('cucumber');
const { By, until, Key } = require('selenium-webdriver');
const { expect } = require('chai');

Given(/^I am logged in LK$/, async function() {
  await this.driver.manage().window().maximize();
  await this.driver.get(this.CONFIG.url);
  //TODO remove sleeps
  await this.driver.sleep(10000);
  //
  await this.driver.findElement(By.css(this.LOCATORS.USERNAME_FIELD))
    .sendKeys(this.CONFIG.username);
  await this.driver.findElement(By.css(this.LOCATORS.PASSWORD_FIELD))
    .sendKeys(this.CONFIG.password);
  await this.driver.findElement(By.css(this.LOCATORS.LOGIN_BUTTON)).click();
  //TODO remove sleeps
  await this.driver.sleep(10000)
});

Given(/^Sample report tab is opened$/, async function () {
  await this.driver.findElement(By.css(this.LOCATORS.REPORTS_BUTTON)).click();
  await this.driver.findElement(By.css(this.LOCATORS.ANNUAL_REPORT_BUTTON)).click();
  //TODO remove sleeps
  await this.driver.sleep(30000)
});

When(/^I select a company ([^"]*) in companies list$/, async function (company) {
  await this.driver.switchTo().frame(this.driver.findElement(By.css(this.LOCATORS.IFRAME)));
  await this.driver.findElement(By.className(this.LOCATORS.COMPANIES_LIST)).click();
  await this.driver.findElement(By.id(this.LOCATORS.ORN_INPUT_FIELD)).sendKeys(company);
  await this.driver.findElement(By.css(this.LOCATORS.COMPANIES, company)).click()
});

When(/^I create new report$/, async function () {
  await this.driver.findElement(By.className(this.LOCATORS.CREATE_REPORT_BUTTON)).click()
});