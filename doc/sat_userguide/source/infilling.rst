Infilling
*********
New Sampling
============

If your object problem is a optimization::

    [~, new_idx] = max(EI);

If your goal is to make model more fitting::

    [~, new_idx] = max(MSE);



Evaluate and Append
===================

A stupid method::

    new_sample = G(new_idx, :);
    new_value = YourFunc(new_sample);


    samples(end+1, :) = new_sample;
    values(end+1, :) = new_value;

