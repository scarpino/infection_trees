#written by sv scarpino
#scarpino@utexas.edu

#libraries
#install.packages('ape')
library(ape)

#functions
source('tree_utility_functions.R')

#########
#example#
#########
edgelists <- c('testing_edgelist.csv','edgelist_example_works.csv','edgelist_example_does_not_work.csv')

edgelist_use <- 1

edgelist <- read.csv(edgelists[edgelist_use])

#annoying factor conversion for the two later examples
if(edgelist_use != 1){
	edgelist[,c('source','patient')] <- apply(edgelist[,c('source','patient')], 2, as.character)
}


#constructing a single tree
source.focal <- 'A'

edgelist <- edgelist_check(edgelist, root_id = 'A', remove_singletons = TRUE)
tree <- build_tree(source.focal, edgelist)

TREE <- read.tree(text = tree)
TREE <- collapse.singles(TREE)
plot(TREE, cex = 0.5)