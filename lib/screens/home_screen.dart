import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locatly/service/distance_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    requestLocationPermission().then((value) => getUserPosition());

  }
  String bearer = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE2MTAzODgzLCJpYXQiOjE3MTU4ODc4ODMsImp0aSI6IjVkYTg2MmUyM2I4ZTQ0MTU4NTFlODU3OGM5YmE3NGUwIiwidXNlcl9pZCI6M30.PXlh6fUu0yE8MEmQ1lECnHThTnPnlGTyMol0pRD2yro';
  Point userPoint = const Point(latitude: 41.311081, longitude: 69.240562);
  late YandexMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        YandexMap(
          onMapCreated: (YandexMapController controller) {
            _controller = controller;
            controller.toggleUserLayer(visible: true);
            controller.moveCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: userPoint)),
                animation: const MapAnimation());
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                getUserPosition();
              },
              child: const Text('Get distance'),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.location);
    }
  }

  Future<void> getUserPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      userPoint =
          Point(latitude: position.latitude, longitude: position.longitude);
      _controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: userPoint)),
          animation: const MapAnimation());
    });
    double distance = await DistanceService().getDistance(userPoint.latitude, userPoint.longitude, bearer);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(distance.toString() + ' km')));
  }
}
