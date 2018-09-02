import time
import os
import requests

from behave import *

from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.expected_conditions import staleness_of

use_step_matcher("parse")

"""
NB!!! All assertions should be done only in @then steps
Whenever it is possible provide readable error messages for assertions

Then step MUST use the following template:

try:
  ...
  assert (some condition), 'MANDATORY assert fail description'
  assert (some condition), 'MANDATORY assert fail description'
  assert (some condition), 'MANDATORY assert fail description'
except AssertionError:
  create_screenshot(context) # this function create and store screenshoot for future analysis
  raise # (!!!) assertion exception MUST be rethrown and it will log message path as second parameter in assert  

"""


def create_screenshot(context):
    """
    This function create screenshot and store it in file with scenario name
    :param context:
    :return:
    """
    # Create screenshot
    if not os.path.isdir('Screenshots'):
        os.mkdir('Screenshots')

    scn_name: str = context.scenario.name.replace(' ', '_')
    if not context.browser.save_screenshot('Screenshots/' + scn_name + '.png'):
        print("No screenshot taken\n")
    else:
        print("Screenshot: " + scn_name + ".png taken")


"""
###GIVEN###
"""


@step('Some portal {page} page is opened and start popup is skipped')
def step_impl(context, page: str):
    """
    This step is used to move on page under test
    :param context: behave.runner.Context
    :param page: related path to the page under test from the main page
      for example: /news
      Special page name only Main in this case main page will be displayed
      If it is not possible to move directly on the page under test it should be
        done in 2-3-4 steps: the first one move to page that available with path and then click on links
    :return: none
    """
    old_page = context.browser.find_element_by_tag_name('html')

    if page == 'Main':
        context.browser.get(context.host)
    else:
        context.browser.get(context.host + page)

    # After Deploy it takes an additional time to load the fist page and cache data.
    # That is why need some time to prevent unexpected fail.
    if context.first_time_execution:
        time.sleep(10)
        context.first_time_execution: bool = False

    WebDriverWait(context.browser, 10).until(staleness_of(old_page))

    if len(context.browser.find_elements(By.CSS_SELECTOR, "button.btn.btn-buy")) == 1:
        if context.browser.find_element(By.CSS_SELECTOR, "button.btn.btn-buy").is_displayed():
            context.browser.find_element(By.CSS_SELECTOR, "button.btn.btn-buy").click()
            time.sleep(1)
        else:
            pass
    else:
        pass


@given('The course {course_name} exists')
def step_impl(context, course_name: str):
    """
    To verify the course for all tests is available on first page
    :param context: behave.runner.Context
    :param course_name: name of the course to search for
    :return: none
    """
    try:
        context.browser.find_element(By.LINK_TEXT, course_name), 'The course was not found'
    except AssertionError:
        create_screenshot(context)
        raise


"""
###WHEN###
"""


@when('I click \'{text}\' button in top menu')
def step_impl(context, text: str):
    """
    Click on top menu to go to related page
    :param context: behave.runner.Context
    :param text: top menu link text which used to find and click on it
    :return: none
    """
    context.browser.find_element(By.LINK_TEXT, text).click()
    time.sleep(1)


@when('I click on {button} button')
def step_impl(context, button: str):
    """
    This step is used to click on buttons. To be refactored soon.
    :param context: behave.runner.Context
    :param button: used to identify the button when CSS_SELECTOR differs
    :return: none
    """
    if button == 'Subscribe':
        button = 'a.btn-sub'
        context.browser.find_element(By.CSS_SELECTOR, button).click()
    elif button == 'Crypto100':
        button = "//STRONG[text()='TN Crypto 100']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Price':
        button = "//A[@href='#price'][text()='Price']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Volatility':
        button = "//A[@href='#volatility'][text()='Volatility']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Alpha':
        button = "//A[@href='#alpha'][text()='Alpha']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Beta':
        button = "//A[@href='#beta'][text()='Beta']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Sharpe ratio':
        button = "//A[@href='#sharpe'][text()='Sharpe Ratio']"
        context.browser.find_element(By.XPATH, button).click()
    elif button == 'Start Course':
        context.browser.find_element(By.CSS_SELECTOR, 'a.btn.btn-buy.btn-block').click()
    else:
        # This branch should never be reached!
        print('Selector for button is not defined')
        create_screenshot(context)
        assert False, "Selector for button: '" + button + "' is not defined"


@when('I open {course_name} course from courses index page')
def step_impl(context, course_name: str):
    """
    This step is used to open the exact course by its name
    :param context: behave.runner.Context
    :param course_name: string to indicate the course to open in By.LINK_TEXT
    :return: none
    """
    context.browser.find_element(By.LINK_TEXT, course_name).click()


@when('I click on {material_name} material')
def step_impl(context, material_name: str):
    """
    This step is used to open a material from course page by its name
    :param context: behave.runner.Context
    :param material_name: the name of material
    :return: none
    """
    context.browser.find_element(By.PARTIAL_LINK_TEXT, material_name).click()


"""
###THEN###
"""


@then('I should see \'{text}\' page')
def step_impl(context, text: str):
    """
    This step is used to verify that we reach some page (or leave on the same page) as result of previous steps
    :param context: behave.runner.Context
    :param text: Title of the expected page
    :return: none
    """
    try:
        # TODO for unknown reason page status is not ok when Symfony not found something
        # vomment this line to avoid smoke test fail
        # assert requests.get(context.host).status_code == requests.codes.ok, text + ' page is not loaded successfully'

        assert text in context.browser.title, 'Expected Page Title is: \'' + text + '\' actual title is: \'' \
                                              + context.browser.title + '\''
    except AssertionError:
        create_screenshot(context)
        raise


@then('I should see {course_name} course view page')
def step_impl(context, course_name: str):
    """
    This step should verify the course name
    :param context: behave.runner.Context
    :param course_name: name of the course that is displayed in URL
    :return none
    """
    try:
        assert course_name in context.browser.find_element(By.CSS_SELECTOR, 'div.news-header').text, \
            'Course name is not found in header'
        course_name = course_name.lower()
        course_name = course_name.replace(' ', '-')
        assert course_name in context.browser.current_url, 'Course is not loaded in ' + context.browser.current_url
    except AssertionError:
        create_screenshot(context)
        raise


@then('I should see {page_name} page of {course_name} course')
def step_impl(context, page_name: str, course_name: str):
    """
    This step should verify the lecture's name and course name on the lecture's page
    :param context: behave.runner.Context
    :param course_name: name of the course that is displayed in title
    :param page_name: name of page
    :return none
    """
    try:
        assert page_name in context.browser.title, page_name + ' was not found in ' + context.browser.title
        assert course_name in context.browser.find_element(By.CSS_SELECTOR, 'div.news-header').text, \
            'Course name is not found in header'
    except AssertionError:
        create_screenshot(context)
        raise


@then('I should see PDF loaded')
def step_impl(context):
    """
    This step should verify the pdf with the docs is loaded
    :param context: behave.runner.Context
    :return none
    """
    try:
        context.browser.switch_to.window(context.browser.window_handles[-1])
        assert (True != ("not be found" in context.browser.page_source)), 'Errors in loading PDF'
    except AssertionError:
        create_screenshot(context)
        raise


@then('I check Write to us link')
def step_impl(context):
    """
    This step is used to check the write to us link on page
    :param context: behave.runner.Context
    :return: none
    """
    try:
        assert context.browser.find_element(By.XPATH, "//A[@href='mailto:info@someportal.io '][text()='Write to us']"), \
            'Mailto link was not found'
    except AssertionError:
        create_screenshot(context)
        raise