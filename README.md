# [Idea]
	This layout idea could be widely applied to many areas like:
	Facebook picture preview layouts, interior design tools, website layouts, image/video editing app or some puzzle games.
	Based on the idea, I implemented some configurable settings to the app, and suggests some suggestions in the future.

# [Extra Features] 
	Implemented some configurable settings in the setting view:
	- Widget theme: by changing this setting, all widget appearance would change on the fly.
	- Widget ratio: widget ratio for the newly added widget and the affected widget on the canvas.
	- Widget information display: by turning this setting on, each widget will show the percentage it occupies.

# [Idea to determine the layout when a new widget is dropped]
	- Firstly I keep all dropped widget in an array, from this array, check which widget on the canvas the dragging position falls in, for instance it falls in widget_x. 
	- Then divide the widget_x into 4 zones diagonally, and check which zone the position falls in. The shrinked size dependents on the ratio setting. For default the new widget will have half size of widget_x and thus widget_x will shrink to half size.	
 	- If it falls in the top zone, I shrink widget_x and move it down, place the new widget on top.
	- If it falls in the left zone, I shrink widget_x and move it right, place the new widget on left, and so on.
 	- The transformed widget_x is stored in another widget preview array for UI display when user is still dragging.
	- And the widget array will be updated with preview array when user finally drops it in the canvas or the preview array will be discard if he drops outside of the canvas. After the drop, we will use the widget array for UI display.
 

# [UI improvement in the future]
	- Generate a ghost size of the dragging widget when it is in the canvas.
	- Add animations between size change to display it more smoothly.

# [Feature Extension in the future]
	1. Show the occupation rate data in a bar chart in the same time with sorted sequence.
	   > A bar chart allows user to know the rankings and changes easily. This feature would be useful in some application like games.
	2. Allow user to attach text or image to the widget to make the app more meaningful and customizable.
	3. Redo & Undo feature for easy modifications.

# [Screenshots]

<img width="354" alt="截圖 2024-09-07 18 57 50" src="https://github.com/user-attachments/assets/d6b1a2ce-824a-40a1-8b32-8a2851f4aef0">
<img width="356" alt="截圖 2024-09-07 18 57 41" src="https://github.com/user-attachments/assets/d15f319c-bdd6-47dc-9a0c-394e52ae6041">

After changing the settings:

<img width="351" alt="截圖 2024-09-07 18 58 03" src="https://github.com/user-attachments/assets/0281af53-c4b0-475b-a15f-f3f0e3d494bc">
<img width="353" alt="截圖 2024-09-07 18 58 12" src="https://github.com/user-attachments/assets/eb74ad81-5095-45c6-a922-f8d978813cf8">





￼￼
