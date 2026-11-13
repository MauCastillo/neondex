import '../entities/type_detail.dart';
import '../repositories/pokedex_repository.dart';

class GetTypeDetail {
  const GetTypeDetail(this._repository);

  final PokedexRepository _repository;

  Future<TypeDetail> call(Object typeNameOrId) {
    return _repository.getTypeDetail(typeNameOrId);
  }
}
