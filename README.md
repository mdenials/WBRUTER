# WBRUTER | Bruteforce

> **Note**
> Check out the latest and updated Android bruter, now available from the command line. This enhanced version includes a pause mechanism that automatically waits until the throttling period ends. Although initially intended for an upcoming release of WBRUTER, you have the opportunity to try it out now. Experience faster execution, improved performance, and heightened accuracy, specifically optimized for new devices. Give it a try, it's available in the [extra](https://github.com/wuseman/WBRUTER) dir!


When I created wbruter I was using "locksettings" as command but since Android 10 you can speed up the bruteforce by change this command if you wanna edit this source, I wont add it to wbruter since it will not work on older devices. Well I could probably fix so we can select cmd for 10> versions but  i am not really sure this command will work on all devices that is really old like android 2,3,4,5 etc so I leave it as I was created it. 

But you can do something like below if you want to edit this yourself after you cloned wbruter in the for loop.

```bash
androidVersion="$(adb shell getprop ro.build.version.release)"

if [[ ${androidVersion} -lt 10 ]]; then
    adb shell locksettings ...
else
    adb shell cmd lock_settings ...
fi
```

Another thing that must be added is line 214 wich is the "detect if screen is already on/off" 

```bash
screen="$(adb shell dumpsys nfc | grep 'mScreenState=')"
```

On recent android version it should instead be:

```bash
screen="$(adb shell dumpsys activity|grep -i mCurrentFocus|awk 'NR==1{print $3}'|cut -d'}' -f1)"
```

More tweaks can be found on my new documentation site for adb: [https://android.nr1.nu](https://android.nr1.nu)


![lock_settings](https://user-images.githubusercontent.com/26827453/222868132-2a56810c-14fd-479d-ba21-68f9520c4731.gif)

*** 

[Android Infosec](https://www.youtube.com/watch?v=x5Rt93jshC8) has tested [wbruter](https://github.com/wuseman/wbruter) and have created a really good video that can be seen on youtube, pleased visit this [youtube](https://www.youtube.com/watch?v=x5Rt93jshC8) url to see a real test. If you have problem getting started, please see the video they have done it really nice. They also seems have really interesting videos and other projects on youtube. 

[![IMAGE ALT TEXT HERE](https://i.imgur.com/zL1WSNv.png)](https://www.youtube.com/watch?v=x5Rt93jshC8)

Thanks alot!

*** 

[wbruter](https://github.com/wuseman/wbruter) is not just for Android devices, but if you want to find more tools like [wbruter](https://github.com/wuseman/wbruter) go visit the repository below:

* [Android-PIN-Bruteforce](https://github.com/urbanadventurer/Android-PIN-Bruteforce)

I do not use social media myself, but these have cool stuff.

* [AndroidInfoSec](https://www.facebook.com/AndroidInfoSec)
* [LukasStefanko](https://twitter.com/LukasStefanko)


*** 

## ChatGPT

![Screenshot](https://nr1.nu/archive/videos/wbruter_chatgpt.gif)

## WBRUTER

wbruter is is the first tool wich has been released as open source wich can guarantee **100%** that your pin code will be cracked aslong as usb debugging has been enable. wbruter also includes some other brute methods like dictionary attacks for gmail, ftp, rar, zip and some other file extensions. 

wbruter will allways try to bring support for rare protocols, wbruter wont contain common stuff like other brute tools cover like facebook, snapchat, instagram and you name it (except a few exceptions, very few)

_Many times it's the easiest methods that are the most powerful methods, it's just a matter of using your imagination ;-)_

## 2020-07-11 - Info

Android and Google, now have set a rule for locksettings via cli as via gui earlier, if you try to many attempts within X seconds you will be blocked for X seconds so wbruter via cli wont work anymore on devices that has been upgraded to latest version Android 10, older version should work fine unless they are upgraded to latest android version. 

## Enable USB Debugging

### Via GUI

Go to settings -> about > press on build number 7 times and the developer settings will be enable, go back to settings and press on developer mode and then enable USB DEBUGGING. If you found an android deviceon the street or something and want to break the pin this wont be possible unless you already know the pin so the device must have usb debugging enable for this to work. You wanna try this for fun then you can just enable usb debugging after you unlocked phone)

### Via Command line interface

```bash
adb shell settings put global development_settings_enabled 1
adb shell setprop persist.service.adb.enable 1
```
![Screenshot](https://raw.githubusercontent.com/1939149/wbruter/master/files/wbruter.gif)

From 0000 to 9999 takes ~83 minutes. In around ~1h you will with 100% _guarantee_ have the pin code

![Screenshot](https://nr1.nu/archive/wbruter/previews/wbruter-cli.gif)

## Notice

If you will see a message similiar to message under you don't have to care, just let it run and it will be gone after ~4-5 failed attempts: 

```
Error while executing command: clear
  java.lang.RuntimeException: No data directory found for package android
  at android.app.ContextImpl.getDataDir(ContextImpl.java:2418)
  at android.app.ContextImpl.getPreferencesDir(ContextImpl.java:533)
  at android.app.ContextImpl.getSharedPreferencesPath(ContextImpl.java:795)
  at android.app.ContextImpl.getSharedPreferences(ContextImpl.java:394)
  at com.android.internal.widget.LockPatternUtils.monitorCheckPassword(LockPatternUtils.java:1814)
  at com.android.internal.widget.LockPatternUtils.checkCredential(LockPatternUtils.java:398)
  at com.android.internal.widget.LockPatternUtils.checkPassword(LockPatternUtils.java:548)
  at com.android.internal.widget.LockPatternUtils.checkPassword(LockPatternUtils.java:509)
  at com.android.server.LockSettingsShellCommand.checkCredential(LockSettingsShellCommand.java:151)
  at com.android.server.LockSettingsShellCommand.onCommand(LockSettingsShellCommand.java:57)
  at android.os.ShellCommand.exec(ShellCommand.java:96)
  at com.android.server.LockSettingsService.onShellCommand(LockSettingsService.java:1945)
  at android.os.Binder.shellCommand(Binder.java:574)
  at android.os.Binder.onTransact(Binder.java:474)
  at com.android.internal.widget.ILockSettings$Stub.onTransact(ILockSettings.java:419)
  at com.android.server.HwLockSettingsService.onTransact(HwLockSettingsService.java:179)
  at android.os.Binder.execTransact(Binder.java:675)
```

## Getting started

```bash
git clone https://github.com/wuseman/WBRUTER ~/wbrutrer
cd ~/wbruter; 
chmod +x wbruter.sh
./wbruter --help
```
## License

For more information see the [LICENSE](license.md) file.

## Get in touch

If you have problems, questions, ideas or suggestions please contact me by posting to [wuseman@nr1.nu](mailto:wuseman@nr1.nu)

## Website

Visit my websites and profiles for the latest info and updated tools

* [www.nr1.nu](https://www.nr1.nu/)



