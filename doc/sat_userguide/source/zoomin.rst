"Zoom in" Strategy
******************
Brief Idea
==========

To find the optimal solution, shrink the search region might accelerate optimization procedure.

Shrink Search Region and Create New Window
==========================================
This function determines a new smaller window and locates the position of edge. The optimal sample in the data set is chosen as the center of the new data. Requires the training set **samples** and **values**, a 1 by 2*numDim vector info of old window **window_old**, a 1 by **numDim** vector specifying the ratios in every dimension **shrink_ratio**, and to set **opt_prob** to be either **max** or **min**. The output is a 1 by 2*numDim vector of the info of the new window::

    window_new = zoom_shrink_Window(samples, values, window_old, shrink_ratio, opt_prob)

Drop Off Samples Not Belong to New Window
=====================================

This function drops off the samples which are outside the window. Requires a 1 by 2*numDim vector info of window region **window**, an N by **numDim** matrix of sample (feature data) **samples**, and an N by 1 vector corresponding to **samples** response **values**. The output **samples_new** is an N by **numDim** matrix with updated samples and values_new is an N by 1 vector of the updated responses::

    [samples, values] = zoom_shrink_dropoutside(window, samples, values);

Disadvantage
============
On the other hand, this strategy might converge to local optimum

