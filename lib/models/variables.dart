enum PageContext { read, bucket, recommend, search }

enum BookCategories {
  novel,
  fantasy,
  biography,
  science_fiction,
  action_and_adventure,
  classics,
  comic,
  mystery,
  historical_fiction,
  horror,
  literary_fiction,
  romance,
  short_stories,
  thriller,
  diy,
  history,
  memoir,
  poetry,
  self_help,
  true_crime,
}

String enumToTitle(BookCategories value) {
  return value
      ?.toString()
      ?.split('.')
      ?.elementAt(1)
      .toString()
      .split("_")
      .map((str) => "${str[0].toUpperCase()}${str.substring(1)}")
      .join(" ");
}

dynamic enumFromString(String comp) {
  BookCategories enumValue = BookCategories.novel;
  BookCategories.values.forEach((item) {
    if (item.toString() == comp) {
      enumValue = item;
    }
  });
  return enumValue;
}
