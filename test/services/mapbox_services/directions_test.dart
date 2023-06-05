import 'package:firetrip/services/mapbox_services/directions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late DirectionsService directionsService;
  late MockHttpClient mockHttpClient;
  late String url;
  late LatLng source, destination;

  setUpAll(() async {
    await dotenv.load(fileName: "assets/config/.env");
    mockHttpClient = MockHttpClient();
    directionsService = DirectionsService(mockHttpClient);

    source = LatLng(22.645658, 88.373153);
    destination = LatLng(22.618618, 88.379321);

    String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
    String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";
    String navType = 'driving';

    url =
        '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  });

  group('DirectionsService Class -', () {
    group('getDrivingRoute Function', () {
      test(
          'given DirectionsService class when getDrivingRoute function is called and status code is 200 then a Map would be returned',
          () async {
        // Arrange
        when(() => mockHttpClient.get(
              Uri.parse(url),
            )).thenAnswer((invocation) async {
          return Response(
              '''{
    "routes": [
        {
            "weight_name": "auto",
            "weight": 546.133,
            "duration": 388.169,
            "distance": 1392.106,
            "legs": [
                {
                    "via_waypoints": [],
                    "admins": [
                        {
                            "iso_3166_1_alpha3": "IND",
                            "iso_3166_1": "IN"
                        }
                    ],
                    "weight": 546.133,
                    "duration": 388.169,
                    "steps": [
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        100
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 0,
                                    "location": [
                                        88.373308,
                                        22.64597
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "depart",
                                "instruction": "Drive east on Deshbandhu Road.",
                                "bearing_after": 100,
                                "bearing_before": 0,
                                "location": [
                                    88.373308,
                                    22.64597
                                ]
                            },
                            "name": "Deshbandhu Road",
                            "duration": 34.513,
                            "distance": 162.976,
                            "driving_side": "left",
                            "weight": 41.415,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.373308,
                                        22.64597
                                    ],
                                    [
                                        88.374249,
                                        22.645811
                                    ],
                                    [
                                        88.37487,
                                        22.645717
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        17,
                                        196,
                                        279
                                    ],
                                    "duration": 12.467,
                                    "turn_weight": 10,
                                    "turn_duration": 6.114,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 17.624,
                                    "geometry_index": 2,
                                    "location": [
                                        88.37487,
                                        22.645717
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        111,
                                        196
                                    ],
                                    "duration": 9.76,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 12.439,
                                    "geometry_index": 3,
                                    "location": [
                                        88.374789,
                                        22.645462
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        192,
                                        294
                                    ],
                                    "duration": 0.856,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.009,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 1.766,
                                    "geometry_index": 4,
                                    "location": [
                                        88.374663,
                                        22.645066
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        12,
                                        107,
                                        190
                                    ],
                                    "duration": 4.456,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 6.086,
                                    "geometry_index": 5,
                                    "location": [
                                        88.374654,
                                        22.645027
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        191,
                                        284
                                    ],
                                    "duration": 8.066,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 10.406,
                                    "geometry_index": 6,
                                    "location": [
                                        88.374618,
                                        22.644843
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        11,
                                        190,
                                        289
                                    ],
                                    "duration": 4.454,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 6.086,
                                    "geometry_index": 7,
                                    "location": [
                                        88.37455,
                                        22.644506
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        103,
                                        190
                                    ],
                                    "duration": 6.818,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 8.91,
                                    "geometry_index": 8,
                                    "location": [
                                        88.374515,
                                        22.644324
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        7,
                                        184,
                                        282
                                    ],
                                    "duration": 4.608,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 6.27,
                                    "geometry_index": 10,
                                    "location": [
                                        88.374467,
                                        22.644025
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        4,
                                        103,
                                        184
                                    ],
                                    "duration": 10.618,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 13.47,
                                    "geometry_index": 11,
                                    "location": [
                                        88.374452,
                                        22.643817
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        155,
                                        221,
                                        342
                                    ],
                                    "duration": 19.011,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.011,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 23.55,
                                    "geometry_index": 14,
                                    "location": [
                                        88.374513,
                                        22.643353
                                    ]
                                },
                                {
                                    "bearings": [
                                        94,
                                        170,
                                        351
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 17,
                                    "location": [
                                        88.374766,
                                        22.642536
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right onto Gopal Lal Tagore Road.",
                                "modifier": "right",
                                "bearing_after": 196,
                                "bearing_before": 99,
                                "location": [
                                    88.37487,
                                    22.645717
                                ]
                            },
                            "name": "Gopal Lal Tagore Road",
                            "duration": 88.122,
                            "distance": 399.481,
                            "driving_side": "left",
                            "weight": 115.759,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.37487,
                                        22.645717
                                    ],
                                    [
                                        88.374789,
                                        22.645462
                                    ],
                                    [
                                        88.374663,
                                        22.645066
                                    ],
                                    [
                                        88.374654,
                                        22.645027
                                    ],
                                    [
                                        88.374618,
                                        22.644843
                                    ],
                                    [
                                        88.37455,
                                        22.644506
                                    ],
                                    [
                                        88.374515,
                                        22.644324
                                    ],
                                    [
                                        88.374472,
                                        22.644103
                                    ],
                                    [
                                        88.374467,
                                        22.644025
                                    ],
                                    [
                                        88.374452,
                                        22.643817
                                    ],
                                    [
                                        88.374439,
                                        22.643628
                                    ],
                                    [
                                        88.374453,
                                        22.643489
                                    ],
                                    [
                                        88.374513,
                                        22.643353
                                    ],
                                    [
                                        88.374569,
                                        22.643262
                                    ],
                                    [
                                        88.3747,
                                        22.642902
                                    ],
                                    [
                                        88.374766,
                                        22.642536
                                    ],
                                    [
                                        88.374796,
                                        22.642441
                                    ],
                                    [
                                        88.374805,
                                        22.642321
                                    ],
                                    [
                                        88.374806,
                                        22.642227
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        115,
                                        206,
                                        358
                                    ],
                                    "duration": 20.609,
                                    "turn_weight": 7,
                                    "turn_duration": 0.449,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 31.192,
                                    "geometry_index": 20,
                                    "location": [
                                        88.374806,
                                        22.642227
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        24,
                                        140,
                                        295
                                    ],
                                    "duration": 9.464,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.104,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 12.732,
                                    "geometry_index": 21,
                                    "location": [
                                        88.375298,
                                        22.64202
                                    ]
                                },
                                {
                                    "bearings": [
                                        111,
                                        199,
                                        311
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.026,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 24,
                                    "location": [
                                        88.375478,
                                        22.641853
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 115,
                                "bearing_before": 178,
                                "location": [
                                    88.374806,
                                    22.642227
                                ]
                            },
                            "name": "",
                            "duration": 48.459,
                            "distance": 132.732,
                            "driving_side": "left",
                            "weight": 67.456,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.374806,
                                        22.642227
                                    ],
                                    [
                                        88.375298,
                                        22.64202
                                    ],
                                    [
                                        88.375335,
                                        22.641977
                                    ],
                                    [
                                        88.375403,
                                        22.641903
                                    ],
                                    [
                                        88.375478,
                                        22.641853
                                    ],
                                    [
                                        88.375939,
                                        22.641689
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        15,
                                        187,
                                        291
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 5,
                                    "turn_duration": 3.477,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 25,
                                    "location": [
                                        88.375939,
                                        22.641689
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right.",
                                "modifier": "right",
                                "bearing_after": 187,
                                "bearing_before": 111,
                                "location": [
                                    88.375939,
                                    22.641689
                                ]
                            },
                            "name": "",
                            "duration": 17.157,
                            "distance": 38.274,
                            "driving_side": "left",
                            "weight": 21.416,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375939,
                                        22.641689
                                    ],
                                    [
                                        88.375946,
                                        22.641691
                                    ],
                                    [
                                        88.375883,
                                        22.641359
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        102,
                                        234
                                    ],
                                    "duration": 30.445,
                                    "turn_weight": 2,
                                    "turn_duration": 2.005,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 36.128,
                                    "geometry_index": 27,
                                    "location": [
                                        88.375883,
                                        22.641359
                                    ]
                                },
                                {
                                    "bearings": [
                                        84,
                                        208,
                                        282
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.023,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 28,
                                    "location": [
                                        88.376632,
                                        22.641216
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 102,
                                "bearing_before": 190,
                                "location": [
                                    88.375883,
                                    22.641359
                                ]
                            },
                            "name": "",
                            "duration": 52.068,
                            "distance": 138.47,
                            "driving_side": "left",
                            "weight": 63.548,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375883,
                                        22.641359
                                    ],
                                    [
                                        88.376632,
                                        22.641216
                                    ],
                                    [
                                        88.37674,
                                        22.641216
                                    ],
                                    [
                                        88.37681,
                                        22.641243
                                    ],
                                    [
                                        88.376865,
                                        22.64127
                                    ],
                                    [
                                        88.376904,
                                        22.64129
                                    ],
                                    [
                                        88.376964,
                                        22.641298
                                    ],
                                    [
                                        88.377192,
                                        22.641261
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        118,
                                        191,
                                        280
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 5,
                                    "turn_duration": 5.51,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 34,
                                    "location": [
                                        88.377192,
                                        22.641261
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right.",
                                "modifier": "right",
                                "bearing_after": 191,
                                "bearing_before": 100,
                                "location": [
                                    88.377192,
                                    22.641261
                                ]
                            },
                            "name": "",
                            "duration": 26.39,
                            "distance": 58.046,
                            "driving_side": "left",
                            "weight": 30.056,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377192,
                                        22.641261
                                    ],
                                    [
                                        88.377085,
                                        22.640749
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        11,
                                        91,
                                        187
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 2,
                                    "turn_duration": 3.125,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 35,
                                    "location": [
                                        88.377085,
                                        22.640749
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 91,
                                "bearing_before": 191,
                                "location": [
                                    88.377085,
                                    22.640749
                                ]
                            },
                            "name": "",
                            "duration": 32.645,
                            "distance": 82.056,
                            "driving_side": "left",
                            "weight": 37.424,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377085,
                                        22.640749
                                    ],
                                    [
                                        88.377497,
                                        22.64074
                                    ],
                                    [
                                        88.377883,
                                        22.640759
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        177,
                                        267,
                                        356
                                    ],
                                    "entry": [
                                        false,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "turn_weight": 10.5,
                                    "turn_duration": 2.208,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "geometry_index": 37,
                                    "location": [
                                        88.377883,
                                        22.640759
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left onto Barrackpore Trunk Road/SH1.",
                                "modifier": "left",
                                "bearing_after": 356,
                                "bearing_before": 87,
                                "location": [
                                    88.377883,
                                    22.640759
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 7.833,
                            "distance": 25.434,
                            "driving_side": "left",
                            "weight": 17.25,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377883,
                                        22.640759
                                    ],
                                    [
                                        88.377867,
                                        22.640987
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "bearings": [
                                        86,
                                        176,
                                        358
                                    ],
                                    "duration": 6.715,
                                    "turn_weight": 7.5,
                                    "turn_duration": 5.395,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 9.084,
                                    "geometry_index": 38,
                                    "location": [
                                        88.377867,
                                        22.640987
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        266,
                                        358
                                    ],
                                    "duration": 39.71,
                                    "turn_weight": 59.25,
                                    "turn_duration": 5.51,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 100.29,
                                    "geometry_index": 39,
                                    "location": [
                                        88.377976,
                                        22.640994
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        89,
                                        177,
                                        358
                                    ],
                                    "duration": 31.807,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 38.16,
                                    "geometry_index": 41,
                                    "location": [
                                        88.378055,
                                        22.63946
                                    ]
                                },
                                {
                                    "bearings": [
                                        97,
                                        177,
                                        286,
                                        356
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "turn_weight": 1,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 43,
                                    "location": [
                                        88.378145,
                                        22.638036
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "continue",
                                "instruction": "Make a right U-turn to stay on Barrackpore Trunk Road/SH1.",
                                "modifier": "uturn",
                                "bearing_after": 177,
                                "bearing_before": 356,
                                "location": [
                                    88.377867,
                                    22.640987
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 80.981,
                            "distance": 354.637,
                            "driving_side": "left",
                            "weight": 151.809,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377867,
                                        22.640987
                                    ],
                                    [
                                        88.377976,
                                        22.640994
                                    ],
                                    [
                                        88.378026,
                                        22.640225
                                    ],
                                    [
                                        88.378055,
                                        22.63946
                                    ],
                                    [
                                        88.378095,
                                        22.638713
                                    ],
                                    [
                                        88.378145,
                                        22.638036
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        357
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "in": 0,
                                    "admin_index": 0,
                                    "geometry_index": 44,
                                    "location": [
                                        88.378152,
                                        22.637914
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "arrive",
                                "instruction": "Your destination is on the right.",
                                "modifier": "right",
                                "bearing_after": 0,
                                "bearing_before": 177,
                                "location": [
                                    88.378152,
                                    22.637914
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 0,
                            "distance": 0,
                            "driving_side": "left",
                            "weight": 0,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.378152,
                                        22.637914
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        }
                    ],
                    "distance": 1392.106,
                    "summary": "Gopal Lal Tagore Road, Barrackpore Trunk Road"
                }
            ],
            "geometry": {
                "coordinates": [
                    [
                        88.373308,
                        22.64597
                    ],
                    [
                        88.37487,
                        22.645717
                    ],
                    [
                        88.374654,
                        22.645027
                    ],
                    [
                        88.374439,
                        22.643628
                    ],
                    [
                        88.3747,
                        22.642902
                    ],
                    [
                        88.374806,
                        22.642227
                    ],
                    [
                        88.375298,
                        22.64202
                    ],
                    [
                        88.375478,
                        22.641853
                    ],
                    [
                        88.375939,
                        22.641689
                    ],
                    [
                        88.375883,
                        22.641359
                    ],
                    [
                        88.376632,
                        22.641216
                    ],
                    [
                        88.376964,
                        22.641298
                    ],
                    [
                        88.377192,
                        22.641261
                    ],
                    [
                        88.377085,
                        22.640749
                    ],
                    [
                        88.377883,
                        22.640759
                    ],
                    [
                        88.377867,
                        22.640987
                    ],
                    [
                        88.377976,
                        22.640994
                    ],
                    [
                        88.378152,
                        22.637914
                    ]
                ],
                "type": "LineString"
            }
        },
        {
            "weight_name": "auto",
            "weight": 566.873,
            "duration": 399.844,
            "distance": 1555.122,
            "legs": [
                {
                    "via_waypoints": [],
                    "admins": [
                        {
                            "iso_3166_1_alpha3": "IND",
                            "iso_3166_1": "IN"
                        }
                    ],
                    "weight": 566.873,
                    "duration": 399.844,
                    "steps": [
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        100
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 0,
                                    "location": [
                                        88.373308,
                                        22.64597
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "depart",
                                "instruction": "Drive east on Deshbandhu Road.",
                                "bearing_after": 100,
                                "bearing_before": 0,
                                "location": [
                                    88.373308,
                                    22.64597
                                ]
                            },
                            "name": "Deshbandhu Road",
                            "duration": 34.513,
                            "distance": 162.976,
                            "driving_side": "left",
                            "weight": 41.415,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.373308,
                                        22.64597
                                    ],
                                    [
                                        88.374249,
                                        22.645811
                                    ],
                                    [
                                        88.37487,
                                        22.645717
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        17,
                                        196,
                                        279
                                    ],
                                    "duration": 12.467,
                                    "turn_weight": 10,
                                    "turn_duration": 6.114,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 17.624,
                                    "geometry_index": 2,
                                    "location": [
                                        88.37487,
                                        22.645717
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        111,
                                        196
                                    ],
                                    "duration": 9.76,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 12.439,
                                    "geometry_index": 3,
                                    "location": [
                                        88.374789,
                                        22.645462
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        192,
                                        294
                                    ],
                                    "duration": 0.856,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.009,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 1.766,
                                    "geometry_index": 4,
                                    "location": [
                                        88.374663,
                                        22.645066
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        12,
                                        107,
                                        190
                                    ],
                                    "duration": 4.456,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 6.086,
                                    "geometry_index": 5,
                                    "location": [
                                        88.374654,
                                        22.645027
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        191,
                                        284
                                    ],
                                    "duration": 8.066,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 10.406,
                                    "geometry_index": 6,
                                    "location": [
                                        88.374618,
                                        22.644843
                                    ]
                                },
                                {
                                    "bearings": [
                                        11,
                                        190,
                                        289
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 7,
                                    "location": [
                                        88.37455,
                                        22.644506
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right onto Gopal Lal Tagore Road.",
                                "modifier": "right",
                                "bearing_after": 196,
                                "bearing_before": 99,
                                "location": [
                                    88.37487,
                                    22.645717
                                ]
                            },
                            "name": "Gopal Lal Tagore Road",
                            "duration": 40.06,
                            "distance": 159.515,
                            "driving_side": "left",
                            "weight": 54.409,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.37487,
                                        22.645717
                                    ],
                                    [
                                        88.374789,
                                        22.645462
                                    ],
                                    [
                                        88.374663,
                                        22.645066
                                    ],
                                    [
                                        88.374654,
                                        22.645027
                                    ],
                                    [
                                        88.374618,
                                        22.644843
                                    ],
                                    [
                                        88.37455,
                                        22.644506
                                    ],
                                    [
                                        88.374515,
                                        22.644324
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        10,
                                        103,
                                        190
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 7,
                                    "turn_duration": 1.814,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 8,
                                    "location": [
                                        88.374515,
                                        22.644324
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 103,
                                "bearing_before": 190,
                                "location": [
                                    88.374515,
                                    22.644324
                                ]
                            },
                            "name": "",
                            "duration": 66.254,
                            "distance": 178.565,
                            "driving_side": "left",
                            "weight": 84.328,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.374515,
                                        22.644324
                                    ],
                                    [
                                        88.374909,
                                        22.644239
                                    ],
                                    [
                                        88.375051,
                                        22.644199
                                    ],
                                    [
                                        88.375118,
                                        22.644129
                                    ],
                                    [
                                        88.375204,
                                        22.644098
                                    ],
                                    [
                                        88.375469,
                                        22.644073
                                    ],
                                    [
                                        88.375645,
                                        22.64404
                                    ],
                                    [
                                        88.375669,
                                        22.64396
                                    ],
                                    [
                                        88.375717,
                                        22.643915
                                    ],
                                    [
                                        88.37589,
                                        22.64384
                                    ],
                                    [
                                        88.375909,
                                        22.64366
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        113,
                                        282,
                                        354
                                    ],
                                    "duration": 33.851,
                                    "turn_weight": 2,
                                    "turn_duration": 0.371,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 42.176,
                                    "geometry_index": 18,
                                    "location": [
                                        88.375909,
                                        22.64366
                                    ]
                                },
                                {
                                    "bearings": [
                                        200,
                                        289
                                    ],
                                    "entry": [
                                        true,
                                        false
                                    ],
                                    "in": 1,
                                    "turn_weight": 5,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 21,
                                    "location": [
                                        88.376764,
                                        22.643384
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 113,
                                "bearing_before": 174,
                                "location": [
                                    88.375909,
                                    22.64366
                                ]
                            },
                            "name": "",
                            "duration": 44.651,
                            "distance": 123.123,
                            "driving_side": "left",
                            "weight": 60.136,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375909,
                                        22.64366
                                    ],
                                    [
                                        88.376038,
                                        22.643608
                                    ],
                                    [
                                        88.37627,
                                        22.643537
                                    ],
                                    [
                                        88.376764,
                                        22.643384
                                    ],
                                    [
                                        88.376666,
                                        22.64313
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        20,
                                        105,
                                        200
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 2,
                                    "turn_duration": 2.535,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 22,
                                    "location": [
                                        88.376666,
                                        22.64313
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 105,
                                "bearing_before": 200,
                                "location": [
                                    88.376666,
                                    22.64313
                                ]
                            },
                            "name": "",
                            "duration": 9.975,
                            "distance": 61.584,
                            "driving_side": "left",
                            "weight": 10.928,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.376666,
                                        22.64313
                                    ],
                                    [
                                        88.376889,
                                        22.643076
                                    ],
                                    [
                                        88.376931,
                                        22.643062
                                    ],
                                    [
                                        88.37695,
                                        22.643046
                                    ],
                                    [
                                        88.376955,
                                        22.643027
                                    ],
                                    [
                                        88.376952,
                                        22.642988
                                    ],
                                    [
                                        88.376908,
                                        22.642775
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        11,
                                        97,
                                        189,
                                        279
                                    ],
                                    "duration": 14.535,
                                    "turn_weight": 6.2,
                                    "turn_duration": 2.535,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 20.6,
                                    "geometry_index": 28,
                                    "location": [
                                        88.376908,
                                        22.642775
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "bearings": [
                                        8,
                                        97,
                                        189,
                                        277
                                    ],
                                    "duration": 4.338,
                                    "turn_weight": 2,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 7.184,
                                    "geometry_index": 29,
                                    "location": [
                                        88.3771,
                                        22.642754
                                    ]
                                },
                                {
                                    "bearings": [
                                        1,
                                        99,
                                        277
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 3.1,
                                    "turn_duration": 0.021,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 30,
                                    "location": [
                                        88.377451,
                                        22.642717
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 97,
                                "bearing_before": 191,
                                "location": [
                                    88.376908,
                                    22.642775
                                ]
                            },
                            "name": "",
                            "duration": 30.773,
                            "distance": 89.57,
                            "driving_side": "left",
                            "weight": 45.14,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.376908,
                                        22.642775
                                    ],
                                    [
                                        88.3771,
                                        22.642754
                                    ],
                                    [
                                        88.377451,
                                        22.642717
                                    ],
                                    [
                                        88.377772,
                                        22.642669
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        176,
                                        279,
                                        357
                                    ],
                                    "entry": [
                                        false,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "turn_weight": 10.5,
                                    "turn_duration": 3.373,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "geometry_index": 31,
                                    "location": [
                                        88.377772,
                                        22.642669
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "end of road",
                                "instruction": "Turn left onto Barrackpore Trunk Road/SH1.",
                                "modifier": "left",
                                "bearing_after": 357,
                                "bearing_before": 99,
                                "location": [
                                    88.377772,
                                    22.642669
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 36.603,
                            "distance": 120.224,
                            "driving_side": "left",
                            "weight": 50.377,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377772,
                                        22.642669
                                    ],
                                    [
                                        88.377725,
                                        22.643394
                                    ],
                                    [
                                        88.377701,
                                        22.643747
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "bearings": [
                                        103,
                                        176,
                                        358
                                    ],
                                    "duration": 8.232,
                                    "turn_weight": 7.5,
                                    "turn_duration": 6.792,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 9.228,
                                    "geometry_index": 33,
                                    "location": [
                                        88.377701,
                                        22.643747
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        283,
                                        358
                                    ],
                                    "duration": 41.653,
                                    "turn_weight": 59.25,
                                    "turn_duration": 3.189,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 105.406,
                                    "geometry_index": 34,
                                    "location": [
                                        88.377813,
                                        22.643724
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        357
                                    ],
                                    "duration": 18.367,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 22.032,
                                    "geometry_index": 35,
                                    "location": [
                                        88.377925,
                                        22.641906
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "bearings": [
                                        101,
                                        177,
                                        266,
                                        357
                                    ],
                                    "duration": 34.207,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 41.04,
                                    "geometry_index": 36,
                                    "location": [
                                        88.377976,
                                        22.640994
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        89,
                                        177,
                                        358
                                    ],
                                    "duration": 31.807,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 38.16,
                                    "geometry_index": 38,
                                    "location": [
                                        88.378055,
                                        22.63946
                                    ]
                                },
                                {
                                    "bearings": [
                                        97,
                                        177,
                                        286,
                                        356
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "turn_weight": 1,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 40,
                                    "location": [
                                        88.378145,
                                        22.638036
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "continue",
                                "instruction": "Make a right U-turn to stay on Barrackpore Trunk Road/SH1.",
                                "modifier": "uturn",
                                "bearing_after": 177,
                                "bearing_before": 356,
                                "location": [
                                    88.377701,
                                    22.643747
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 137.015,
                            "distance": 659.565,
                            "driving_side": "left",
                            "weight": 220.141,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377701,
                                        22.643747
                                    ],
                                    [
                                        88.377813,
                                        22.643724
                                    ],
                                    [
                                        88.377925,
                                        22.641906
                                    ],
                                    [
                                        88.377976,
                                        22.640994
                                    ],
                                    [
                                        88.378026,
                                        22.640225
                                    ],
                                    [
                                        88.378055,
                                        22.63946
                                    ],
                                    [
                                        88.378095,
                                        22.638713
                                    ],
                                    [
                                        88.378145,
                                        22.638036
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        357
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "in": 0,
                                    "admin_index": 0,
                                    "geometry_index": 41,
                                    "location": [
                                        88.378152,
                                        22.637914
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "arrive",
                                "instruction": "Your destination is on the right.",
                                "modifier": "right",
                                "bearing_after": 0,
                                "bearing_before": 177,
                                "location": [
                                    88.378152,
                                    22.637914
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 0,
                            "distance": 0,
                            "driving_side": "left",
                            "weight": 0,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.378152,
                                        22.637914
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        }
                    ],
                    "distance": 1555.122,
                    "summary": "Deshbandhu Road, Barrackpore Trunk Road"
                }
            ],
            "geometry": {
                "coordinates": [
                    [
                        88.373308,
                        22.64597
                    ],
                    [
                        88.37487,
                        22.645717
                    ],
                    [
                        88.374515,
                        22.644324
                    ],
                    [
                        88.375204,
                        22.644098
                    ],
                    [
                        88.375645,
                        22.64404
                    ],
                    [
                        88.375717,
                        22.643915
                    ],
                    [
                        88.37589,
                        22.64384
                    ],
                    [
                        88.375909,
                        22.64366
                    ],
                    [
                        88.376764,
                        22.643384
                    ],
                    [
                        88.376666,
                        22.64313
                    ],
                    [
                        88.37695,
                        22.643046
                    ],
                    [
                        88.376908,
                        22.642775
                    ],
                    [
                        88.377772,
                        22.642669
                    ],
                    [
                        88.377701,
                        22.643747
                    ],
                    [
                        88.377813,
                        22.643724
                    ],
                    [
                        88.378152,
                        22.637914
                    ]
                ],
                "type": "LineString"
            }
        }
    ],
    "waypoints": [
        {
            "distance": 0.324,
            "name": "Deshbandhu Road",
            "location": [
                88.373308,
                22.64597
            ]
        },
        {
            "distance": 5.369,
            "name": "Barrackpore Trunk Road",
            "location": [
                88.378152,
                22.637914
            ]
        }
    ],
    "code": "Ok",
    "uuid": "5OC5mkMAcYaOKybbhmon10sNv9ZuEBW65rcbEmrYIJBc4h3ojaZdwg=="
} 
''',
              200);
        });

        // Act
        final response =
            await directionsService.getDrivingRoute(source, destination);

        // Assert
        expect(response, isA<Map>());
      });

      test(
          'given DirectionsService class when getDrivingRoute function is called and status code is not 200 then an exception should be thrown',
          () async {
        // Arrange

        when(() => mockHttpClient.get(Uri.parse(url)))
            .thenAnswer((invocation) async => Response('{}', 500));
        // Act
        final response = directionsService.getDrivingRoute(source, destination);

        // Assert
        expect(response, throwsException);
      });
    });

    group('getDirectionsAPIResponse Function', () {
      test(
          'given DirectionsService when getDirectionsAPIResponse function is called and a valid response is received from getDrivingRoute function then a Map should be returned',
          () async {
        // Arrange
        when(() => mockHttpClient.get(Uri.parse(url))).thenAnswer(
          (invocation) async {
            return Response(
                '''{
    "routes": [
        {
            "weight_name": "auto",
            "weight": 546.133,
            "duration": 388.169,
            "distance": 1392.106,
            "legs": [
                {
                    "via_waypoints": [],
                    "admins": [
                        {
                            "iso_3166_1_alpha3": "IND",
                            "iso_3166_1": "IN"
                        }
                    ],
                    "weight": 546.133,
                    "duration": 388.169,
                    "steps": [
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        100
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 0,
                                    "location": [
                                        88.373308,
                                        22.64597
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "depart",
                                "instruction": "Drive east on Deshbandhu Road.",
                                "bearing_after": 100,
                                "bearing_before": 0,
                                "location": [
                                    88.373308,
                                    22.64597
                                ]
                            },
                            "name": "Deshbandhu Road",
                            "duration": 34.513,
                            "distance": 162.976,
                            "driving_side": "left",
                            "weight": 41.415,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.373308,
                                        22.64597
                                    ],
                                    [
                                        88.374249,
                                        22.645811
                                    ],
                                    [
                                        88.37487,
                                        22.645717
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        17,
                                        196,
                                        279
                                    ],
                                    "duration": 12.467,
                                    "turn_weight": 10,
                                    "turn_duration": 6.114,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 17.624,
                                    "geometry_index": 2,
                                    "location": [
                                        88.37487,
                                        22.645717
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        111,
                                        196
                                    ],
                                    "duration": 9.76,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 12.439,
                                    "geometry_index": 3,
                                    "location": [
                                        88.374789,
                                        22.645462
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        192,
                                        294
                                    ],
                                    "duration": 0.856,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.009,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 1.766,
                                    "geometry_index": 4,
                                    "location": [
                                        88.374663,
                                        22.645066
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        12,
                                        107,
                                        190
                                    ],
                                    "duration": 4.456,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 6.086,
                                    "geometry_index": 5,
                                    "location": [
                                        88.374654,
                                        22.645027
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        191,
                                        284
                                    ],
                                    "duration": 8.066,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 10.406,
                                    "geometry_index": 6,
                                    "location": [
                                        88.374618,
                                        22.644843
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        11,
                                        190,
                                        289
                                    ],
                                    "duration": 4.454,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 6.086,
                                    "geometry_index": 7,
                                    "location": [
                                        88.37455,
                                        22.644506
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        103,
                                        190
                                    ],
                                    "duration": 6.818,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 8.91,
                                    "geometry_index": 8,
                                    "location": [
                                        88.374515,
                                        22.644324
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        7,
                                        184,
                                        282
                                    ],
                                    "duration": 4.608,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 6.27,
                                    "geometry_index": 10,
                                    "location": [
                                        88.374467,
                                        22.644025
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        4,
                                        103,
                                        184
                                    ],
                                    "duration": 10.618,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 13.47,
                                    "geometry_index": 11,
                                    "location": [
                                        88.374452,
                                        22.643817
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        155,
                                        221,
                                        342
                                    ],
                                    "duration": 19.011,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.011,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 23.55,
                                    "geometry_index": 14,
                                    "location": [
                                        88.374513,
                                        22.643353
                                    ]
                                },
                                {
                                    "bearings": [
                                        94,
                                        170,
                                        351
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 17,
                                    "location": [
                                        88.374766,
                                        22.642536
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right onto Gopal Lal Tagore Road.",
                                "modifier": "right",
                                "bearing_after": 196,
                                "bearing_before": 99,
                                "location": [
                                    88.37487,
                                    22.645717
                                ]
                            },
                            "name": "Gopal Lal Tagore Road",
                            "duration": 88.122,
                            "distance": 399.481,
                            "driving_side": "left",
                            "weight": 115.759,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.37487,
                                        22.645717
                                    ],
                                    [
                                        88.374789,
                                        22.645462
                                    ],
                                    [
                                        88.374663,
                                        22.645066
                                    ],
                                    [
                                        88.374654,
                                        22.645027
                                    ],
                                    [
                                        88.374618,
                                        22.644843
                                    ],
                                    [
                                        88.37455,
                                        22.644506
                                    ],
                                    [
                                        88.374515,
                                        22.644324
                                    ],
                                    [
                                        88.374472,
                                        22.644103
                                    ],
                                    [
                                        88.374467,
                                        22.644025
                                    ],
                                    [
                                        88.374452,
                                        22.643817
                                    ],
                                    [
                                        88.374439,
                                        22.643628
                                    ],
                                    [
                                        88.374453,
                                        22.643489
                                    ],
                                    [
                                        88.374513,
                                        22.643353
                                    ],
                                    [
                                        88.374569,
                                        22.643262
                                    ],
                                    [
                                        88.3747,
                                        22.642902
                                    ],
                                    [
                                        88.374766,
                                        22.642536
                                    ],
                                    [
                                        88.374796,
                                        22.642441
                                    ],
                                    [
                                        88.374805,
                                        22.642321
                                    ],
                                    [
                                        88.374806,
                                        22.642227
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        115,
                                        206,
                                        358
                                    ],
                                    "duration": 20.609,
                                    "turn_weight": 7,
                                    "turn_duration": 0.449,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 31.192,
                                    "geometry_index": 20,
                                    "location": [
                                        88.374806,
                                        22.642227
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        24,
                                        140,
                                        295
                                    ],
                                    "duration": 9.464,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.104,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 12.732,
                                    "geometry_index": 21,
                                    "location": [
                                        88.375298,
                                        22.64202
                                    ]
                                },
                                {
                                    "bearings": [
                                        111,
                                        199,
                                        311
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.026,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 24,
                                    "location": [
                                        88.375478,
                                        22.641853
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 115,
                                "bearing_before": 178,
                                "location": [
                                    88.374806,
                                    22.642227
                                ]
                            },
                            "name": "",
                            "duration": 48.459,
                            "distance": 132.732,
                            "driving_side": "left",
                            "weight": 67.456,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.374806,
                                        22.642227
                                    ],
                                    [
                                        88.375298,
                                        22.64202
                                    ],
                                    [
                                        88.375335,
                                        22.641977
                                    ],
                                    [
                                        88.375403,
                                        22.641903
                                    ],
                                    [
                                        88.375478,
                                        22.641853
                                    ],
                                    [
                                        88.375939,
                                        22.641689
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        15,
                                        187,
                                        291
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 5,
                                    "turn_duration": 3.477,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 25,
                                    "location": [
                                        88.375939,
                                        22.641689
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right.",
                                "modifier": "right",
                                "bearing_after": 187,
                                "bearing_before": 111,
                                "location": [
                                    88.375939,
                                    22.641689
                                ]
                            },
                            "name": "",
                            "duration": 17.157,
                            "distance": 38.274,
                            "driving_side": "left",
                            "weight": 21.416,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375939,
                                        22.641689
                                    ],
                                    [
                                        88.375946,
                                        22.641691
                                    ],
                                    [
                                        88.375883,
                                        22.641359
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        102,
                                        234
                                    ],
                                    "duration": 30.445,
                                    "turn_weight": 2,
                                    "turn_duration": 2.005,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 36.128,
                                    "geometry_index": 27,
                                    "location": [
                                        88.375883,
                                        22.641359
                                    ]
                                },
                                {
                                    "bearings": [
                                        84,
                                        208,
                                        282
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 1.5,
                                    "turn_duration": 0.023,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 28,
                                    "location": [
                                        88.376632,
                                        22.641216
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 102,
                                "bearing_before": 190,
                                "location": [
                                    88.375883,
                                    22.641359
                                ]
                            },
                            "name": "",
                            "duration": 52.068,
                            "distance": 138.47,
                            "driving_side": "left",
                            "weight": 63.548,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375883,
                                        22.641359
                                    ],
                                    [
                                        88.376632,
                                        22.641216
                                    ],
                                    [
                                        88.37674,
                                        22.641216
                                    ],
                                    [
                                        88.37681,
                                        22.641243
                                    ],
                                    [
                                        88.376865,
                                        22.64127
                                    ],
                                    [
                                        88.376904,
                                        22.64129
                                    ],
                                    [
                                        88.376964,
                                        22.641298
                                    ],
                                    [
                                        88.377192,
                                        22.641261
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        118,
                                        191,
                                        280
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 5,
                                    "turn_duration": 5.51,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 34,
                                    "location": [
                                        88.377192,
                                        22.641261
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right.",
                                "modifier": "right",
                                "bearing_after": 191,
                                "bearing_before": 100,
                                "location": [
                                    88.377192,
                                    22.641261
                                ]
                            },
                            "name": "",
                            "duration": 26.39,
                            "distance": 58.046,
                            "driving_side": "left",
                            "weight": 30.056,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377192,
                                        22.641261
                                    ],
                                    [
                                        88.377085,
                                        22.640749
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        11,
                                        91,
                                        187
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 2,
                                    "turn_duration": 3.125,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 35,
                                    "location": [
                                        88.377085,
                                        22.640749
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 91,
                                "bearing_before": 191,
                                "location": [
                                    88.377085,
                                    22.640749
                                ]
                            },
                            "name": "",
                            "duration": 32.645,
                            "distance": 82.056,
                            "driving_side": "left",
                            "weight": 37.424,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377085,
                                        22.640749
                                    ],
                                    [
                                        88.377497,
                                        22.64074
                                    ],
                                    [
                                        88.377883,
                                        22.640759
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        177,
                                        267,
                                        356
                                    ],
                                    "entry": [
                                        false,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "turn_weight": 10.5,
                                    "turn_duration": 2.208,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "geometry_index": 37,
                                    "location": [
                                        88.377883,
                                        22.640759
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left onto Barrackpore Trunk Road/SH1.",
                                "modifier": "left",
                                "bearing_after": 356,
                                "bearing_before": 87,
                                "location": [
                                    88.377883,
                                    22.640759
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 7.833,
                            "distance": 25.434,
                            "driving_side": "left",
                            "weight": 17.25,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377883,
                                        22.640759
                                    ],
                                    [
                                        88.377867,
                                        22.640987
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "bearings": [
                                        86,
                                        176,
                                        358
                                    ],
                                    "duration": 6.715,
                                    "turn_weight": 7.5,
                                    "turn_duration": 5.395,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 9.084,
                                    "geometry_index": 38,
                                    "location": [
                                        88.377867,
                                        22.640987
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        266,
                                        358
                                    ],
                                    "duration": 39.71,
                                    "turn_weight": 59.25,
                                    "turn_duration": 5.51,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 100.29,
                                    "geometry_index": 39,
                                    "location": [
                                        88.377976,
                                        22.640994
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        89,
                                        177,
                                        358
                                    ],
                                    "duration": 31.807,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 38.16,
                                    "geometry_index": 41,
                                    "location": [
                                        88.378055,
                                        22.63946
                                    ]
                                },
                                {
                                    "bearings": [
                                        97,
                                        177,
                                        286,
                                        356
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "turn_weight": 1,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 43,
                                    "location": [
                                        88.378145,
                                        22.638036
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "continue",
                                "instruction": "Make a right U-turn to stay on Barrackpore Trunk Road/SH1.",
                                "modifier": "uturn",
                                "bearing_after": 177,
                                "bearing_before": 356,
                                "location": [
                                    88.377867,
                                    22.640987
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 80.981,
                            "distance": 354.637,
                            "driving_side": "left",
                            "weight": 151.809,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377867,
                                        22.640987
                                    ],
                                    [
                                        88.377976,
                                        22.640994
                                    ],
                                    [
                                        88.378026,
                                        22.640225
                                    ],
                                    [
                                        88.378055,
                                        22.63946
                                    ],
                                    [
                                        88.378095,
                                        22.638713
                                    ],
                                    [
                                        88.378145,
                                        22.638036
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        357
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "in": 0,
                                    "admin_index": 0,
                                    "geometry_index": 44,
                                    "location": [
                                        88.378152,
                                        22.637914
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "arrive",
                                "instruction": "Your destination is on the right.",
                                "modifier": "right",
                                "bearing_after": 0,
                                "bearing_before": 177,
                                "location": [
                                    88.378152,
                                    22.637914
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 0,
                            "distance": 0,
                            "driving_side": "left",
                            "weight": 0,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.378152,
                                        22.637914
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        }
                    ],
                    "distance": 1392.106,
                    "summary": "Gopal Lal Tagore Road, Barrackpore Trunk Road"
                }
            ],
            "geometry": {
                "coordinates": [
                    [
                        88.373308,
                        22.64597
                    ],
                    [
                        88.37487,
                        22.645717
                    ],
                    [
                        88.374654,
                        22.645027
                    ],
                    [
                        88.374439,
                        22.643628
                    ],
                    [
                        88.3747,
                        22.642902
                    ],
                    [
                        88.374806,
                        22.642227
                    ],
                    [
                        88.375298,
                        22.64202
                    ],
                    [
                        88.375478,
                        22.641853
                    ],
                    [
                        88.375939,
                        22.641689
                    ],
                    [
                        88.375883,
                        22.641359
                    ],
                    [
                        88.376632,
                        22.641216
                    ],
                    [
                        88.376964,
                        22.641298
                    ],
                    [
                        88.377192,
                        22.641261
                    ],
                    [
                        88.377085,
                        22.640749
                    ],
                    [
                        88.377883,
                        22.640759
                    ],
                    [
                        88.377867,
                        22.640987
                    ],
                    [
                        88.377976,
                        22.640994
                    ],
                    [
                        88.378152,
                        22.637914
                    ]
                ],
                "type": "LineString"
            }
        },
        {
            "weight_name": "auto",
            "weight": 566.873,
            "duration": 399.844,
            "distance": 1555.122,
            "legs": [
                {
                    "via_waypoints": [],
                    "admins": [
                        {
                            "iso_3166_1_alpha3": "IND",
                            "iso_3166_1": "IN"
                        }
                    ],
                    "weight": 566.873,
                    "duration": 399.844,
                    "steps": [
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        100
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 0,
                                    "location": [
                                        88.373308,
                                        22.64597
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "depart",
                                "instruction": "Drive east on Deshbandhu Road.",
                                "bearing_after": 100,
                                "bearing_before": 0,
                                "location": [
                                    88.373308,
                                    22.64597
                                ]
                            },
                            "name": "Deshbandhu Road",
                            "duration": 34.513,
                            "distance": 162.976,
                            "driving_side": "left",
                            "weight": 41.415,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.373308,
                                        22.64597
                                    ],
                                    [
                                        88.374249,
                                        22.645811
                                    ],
                                    [
                                        88.37487,
                                        22.645717
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        17,
                                        196,
                                        279
                                    ],
                                    "duration": 12.467,
                                    "turn_weight": 10,
                                    "turn_duration": 6.114,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 17.624,
                                    "geometry_index": 2,
                                    "location": [
                                        88.37487,
                                        22.645717
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        111,
                                        196
                                    ],
                                    "duration": 9.76,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 12.439,
                                    "geometry_index": 3,
                                    "location": [
                                        88.374789,
                                        22.645462
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        16,
                                        192,
                                        294
                                    ],
                                    "duration": 0.856,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.009,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 1.766,
                                    "geometry_index": 4,
                                    "location": [
                                        88.374663,
                                        22.645066
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        12,
                                        107,
                                        190
                                    ],
                                    "duration": 4.456,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.008,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "weight": 6.086,
                                    "geometry_index": 5,
                                    "location": [
                                        88.374654,
                                        22.645027
                                    ]
                                },
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        10,
                                        191,
                                        284
                                    ],
                                    "duration": 8.066,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 10.406,
                                    "geometry_index": 6,
                                    "location": [
                                        88.374618,
                                        22.644843
                                    ]
                                },
                                {
                                    "bearings": [
                                        11,
                                        190,
                                        289
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 0.75,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "tertiary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 7,
                                    "location": [
                                        88.37455,
                                        22.644506
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn right onto Gopal Lal Tagore Road.",
                                "modifier": "right",
                                "bearing_after": 196,
                                "bearing_before": 99,
                                "location": [
                                    88.37487,
                                    22.645717
                                ]
                            },
                            "name": "Gopal Lal Tagore Road",
                            "duration": 40.06,
                            "distance": 159.515,
                            "driving_side": "left",
                            "weight": 54.409,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.37487,
                                        22.645717
                                    ],
                                    [
                                        88.374789,
                                        22.645462
                                    ],
                                    [
                                        88.374663,
                                        22.645066
                                    ],
                                    [
                                        88.374654,
                                        22.645027
                                    ],
                                    [
                                        88.374618,
                                        22.644843
                                    ],
                                    [
                                        88.37455,
                                        22.644506
                                    ],
                                    [
                                        88.374515,
                                        22.644324
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        10,
                                        103,
                                        190
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 7,
                                    "turn_duration": 1.814,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 8,
                                    "location": [
                                        88.374515,
                                        22.644324
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 103,
                                "bearing_before": 190,
                                "location": [
                                    88.374515,
                                    22.644324
                                ]
                            },
                            "name": "",
                            "duration": 66.254,
                            "distance": 178.565,
                            "driving_side": "left",
                            "weight": 84.328,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.374515,
                                        22.644324
                                    ],
                                    [
                                        88.374909,
                                        22.644239
                                    ],
                                    [
                                        88.375051,
                                        22.644199
                                    ],
                                    [
                                        88.375118,
                                        22.644129
                                    ],
                                    [
                                        88.375204,
                                        22.644098
                                    ],
                                    [
                                        88.375469,
                                        22.644073
                                    ],
                                    [
                                        88.375645,
                                        22.64404
                                    ],
                                    [
                                        88.375669,
                                        22.64396
                                    ],
                                    [
                                        88.375717,
                                        22.643915
                                    ],
                                    [
                                        88.37589,
                                        22.64384
                                    ],
                                    [
                                        88.375909,
                                        22.64366
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        113,
                                        282,
                                        354
                                    ],
                                    "duration": 33.851,
                                    "turn_weight": 2,
                                    "turn_duration": 0.371,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 42.176,
                                    "geometry_index": 18,
                                    "location": [
                                        88.375909,
                                        22.64366
                                    ]
                                },
                                {
                                    "bearings": [
                                        200,
                                        289
                                    ],
                                    "entry": [
                                        true,
                                        false
                                    ],
                                    "in": 1,
                                    "turn_weight": 5,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "geometry_index": 21,
                                    "location": [
                                        88.376764,
                                        22.643384
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 113,
                                "bearing_before": 174,
                                "location": [
                                    88.375909,
                                    22.64366
                                ]
                            },
                            "name": "",
                            "duration": 44.651,
                            "distance": 123.123,
                            "driving_side": "left",
                            "weight": 60.136,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.375909,
                                        22.64366
                                    ],
                                    [
                                        88.376038,
                                        22.643608
                                    ],
                                    [
                                        88.37627,
                                        22.643537
                                    ],
                                    [
                                        88.376764,
                                        22.643384
                                    ],
                                    [
                                        88.376666,
                                        22.64313
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        20,
                                        105,
                                        200
                                    ],
                                    "entry": [
                                        false,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "turn_weight": 2,
                                    "turn_duration": 2.535,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 22,
                                    "location": [
                                        88.376666,
                                        22.64313
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 105,
                                "bearing_before": 200,
                                "location": [
                                    88.376666,
                                    22.64313
                                ]
                            },
                            "name": "",
                            "duration": 9.975,
                            "distance": 61.584,
                            "driving_side": "left",
                            "weight": 10.928,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.376666,
                                        22.64313
                                    ],
                                    [
                                        88.376889,
                                        22.643076
                                    ],
                                    [
                                        88.376931,
                                        22.643062
                                    ],
                                    [
                                        88.37695,
                                        22.643046
                                    ],
                                    [
                                        88.376955,
                                        22.643027
                                    ],
                                    [
                                        88.376952,
                                        22.642988
                                    ],
                                    [
                                        88.376908,
                                        22.642775
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        false,
                                        true,
                                        true,
                                        true
                                    ],
                                    "in": 0,
                                    "bearings": [
                                        11,
                                        97,
                                        189,
                                        279
                                    ],
                                    "duration": 14.535,
                                    "turn_weight": 6.2,
                                    "turn_duration": 2.535,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 20.6,
                                    "geometry_index": 28,
                                    "location": [
                                        88.376908,
                                        22.642775
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "bearings": [
                                        8,
                                        97,
                                        189,
                                        277
                                    ],
                                    "duration": 4.338,
                                    "turn_weight": 2,
                                    "turn_duration": 0.018,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 7.184,
                                    "geometry_index": 29,
                                    "location": [
                                        88.3771,
                                        22.642754
                                    ]
                                },
                                {
                                    "bearings": [
                                        1,
                                        99,
                                        277
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "turn_weight": 3.1,
                                    "turn_duration": 0.021,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 30,
                                    "location": [
                                        88.377451,
                                        22.642717
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "turn",
                                "instruction": "Turn left.",
                                "modifier": "left",
                                "bearing_after": 97,
                                "bearing_before": 191,
                                "location": [
                                    88.376908,
                                    22.642775
                                ]
                            },
                            "name": "",
                            "duration": 30.773,
                            "distance": 89.57,
                            "driving_side": "left",
                            "weight": 45.14,
                            "mode": "driving",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.376908,
                                        22.642775
                                    ],
                                    [
                                        88.3771,
                                        22.642754
                                    ],
                                    [
                                        88.377451,
                                        22.642717
                                    ],
                                    [
                                        88.377772,
                                        22.642669
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        176,
                                        279,
                                        357
                                    ],
                                    "entry": [
                                        false,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "turn_weight": 10.5,
                                    "turn_duration": 3.373,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 2,
                                    "geometry_index": 31,
                                    "location": [
                                        88.377772,
                                        22.642669
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "end of road",
                                "instruction": "Turn left onto Barrackpore Trunk Road/SH1.",
                                "modifier": "left",
                                "bearing_after": 357,
                                "bearing_before": 99,
                                "location": [
                                    88.377772,
                                    22.642669
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 36.603,
                            "distance": 120.224,
                            "driving_side": "left",
                            "weight": 50.377,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377772,
                                        22.642669
                                    ],
                                    [
                                        88.377725,
                                        22.643394
                                    ],
                                    [
                                        88.377701,
                                        22.643747
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "entry": [
                                        true,
                                        false,
                                        true
                                    ],
                                    "in": 1,
                                    "bearings": [
                                        103,
                                        176,
                                        358
                                    ],
                                    "duration": 8.232,
                                    "turn_weight": 7.5,
                                    "turn_duration": 6.792,
                                    "mapbox_streets_v8": {
                                        "class": "street"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 0,
                                    "weight": 9.228,
                                    "geometry_index": 33,
                                    "location": [
                                        88.377701,
                                        22.643747
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        283,
                                        358
                                    ],
                                    "duration": 41.653,
                                    "turn_weight": 59.25,
                                    "turn_duration": 3.189,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 105.406,
                                    "geometry_index": 34,
                                    "location": [
                                        88.377813,
                                        22.643724
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        101,
                                        177,
                                        357
                                    ],
                                    "duration": 18.367,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 22.032,
                                    "geometry_index": 35,
                                    "location": [
                                        88.377925,
                                        22.641906
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "bearings": [
                                        101,
                                        177,
                                        266,
                                        357
                                    ],
                                    "duration": 34.207,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 41.04,
                                    "geometry_index": 36,
                                    "location": [
                                        88.377976,
                                        22.640994
                                    ]
                                },
                                {
                                    "entry": [
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 2,
                                    "bearings": [
                                        89,
                                        177,
                                        358
                                    ],
                                    "duration": 31.807,
                                    "turn_duration": 0.007,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "weight": 38.16,
                                    "geometry_index": 38,
                                    "location": [
                                        88.378055,
                                        22.63946
                                    ]
                                },
                                {
                                    "bearings": [
                                        97,
                                        177,
                                        286,
                                        356
                                    ],
                                    "entry": [
                                        true,
                                        true,
                                        true,
                                        false
                                    ],
                                    "in": 3,
                                    "turn_weight": 1,
                                    "turn_duration": 0.019,
                                    "mapbox_streets_v8": {
                                        "class": "primary"
                                    },
                                    "is_urban": true,
                                    "admin_index": 0,
                                    "out": 1,
                                    "geometry_index": 40,
                                    "location": [
                                        88.378145,
                                        22.638036
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "continue",
                                "instruction": "Make a right U-turn to stay on Barrackpore Trunk Road/SH1.",
                                "modifier": "uturn",
                                "bearing_after": 177,
                                "bearing_before": 356,
                                "location": [
                                    88.377701,
                                    22.643747
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 137.015,
                            "distance": 659.565,
                            "driving_side": "left",
                            "weight": 220.141,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.377701,
                                        22.643747
                                    ],
                                    [
                                        88.377813,
                                        22.643724
                                    ],
                                    [
                                        88.377925,
                                        22.641906
                                    ],
                                    [
                                        88.377976,
                                        22.640994
                                    ],
                                    [
                                        88.378026,
                                        22.640225
                                    ],
                                    [
                                        88.378055,
                                        22.63946
                                    ],
                                    [
                                        88.378095,
                                        22.638713
                                    ],
                                    [
                                        88.378145,
                                        22.638036
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        },
                        {
                            "intersections": [
                                {
                                    "bearings": [
                                        357
                                    ],
                                    "entry": [
                                        true
                                    ],
                                    "in": 0,
                                    "admin_index": 0,
                                    "geometry_index": 41,
                                    "location": [
                                        88.378152,
                                        22.637914
                                    ]
                                }
                            ],
                            "maneuver": {
                                "type": "arrive",
                                "instruction": "Your destination is on the right.",
                                "modifier": "right",
                                "bearing_after": 0,
                                "bearing_before": 177,
                                "location": [
                                    88.378152,
                                    22.637914
                                ]
                            },
                            "name": "Barrackpore Trunk Road",
                            "duration": 0,
                            "distance": 0,
                            "driving_side": "left",
                            "weight": 0,
                            "mode": "driving",
                            "ref": "SH1",
                            "geometry": {
                                "coordinates": [
                                    [
                                        88.378152,
                                        22.637914
                                    ],
                                    [
                                        88.378152,
                                        22.637914
                                    ]
                                ],
                                "type": "LineString"
                            }
                        }
                    ],
                    "distance": 1555.122,
                    "summary": "Deshbandhu Road, Barrackpore Trunk Road"
                }
            ],
            "geometry": {
                "coordinates": [
                    [
                        88.373308,
                        22.64597
                    ],
                    [
                        88.37487,
                        22.645717
                    ],
                    [
                        88.374515,
                        22.644324
                    ],
                    [
                        88.375204,
                        22.644098
                    ],
                    [
                        88.375645,
                        22.64404
                    ],
                    [
                        88.375717,
                        22.643915
                    ],
                    [
                        88.37589,
                        22.64384
                    ],
                    [
                        88.375909,
                        22.64366
                    ],
                    [
                        88.376764,
                        22.643384
                    ],
                    [
                        88.376666,
                        22.64313
                    ],
                    [
                        88.37695,
                        22.643046
                    ],
                    [
                        88.376908,
                        22.642775
                    ],
                    [
                        88.377772,
                        22.642669
                    ],
                    [
                        88.377701,
                        22.643747
                    ],
                    [
                        88.377813,
                        22.643724
                    ],
                    [
                        88.378152,
                        22.637914
                    ]
                ],
                "type": "LineString"
            }
        }
    ],
    "waypoints": [
        {
            "distance": 0.324,
            "name": "Deshbandhu Road",
            "location": [
                88.373308,
                22.64597
            ]
        },
        {
            "distance": 5.369,
            "name": "Barrackpore Trunk Road",
            "location": [
                88.378152,
                22.637914
            ]
        }
    ],
    "code": "Ok",
    "uuid": "5OC5mkMAcYaOKybbhmon10sNv9ZuEBW65rcbEmrYIJBc4h3ojaZdwg=="
} 
''',
                200);
          },
        );

        // Act
        final response = await directionsService.getDirectionsAPIResponse(
            source, destination);

        // Assert
        expect(response, isA<Map<dynamic, dynamic>>());
      });
      test(
          'given DirectionsService when getDirectionsAPIResponse function is called and the API call fails then an exception should be thrown',
          () async {
        // Arrange
        when(() => mockHttpClient.get(Uri.parse(url)))
            .thenAnswer((invocation) async => Response('{}', 500));

        // Act
        final response =
            directionsService.getDirectionsAPIResponse(source, destination);

        // Assert
        expect(response, throwsException);
      });
    });
  });
}
