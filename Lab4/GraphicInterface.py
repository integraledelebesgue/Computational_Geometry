import matplotlib.pyplot as plt
from matplotlib.backend_bases import MouseButton


def runCanvas(xsize=1000, ysize=1000):
    
    def on_click(event):
        nonlocal in_segment, last

        if event.button is MouseButton.LEFT:
            #points.append((event.xdata, event.ydata))
            
            if in_segment:
                new_point = (event.xdata, event.ydata)
                
                plt.plot(*new_point, marker='o', markersize=3)
                plt.plot([last[0], new_point[0]], [last[1], new_point[1]], )
                
                in_segment = False
                segments.append((last, new_point))
                last = new_point

            else:
                last = (event.xdata, event.ydata)
                in_segment = True

                plt.plot(*last, marker='o', markersize=3)

            fig.canvas.draw()
        #end
    #end def

    segments = []
    in_segment = False
    last = None

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_xlim([0, xsize])
    ax.set_ylim([0, ysize])
    ax.set_box_aspect(1.0)

    cid = fig.canvas.mpl_connect('button_press_event', on_click)

    plt.show()

    print(segments)

    return segments

#end def

#print(runCanvas(500, 500))