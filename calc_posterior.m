function result = calc_posterior(X, nesw, RowTable, ColumnTable, eta, alpha)

result = calc_CRPprob(RowTable, ColumnTable, eta);
EachClusterCount = calc_EachClusterCount(X, nesw, RowTable, ColumnTable);
result = result + calc_DirichletLikelihood(EachClusterCount, alpha);