import '../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../domain/component_health.dart';

class CgmSensorDetailMapper {
  const CgmSensorDetailMapper();

  CgmSensorDetailData? map(ComponentHealth component) {
    final data = component.detailData;
    return data is CgmSensorDetailData ? data : null;
  }
}
