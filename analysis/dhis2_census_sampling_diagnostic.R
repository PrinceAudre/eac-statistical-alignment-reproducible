# Post hoc design-consistency diagnostic for the DHIS2 census.
# This is not a primary hypothesis test. It conditions on the final N=89
# census classifications and asks how unusual the realised n=47 country-
# stratified sample was under the frozen without-replacement selection design.

x <- read.csv("DHIS2_Census_Stratum_Diagnostic_2026-10-14.csv",
              stringsAsFactors = FALSE)

# Integer scale for weighted Horvitz-Thompson totals. The sample sizes
# (6,11,4,1,1,10,14) divide 4620, so weighted scores can be represented exactly.
scale <- 4620L

state <- new.env(hash=TRUE, parent=emptyenv())
assign("0|0|0|0", 1, envir=state)

for (h in seq_len(nrow(x))) {
  N <- x$N_h[h]; n <- x$n_h[h]
  A <- x$frame_A[h]; M <- x$frame_M[h]; I <- x$frame_I[h]
  den <- choose(N,n)
  opts <- list()
  k <- 0L

  for (a in max(0,n-M-I):min(A,n)) {
    for (m in max(0,n-a-I):min(M,n-a)) {
      i <- n-a-m
      if (i < 0 || i > I) next
      p <- choose(A,a)*choose(M,m)*choose(I,i)/den
      k <- k+1L
      opts[[k]] <- c(rawA=a, rawM=m,
                     scoreA=as.integer(a*N*(scale/n)),
                     scoreM=as.integer(m*N*(scale/n)),
                     prob=p)
    }
  }

  nxt <- new.env(hash=TRUE, parent=emptyenv())
  for (key in ls(state, all.names=TRUE)) {
    p0 <- get(key, envir=state)
    z <- as.integer(strsplit(key, "\\|")[[1]])
    for (op in opts) {
      key2 <- paste(z[1]+op["rawA"], z[2]+op["rawM"],
                    z[3]+op["scoreA"], z[4]+op["scoreM"], sep="|")
      old <- if (exists(key2,envir=nxt,inherits=FALSE)) get(key2,envir=nxt) else 0
      assign(key2, old+p0*op["prob"], envir=nxt)
    }
  }
  state <- nxt
}

keys <- ls(state, all.names=TRUE)
vals <- lapply(keys, function(key) {
  z <- as.integer(strsplit(key, "\\|")[[1]])
  c(rawA=z[1],rawM=z[2],scoreA=z[3],scoreM=z[4],prob=get(key,envir=state))
})
d <- as.data.frame(do.call(rbind, vals))
d$weighted_A_total <- d$scoreA/scale
d$weighted_M_total <- d$scoreM/scale

obs_raw_A <- sum(x$sample_A)
obs_raw_M <- sum(x$sample_M)
obs_wA <- sum(x$sample_A*x$publication_weight)
obs_wM <- sum(x$sample_M*x$publication_weight)

res <- data.frame(
  diagnostic=c(
    "P(raw M >= observed)",
    "P(raw A <= observed)",
    "P(raw M >= observed AND raw A <= observed)",
    "P(weighted M >= observed)",
    "P(weighted A <= observed)",
    "P(weighted M >= observed AND weighted A <= observed)"
  ),
  probability=c(
    sum(d$prob[d$rawM >= obs_raw_M]),
    sum(d$prob[d$rawA <= obs_raw_A]),
    sum(d$prob[d$rawM >= obs_raw_M & d$rawA <= obs_raw_A]),
    sum(d$prob[d$weighted_M_total >= obs_wM-1e-12]),
    sum(d$prob[d$weighted_A_total <= obs_wA+1e-12]),
    sum(d$prob[d$weighted_M_total >= obs_wM-1e-12 &
               d$weighted_A_total <= obs_wA+1e-12])
  )
)

write.csv(res, "DHIS2_Census_Sampling_Diagnostic_Results_2026-10-14.csv",
          row.names=FALSE)

cat("Observed raw A/M:", obs_raw_A, obs_raw_M, "\n")
cat("Observed weighted A/M:", obs_wA/89, obs_wM/89, "\n")
print(res)
