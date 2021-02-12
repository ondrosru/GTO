enum Keys {
  accessToken,
  refreshToken,
  role,
  orgId,
  userId,
}

extension KeysEx on Keys {
  String toStr() {
    return {
      Keys.accessToken: "accessToken",
      Keys.refreshToken: "refreshToken",
      Keys.role: "role",
      Keys.orgId: "organisationId",
      Keys.userId: "userId",
    }[this];
  }
}
