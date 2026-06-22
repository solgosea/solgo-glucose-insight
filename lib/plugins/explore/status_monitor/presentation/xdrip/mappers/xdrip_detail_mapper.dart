import '../../../domain/component_health.dart';
import '../../../domain/xdrip/xdrip_detail_data.dart';

class XdripDetailMapper {
  const XdripDetailMapper();

  XdripDetailData? map(ComponentHealth component) {
    final data = component.detailData;
    return data is XdripDetailData ? data : null;
  }
}
