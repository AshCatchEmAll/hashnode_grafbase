import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'grafbase_state.dart';

class GrafbaseCubit extends Cubit<GrafbaseState> {
  GrafbaseCubit() : super(GrafbaseInitial());
}
