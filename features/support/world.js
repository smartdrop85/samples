const { setDefaultTimeout, setWorldConstructor } = require('cucumber');
const { Builder, By, until } = require('selenium-webdriver');
const config = require('./config');
const locators = require('./locators');
const fs = require('fs');

const platform = config.platform || "CHROME";

const buildChromeDriver = function () {
  require('selenium-webdriver/chrome');
  require('chromedriver');
  return new Builder().forBrowser("chrome").build();
};

const buildFirefoxDriver = function () {
  require('selenium-webdriver/firefox.js');
  require('geckodriver');
  return new Builder().forBrowser("firefox").build();
};

const buildDriver = function () {
  switch (platform) {
    case 'FIREFOX':
      return buildFirefoxDriver();
    default:
      return buildChromeDriver();
  }
};


const World = function World({ attach, parameters }) {
  this.driver = buildDriver();
  this.attach = attach;
  this.CONFIG = config;
  this.LOCATORS = locators;
  if (!fs.existsSync(config.screenshotDir)) {
    fs.mkdirSync(config.screenshotDir);
  }
};

setDefaultTimeout(60 * 1000);
setWorldConstructor(World);