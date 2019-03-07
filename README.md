# Cyano Wallet

Cayno wallet implement dApi:

- support open dapp in wallet
- support scan qrcode
- support APP wakeup Cyano

## App wakeup Cyano

- login
- invoke smartcontract

## Project configuration

Add `query schemes` to the arousal project

- Open  `info.plist`  in the arousal project

- Click to open using  `Open As Source Code`

- Add the following code

  ```
  <key>LSApplicationQueriesSchemes</key> 
    <array> 
    <string>ont</string> 
  </array>
  ```

### Login

Request data the same to [Cyano scan qrcode Login](https://github.com/ontio-cyano/CEPs/blob/master/CEPS/CEP1.mediawiki#Login-2)

```
{
	"action": "login",
	"id": "10ba038e-48da-487b-96e8-8d3b99b6d18a",
	"version": "v1.0.0",
	"params": {
		"type": "ontid or account",
		"dappName": "dapp Name",
		"dappIcon": "dapp Icon",
		"message": "helloworld",
		"expire": 1546415363,
		"callback": "http://127.0.0.1:80/login/callback"
	}
}
```

1、Check if cyano App is installed locally

```
NSString *appUrl = [NSURL URLWithString:@"ont://com.github.cyano?data="];
BOOL isCanOpen = [[UIApplication sharedApplication] canOpenURL:appUrl];
if (!isCanOpen) {
   NSLog(@"Not installed cyano");
}else{
    // TODO Login
}
```

2、Convert Request data to base64

3、Stitch base64 data into appUrl

```
NSString *urlString = [NSString stringWithFormat:@"ont://com.github.cyano?   
                                                   data=%@",base64];
```

4、Login

```
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] 
                                   options:@{} 
                                   completionHandler:^(BOOL success) {
                                       
}];
```

### Invoke smartcontract

Request data the same to [Cyano scan qrcode Invoke](https://github.com/ontio-cyano/CEPs/blob/master/CEPS/CEP1.mediawiki#Invoke_a_Smart_Contract-2)

```
{
	"action": "invoke",
	"version": "v1.0.0",
	"id": "10ba038e-48da-487b-96e8-8d3b99b6d18a",
	"params": {
		"login": true,
		"qrcodeUrl": "http://101.132.193.149:4027/qrcode/AUr5QUfeBADq6BMY6Tp5yuMsUNGpsD7nLZ",
		"message": "will pay 1 ONT in this transaction",
		"callback": "http://101.132.193.149:4027/invoke/callback"
	}
}
```

1、Check if cyano App is installed locally

```
NSString *appUrl = [NSURL URLWithString:@"ont://com.github.cyano?data="];
BOOL isCanOpen = [[UIApplication sharedApplication] canOpenURL:appUrl];
if (!isCanOpen) {
   NSLog(@"Not installed cyano");
}else{
    // TODO Invoke
}
```

2、Convert Request data to base64

3、Stitch base64 data into appUrl

```
NSString *urlString = [NSString stringWithFormat:@"ont://com.github.cyano?   
                                                   data=%@",base64];
```

4、Invoke

```
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] 
                                   options:@{} 
                                   completionHandler:^(BOOL success) {
                                       
}];
```

### 