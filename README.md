# A robust fuzzy least squares twin support vector machine for class imbalance learning (RFLSTSVM-CIL)
This is implementation of the paper: B. Richhariya, M. Tanveer, A robust fuzzy least squares twin support vector machine for class imbalance learning, Applied Soft Computing, Volume 71, 2020, pp. 418-432, https://doi.org/10.1016/j.asoc.2018.07.003.

Description of files:

main.m: selecting parameters of RFLSTSVM-CIL using k fold cross-validation. One can select parameters c, c0, mu and ir to be used in grid-search method.

rflstsvm.m: implementation of RFLSTSVM-CIL algorithm. Takes parameters c, c0, mu and ir, and training data and test data, and provides accuracy obtained and running time.

fuzz.m: implements the proposed fuzzy membership function.

For quickly reproducing the results of the RFLSTSVM-CIL algorithm, we have made a newd folder containing a sample dataset. One can simply run the main.m file to check the obtained results on this sample dataset. To run experiments on more datasets, simply add datasets in the newd folder and run main.m file. The code has been tested on Windows 10 with MATLAB R2017a.

This code is for non-commercial and academic use only.
Please cite the following paper if you are using this code.

Reference: B. Richhariya, M. Tanveer, A robust fuzzy least squares twin support vector machine for class imbalance learning, Applied Soft Computing, Volume 71, 2020, pp. 418-432, https://doi.org/10.1016/j.asoc.2018.07.003.

For further details regarding working of algorithm, please refer to the paper.

If further information is required you may contact on: phd1701241001@iiti.ac.in.
