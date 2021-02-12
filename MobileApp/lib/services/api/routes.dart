import 'package:gtoserviceapp/models/gender.dart';

enum Routes {
  // Event
  SecretaryEvents,
  UserEvents,
  OrgEvents,
  OrgEvent,
  EventChangeStatus,

  // ParticipantEvent
  EventApply,
  EventUnsubscribe,
  TeamParticipants,
  EventParticipants,
  EventParticipant,
  Participant,

  //Tables
  Tables,
  EventTableGet,
  EventTableSet,

  // User
  Invite,
  Confirm,
  Login,
  Refresh,
  Info,

  // LocalAdmin
  LocalAdmins,
  LocalAdmin,
  LocalAdminExisting,

  // Organization
  Organizations,
  Organization,

  // Referee
  OrgReferees,
  OrgReferee,
  EventTrialReferee,
  TrialReferee,

  // Result
  EventUserResult,
  EventResults,
  EventResultsCsv, // Не используется
  TrialResults,
  TrialResult,

  // Role
  Role,

  // Secretary
  OrgSecretaries,
  OrgSecretary,
  EventSecretaries,
  EventSecretary,

  // SportObject
  SportObjects,
  SportObject,

  // Team
  EventTeams,
  EventTeam,
  ConfirmTeam,
  UserTeams,
  Team,

  // TeamLead
  TeamLeads,
  TeamLead,

  // Trial
  Trial,
  TrialSecondaryResult,
  EventFreeTrials,
  EventTrials,
  EventTrial,

  // Photo
  AddUserPhoto,
  UpdateUserPhoto,
  DeleteUserPhoto,
  GetUserPhoto,
  FindFaceOnPhoto,
}

