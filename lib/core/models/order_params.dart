import 'package:equatable/equatable.dart';

class OrderParams extends Equatable {
  final String status;
  final DateTime dateTime;

  OrderParams({required this.status, required this.dateTime});

  @override
  List<Object?> get props => [status,dateTime];
}