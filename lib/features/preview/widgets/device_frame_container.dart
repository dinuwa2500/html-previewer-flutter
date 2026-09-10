import 'package:flutter/material.dart';

class DeviceFrameContainer extends StatelessWidget {
  final String deviceMode; // 'mobile', 'tablet', 'desktop'
  final Widget child;

  const DeviceFrameContainer({
    super.key,
    required this.deviceMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (deviceMode == 'desktop') {
      return Container(
        color: Colors.white,
        child: child,
      );
    }

    final isMobile = deviceMode == 'mobile';
    final targetWidth = isMobile ? 375.0 : 768.0;

    return Container(
      color: const Color(0xFF0F141C),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Center(
            child: Container(
              width: targetWidth,
              height: isMobile ? 667.0 : 900.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isMobile ? 32.0 : 20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF334155),
                  width: isMobile ? 8.0 : 10.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isMobile ? 24.0 : 12.0),
                child: Column(
                  children: [
                    // Device Notch / Header simulator
                    if (isMobile)
                      Container(
                        height: 24,
                        color: const Color(0xFF1E293B),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF475569),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
