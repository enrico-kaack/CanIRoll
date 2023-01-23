class Peer {
  int id;
  String hostname;
  int port;

  get url => "$hostname:$port";

  Peer(this.id, this.hostname, this.port);

  Peer.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        hostname = json["host"],
        port = json["port"];

  Map<String, dynamic> toJson() => {"id": id, "host": hostname, "port": port};

  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Peer && other.id == id && other.port == port;
  }

  @override
  int get hashCode => Object.hash(id, port);

  @override
  String toString() {
    return url;
  }
}
