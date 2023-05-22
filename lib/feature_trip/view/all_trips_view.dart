import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AllTripsView extends StatefulWidget {
  const AllTripsView({super.key});

  @override
  State<AllTripsView> createState() => _AllTripsViewState();
}

class _AllTripsViewState extends State<AllTripsView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("All trips"));
  }
}
