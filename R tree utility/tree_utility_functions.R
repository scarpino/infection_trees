#written by sv scarpino
#scarpino@utexas.edu

build_tree <- function(source.focal, edgelist){
	edgelist[,'source'] <- as.character(edgelist[,'source'])
	edgelist[,'patient'] <- as.character(edgelist[,'patient'])
	next.nodes <- which(edgelist[,'source'] == source.focal)
	tree <- '('
	n <- 1
	open <- numeric(0)
	while(n <= length(next.nodes)){
		next.nodes.n <- which(edgelist[,'source'] == edgelist[next.nodes[n],'patient'])
			if(n == length(next.nodes) & length(next.nodes.n)==0){
			n.close <- ''
			if(length(open)>0){
				for(o in 1:length(open)){
					n.close <- paste0(n.close,')')
				}
			}
			tree <-paste0(tree,edgelist[next.nodes[n],'patient'],':',edgelist[next.nodes[n],'br_len'],n.close)
		}else{
			if(length(next.nodes.n)==0){
				if(edgelist[next.nodes[n],'source'] == edgelist[next.nodes[(n+1)],'source'] | length(open) == 0){
					tree <-paste0(tree,edgelist[next.nodes[n],'patient'],':',edgelist[next.nodes[n],'br_len'],',')
					}else{
						n.close <- ''
						for(o in 1:length(open)){
							n.close <- paste0(n.close,')')
						}
						tree <-paste0(tree,edgelist[next.nodes[n],'patient'],':',edgelist[next.nodes[n],'br_len'],n.close,',')
						open <- numeric(0)
				}
			}else{
				tree <-paste0(tree,edgelist[next.nodes[n],'patient'],':',edgelist[next.nodes[n],'br_len'],'(')
				open <- c(open, 1)
				if(n == length(next.nodes)){
					next.nodes <- c(next.nodes[1:n],next.nodes.n)
					}else{
				next.nodes <- c(next.nodes[1:n],next.nodes.n,next.nodes[((n+1):length(next.nodes))])	
			}
		}
		}
		n <- n + 1
	}
	tree <- paste0(tree,')',source.focal,';')
	return(tree)
}

edgelist_check <- function(edgelist, root_id = 'A', remove_singletons = FALSE){
	if(remove_singletons == FALSE){
		warning('if there are singletons, the ape package will not read in the tree')
		return(edgelist)
	}else{
		sources <- unique(edgelist[,'source'])
		n_singles <- 0
		
		for(i in sources){
			use.i <- which(edgelist[,'source']==i)
			pats.i <- edgelist[use.i,'patient']
			if(length(pats.i) == 1 & i != root_id){
				source.i <- which(edgelist[,'patient']==i)
				edgelist[use.i,'br_len'] <- edgelist[use.i,'br_len'] + edgelist[source.i,'br_len']
				edgelist[use.i,'source'] <- edgelist[source.i,'source']
				edgelist <- edgelist[-source.i, ]
				n_singles <- n_singles + 1
			}
		}
		
		if(n_singles > 0 ){
			warning(paste0('I have collapsed ', n_singles, ' singleton(s)'))
		}
		return(edgelist)
	}
}