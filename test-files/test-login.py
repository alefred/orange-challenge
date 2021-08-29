from selenium import webdriver
#from selenium.webdriver.common.keys import Keys
#from selenium.webdriver.support.ui import WebDriverWait

import sys 

# Create a new instance of the chrome driver
chrome_opt = webdriver.ChromeOptions()
chrome_opt.add_argument('--headless')
chrome_opt.add_argument('--no-sandbox')
chrome_opt.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome("/usr/lib/chromium-browser/chromedriver", options=chrome_opt)

print ("Driver Made")
driver.get("http://" + str(sys.argv[1]))
print ("URL got" + driver.page_source)
#driver.implicitly_wait(5)

#fillin the username
username_textbox = driver.find_element_by_id("username")
username_textbox.send_keys("greg")
#fillin the password
password_textbox = driver.find_element_by_id("password")
password_textbox.send_keys("turnquist")
#submit the form
login_button = driver.find_element_by_xpath("//button[@type='submit']")
login_button.submit()

# wait the ready state to be complete
WebDriverWait(driver=driver, timeout=10).until(
    lambda x: x.execute_script("return document.readyState === 'complete'")
)

#error management
# errors = driver.find_element_by_xpath("//div[@role='alert']")
# if any(error_message in e.text for e in errors):
#     print("[!] Login failed")
# else:
#     print("[+] Login successful")


# print("Login successful: " + driver.current_url)
print("Page source" + driver.page_source)
driver.close()

#python ./test-files/test-login.py orangeappfree01.azurewebsites.net 



