class TreeNode:
  def __init__(self, value):
    self.value = value # Data
    self.children = [] # References to other nodes

from collections import deque


def bfs(root_node, goal_value):

  path_queue = deque()

  initial_path = [root_node]
  path_queue.appendleft(initial_path)
  
  while path_queue:
    current_path = path_queue.pop()
    current_node = current_path[-1]

    if current_node.value == goal_value:
      return current_path

    # Add code here:
    #create a variable and set it to a shallow copy of the current path

    for child in current_node.children:
        #create a shallow copy of the current path
        path_copy = current_path[:]
        #append the child to the copy   


class BinarySearchTree:
  def __init__(self, value, depth=1):
    self.value = value
    self.depth = depth
    self.left = None
    self.right = None

  def insert(self, val):
    if (val < self.value):
      if (self.left is None):
        self.left = BinarySearchTree(val, self.depth + 1)
      else:
        self.left.insert(val)
    # Write your code here:
    #check if the value is greater than or equal to the current node's value
    elif val >= self.value:
        #check if the current node's right child is None
        if self.right is None:
            #create a new binary search tree and set the current node's right child to it
            self.right = BinarySearchTree(val, self.depth + 1)
        else:
            #call the insert method on the right child
            self.right.insert(val)

class MaxHeap:
  def __init__(self):
    self.heap_list = [None]
    self.count = 0

  def heapsort(input_list):
    sort_list = []
    max_heap = MaxHeap()
    for index in input_list:
      max_heap.add(index)
    # Add your code here:
    while max_heap.count > 0:
      sort_list.append(max_heap.retrieve_max())

    return sort_list

  def retrieve_max(self):
    if self.count == 0:
      return None
    max = self.heap_list[1]
    self.heap_list[1] = self.heap_list[self.count]
    self.count -= 1
    self.heap_list.pop()
    self.heapify_down()
    return max

  def add(self, element):
    self.count += 1
    self.heap_list.append(element)
    self.heapify_up()
    
  def heapify_up(self):
    idx = self.count
    while self.parent_idx(idx) > 0:
      if self.heap_list[self.parent_idx(idx)] < self.heap_list[idx]:
        tmp = self.heap_list[self.parent_idx(idx)]
        self.heap_list[self.parent_idx(idx)] = self.heap_list[idx]
        self.heap_list[idx] = tmp
      idx = self.parent_idx(idx)

  def heapify_down(self):
    idx = 1
    while self.child_present(idx):
      larger_child_idx = self.get_larger_child_idx(idx)
      if self.heap_list[idx] < self.heap_list[larger_child_idx]:
        tmp = self.heap_list[larger_child_idx]
        self.heap_list[larger_child_idx] = self.heap_list[idx]
        self.heap_list[idx] = tmp
      idx = larger_child_idx

  def get_larger_child_idx(self, idx):
    if self.right_child_idx(idx) > self.count:
      return self.left_child_idx(idx)
    else:
      left_child = self.heap_list[self.left_child_idx(idx)]
      right_child = self.heap_list[self.right_child_idx(idx)]
      if left_child > right_child:
        return self.left_child_idx(idx)
      else:
        return self.right_child_idx(idx)

  def parent_idx(self, idx):
    return idx // 2

  def left_child_idx(self, idx):
    return idx * 2

  def right_child_idx(self, idx):
    return idx * 2 + 1

  def child_present(self, idx):
    return self.left_child_idx(idx) <= self.count
  
def dfs(graph, current_vertex, target_val, visited_vertices=None):
  if visited_vertices is None:
    visited_vertices = []
  visited_vertices.append(current_vertex)
  if current_vertex == target_val:
    return visited_vertices
  
  for neighbor in graph[current_vertex]:
  # Add your code here:
    if neighbor not in visited_vertices:
        path = dfs(graph, neighbor, target_val, visited_vertices)
        if path:
            return path
        

      
# Leave this for testing:
the_most_dangerous_graph = {
    'lava': set(['sharks', 'piranhas']),
    'sharks': set(['lava', 'bees', 'lasers']),
    'piranhas': set(['lava', 'crocodiles']),
    'bees': set(['sharks']),
    'lasers': set(['sharks', 'crocodiles']),
    'crocodiles': set(['piranhas', 'lasers'])
  }

def bfs(graph, start_vert, target_val):
  path = [start_vert]
  vertex_and_path = [start_vert, path]
  bfs_queue = [vertex_and_path]
  visited = set()
  
  while bfs_queue:
    current_vertex, path = bfs_queue.pop(0)
    visited.add(current_vertex)
    
    for neighbor in graph[current_vertex]:
      if neighbor not in visited:
      # Add your code here:
        if neighbor == target_val:
            return path + [neighbor]
        else:
            bfs_queue.append([neighbor, path + [neighbor]])
            

 

# Leave this for testing:
the_most_dangerous_graph = {
    'lava': set(['sharks', 'piranhas']),
    'sharks': set(['lava', 'bees', 'lasers']),
    'piranhas': set(['lava', 'crocodiles']),
    'bees': set(['sharks']),
    'lasers': set(['sharks', 'crocodiles']),