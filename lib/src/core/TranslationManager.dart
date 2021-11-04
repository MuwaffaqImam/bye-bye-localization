import 'package:bye_bye_localization/bye_bye_localization.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:ui' as ui;


/// Manager to help translate and download the AI Model for translation
class TranslationManager {
  late String _originLanguage = Languages.ENGLISH;
  late String _translateTo = Languages.ARABIC;
  final _languageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  late OnDeviceTranslator _onDeviceTranslator;
  static final TranslationManager _singleton = TranslationManager.initObject();

  /// save a singleton to help preserve the state of the manager
  factory TranslationManager() {
    return _singleton;
  }

  TranslationManager.initObject();

  /// init the manger,
  /// originLanguage : is the language you wish to translate from By default it's English
  /// translateToLanguage : is the language you ish to translate to, by default it will be the Device's system language
  Future<bool> init({
    String originLanguage = Languages.ENGLISH,
    String? translateToLanguage,
  }) async {
    _originLanguage = originLanguage;
    _translateTo = translateToLanguage ?? ui.window.locale.languageCode;
    _onDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
        sourceLanguage: _originLanguage, targetLanguage: _translateTo);
    return await checkModels();
  }

  /// handle the translation
  Future<String> translateText({
    required String text,
  }) async {
    _onDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: _originLanguage,
      targetLanguage: _translateTo,
    );
    String translate = await _onDeviceTranslator.translateText(text);
    return translate;
  }

  /// check if the AI model is download if not, it will download it automatically
  Future<bool> checkModels() async {
    bool downloadStatus = false;
    print('Checking models ..');
    await _downloadModel(_originLanguage).then((value) {
      print('$_originLanguage model is downloaded');
      downloadStatus = true;
    }).onError((error, stackTrace) {
      print('$error and $stackTrace');
      downloadStatus = false;
    });
    await _downloadModel(_translateTo).then((value) {
      print('$_translateTo model is downloaded');
      downloadStatus = true;
    }).onError((error, stackTrace) {
      print('$error and $stackTrace');
      downloadStatus = false;
    });
    return Future.value(downloadStatus);
  }
  /// to download AI model
  Future<bool> _downloadModel(String language) async {
    print('^^^^^ downloading $language model');
    bool downloaded = await _languageModelManager.isModelDownloaded(language);
    if (!downloaded)
      await _languageModelManager
          .downloadModel(language)
          .then((value) => downloaded = true)
          .onError((error, stackTrace) => downloaded = false);
    return Future.value(downloaded);
  }
}
