
import numpy as np
from grid_world import standard_grid, negative_grid
import time

SMALL_ENOUGH = 1e-3
GAMMA = 0.9
ALL_POSSIBLE_ACTIONS = ('U', 'D', 'L', 'R')

def print_values(V, g):
  time.sleep(1)
  for j in reversed(range(g.height)):

    print ("'---------------------------------------")
   
    for i in range(g.width):
      v = V.get((i,j), 0)
      if v >= 0:
          print( "| ",'{:06.2f}'.format(v), end=" ")  

      else:
         print( "| ",'{:06.2f}'.format(v), end=" ") 

    print( "| ")
  print ("'---------------------------------------")
  print ("")
  print ("")



def print_policy(P, g):
  time.sleep(2)
  for j in reversed(range(g.height)):
    print ("-----------------------------")
    for i in range(g.width):
      a = P.get((i,j), ' ')
      print( "| ",'{:3s}'.format(a),end=" ") 
    print( "| ")
  print ("-----------------------------")
  print ("")
  print ("")



if __name__ == '__main__':
  grid = standard_grid()
  print ("rewards:")
  print_values(grid.rewards, grid)
  policy = {}
  for s in grid.actions.keys():
    policy[s] = np.random.choice(ALL_POSSIBLE_ACTIONS)

  print ("initial policy:")
  print_policy(policy, grid)
  V = {}
  states = grid.all_states()
  for s in states:
    if s in grid.actions:
      V[s] = np.random.random()
    else:
      V[s] = 0

  count2 = 0
  count1 = 0
  while True :
    is_policy_converged = True
    count2  += 1

    for s in states:
      if s in policy:
        old_a = policy[s]
        new_a = None
        best_value = float('-inf')
        for a in ALL_POSSIBLE_ACTIONS:
          grid.set_state(s)
          r = grid.move(a)
          v = r + GAMMA * V[grid.current_state()]
          if v > best_value:
            best_value = v
            new_a = a
        policy[s] = new_a
        if new_a != old_a:
          is_policy_converged = False
    print_policy(policy, grid)
    if is_policy_converged:
        break


    while True:
        biggest_change = 0
        for s in states:
            old_v = V[s]
            if s in policy:
                  a = policy[s]
                  grid.set_state(s)
                  r = grid.move(a)
                  V[s] = r + GAMMA * V[grid.current_state()]
                  biggest_change = max(biggest_change, np.abs(old_v - V[s]))

        print_values(V, grid)

        if biggest_change < SMALL_ENOUGH:
              break

  print ("values:")
  print_values(V, grid)
  print ("policy:")
  print_policy(policy, grid)
