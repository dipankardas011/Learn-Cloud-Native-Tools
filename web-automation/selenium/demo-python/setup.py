from selenium import webdriver
import time
import os
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

driver = webdriver.Chrome(service=ChromeService(executable_path=ChromeDriverManager().install()))

driver.get("https://www.selenium.dev/selenium/web/web-form.html")

title = driver.title

driver.implicitly_wait(0.5)
text_box = driver.find_element(by=By.NAME, value="my-text")
pass_box = driver.find_element(by=By.NAME, value="my-password")
submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")

while True:
    xyz = int(input("Enter the 1 to continue..."))
    if xyz == 1:
        break;


pass_box.send_keys(os.getenv("PASS"))
text_box.send_keys("Selenium")

time.sleep(10)

submit_button.click()

driver.quit();

