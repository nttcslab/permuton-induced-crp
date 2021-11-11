# Permuton-induced Chinese Restaurant Process

![animationMCMCepinions](https://user-images.githubusercontent.com/73105349/141063466-1f5e097c-7397-4376-848e-c789cd012989.gif)

Note: Currently only the Matlab version is available, but a **Python version will be available soon**!

This is a demo code for Bayesian nonparametric relational data analysis based on **Permuton-induced Chinese Restaurant Process** ([NeurIPS, 2021](https://nips.cc/)). The key features are listed as follows:

- **Clustering based on rectangular partitioning**: For an input matrix, the algorithm probabilistically searches for the row and column order and rectangular partitioning so that similar elements are clustered in each block as much as possible.
- **Infinite model complexity**: There is no need to fix the suitable number of rectangle clusters in advance, which is a fundamental principle of Bayesian nonparametric machine learning. 
- **Arbitrary rectangular partitioning**: It can potentially obtain a posterior distribution on arbitrary rectangular partitioning with any numbers of rectangle blocks.  
- **Empirically faster mixing of Markov chain Monte Carlo (MCMC) iterations**: The method most closely related to this algorithm is [the Baxter Permutation Process (NeurIPS, 2020)](https://github.com/nttcslab/baxter-permutation-process). Typically, this algorithm seems to be able to mix MCMC faster than the Baxter permutation process empirically.

You will need a basic MATLAB installation with Statistics and Machine Learning Toolbox. 

## In a nutshell

1. `cd permuton-induced-crp`
2. `run` 

Then, the MCMC evolution will appear like the gif animation at the top of this page. The following two items are particularly noteworthy. 
- Top center: Probabilistic rectangular partitioning of a sample matrix (`irmdata\sampledata.mat` ).
- Bottom right: Posterior probability.

## Interpretation of analysis results

![model](https://user-images.githubusercontent.com/73105349/141225676-69df9631-1240-480d-a35e-3467bb165a6e.png)

The details of the visualization that will be drawn while running the MCMC iterations require additional explanation of our model. Please refer to the paper for more details. Our model, an extension of the **Chinese Restaurant Process (CRP)**, consists of a generative probabilistic model as shown in the figure above (taken from the original paper). While the standard CRP achieves *sequence clustering* by the analogy of placing customers (data) on tables (clusters), our model additionally achieves *array clustering* by giving the random table coordinates on [0,1]x[0,1] drawn from the **permuton**. By viewing the table coordinates as a geometric representation of a permutation, we can use the permutation-to-rectangulation transformation to obtain a rectangular partition of the matrix.

- Bottom center: Random coordinates of the CRP tables on [0,1]x[0,1]. The size of each table (circle) reflects the number of customers sitting at that table.
- Top left: Diagonal rectangulation corresponding to the permutation represented by the table coordinates.
- Bottom left: Generic rectangulation corresponding to the permutation represented by the table coordinates.

## Details of usage

Given an input relational matrix, the Permuton-induced Chinese Restaurant Process can be fitted to it by a MCMC inference algorithm as follows:

`[RowTable, ColumnTable, TableCoordinates, nesw] = test_MCMC_PCRP(X);`

or

`[RowTable, ColumnTable, TableCoordinates, nesw] = test_MCMC_PCRP(X, opt);`

- `X`: An M by N input observation matrix. Each element must be natural numbers.
- `opt.maxiter`: Maximum number of MCMC iterations. 
- `opt.missingRatio`: Ratio of test/(training+test) for prediction performance evaluation based on perplexity. 

## Reference

1. M. Nakano, Yasuhiro Fujiwara, A. Kimura, T. Yamada, and N. Ueda, 'Permuton-induced Chinese Restaurant Process,' *Advances in Neural Information Processing Systems* 34 (NeurIPS 2021).

   ```
   @inproceedings{Nakano2021,
    author = {Nakano, Masahiro and Fujiwara, Yasuhiro and Kimura, Akisato and Yamada, Takeshi and Ueda, Naonori},
    booktitle = {Advances in Neural Information Processing Systems},
    pages = {},
    publisher = {Curran Associates, Inc.},
    title = {Permuton-induced Chinese Restaurant Process},
    url = {},
    volume = {34},
    year = {2021}
   }
   ```