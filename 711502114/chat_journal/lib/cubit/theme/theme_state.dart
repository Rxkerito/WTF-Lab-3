import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeData theme;

  const ThemeState(this.theme);

  ThemeState copyWith(ThemeData? theme) {
    return ThemeState(theme ?? this.theme);
  }

  @override
  List<Object?> get props => [theme];
}
