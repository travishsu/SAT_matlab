Data Arrangement
======================
In SAT package, 
we require user to give data a specified form which is readable by SAT machine.

Training Set
**********************
We require each sample and its corresponding value are row-wisely permuted::

    samples = [sample1; sample2; sample3];
    values  = [value1 ; value2 ; value3 ];

Commonly Used Variables
***********************
Variable's names in **demo_kriging.m** and **demo_cokriging.m** are easy to understand what it means.

+---------------+----------------------------------------+
| Variable name |            Description                 |
+===============+========================================+
| numDim        | Dimension number of objective function |
+---------------+----------------------------------------+
| numInitial    |       Number of initial samples        |
+---------------+----------------------------------------+
| samples       |   Coordinates of current training set  |
+---------------+----------------------------------------+
| values        |     Values of current training set     |
+---------------+----------------------------------------+

