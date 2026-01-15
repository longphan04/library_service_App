import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_info.dart';

/// Implementation of [INetworkInfo]
class NetworkInfoImpl implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    // If result is 'none', then no connection
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      // Connected via wifi, mobile, ethernet, etc.
      return true;
    }
  }
}
