import 'package:flutter_test/flutter_test.dart';
import 'package:wazafak_app/components/sheets/filter_sheet.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';

/// Mirrors how the freelancer/employer search services serialize the filter map
/// into the request URL (see FreelancerSearchService.freelancerSearch).
String buildSearchUrl(String base, Map<String, String> filters) {
  if (filters.isEmpty) return base;
  final params = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
  return '$base?$params';
}

/// Mirrors SearchController._filterParams(): the inline category is resolved
/// separately, so the singular `category` key is stripped but `category_list`
/// stays.
Map<String, String> filterParams(HomeFilters f) =>
    f.toSearchParams()..remove('category');

/// Mirrors SearchController.search() building the freelancer-search filter map.
Map<String, String> freelancerSearchFilters(
  String query,
  int page,
  HomeFilters f, {
  String? resolvedCategory,
}) {
  final filters = <String, String>{
    'query': query,
    'page': page.toString(),
  };
  if (resolvedCategory != null) filters['category'] = resolvedCategory;
  filters.addAll(filterParams(f));
  return filters;
}

Category cat(String hash, String name) => Category(hashcode: hash, name: name);

void main() {
  group('HomeFilters.toSearchParams – multi category', () {
    test('emits category_list[i] for each selected category, no singular key',
        () {
      final f = HomeFilters(categories: [
        cat('HASH_A', 'Design'),
        cat('HASH_B', 'Development'),
        cat('HASH_C', 'Writing'),
      ]);

      final params = f.toSearchParams();

      expect(params['category_list[0]'], 'HASH_A');
      expect(params['category_list[1]'], 'HASH_B');
      expect(params['category_list[2]'], 'HASH_C');
      expect(params.containsKey('category'), isFalse,
          reason: 'multi-select must not also send the singular key');
    });

    test('skips categories with a null hashcode but keeps stable indices', () {
      final f = HomeFilters(categories: [
        cat('HASH_A', 'Design'),
        Category(name: 'No hash'), // hashcode == null
      ]);

      final params = f.toSearchParams();

      expect(params['category_list[0]'], 'HASH_A');
      expect(params.containsKey('category_list[1]'), isFalse);
    });

    test('falls back to singular category when the list is empty', () {
      final f = HomeFilters(category: cat('HASH_SINGLE', 'Design'));

      final params = f.toSearchParams();

      expect(params['category'], 'HASH_SINGLE');
      expect(params.keys.where((k) => k.startsWith('category_list')), isEmpty);
    });

    test('default / reset filters send no category params at all', () {
      // HomeFilters() == the state produced by Reset.
      final params = HomeFilters().toSearchParams();

      expect(params.containsKey('category'), isFalse);
      expect(params.keys.where((k) => k.startsWith('category_list')), isEmpty);
    });
  });

  group('Freelancer search request URL', () {
    test('serializes multi categories as category_list[0..n] (Postman format)',
        () {
      final f = HomeFilters(categories: [
        cat('Wx0EAS5tgbDEI4bRz8SP15FAkZ3aiMYm', 'Design'),
        cat('Zy9PLm2qABCDEF1234567890ghijklmn', 'Development'),
      ]);

      final filters = freelancerSearchFilters('a', 1, f);
      final url = buildSearchUrl('v2/search/freelancerSearch', filters);

      expect(
        url,
        contains('category_list[0]=Wx0EAS5tgbDEI4bRz8SP15FAkZ3aiMYm'),
      );
      expect(url, contains('category_list[1]=Zy9PLm2qABCDEF1234567890ghijklmn'));
      // Singular category is stripped by _filterParams in search.
      expect(url, isNot(contains('category=')));
      expect(url, startsWith('v2/search/freelancerSearch?query=a&page=1'));
    });

    test('no category selected → no category params in the URL', () {
      final filters = freelancerSearchFilters('a', 1, HomeFilters());
      final url = buildSearchUrl('v2/search/freelancerSearch', filters);

      expect(url, isNot(contains('category')));
    });
  });
}
