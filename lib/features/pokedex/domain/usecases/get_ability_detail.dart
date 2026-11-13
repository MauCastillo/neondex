import '../entities/ability_detail.dart';
import '../repositories/pokedex_repository.dart';

class GetAbilityDetail {
  const GetAbilityDetail(this._repository);

  final PokedexRepository _repository;

  Future<AbilityDetail> call(Object abilityNameOrId) {
    return _repository.getAbilityDetail(abilityNameOrId);
  }
}
