import '../../../domain/component_health.dart';
import '../../../domain/nightscout/nightscout_detail_data.dart';

class NightscoutDetailMapper {
  const NightscoutDetailMapper();

  NightscoutDetailData? map(ComponentHealth component) {
    final data = component.detailData;
    return data is NightscoutDetailData ? data : null;
  }
}
