enum Gender {
  Male,
  Female,
}

extension GenderEx on Gender {
  static Gender fromInt(int gender) {
    switch (gender) {
      case 0:
        return Gender.Female;
      case 1:
        return Gender.Male;
      default:
        throw Exception("GenderEx.fromInt: неверное значение");
    }
  }

  int toInt() {
    return {
      Gender.Male: 1,
      Gender.Female: 0,
    }[this];
  }

  String toStr() {
    return {
      Gender.Male: "Мужской",
      Gender.Female: "Женский",
    }[this];
  }
}
