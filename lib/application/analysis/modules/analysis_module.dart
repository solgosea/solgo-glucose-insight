import '../../../domain/analysis/analysis_context.dart';
import '../../../domain/analysis/analysis_module_code.dart';

abstract class AnalysisModule<T> {
  AnalysisModuleCode get code;

  Future<T> run(AnalysisContext context);
}
