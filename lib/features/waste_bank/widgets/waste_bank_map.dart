import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasteBankMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const WasteBankMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 200.h,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.wanigo.nasabah',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 60.w,
                  height: 60.h,
                  child: SvgPicture.asset(
                    'assets/icons/map_marker_icon.svg',
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
