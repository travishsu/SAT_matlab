Modeling
***********************

Kriging
=======================
Given **N** data with dimension **numDim**, create a handle of the Kriging model. In this function **samples** is a **n** by **numDim** matrix of sample(feature data) and **values** is an **n** by 1 vector that corresponds with **samples**. Outputs **model** structure::

    Kmodel = Kriging_info(samples, values);

The Kriging kernel function output **Kmodel**, that is the handle of current model.

Based on the info generated in the function Kriging_info, this function predicts the value y and mean square error mse at the points contained in x::

    [y,mse] = Kriging_pred(x,Kmodel)

In demo script, we predict all points in observation list::

    for i = 1:gridLen
        [P(i), MSE(i)] = Kriging_pred(G(i, :), Kmodel);
        EI(i) = eiMaximum(P(i), values, MSE(i));
        % EI(i) = eiMinimum(P(i), values, MSE(i));
    end

Co-Kriging
=======================
Suppose there are two sets of data:

- High fidelity data: **samples_high** and **values_high**.
- Low fidelity data : **sample_low** and **values_low**.

Given the inputs matrix **samples_high**, **samples_low**, **values_high** and **values_low**, declares the global variables ModelInfo.Xe, ModelInfo.Xc, ModelInfo.ye, and ModelInfo.yc respectively. This function generates and stores the information about the corresponding co-kriging model as a global variable and outputs it::

    CKmodel = coKriging_info(samples_high, samples_low, values_high, values_low);

Given the input scalar x and the input structure CKmodel, this function will construct a function f_hat to model the given data from the four matrices inside the Info structure. It will output this function as well as a generated error mse using the mean square error::

    [f_hat,mse] = coKriging_pred(x, CKmodel)

Prediction all points::

    for i = 1:gridLen
        [P(i), MSE(i)] = coKriging_pred(G(i, :), CKmodel);
        EI(i) = eiMaximum(P(i), values, MSE(i));
        % EI(i) = eiMinimum(P(i), values, MSE(i));
    end

Uncertainty Measurement
***********************
Mean Square Error (MSE)
=======================
Kriging has some useful stochastical properties, it has been  developed to have ability to  measure the uncertainty of surrogate,

Expected Improvement (EI)
=========================
Target to

- Maximization Problem, use **eiMaximum**.
- Minimization Problem, use **eiMinimum**.

