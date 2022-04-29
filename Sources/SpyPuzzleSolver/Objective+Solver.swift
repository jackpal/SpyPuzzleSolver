import SpyPuzzleGameState

extension Objective {
  /// Returns the underestimated cost in actions from the current state to the goal.
  /// Return 0 if the goal has been reached.
  func estimatedCost(initial: GameState,
                     current: GameState,
                     turns: Int)->Float {

    // TODO: Include subways in pathing.
    func estimatedSteps(to goal: (NodeMap) ->Point?)-> Float {
      guard let goalPosition = goal(current.map) else {
        return 0
      }
      return Float(stepsTo(s: current,
              from: current.hitman.position,
              goal: {$0 == goalPosition }) ?? 0)
    }
    
    switch self {
    case .collectBriefcase:
      if current.hitman.hasBriefcase {
        return 0
      }
      return estimatedSteps(to:findBriefcase)
      
    case .dontKillDogs:
      // TODO: Return a big penalty distance for failure.
      return 0
      
    case .killYourMark:
      return estimatedSteps(to:findYourMark)
      
    case .killAllEnemies:
      return Float(countEnemies(map: current.map))
      
    case .levelComplete:
      return estimatedSteps(to:findExit)
    case .levelCompleteWithin:
      // TODO: can we use turnsLimit somehow?
      return estimatedSteps(to:findExit)
    case .noKill:
      return 0
    case .speedKill:
      return Float(current.hitman.speedKill ? 0 : 1)
    }
  }
}
