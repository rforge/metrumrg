partab <-
function(
    run, 
    project = getwd(), 
    tool = "nm7", 
    file = filename(rundir,run,'.ctl'), 
    rundir = filename(project, run),
    nmlog = file.path(rundir, "NonmemRunLog.csv"), 
    nmout = filename(rundir, run, ".lst"), 
    x=params(within=within,by=by,type=type,...),
    within=ctl2xml(readLines(file)),
    by='name',
    as=c(NA,'estimate','unit','prse'),
    type='parameter',    
    append = NULL, 
    purge = FALSE, 
    ...
){
	stopifnot(length(run)==1)
	log <- rlog(
		run=run,
		#boot=boot,
		append=FALSE,tool=tool,file=NULL,rundir=rundir,nmlog=nmlog,nmout=nmout,purge=FALSE,...)
	log <- data.frame(cast(log,...~moment))
	log[] <- lapply(log,as.character)
	names(log)[names(log)=='parameter'] <- by
	par <- data.frame(
	    stringsAsFactors=FALSE,
	    check.names=FALSE,
		sapply(
			simplify=FALSE,
			as,
			function(as,x,within,by,type,...){
				if(is.na(as)) as <- NULL
				as.character(lookup(x=x,within=within,by=by,as=as,type=type,...))
			},
			x=x,
			within=within,
			by=by,
			type=type,
			...
		)
	)
	names(par)[names(par)=='NA'] <- NA
	par <- par[sapply(par,function(x)!all(is.na(x)))]
	par[[by]]<- x
	log <- log[log[[by]] %in% x,]
	log <- log[sapply(log,function(x)!all(is.na(x)))]
	log <- log[names(log) %in% c(by,as)]
	all <- merge(par,log)
	x <- x[x %in% all[[by]]]
	as <- as[as %in% names(all)]
	all <- all[match(c(by,as),names(all))]
	all <- all[match(x,all[[by]]),]
	row.names(all) <- NULL
	all
}
wikitab <- function (
  run, 
  project = getwd(), 
  #boot = FALSE, 
  tool = "nm7", 
  file = filename(rundir, run, ".ctl"), 
  rundir = filename(project, run), 
  nmlog = file.path(rundir, "NonmemRunLog.csv"), 
  nmout = filename(rundir, run, ".lst"), 
  x = params(within = within, by = by, type = type, ...), 
  within = ctl2xml(readLines(file)), 
  by = "model",
  type = "wiki", 
  append = NULL, 
  purge = FALSE, 
  ...
) 
{
    stopifnot(length(run) == 1)
    log <- rlog(
    	run = run, 
    	#boot = boot, 
    	append = FALSE, tool = tool, 
        file = NULL, rundir = rundir, nmlog = nmlog, nmout = nmout, 
        purge = FALSE, ...)
    log <- data.frame(cast(log, ... ~ moment))
    log[] <- lapply(log, as.character)
    #names(log)[names(log) == "parameter"] <- by
    par <- data.frame(
      stringsAsFactors=FALSE,
      description=as.character(
        lookup(
          x=x,
          within=within,
          by=by,
          as=NULL,
          type=type
        )
      )
    )
    par[by] <- x
    par$parameter <- tos(par[[by]])
    log <- log[log$parameter %in% par$parameter, ]
    log <- log[sapply(log, function(x) !all(is.na(x)))]
    #log <- log[names(log) %in% c(by, as)]
    all <- stableMerge(par, log)
    all <- shuffle(all,'parameter')
    all
}
