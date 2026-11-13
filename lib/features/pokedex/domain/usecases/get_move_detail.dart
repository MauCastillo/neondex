import '../entities/move_detail.dart';
import '../repositories/pokedex_repository.dart';

class GetMoveDetail {
  const GetMoveDetail(this._repository);

  final PokedexRepository _repository;

  Future<MoveDetail> call(Object moveNameOrId) {
    return _repository.getMoveDetail(moveNameOrId);
  }
}
