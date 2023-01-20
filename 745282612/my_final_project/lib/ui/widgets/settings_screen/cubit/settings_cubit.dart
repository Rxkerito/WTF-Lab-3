import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_final_project/data/db/firebase_provider.dart';
import 'package:my_final_project/entities/section.dart';
import 'package:my_final_project/ui/widgets/settings_screen/cubit/settings_state.dart';
import 'package:my_final_project/utils/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingCubit extends Cubit<SettingState> {
  final User? user;
  late final firebase = FirebaseProvider(user: user);

  SettingCubit({this.user})
      : super(
          SettingState(
            listSection: [],
            theme: AppTheme.lightTheme,
            textTheme: AppFontSize.mediumFontSize,
            backgroundImage: '',
          ),
        ) {
    initializer();
  }

  Future<void> initializer() async {
    final listSection = await firebase.getAllSection();
    ThemeData themeData;
    TextTheme textTheme;
    String? backgroundImage;
    final prefs = await SharedPreferences.getInstance();
    final themeKey = prefs.getString('theme') ?? ThemeGlobalKey.light.toString();
    final fontKey = prefs.getString('font') ?? FontSizeKey.medium.toString();
    final backgroundImageKey = prefs.getString('image') ?? '';
    if (themeKey == ThemeGlobalKey.light.toString() || themeKey == '') {
      themeData = AppTheme.lightTheme;
    } else {
      themeData = AppTheme.darkTheme;
    }
    if (fontKey == FontSizeKey.medium.toString() || fontKey == '') {
      textTheme = AppFontSize.mediumFontSize;
    } else if (fontKey == FontSizeKey.small.toString()) {
      textTheme = AppFontSize.smallFontSize;
    } else {
      textTheme = AppFontSize.largeFontSize;
    }
    if (backgroundImageKey != '') {
      backgroundImage = backgroundImageKey;
    } else {
      backgroundImage = null;
    }
    emit(
      state.copyWith(
        theme: themeData,
        textTheme: textTheme,
        listSection: listSection,
        backgroundImage: backgroundImage,
      ),
    );
  }

  Future<void> changeBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      prefs.setString('image', pickedFile.path);
      emit(state.copyWith(backgroundImage: pickedFile.path));
    }
  }

  Future<void> addSection({
    required IconData iconData,
    required String title,
  }) async {
    final listSection = state.listSection;
    final newSection = Section(
      id: UniqueKey().hashCode,
      iconSection: iconData,
      titleSection: title,
    );
    await firebase.addSection(newSection);
    listSection.add(newSection);
    emit(state.copyWith(listSection: listSection));
  }

  void changeAddStatus() {
    emit(state.copyWith(isAdd: !state.isAdd));
  }

  Future<void> changeFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.textTheme == AppFontSize.smallFontSize) {
      prefs.setString('font', FontSizeKey.medium.toString());
      emit(state.copyWith(textTheme: AppFontSize.mediumFontSize));
    } else if (state.textTheme == AppFontSize.mediumFontSize) {
      prefs.setString('font', FontSizeKey.large.toString());
      emit(state.copyWith(textTheme: AppFontSize.largeFontSize));
    } else {
      prefs.setString('font', FontSizeKey.small.toString());
      emit(state.copyWith(textTheme: AppFontSize.smallFontSize));
    }
  }

  Future<void> resetSetting() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', ThemeGlobalKey.light.toString());
    prefs.setString('font', FontSizeKey.medium.toString());
    prefs.setString('image', '');
    emit(
      state.copyWith(
        theme: AppTheme.lightTheme,
        textTheme: AppFontSize.mediumFontSize,
        backgroundImage: '',
      ),
    );
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.theme == AppTheme.lightTheme) {
      prefs.setString('theme', ThemeGlobalKey.dark.toString());
      emit(state.copyWith(theme: AppTheme.darkTheme));
    } else {
      prefs.setString('theme', ThemeGlobalKey.light.toString());
      emit(state.copyWith(theme: AppTheme.lightTheme));
    }
  }

  bool isLight() => state.theme == AppTheme.lightTheme;
}
