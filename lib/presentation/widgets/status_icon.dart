import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  
  final IconData icon;
  final Color backgroundColor;
  
  const StatusIcon({
    required this.icon,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }
}
