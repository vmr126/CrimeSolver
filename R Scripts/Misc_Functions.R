## Check if Package is already installed
is.installed <- function(package){
  is.element(package, installed.packages()[,1])
} 

## Output Recall and Precision for Trees
tree_performance <- function(matrix){
  cor_diag = diag(matrix)
  rowsums = apply(matrix, 1, sum) # number of instances per class
  colsums = apply(matrix, 2, sum) # number of predictions per class
  precision = cor_diag / colsums 
  recall = cor_diag / rowsums 
  f1 = 2 * precision * recall / (precision + recall) 
  return(data.frame(precision, recall, f1))
}

## Wrap Text in Decision Tree Diagram
split.fun <- function(x, labs, digits, varlen, faclen)
{
  # replace commas with spaces (needed for strwrap)
  labs <- gsub(",", " ", labs)
  for(i in 1:length(labs)) {
    # split labs[i] into multiple lines
    labs[i] <- paste(strwrap(labs[i], width = 50), collapse = "\n")
  }
  labs
}