# Robot Framework Examples
Examples of using Robot Framework libraries 

Run all tests: 
```
robot -d Logs Tests\
```

Run only one test suite: 
```
robot -d Logs Tests\Web\web_selenium_lib.robot
robot -d Logs Tests\Webservices\REST.robot
```

Run only one test: 
```
robot -d Logs -t "Verify Checkbox" Tests\Web\web_selenium_lib.robot
robot -d Logs -t "Get Github User" Tests\Webservices\REST.robot
```

## Libraries
In these examples you will find the use of the following libraries

- _Web_  
[SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary)  
[BrowserLibrary](https://github.com/MarketSquare/robotframework-browser)

- _Webservices_  
[SoapLibrary](https://github.com/Altran-PT-GDC/Robot-Framework-SOAP-Library)  
[RequestsLibrary](https://github.com/MarketSquare/robotframework-requests)  
[JSONLibrary](https://github.com/robotframework-thailand/robotframework-jsonlibrary)

## Logs
You can see how the log looks like in [here](https://raw.githack.com/samuelpcabral/Robot_Framework_Examples/main/Logs/log.html)
