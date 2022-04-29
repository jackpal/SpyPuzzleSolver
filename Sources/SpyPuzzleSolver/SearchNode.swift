import SpyPuzzleGameState

struct SearchNode : Hashable {
  let state: GameState
  /// How many turns to get to this search node.
  /// Note that this only counts "move" and "subway" actions.
  let turns: Int
  /// The action that got us into this node. Nil for start.
  let action: Action?
  /// Whether this is the goal node or not.
  let isGoal: Bool

  init(state: GameState, turns: Int, action: Action?, isGoal: Bool = false) {
    self.state = state
    self.turns = turns
    self.action = action
    self.isGoal = isGoal
  }
  
  static func == (lhs: SearchNode, rhs: SearchNode) -> Bool {
    if lhs.isGoal || rhs.isGoal {
      // For the goal we only compare the goal state
      return lhs.isGoal == rhs.isGoal
    }
    // For non-goals we only consider the GameState
    return lhs.state == rhs.state
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(isGoal)
    if isGoal {
      return
    }
    hasher.combine(state)
  }
  
}
