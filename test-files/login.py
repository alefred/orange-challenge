from selenium import webdriver
from selenium.webdriver.common.keys import Keys

chrome_opt = webdriver.ChromeOptions()
chrome_opt.add_argument('--headless')
chrome_opt.add_argument('--no-sandbox')

driver = webdriver.Chrome("/usr/lib/chromium-browser/chromedriver", options=chrome_opt)
driver.get("http://orangechallenge.azurewebsites.net")

username_textbox = driver.find_element_by_id("username")
username_textbox.send_keys("greg")

password_textbox = driver.find_element_by_id("password")
password_textbox.send_keys("turnquist")

login_button = driver.find_element_by_css_selector(".btn-block").click()

print("Login successful" + driver.current_url)

driver.close()
