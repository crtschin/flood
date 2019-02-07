/// A single node in the directed graph
class GraphNode<T> {
  T value;
  List<GraphNode> prev;
  List<GraphNode> next;
  GraphNode(
      T this.value, List<GraphNode> this.next, List<GraphNode> this.prev) {}

  GraphNode.empty(T this.value) {
    this.next = [];
    this.prev = [];
  }
}

class DependancyGraph<T> {
  Map<T, GraphNode<T>> nodes = Map();

  void addRelationship(T from, T to) {
    if (!nodes.containsKey(from)) {
      nodes[from] = GraphNode.empty(from);
    }
    if (!nodes.containsKey(to)) {
      nodes[to] = GraphNode.empty(to);
    }

    nodes[from].next.add(nodes[to]);
    nodes[to].prev.add(nodes[from]);
  }

  /// Using Kahns algorithms, find the topological sort of the graph
  Iterable<GraphNode<T>> findOrder() {
    List<GraphNode<T>> results = [];
    Set<GraphNode<T>> current = Set.from(roots());
    while (current.isNotEmpty) {
      var currentNode = current.first;
      current.remove(currentNode);
      results.add(currentNode);

      for (var next in currentNode.next) {
        next.prev.remove(currentNode);
        if (next.prev.isEmpty) current.add(next);
      }
    }
    if (results.length != nodes.length) {
      throw Exception("Dependancy graph contains cycles");
    } else {
      return results;
    }
  }

  /// Get the nodes in the graph containing no predecessers
  Iterable<GraphNode<T>> roots() {
    Map<T, GraphNode<T>> nodesCopy = Map.from(nodes);
    for (var entry in nodes.entries) {
      for (var next in entry.value.next) {
        nodesCopy.remove(next.value);
      }
    }
    return nodesCopy.values;
  }
}
