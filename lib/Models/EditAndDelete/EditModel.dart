import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';

class Editmodel {
  Future<List<Map<String, dynamic>>> searchAcrossCollections(
    String collection,
    String searchTerm,
  ) async {
    final results = <Map<String, dynamic>>[];
    final found = await CloudflareApi.instance.lookupByNumber(
      collection,
      searchTerm,
    );
    Logger.logger('message editmodel $found');
    if (found != null) {
      results.add(found);
    }
    return results;
  }
}
