import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

/*const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);*/

class MapPage extends StatefulWidget {
  final dynamic place;
  final bool isRoute;
  MapPage({Key? key, required this.place, this.isRoute = false})
      : super(key: key) {
    XController.to.createBitmapMap();
  }
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  double _originLatitude = XController.to.getOriginLat()!,
      _originLongitude = XController.to.getOriginLon()!;

  //1.3089153, _originLongitude = 103.7601042;
  double _destLatitude = 1.3109104, _destLongitude = 103.7600613;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = mapGoogleAPIKey;

  final XController x = XController.to;

  @override
  void initState() {
    super.initState();

    var splitLatLon = widget.place['latitude'].split(",");
    _destLatitude = double.parse(splitLatLon[0]);
    _destLongitude = double.parse(splitLatLon[1]);

    if (!widget.isRoute) {
      _originLatitude = _destLatitude;
      _originLongitude = _destLongitude;
    }

    /// origin marker BitmapDescriptor.defaultMarker
    _addMarker(
        LatLng(_originLatitude, _originLongitude), "origin", x.iconMap.value);

    if (widget.isRoute) {
      /// destination marker BitmapDescriptor.defaultMarkerWithHue(90)
      _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
          BitmapDescriptor.defaultMarkerWithHue(90));
      _getPolyline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_originLatitude, _originLongitude),
                  zoom: widget.isRoute ? 12 : 17,
                ),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InputContainer(
                    backgroundColor: Get.theme.backgroundColor,
                    radius: 35,
                    boxShadow: BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(1, 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              alignment: Alignment.center,
                              child: Row(
                                children: const [
                                  Icon(BootstrapIcons.chevron_left, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(
            title: "${widget.place['title']}",
            snippet: "${widget.place['description']}"));
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      //travelMode: TravelMode.driving,
      //wayPoints: [PolylineWayPoint(location: "Coast Walk Singapore")],
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint("error message ${result.errorMessage}");
    }
    _addPolyLine();
  }
}
