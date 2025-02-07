import 'package:flutter_bloc/flutter_bloc.dart';

enum PremiumPlan { none, monthly, yearly }

class PremiumCubit extends Cubit<PremiumPlan> {
  PremiumCubit() : super(PremiumPlan.none);

  void selectMonthlyPlan() {
    emit(PremiumPlan.monthly);
  }

  void selectYearlyPlan() {
    emit(PremiumPlan.yearly);
  }

  void clearSelection() {
    emit(PremiumPlan.none);
  }
}
