
Introduction
==============================

Preface
*******

Surrogate-Based Auto Tuning (SAT) package is a collection of MATLAB code used for stochastically optimization based on the Kriging modeling method. **demo_kriging.m** and **demo_cokriging.m**  can be referred to for an intuitive look in the function of this package.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser Public License for more details.

You should have received a copy of the GNU General Public License and GNU Lesser Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

SAT Framework
******************************
SAT brief framework::

    Initialization;
    while stopping criteria is not satisfied:

        Modeling;
        Infilling;

    endwhile

Stochastical Modeling Method
******************************

Target to different objective problems, SAT provided several types of Kriging as following:

- Kriging
- Co-Kriging
- Derivative-enhanced Kriging (coming soon)

