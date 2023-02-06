import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/locale_repository_api.dart';

part 'locale_state.dart';

part 'locale_cubit.freezed.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({
    required LocaleRepositoryApi localeRepository,
  })  : _repository = localeRepository,
        super(
          LocaleState(
            localeRepository.locale,
          ),
        );

  final LocaleRepositoryApi _repository;

  void setLocale(Locale locale) {
    _repository.setLocale(locale);
    emit(
      LocaleState(locale),
    );
  }

  Future<void> resetToDefault() async {
    emit(
      const LocaleState(
        LocaleRepositoryApi.defaultLocale,
      ),
    );
    _repository.resetToDefault();
  }
}
