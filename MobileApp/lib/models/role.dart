enum Role {
  GlobalAdmin,
  LocalAdmin,
  User,
  Secretary,
  TeamLead,
}

extension RoleEx on Role {
  static Role fromStr(String str) {
    return {
      "Глобальный администратор": Role.GlobalAdmin,
      "Локальный администратор": Role.LocalAdmin,
      "Простой пользователь": Role.User,
      "Секретарь": Role.Secretary,
      "Тренер": Role.TeamLead,
    }[str];
  }

  String toText() {
    return {
      Role.GlobalAdmin: "Глобальный администратор",
      Role.LocalAdmin: "Локальный администратор",
      Role.User: "Участник",
      Role.Secretary: "Секретарь",
      Role.TeamLead: "Тренер",
    }[this];
  }
}
