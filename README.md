# SEM.WebCamMonitor

Just a very simple PowerShell script to monitor MS-Teams for webcam activity, activate a Shelly Switch when webcam is on and switch it off when webcam is off.

I am using a simple ["Shelly Plus Plug S"](https://www.amazon.de/dp/B0BTJ1DTBX) which is configured to show the color "red" when it's on.

You need to setup an environment variable for the host:
```
setx ShellyWebCamLight 192.168.22.231
```
(the IP address must be the one of your device)

The script will simply run an endless loop testing the current status of a registry key that holds the last start and end of camera usage of MS Teams.
While the camera is on, the end-time is `0`, so we can use this as a hint that the camera is currently active.
When the camera is active and the device is `off`, it will switch on the device. When the camera is off (value is different to `0`) and the device is on, it will switch off the device.
