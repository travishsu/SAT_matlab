Initialization
**********************

Problem Definition
======================

Constant Variables
----------------------

- **numDim**
- **maxIteration**
- **maxTime**

Function Evaluation
----------------------

In optimization procedure, it always asks to evaluate function value at a series of points repeatly, in this User Guide we assume objective function called **YourFunc**, this function outputs a real value::

    value = YourFunc(sample);

Search Region
----------------------

Our model can predict everywhere in space same as samples, but to predict the value at some point far far away from training data is meaningfulless, since training set has tiny even no influence to that points.

You are required to set a rectangular region **window** where we select sample at every iteration::


    window = [x_lb, x_ub, y_lb, y_ub]

    % x_lb: lower bound in x_axis
    % x_ub: upper bound in x_axis
    % y_lb: lower bound in y_axis
    % y_ub: upper bound in y_axis

Here we assume **numDim** is 2, then we define **window** as a rectangular region, **window** will be a 1-by-2\*2 (1-by-2*numDim) vector.

Observation Grid
======================

Given a vector of alternating corresponding lower and upper bounds along with a vector of the corresponding **gridsize**, construct multiple return values for reshaping the structure. It returns a integer number length of the number of observation points in the grid, a length by k matrix called grid containing every observation point in every row, a length by 1 vector matrix called **P** for containing the prediction value corresponding to ever observation point, a length by 1 vector called **MSE** for containing the mean square error corresponding to every observation point, and a length by 1 vector called **EI** for containing the expected improvement corresponding to every observation point. The output vectors, **P**, **MSE**, and **EI** do not contain actual values from this function::


    [gridLen, G, P, MSE, EI] = grid_cut(window, gridsize);

- Input
    - **window**  :  [lb1, ub1, lb2, ub2, ..., lbk, ubk]
    - **gridsize**:  [ g1,  g2, ...,  gk]
- Output
    - **gridLen** :  Integer number, number of observation points in grid
    - **G**       :  gridLen-by-k matrix, list every observation point in every single row
    - **P**       :  gridLen-by-1 vector, list for fill with prediction value corresponding to every observation point
    - **MSE**     :  gridLen-by-1 vector, list for fill with mean square error corresponding to every observation point
    - **EI**      : gridLen-by-1 vector, list for fill with expected improvement corresponding to every observation point

Variable **gridsize** means how dense observation set to list, it is a 1-by-numDim vector, each component represent how many grid to cut in each axis.


Latin Hypercube Design
======================

For **numDim**-dimensional region bounded in **window**, generate a Latin-Hypercube Design. Requires an integer representing the number of designs **numInitial**, an integer representing the dimension of designs **numDim** and a 1 by 2*numDim vector representing the region’s edges in each dimension window. Will output a **numInitial** by **numDim** matrix over a region in **window** Initial::

    samples = LHD(numInitial, numDim, window);

Training Set Initialization
===========================

Constructing Kriging model needs a set of training data.

Kriging
----------------------
Put objective data in values::

    values = zeros(size(samples, 1), 1);
    for idx = 1:size(samples, 1)
        values(idx) = YourFunc(samples(idx,:));
    end

Co-Kriging
----------------------

In Co-Kriging modeling method, it's supposed that there are available to use two fidelities of evaluation function, they are supposed to solve the same problem but have different levels of approximation.

One of them has more accurate, Co-Kriging will construct surrogate for high-fidelity objective.

