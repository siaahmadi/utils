Here, I was unaware of the possibility that a listener could be added for the 'ContinuousValueChange' event
of the sliders and everything could be updated that way. Rather, I took an awry path of piping events to the
Figure and then having the spikepatch and linkedslider classes update the figure appropriately. This has its
own problems, obviously, and is thus declared deprecated.