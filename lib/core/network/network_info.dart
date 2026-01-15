/// Network connectivity info abstract interface
abstract class INetworkInfo {
  Future<bool> get isConnected;
}
