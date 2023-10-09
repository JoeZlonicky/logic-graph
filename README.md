# LogicGraph
A WIP Godot plugin for a visual editor for game content logic.

I'm using the "Refresh Plugin" by Pedro Braga that can be found here: https://godotengine.org/asset-library/asset/1807.

## Features
* Logic Graph editor window that utilizes Godot's GraphEdit and GraphNode nodes for visual editing
* Saving/loading graph data to/from a custom resource file
* Misc. functionality like clearing, save as, closing open graph
* Saving on editor save
* Modification detection so auto-save will only trigger when necessary and confirmation will be given beforing closing a graph if there are unsaved changes
* Right click for a context menu to add available nodes to the graph (new node types can easily be added in `node_list.gd`)

## To-do
* Undo (especially for deleting nodes)
* More helper functions to make it easier to make new node types
* Create some examples for nodes with multiple inputs
* Create a set of nodes for basic functionality like variables and control flow