extension RoutesEx on Routes {
  String toStr() {
    switch (this) {
      // Event
      case Routes.SecretaryEvents:
        return "/event/forSecretary";
      case Routes.UserEvents:
        return "/event/forUser";
      case Routes.OrgEvents:
        return "/organization/{orgId}/event";
      case Routes.OrgEvent:
        return "/organization/{orgId}/event/{eventId}";
      case Routes.EventChangeStatus:
        return "/event/{eventId}/changeStatus";
      // ParticipantEvent
      case Routes.EventApply:
        return "/event/{eventId}/apply";
      case Routes.EventUnsubscribe:
        return "/event/{eventId}/unsubscribe";
      case Routes.TeamParticipants:
        return "/team/{teamId}/participant";
      case Routes.EventParticipants:
        return "/event/{eventId}/participant";
      case Routes.EventParticipant:
        return "/event/{eventId}/participant/{participantId}";
      case Routes.Participant:
        return "/participant/{participantId}";
      //Tables
      case Routes.Tables:
        return "/tables";
      case Routes.EventTableGet:
        return "/event/{eventId}/table";
      case Routes.EventTableSet:
        return "/event/{eventId}/table/{tableId}";
      // User
      case Routes.Invite:
        return "/auth/invite";
      case Routes.Confirm:
        return "/auth/confirmAccount";
      case Routes.Login:
        return "/auth/login";
      case Routes.Refresh:
        return "/auth/refresh";
      case Routes.Info:
        return "/auth/info";
      // LocalAdmin
      case Routes.LocalAdmins:
        return "/organization/{orgId}/localAdmin";
      case Routes.LocalAdmin:
        return "/organization/{orgId}/localAdmin/{localAdminId}";
      case Routes.LocalAdminExisting:
        return "/organization/{orgId}/localAdmin/existingAccount";
      // Organization
      case Routes.Organizations:
        return "/organization";
      case Routes.Organization:
        return "/organization/{orgId}";
      // Referee
      case Routes.OrgReferees:
        return "/organization/{orgId}/referee";
      case Routes.OrgReferee:
        return "/organization/{orgId}/referee/{refereeId}";
      case Routes.EventTrialReferee:
        return "/trialInEvent/{trialId}/refereeInOrganization/{refereeId}";
      case Routes.TrialReferee:
        return "/refereeInTrialOnEvent/{refereeId}";
      // Result
      case Routes.EventUserResult:
        return "/event/{eventId}/user/{userId}/result";
      case Routes.EventResults:
        return "/event/{eventId}/allResults";
      case Routes.EventResultsCsv:
        return "/event/{eventId}/allResults/csv";
      case Routes.TrialResults:
        return "/trialInEvent/{trialInEventId}/result";
      case Routes.TrialResult:
        return "/resultTrialInEvent/{resultId}";
      // Role
      case Routes.Role:
        return "/role";
      // Secretary
      case Routes.OrgSecretaries:
        return "/organization/{orgId}/secretary";
      case Routes.OrgSecretary:
        return "/organization/{orgId}/secretary/{secretaryId}";
      case Routes.EventSecretaries:
        return "/organization/{orgId}/event/{eventId}/secretary";
      case Routes.EventSecretary:
        return "/organization/{orgId}/event/{eventId}/secretary/{secretaryId}";
      // SportObject
      case Routes.SportObjects:
        return "/organization/{orgId}/sportObject";
      case Routes.SportObject:
        return "/organization/{orgId}/sportObject/{sportObjectId}";
      // Team
      case Routes.EventTeams:
        return "/organization/{orgId}/event/{eventId}/team";
      case Routes.EventTeam:
        return "/organization/{orgId}/event/{eventId}/team/{teamId}";
      case Routes.ConfirmTeam:
        return "/team/{teamId}/confirm";
      case Routes.UserTeams:
        return "/team";
      case Routes.Team:
        return "/team/{teamId}";
      // TeamLead
      case Routes.TeamLeads:
        return "/team/{teamId}/teamLead";
      case Routes.TeamLead:
        return "/teamLead/{teamLeadId}";
      // Trial
      case Routes.Trial:
        return "/trial/{age}/{gender}";
      case Routes.TrialSecondaryResult:
        return "/trial/{trialId}/firstResult?firstResult={primaryResult}";
      case Routes.EventFreeTrials:
        return "/event/{eventId}/freeTrials";
      case Routes.EventTrials:
        return "/event/{eventId}/trial";
      case Routes.EventTrial:
        return "/trialInEvent/{trialInEventId}";
      // Photo
      case Routes.AddUserPhoto:
        return "/addPhoto/user/{userId}";
      case Routes.UpdateUserPhoto:
        return "/updatePhoto/user/{userId}";
      case Routes.DeleteUserPhoto:
        return "/deletePhoto/user/{userId}";
      case Routes.GetUserPhoto:
        return "/getPhoto/user/{userId}";
      case Routes.FindFaceOnPhoto:
        return "/findFaceOnPhoto";
      // Default - забыли добавить сюда путь?
      default:
        throw Exception("Invlid route");
    }
  }

  String withArgs({
    int orgId,
    int eventId,
    int teamId,
    int participantId,
    int secretaryId,
    int localAdminId,
    int teamLeadId,
    int age,
    Gender gender,
    int trialId,
    String primaryResult,
    int sportObjectId,
    int refereeId,
    int tableId,
    int trialInEventId,
    int userId,
    int resultId,
  }) {
    return _withArgs({
      "orgId": orgId?.toString(),
      "eventId": eventId?.toString(),
      "teamId": teamId?.toString(),
      "participantId": participantId?.toString(),
      "secretaryId": secretaryId?.toString(),
      "localAdminId": localAdminId?.toString(),
      "teamLeadId": teamLeadId?.toString(),
      "age": age?.toString(),
      "gender": gender?.toInt().toString(),
      "trialId": trialId?.toString(),
      "primaryResult": primaryResult,
      "sportObjectId": sportObjectId?.toString(),
      "refereeId": refereeId?.toString(),
      "tableId": tableId?.toString(),
      "trialInEventId": trialInEventId?.toString(),
      "userId": userId?.toString(),
      "resultId": resultId?.toString(),
    });
  }

  String _withArgs(Map<String, String> args) {
    var route = this.toStr();
    args.forEach((from, to) {
      if (to == null) {
        return;
      }
      route = route.replaceAll("{$from}", to);
    });
    if (route.contains("{")) {
      print("WARNING: Route '$route' contains placeholders");
    }

    return route;
  }
}
