# Bye Bye Localization 👋
Its just a simple `Text` widget that will provide automatic fast translation for any text. it supports 59 languages.

No more boring Localization configuration files, all you have to do is change your old `Text()` widget to `TranslatedText()` and enjoy the sweet sweet life without Localization

PS: the translation will be fast as it uses translation model deployed to the device under the hood.

## Demo 📹

![Demo](https://github.com/MuwaffaqImam/bye-bye-localization/blob/main/demo/demo.gif)



# How to use ?
**Step 1: All you have to do is call the widget**

```dart
TranslatedText('your text')
```

 **Step2: don't forget to call init the widget using the Manager**

 ```dart
  Future<bool> initWidget() async {
    return await TranslationManager().init(
      originLanguage: Languages.ENGLISH,
      translateToLanguage: Languages.ARABIC,
    );
  } 
```

**Step 3: Buy me Coffee 🙂!** ☕️

[Buy Me a Coffee](https://bit.ly/3bHVfGH)

![coffee](https://user-images.githubusercontent.com/8396626/140408636-4b91040e-5d89-41e0-9fe4-0e814a142c62.png)

## Quick example ⚡️
```dart
Widget buildWidget(){
    return FutureBuilder(
      future: initTranslation(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return TranslatedText('I am a text that will be translated always');
        }
        return CircularProgressIndicator();
      },
    );
  }
  Future<bool> initWidget() async {
    return await TranslationManager().init(
      originLanguage: Languages.ENGLISH,
      /// Change here the language to change the translation, and re run.
      /// For example Languages.RUSSIAN.
      translateToLanguage: Languages.ARABIC,
    );
  }
```


## Live Demo 🔆
below you will find a link to APK contains live demo 

[Download APK](https://www.dropbox.com/s/3o6t4f9mxnf94hu/bye%20bye%20localization.apk?dl=0)

## Author ✍️
Muwaffaq Imam
- Edu email : m.imam@innopolis.university	
- Telegram : moofiy
