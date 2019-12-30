import 'package:graphql/client.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';

Future<Map> restaurantInfo() async {
  QueryResult result =
  await clientToQuery().query(QueryOptions(document: getRestaurantInfo));
  if (result.hasErrors) {
    print(result.errors);
  } else {
    return result.data['getRestaurantInfo'];
  }
  return null;
}

final String getRestaurantInfo = r"""
                    query RestaurantInfo{
                      getRestaurantInfo{
                        restaurantName,
                        restaurantLogo,
                        restaurantPhone,
                        restaurantEmail,
                        deliveryTime,
                        collectionTime,
                        weekdayOpeningTime,
                        weekdayCloseTime,
                        minimumOrderPrice,
                        socialLogin,
                        stripeSetting{
                        privateKey
                        }
                      }
                    }
                  """;


Future<Map> restaurantLogoColorSplashDuration() async {
  QueryResult result =
  await clientToQuery().query(QueryOptions(document: getRestaurantLogoColorSplashDuration));
  if (result.hasErrors) {
    print(result.errors);
  } else {
    return result.data['getRestaurantInfo'];
  }
  return null;
}

final String getRestaurantLogoColorSplashDuration = r"""
                    query RestaurantInfo{
                      getRestaurantInfo{
                        restaurantName
                        restaurantLogo
                        splashDuration
                        color
                      }
                    }
                  """;