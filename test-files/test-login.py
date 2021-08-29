from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import sys 


chrome_opt = webdriver.ChromeOptions()
chrome_opt.add_argument('--headless')
chrome_opt.add_argument('--no-sandbox')
driver = webdriver.Chrome("/usr/lib/chromium-browser/chromedriver", options=chrome_opt)
print "Driver Made"
#driver.get(url)
driver.get("http://" + str(sys.argv[1]))
print "URL got"
driver.implicitly_wait(5)

username_textbox = driver.find_element_by_id("username")
username_textbox.send_keys("greg")

password_textbox = driver.find_element_by_id("password")
password_textbox.send_keys("turnquist")
#login_button = driver.find_element_by_css_selector(".btn-block").click()
login_button = driver.find_element_by_xpath("//button[@class='btn btn-lg btn-primary btn-block']")
login_button.click()
print("Login successful: " + driver.current_url)
print("Page source" + driver.page_source)
driver.close()

#driver.get("http://oczoom.azurewebsites.net")  / orangeappfree01.azurewebsites.net
#//*[text()='Sign in']
#//*[text()='Sign in'][1]


