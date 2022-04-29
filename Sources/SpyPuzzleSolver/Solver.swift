import AStar
import SpyPuzzleGameState

enum GameStateGraphError : Error {
  case noMarkToKill
  case noMarkToKillOrExitToReach
  case notApplicable(objective: Objective)
}

struct GameStateGraph : Graph {
  var goal: SearchNode
  var initialGameState: GameState
  var exitObjective: Objective
  var statusObjectives: [Objective]
  
  init(state: GameState,
       exitObjective: Objective,
       statusObjectives: [Objective]) throws {
    self.initialGameState = state
    self.exitObjective = exitObjective
    self.statusObjectives = statusObjectives
    
    if exitObjective.judge(initial: state, current: state, turns: 0) == .notApplicable {
      throw GameStateGraphError.notApplicable(objective: exitObjective)
    }
    for objective in statusObjectives {
      if objective.judge(initial: state, current: state, turns: 0) == .notApplicable {
        throw GameStateGraphError.notApplicable(objective: objective)
      }
    }
    
    self.goal = SearchNode(state:state, turns: 0, action: nil, isGoal:true)
  }
    
  func goalDecided(node: SearchNode) -> Decision {
    let state = node.state
    let turns = node.turns
    let exitObjectiveDecision =
      exitObjective.judge(initial: initialGameState,
                          current:state,
                          turns: turns)
    let statusObjectivesDecision =
        statusObjectives.reduce(.notApplicable) {
          $0 & $1.judge(initial: initialGameState,
                        current:state,
                        turns: turns)
        }
    let combinedDecision = exitObjectiveDecision & statusObjectivesDecision
    return combinedDecision
  }

  func nodesAdjacent(to node: SearchNode) -> Set<SearchNode> {
    // print(node.state.hitman.position.cleanDescription)
    switch goalDecided(node: node) {
    case .success:
        return [goal]
    case .failure,.notApplicable:
      return []
    case .currentlyFailing,.currentlySucceeding:
      // Continue search
      break
    }
    
    let edges = actions(state:node.state)
    
    return Set(edges.map { action in
      var newState = node.state
      perform(action: action, on: &newState)
      return SearchNode(state: newState, turns:node.turns + action.turns, action:action)
    })
  }
  
  // Should underestimate the cost to the goal.
  func estimatedCost(from start: SearchNode, to end: SearchNode) -> Float {
    return exitObjective.estimatedCost(
      initial:initialGameState,
      current:start.state,
      turns:start.turns
    )
    + statusObjectives.reduce(0) {
      $0 + $1.estimatedCost(
        initial:initialGameState,
        current:start.state,
        turns:start.turns
      )
    }
  }
  
  func cost(from start: SearchNode, to end: SearchNode) -> Float {
    // Assumes the start and end nodes are adjacent
    return 1.0
  }
  
}

public func solve(state: GameState, exitObjective:Objective, statusObjectives: [Objective]) throws -> [Action]? {
  // A*
  let start = SearchNode(state:state, turns: 0, action: nil)
  
  let graph = try GameStateGraph(state:state, exitObjective: exitObjective, statusObjectives:statusObjectives)
  
  switch graph.goalDecided(node: start) {
  case .success:
    return []
  case .failure:
    return nil
  default:
    break
  }
  
  let goal = graph.goal
  
  let path = graph.findPath(from: start, to: goal)
  return path.compactMap(\.action)
}
