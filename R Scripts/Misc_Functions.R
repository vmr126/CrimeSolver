tree_performance <- function(matrix){
  cor_diag = diag(matrix)
  rowsums = apply(matrix, 1, sum) # number of instances per class
  colsums = apply(matrix, 2, sum) # number of predictions per class
  precision = cor_diag / colsums 
  recall = cor_diag / rowsums 
  f1 = 2 * precision * recall / (precision + recall) 
  return(data.frame(precision, recall, f1))
}