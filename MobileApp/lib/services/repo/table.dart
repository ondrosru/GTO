import 'package:get_it/get_it.dart';
import 'package:gtoserviceapp/services/api/api.dart';
import 'package:gtoserviceapp/services/api/routes.dart';
import 'package:gtoserviceapp/services/utils/utils.dart';

class ConversionTable {
  int tableInEventId;
  int eventId;
  int id;
  String name;

  ConversionTable({this.tableInEventId, this.eventId, this.id, this.name});

  ConversionTable.fromJson(Map<String, dynamic> json) {
    tableInEventId = json['tableInEventId'];
    eventId = json['eventId'];
    id = json['tableId'];
    name = json['tableName'];
    name = name ?? json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableInEventId'] = this.tableInEventId;
    data['eventId'] = this.eventId;
    data['tableId'] = this.id;
    data['tableName'] = this.name;
    data['name'] = this.name;
    return data;
  }
}

class TableRepo {
  static TableRepo get I {
    return GetIt.I<TableRepo>();
  }

  Future<List<ConversionTable>> getAll() async {
    List<dynamic> json = await API.I.get(Routes.Tables.toStr());
    return Utils.map(json, (json) => ConversionTable.fromJson(json));
  }

  Future<ConversionTable> getFromEvent(int eventId) async {
    var json = await API.I.get(Routes.EventTableGet.withArgs(eventId: eventId));
    if (json == null) {
      return null;
    }

    return ConversionTable.fromJson(json);
  }

  Future setForEvent(int eventId, int tableId) {
    return API.I.post(
      Routes.EventTableSet.withArgs(
        eventId: eventId,
        tableId: tableId,
      ),
      auth: true,
    );
  }
}
