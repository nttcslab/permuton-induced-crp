# Bayesian Inference for Permuton-induced Chinese Restaurant Process

![animationMCMCepinions](https://user-images.githubusercontent.com/73105349/141063466-1f5e097c-7397-4376-848e-c789cd012989.gif)

Note: Currently only the Matlab version is available, but a **Python version will be available soon**!

This is a demo code for Bayesian nonparametric relational data analysis based on **Permuton-induced Chinese Restaurant Process** ([NeurIPS, 2021](https://nips.cc/)). The key features are listed as follows:

- **Clustering based on rectangular partitioning**: For an input relational matrix, it can discover disjoint rectangle blocks and suitable permutations of rows and columns. 
- **Infinite model complexity**: There is no need to fix the suitable number of rectangle clusters in advance, which is a fundamental principle of Bayesian nonparametric machine learning. 
- **Arbitrary rectangular partitioning**: It can potentially obtain a posterior distribution on arbitrary rectangular partitioning with any numbers of rectangle blocks.  

You will need a basic MATLAB installation with Statistics and Machine Learning Toolbox. 

## In a nutshell

1. `cd permuton-induced-crp`
2. `run` 

Then you can see a Markov chain Monte Carlo (MCMC) evolution with the following six figures:
- Rectangular partitioning of a sample matrix (`irmdata\sampledata.mat` ).
- Perplexity evolution.

## Reference

1. M. Nakano, Yasuhiro Fujiwara, A. Kimura, T. Yamada, and N. Ueda, 'Permuton-induced Chinese Restaurant Process,' *Advances in Neural Information Processing Systems* 34 (NeurIPS 2021). 