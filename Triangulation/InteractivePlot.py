import matplotlib.pyplot as plt
from matplotlib.backend_bases import MouseButton


def runCanvas(xsize=1000, ysize=1000):
    
    def on_click(event):
        if event.button is MouseButton.LEFT:
            points.append((event.xdata, event.ydata))
            plt.plot(event.xdata, event.ydata, marker='.', markersize=3)
            fig.canvas.draw()
        #end
    #end def

    points = []

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_xlim([0, xsize])
    ax.set_ylim([0, ysize])
    ax.set_box_aspect(1.0)

    cid = fig.canvas.mpl_connect('button_press_event', on_click)

    plt.show()

    return points

#end def

#print(runCanvas(500, 500))