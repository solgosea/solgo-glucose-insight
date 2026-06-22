abstract class StatusComponentDetailData {
  const StatusComponentDetailData();

  String get type;

  Map<String, Object?> toJson();
}

Map<String, Object?> detailDataToJson(StatusComponentDetailData? data) {
  return data?.toJson() ?? const {};
}
