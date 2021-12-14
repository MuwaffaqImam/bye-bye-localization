import 'dart:ui' as ui;

import 'package:bye_bye_localization/bye_bye_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(PdfExtractionMain());

class PdfExtractionMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfExtraction(),
    );
  }
}

class PdfExtraction extends StatefulWidget {
  @override
  _PdfExtractionState createState() => _PdfExtractionState();
}

class _PdfExtractionState extends State<PdfExtraction> {
  static final String _startingText =
      "A simple Text Widget, that can translate any text to any language using instant on device translation AI model, all you have to do is to provide the text and the widget will translate automatically, as a result you don't have to specify and localization files and type translation manually the widget will do it for you.";
  String _text = _startingText;
  Map<String, String>? originLanguage = {'ENGLISH': "en"};
  Map<String, String>? translateTo;
  bool _translate = true;
  bool textDirection = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  TranslatedText(
            'Bye Bye Localization',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body:
        FutureBuilder(
          // Initialize FlutterFire:
          future: initTranslation(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return buildBody();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Translating  from ${originLanguage!.keys.first} to ${translateTo == null ? Localizations.localeOf(context).languageCode : translateTo!.keys.first} \n',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'this might take a while... \n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(
                              text:
                                  'because we are downloading an AI model to translate through it,'
                                  ' once finished you will see an incredible thing, I PROMISE... \n ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          TextSpan(
                              text:
                                  '  so say Astaghfer Allah in this time time!',
                              style: TextStyle(
                                  fontFamily: 'casual', fontSize: 30)),
                        ],
                      ),
                    ),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                ],
              ),
            );
          },
        )
    );
  }

  TextEditingController _controller = new TextEditingController();

  Container buildBody() {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            onTap: () {
              buildModelSheet().then((value) {
                setState(() {
                  translateTo = value;
                });
              });
            },
            leading: Icon(Icons.translate),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: Text(
              "tap to Change Local",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: translateTo != null
                ? Text('${translateTo!.keys.first}')
                : Text('current local is -->'
                    '${LanguageHelper.languages.firstWhere(
                          (k) =>
                              k.values.first == ui.window.locale.languageCode,
                        ).keys.first}'),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                icon: Icon(Icons.edit_rounded),
                hintText: 'Write any text then press translate',
              ),
            ),
          ),
          TextButton(
            child: TranslatedText(
              "Translate the text",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(5), backgroundColor: Colors.blueAccent),
            onPressed: () {
              setState(() {
                _translate = true;
                _text = _controller.text.isNotEmpty
                    ? _controller.text
                    : _startingText;
              });
            },
          ),
          TextButton(
            child: TranslatedText(
              "Change Text direction",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(5), backgroundColor: Colors.blueAccent),
            onPressed: () {
              setState(() {
                textDirection = !textDirection;
              });
            },
          ),
          TextButton(
            child: Text(
              _translate ? "Show Original language" : "Show translation",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(5), backgroundColor: Colors.blueAccent),
            onPressed: () {
              setState(() {
                _translate = !_translate;
              });
            },
          ),
          TextButton(
            child: TranslatedText(
              'Reset text',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(5), backgroundColor: Colors.blueAccent),
            onPressed: () {
              setState(() {
                _text = _startingText;
              });
            },
          ),
          _translate
              ? TranslatedText(_text,
                  textDirection:
                      textDirection ? TextDirection.ltr : TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                  ))
              : Text(
                  _text,
                  textDirection:
                      textDirection ? TextDirection.ltr : TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
        ],
      ),
    );
  }

  Future<bool> initTranslation() async {
    Locale myLocale = Localizations.localeOf(context);
    print('myLocale.languageCode ${ui.window.locale.languageCode}');
    return await TranslationManager().init(
        translateToLanguage: translateTo == null
            ? ui.window.locale.languageCode
            : translateTo!.values.first,
        originLanguage: originLanguage!.values.first);
  }

  Future<bool> initWidget() async {
    return await TranslationManager().init(
      originLanguage: Languages.ENGLISH,
      translateToLanguage: Languages.ARABIC,
    );
  }

  Future<Map<String, String>?> buildModelSheet() async {
    return await showModalBottomSheet<Map<String, String>>(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          color: Colors.amberAccent,
          child: Center(
            child: ListView.builder(
              itemCount: LanguageHelper.languages.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context, LanguageHelper.languages[index]);
                      },
                      title: Text(
                        '${LanguageHelper.languages[index].keys.first}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
