import 'package:formz/formz.dart';

// Define input validation errors
enum NameValidationError { empty }

enum AgeValidationError { invalid }

enum PayValidatorError { invalid }

enum PositionValidationError { empty }

enum RadiusValidationError { invalid }

enum PositionInputError { empty }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String value) {
    return value.isNotEmpty && value.length >= 3
        ? null
        : NameValidationError.empty;
  }
}

class PayInput extends FormzInput<int, PayValidatorError> {
  const PayInput.pure() : super.pure(0);
  const PayInput.dirty([int value = 0]) : super.dirty(value);

  @override
  PayValidatorError? validator(int value) {
    return value >= 0 ? null : PayValidatorError.invalid;
  }
}

class AgeInput extends FormzInput<int, AgeValidationError> {
  const AgeInput.pure() : super.pure(0);
  const AgeInput.dirty([int value = 0]) : super.dirty(value);

  @override
  AgeValidationError? validator(int value) {
    if (value < 12) {
      return AgeValidationError.invalid;
    }
    if (value.runtimeType != int) {
      return AgeValidationError.invalid;
    }
    return null;
  }
}

class PositionInput extends FormzInput<Position, PositionInputError> {
  const PositionInput.pure() : super.pure(Position.delantero);
  const PositionInput.dirty([Position value = Position.delantero])
      : super.dirty(value);

  @override
  PositionInputError? validator(Position? value) {
    return value == null ? PositionInputError.empty : null;
  }
}

class RadiusInput extends FormzInput<int, RadiusValidationError> {
  const RadiusInput.pure() : super.pure(3);
  const RadiusInput.dirty([int value = 3]) : super.dirty(value);

  @override
  RadiusValidationError? validator(int value) {
    return value >= 1 ? null : RadiusValidationError.invalid;
  }
}

enum Position { delantero, arquero, mediocampista, defensa }

extension PositionX on Position {
  String toShortString() {
    return toString().split('.').last;
  }
}
