import '../domain/home_metric_window.dart';

class HomeMetricWindowPolicy {
  const HomeMetricWindowPolicy();

  HomeMetricWindow get average => HomeMetricWindow.last24Hours;

  HomeMetricWindow get timeInRange => HomeMetricWindow.last24Hours;

  HomeMetricWindow get coefficientOfVariation => HomeMetricWindow.last24Hours;
}
