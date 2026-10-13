#!/usr/bin/env Rscript

# Paper 2: complete design-weighted reproduction in R
# Target journal: Journal of the Royal Statistical Society Series A
#
# This script is intended to become the final manuscript source of truth.
# It reproduces:
#   1. primary weighted overall alignment estimates
#   2. D1-D4 domain-state estimates
#   3. arm-specific methodological items
#   4. applicable-domain sentinel estimates
#   5. sensitivity analyses
#   6. pre-adjudication inter-reviewer reliability
#   7. publication-quality vector figures
#
# Important design clarification:
# The DHS/MICS arm contains one non-census singleton sampling stratum:
# DHS | Democratic Republic of the Congo, N_h=5, n_h=1.
# A within-stratum variance cannot be estimated from one sampled publication.
# The primary R analysis therefore uses survey.lonely.psu="adjust", with
# "average" and "remove" reported as sensitivity analyses. Point estimates
# are unaffected; uncertainty intervals may change slightly.
#
# Required CRAN packages:
# survey, readr, dplyr, tidyr, ggplot2, scales, tibble
#
# Run from the directory containing the four input CSV files, e.g.
#   Rscript paper2_reproduce_all_final_analysis.R
#
# The script does NOT install packages automatically. This preserves a
# transparent environment and avoids silent dependency changes.

required <- c("survey","readr","dplyr","tidyr","ggplot2","scales","tibble")
missing <- required[!vapply(required, requireNamespace, quietly=TRUE, FUN.VALUE=logical(1))]
if (length(missing)) {
  stop(
    "Missing R packages: ", paste(missing, collapse=", "),
    "\nInstall once with:\ninstall.packages(c(",
    paste(sprintf('"%s"', missing), collapse=", "), "))"
  )
}

suppressPackageStartupMessages({
  library(survey)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(scales)
  library(tibble)
})

options(stringsAsFactors = FALSE)
options(survey.adjust.domain.lonely = TRUE)

main_file   <- "Paper2_R_Analysis_Compact_127.csv"
rel_file    <- "Paper2_R_Reliability_Clean_26.csv"
strata_file <- "Paper2_R_Strata_Clean.csv"

out_dir <- "outputs"
dir.create(out_dir, showWarnings=FALSE, recursive=TRUE)

main <- read_csv(main_file, show_col_types=FALSE) %>%
  mutate(
    arm = factor(arm, levels=c("DHS/MICS","DHIS2")),
    stratum = factor(stratum),
    stratum_N = as.numeric(stratum_N),
    stratum_n = as.numeric(stratum_n),
    publication_sampling_weight = as.numeric(publication_sampling_weight),
    pilot_exposed = factor(pilot_exposed, levels=c("no","yes"))
  )

pitfall_names <- c(
  P1="Complex survey treated as simple random sample",
  P2="Routine indicator without relevant data-quality/denominator checks",
  P3="Storage type dictates analysis",
  P4="DHS weight/coded-value semantics mishandled",
  P5="Summary statistic poorly matched",
  P6="Threshold/effect-scale/reporting overclaim",
  P7="Data-dependent assumption-pretest method selection",
  P8="Multiple testing / undisclosed multiplicity",
  P9="Ecological fallacy / level-of-inference mismatch",
  P10="Adjustment-set / causal-interpretation problem",
  P11="Immortal-time / reverse-causation problem",
  P12="Reproducibility artifact mismatch"
)

pit <- main %>%
  select(study_id, arm, stratum, stratum_N, stratum_n,
         publication_sampling_weight,
         matches("^P([1-9]|1[0-2])_(applicable|state)$")) %>%
  pivot_longer(
    cols=matches("^P([1-9]|1[0-2])_(applicable|state)$"),
    names_to=c("pitfall_id", ".value"),
    names_pattern="(P\\d+)_(applicable|state)"
  ) %>%
  mutate(pitfall_name=unname(pitfall_names[pitfall_id]))

rel <- read_csv(rel_file, show_col_types=FALSE)
strata_meta <- read_csv(strata_file, show_col_types=FALSE)

stopifnot(nrow(main)==127L, length(unique(main$study_id))==127L)
stopifnot(sum(main$arm=="DHS/MICS")==80L, sum(main$arm=="DHIS2")==47L)
stopifnot(abs(sum(main$publication_sampling_weight[main$arm=="DHS/MICS"])-377) < 1e-8)
stopifnot(abs(sum(main$publication_sampling_weight[main$arm=="DHIS2"])-89) < 1e-8)
stopifnot(nrow(pit)==127L*12L)
stopifnot(nrow(rel)==26L)
stopifnot(sum(strata_meta$eligible_N)==466L, sum(strata_meta$sample_n)==127L)

make_design <- function(data, lonely="adjust") {
  options(survey.lonely.psu=lonely)
  svydesign(
    ids = ~1,
    strata = ~stratum,
    weights = ~publication_sampling_weight,
    fpc = ~stratum_N,
    data = data,
    nest = TRUE
  )
}

design_primary <- make_design(main, "adjust")

safe_ci <- function(est, se, df) {
  crit <- qt(.975, df=df)
  c(
    low=max(0, est-crit*se),
    high=min(1, est+crit*se)
  )
}

svy_binary <- function(design, expr, arm_name=NULL) {
  d <- if (is.null(arm_name)) design else subset(design, arm==arm_name)
  z <- eval(substitute(expr), envir=d$variables, enclos=parent.frame())
  d$variables$.tmp_indicator <- as.numeric(z)
  fit <- svymean(~.tmp_indicator, d, na.rm=TRUE)
  est <- unname(coef(fit)[1])
  se <- unname(SE(fit)[1])
  df <- degf(d)
  ci <- safe_ci(est,se,df)
  tibble(estimate=est, se=se, ci_low=ci["low"], ci_high=ci["high"], design_df=df)
}

svy_domain_binary <- function(design, applicable, event, arm_name=NULL) {
  d <- if (is.null(arm_name)) design else subset(design, arm==arm_name)
  a <- eval(substitute(applicable), envir=d$variables, enclos=parent.frame())
  e <- eval(substitute(event), envir=d$variables, enclos=parent.frame())
  d$variables$.app <- as.numeric(a)
  d$variables$.evt <- as.numeric(e & a)
  dsub <- subset(d, .app==1)
  if (nrow(dsub$variables)==0) {
    return(tibble(estimate=NA_real_,se=NA_real_,ci_low=NA_real_,ci_high=NA_real_,
                  design_df=degf(d), raw_applicable=0L, raw_event=0L))
  }
  fit <- svymean(~.evt, dsub, na.rm=TRUE)
  est <- unname(coef(fit)[1])
  se <- unname(SE(fit)[1])
  df <- degf(d)
  ci <- safe_ci(est,se,df)
  tibble(
    estimate=est,se=se,ci_low=ci["low"],ci_high=ci["high"],design_df=df,
    raw_applicable=sum(a,na.rm=TRUE),raw_event=sum(e & a,na.rm=TRUE)
  )
}

# -------------------------------------------------------------------------
# Primary overall alignment
# -------------------------------------------------------------------------

overall_levels <- c(
  "fully_aligned",
  "materially_misaligned",
  "indeterminate_or_partial"
)
overall_labels <- c(
  fully_aligned="Fully aligned",
  materially_misaligned="Materially misaligned",
  indeterminate_or_partial="Indeterminate / partial"
)

overall <- bind_rows(lapply(levels(main$arm), function(a) {
  bind_rows(lapply(overall_levels, function(k) {
    est <- svy_binary(design_primary, overall_alignment_class==k, a)
    raw_n <- sum(main$arm==a)
    raw_count <- sum(main$arm==a & main$overall_alignment_class==k)
    est %>% mutate(
      arm=a, outcome=k, outcome_label=overall_labels[[k]],
      raw_n=raw_n, raw_count=raw_count,
      unweighted=raw_count/raw_n,
      .before=1
    )
  }))
}))

# Independent-arm contrasts with Welch-Satterthwaite df.
arm_contrast <- function(outcome) {
  a <- overall %>% filter(arm=="DHS/MICS", outcome==!!outcome)
  b <- overall %>% filter(arm=="DHIS2", outcome==!!outcome)
  v1 <- a$se^2; v2 <- b$se^2
  diff <- b$estimate-a$estimate
  se <- sqrt(v1+v2)
  df <- (v1+v2)^2 / (v1^2/a$design_df + v2^2/b$design_df)
  crit <- qt(.975, df=df)
  tibble(
    outcome=outcome,
    outcome_label=overall_labels[[outcome]],
    DHS_MICS=a$estimate,
    DHIS2=b$estimate,
    difference_DHIS2_minus_DHS_MICS=diff,
    se=se, df=df,
    ci_low=diff-crit*se,
    ci_high=diff+crit*se
  )
}
arm_differences <- bind_rows(lapply(overall_levels, arm_contrast))

# -------------------------------------------------------------------------
# D1-D4 domain states
# -------------------------------------------------------------------------

domain_map <- c(
  D1="d1_data_structure_class",
  D2="d2_inferential_goal_class",
  D3="d3_method_class",
  D4="d4_reporting_interpretation_class"
)

domain_states <- bind_rows(lapply(levels(main$arm), function(a) {
  bind_rows(lapply(names(domain_map), function(dom) {
    field <- domain_map[[dom]]
    bind_rows(lapply(c("A","M","I"), function(st) {
      d <- subset(design_primary, arm==a)
      d$variables$.tmp <- as.numeric(d$variables[[field]]==st)
      fit <- svymean(~.tmp,d,na.rm=TRUE)
      est <- unname(coef(fit)[1]); se <- unname(SE(fit)[1]); df <- degf(d)
      ci <- safe_ci(est,se,df)
      tibble(arm=a,domain=dom,state=st,estimate=est,se=se,
             ci_low=ci["low"],ci_high=ci["high"],design_df=df)
    }))
  }))
}))

# -------------------------------------------------------------------------
# Applicable-domain item estimates
# -------------------------------------------------------------------------

item_estimate <- function(data, design, arm_name, field, adverse_state) {
  d <- subset(design, arm==arm_name)
  x <- d$variables[[field]]
  applicable <- !is.na(x) & x!="" & x!="NA"
  event <- x==adverse_state
  unclear <- x %in% c("unclear","partial")
  # Work on the full domain design so survey's domain handling is preserved.
  d$variables$.app <- as.numeric(applicable)
  d$variables$.event <- as.numeric(event & applicable)
  d$variables$.unclear <- as.numeric(unclear & applicable)
  if (!any(applicable)) {
    return(tibble(estimate=NA_real_,
                  ci_low=NA_real_,ci_high=NA_real_,unclear=NA_real_,
                  unclear_low=NA_real_,unclear_high=NA_real_,
                  raw_applicable=0L,raw_adverse=0L))
  }
  ds <- subset(d,.app==1)
  fit1 <- svymean(~.event,ds,na.rm=TRUE)
  fit2 <- svymean(~.unclear,ds,na.rm=TRUE)
  df <- degf(d)
  e1 <- unname(coef(fit1)[1]); s1 <- unname(SE(fit1)[1]); c1 <- safe_ci(e1,s1,df)
  e2 <- unname(coef(fit2)[1]); s2 <- unname(SE(fit2)[1]); c2 <- safe_ci(e2,s2,df)
  tibble(
    estimate=e1, ci_low=c1["low"], ci_high=c1["high"],
    unclear=e2, unclear_low=c2["low"], unclear_high=c2["high"],
    raw_applicable=sum(applicable), raw_adverse=sum(event & applicable)
  )
}

survey_items <- tribble(
  ~item,~field,~adverse,
  "Survey weights","survey_weights","inappropriate",
  "Cluster / PSU handling","cluster_psu","inappropriate",
  "Stratification handling","strata","inappropriate",
  "Survey variance","survey_variance","inappropriate",
  "Subpopulation/domain variance","subpopulation_domain_variance","inappropriate",
  "Multilevel claim alignment","multilevel_claim_alignment","inappropriate"
)

dhis_items <- tribble(
  ~item,~field,~adverse,
  "Reporting completeness","reporting_completeness","not_considered",
  "Missing versus zero","missing_vs_zero","inappropriate",
  "Numerator provenance","numerator_definition_provenance","insufficient",
  "Denominator provenance","denominator_definition_provenance","insufficient",
  "Numerator-denominator alignment","num_denom_alignment","not_considered",
  "Implausible values","implausible_values","nontransparent",
  "Cleaning/exclusion rules","cleaning_exclusion_rules","absent",
  "Routine time structure","routine_time_structure","inappropriate",
  "Reporting-unit dependence","reporting_unit_dependence","inappropriate"
)

report_items <- tribble(
  ~item,~field,~adverse,
  "Effect estimate with uncertainty","effect_with_uncertainty","no",
  "P-value threshold overclaim","p_value_threshold_overclaim","present",
  "Odds ratio described as risk","or_as_risk_problem","present",
  "Relative effect without absolute context","relative_without_absolute_context","present",
  "Ecological inference problem","ecological_inference_problem","present",
  "Unsupported causal language","causal_language_support","unsupported",
  "Multiplicity","multiplicity","inappropriate",
  "Reproducibility information","reproducibility_information","absent",
  "Code/materials availability","code_or_analysis_materials_available","no"
)

survey_item_results <- survey_items %>%
  rowwise() %>%
  mutate(result=list(item_estimate(main,design_primary,"DHS/MICS",field,adverse))) %>%
  unnest(result) %>% ungroup()

dhis_item_results <- dhis_items %>%
  rowwise() %>%
  mutate(result=list(item_estimate(main,design_primary,"DHIS2",field,adverse))) %>%
  unnest(result) %>% ungroup()

report_item_results <- bind_rows(lapply(levels(main$arm), function(a) {
  report_items %>%
    rowwise() %>%
    mutate(arm=a,result=list(item_estimate(main,design_primary,a,field,adverse))) %>%
    unnest(result) %>% ungroup()
}))

# Survey-design reporting distribution
survey_reporting <- bind_rows(lapply(c("sufficient","partial","insufficient","unclear"), function(st) {
  est <- svy_binary(design_primary, survey_design_reporting==st, "DHS/MICS")
  est %>% mutate(state=st,.before=1)
}))

# -------------------------------------------------------------------------
# Sentinel concerns
# -------------------------------------------------------------------------

pit_ids <- paste0("P",1:12)

pitfall_results <- bind_rows(lapply(levels(main$arm), function(a) {
  bind_rows(lapply(pit_ids,function(pid) {
    d <- subset(design_primary, arm==a)
    app_col <- paste0(pid, "_applicable")
    state_col <- paste0(pid, "_state")
    app <- d$variables[[app_col]]=="yes"
    present <- d$variables[[state_col]]=="present"
    unclear_flag <- d$variables[[state_col]]=="unclear"
    d$variables$.app <- as.numeric(app)
    d$variables$.present <- as.numeric(present & app)
    d$variables$.unclear <- as.numeric(unclear_flag & app)
    if (!any(app)) {
      return(tibble(
        arm=a,pitfall_id=pid,
        pitfall_name=unname(pitfall_names[[pid]]),
        estimate=NA_real_,ci_low=NA_real_,ci_high=NA_real_,
        unclear=NA_real_,unclear_low=NA_real_,unclear_high=NA_real_,
        raw_applicable=0L,raw_present=0L,raw_unclear=0L
      ))
    }
    ds <- subset(d,.app==1)
    f1 <- svymean(~.present,ds,na.rm=TRUE)
    f2 <- svymean(~.unclear,ds,na.rm=TRUE)
    df <- degf(d)
    e1 <- unname(coef(f1)[1]); s1 <- unname(SE(f1)[1]); c1 <- safe_ci(e1,s1,df)
    e2 <- unname(coef(f2)[1]); s2 <- unname(SE(f2)[1]); c2 <- safe_ci(e2,s2,df)
    tibble(
      arm=a,pitfall_id=pid,pitfall_name=unname(pitfall_names[[pid]]),
      estimate=e1,ci_low=c1["low"],ci_high=c1["high"],
      unclear=e2,unclear_low=c2["low"],unclear_high=c2["high"],
      raw_applicable=sum(app),raw_present=sum(present & app),raw_unclear=sum(unclear_flag & app)
    )
  }))
}))

stopifnot(all(pitfall_results$raw_present <= pitfall_results$raw_applicable))
stopifnot(all(pitfall_results$raw_unclear <= pitfall_results$raw_applicable))

# -------------------------------------------------------------------------
# Sensitivity analyses
# -------------------------------------------------------------------------

# Weighted vs unweighted
weight_sensitivity <- overall %>%
  transmute(
    analysis="Weighted versus unweighted",
    arm,outcome=outcome_label,
    reference=unweighted,
    sensitivity=estimate,
    difference=estimate-unweighted,
    ci_low=NA_real_,ci_high=NA_real_
  )

# Exclude pilot-exposed. Reweight to the non-pilot population in each stratum.
nonpilot <- main %>%
  filter(pilot_exposed=="no") %>%
  select(-stratum_N,-stratum_n,-publication_sampling_weight) %>%
  left_join(strata_meta %>% select(stratum,nonpilot_N),by="stratum") %>%
  group_by(stratum) %>%
  mutate(
    nonpilot_sample_n=n(),
    stratum_N=nonpilot_N,
    stratum_n=nonpilot_sample_n,
    publication_sampling_weight=nonpilot_N/nonpilot_sample_n
  ) %>%
  ungroup()

design_nonpilot <- make_design(nonpilot,"adjust")

pilot_sensitivity <- bind_rows(lapply(levels(main$arm), function(a) {
  bind_rows(lapply(overall_levels,function(k) {
    est <- svy_binary(design_nonpilot,overall_alignment_class==k,a)
    primary <- overall %>% filter(arm==a,outcome==k) %>% pull(estimate)
    tibble(
      analysis="Exclude pilot-exposed",arm=a,outcome=overall_labels[[k]],
      reference=primary,sensitivity=est$estimate,difference=est$estimate-primary,
      ci_low=est$ci_low,ci_high=est$ci_high
    )
  }))
}))

# Determinate-only and M+I
other_sensitivity <- bind_rows(lapply(levels(main$arm), function(a) {
  d <- subset(design_primary, arm==a)
  d_det <- subset(d, overall_alignment_class!="indeterminate_or_partial")
  d_det$variables$.m <- as.numeric(d_det$variables$overall_alignment_class=="materially_misaligned")
  f <- svymean(~.m,d_det)
  e <- unname(coef(f)[1]); s <- unname(SE(f)[1]); df <- degf(d); c1 <- safe_ci(e,s,df)

  nf <- svy_binary(design_primary,overall_alignment_class!="fully_aligned",a)
  bind_rows(
    tibble(analysis="Determinate-only",arm=a,
           outcome="Materially misaligned among determinate",
           reference=NA_real_,sensitivity=e,difference=NA_real_,
           ci_low=c1["low"],ci_high=c1["high"]),
    tibble(analysis="Not fully aligned",arm=a,outcome="M + I combined",
           reference=NA_real_,sensitivity=nf$estimate,difference=NA_real_,
           ci_low=nf$ci_low,ci_high=nf$ci_high)
  )
}))

# Coding-nonresponse sensitivity: redefine the codeable Kenya DHS frame as
# N_h=63 instead of the frozen eligible-frame N_h=64, retaining the 14 coded
# publications and therefore using weight 63/14 in that stratum.
kenya_codeable <- main
kenya_idx <- kenya_codeable$arm=="DHS/MICS" &
  as.character(kenya_codeable$stratum)=="DHS|Kenya"
kenya_codeable$stratum_N[kenya_idx] <- 63
kenya_codeable$stratum_n[kenya_idx] <- 14
kenya_codeable$inclusion_probability[kenya_idx] <- 14/63
kenya_codeable$publication_sampling_weight[kenya_idx] <- 63/14
kenya_design <- make_design(kenya_codeable,"adjust")

kenya_sensitivity <- bind_rows(lapply(overall_levels,function(k) {
  ref <- overall %>%
    filter(arm=="DHS/MICS", outcome==k) %>%
    pull(estimate)
  est <- svy_binary(kenya_design,overall_alignment_class==k,"DHS/MICS")
  tibble(
    analysis="Kenya coding-nonresponse frame sensitivity",
    arm="DHS/MICS",
    outcome=overall_labels[[k]],
    reference=ref,
    sensitivity=est$estimate,
    difference=est$estimate-ref,
    ci_low=est$ci_low,
    ci_high=est$ci_high
  )
}))

sensitivity <- bind_rows(
  weight_sensitivity,
  pilot_sensitivity,
  other_sensitivity,
  kenya_sensitivity
)
stopifnot(sum(sensitivity$analysis=="Kenya coding-nonresponse frame sensitivity")==3L)

# Lonely-stratum variance sensitivity for the PRIMARY outcomes.
lonely_modes <- c("adjust","average","remove")
lonely_sensitivity <- bind_rows(lapply(lonely_modes,function(mode) {
  des <- make_design(main,mode)
  bind_rows(lapply(levels(main$arm),function(a) {
    bind_rows(lapply(overall_levels,function(k) {
      est <- svy_binary(des,overall_alignment_class==k,a)
      tibble(mode=mode,arm=a,outcome=overall_labels[[k]],
             estimate=est$estimate,se=est$se,ci_low=est$ci_low,ci_high=est$ci_high)
    }))
  }))
}))
options(survey.lonely.psu="adjust")  # restore primary choice

# -------------------------------------------------------------------------
# Pre-adjudication inter-reviewer reliability
# -------------------------------------------------------------------------

cohen_kappa <- function(a,b) {
  lev <- union(unique(a),unique(b))
  ta <- table(factor(a,levels=lev))
  tb <- table(factor(b,levels=lev))
  po <- mean(a==b)
  pe <- sum((ta/length(a))*(tb/length(b)))
  k <- if (abs(1-pe)<1e-12) NA_real_ else (po-pe)/(1-pe)
  c(agreement=po,kappa=k)
}

gwet_ac1 <- function(a,b) {
  lev <- union(unique(a),unique(b))
  q <- length(lev)
  po <- mean(a==b)
  if (q <= 1L) return(c(agreement=po,ac1=NA_real_))
  pbar <- vapply(lev,function(z) {
    (mean(a==z)+mean(b==z))/2
  },numeric(1))
  pe <- sum(pbar*(1-pbar))/(q-1)
  ac1 <- if (abs(1-pe)<1e-12) NA_real_ else (po-pe)/(1-pe)
  c(agreement=po,ac1=ac1)
}

reliability <- tibble(
  measure=c("D1","D2","D3","D4","Overall"),
  r1=c("R1_D1","R1_D2","R1_D3","R1_D4","R1_Overall"),
  r2=c("R2_D1","R2_D2","R2_D3","R2_D4","R2_Overall")
) %>%
  rowwise() %>%
  mutate(
    stats=list(cohen_kappa(rel[[r1]],rel[[r2]])),
    ac1_stats=list(gwet_ac1(rel[[r1]],rel[[r2]]))
  ) %>%
  ungroup() %>%
  transmute(
    measure,
    agreements=mapply(function(x,y) sum(rel[[x]]==rel[[y]]),r1,r2),
    N=nrow(rel),
    raw_agreement=vapply(stats,function(x)x[["agreement"]],numeric(1)),
    cohen_kappa=vapply(stats,function(x)x[["kappa"]],numeric(1)),
    gwet_ac1=vapply(ac1_stats,function(x)x[["ac1"]],numeric(1))
  )

stopifnot(nrow(reliability)==5L, identical(reliability$measure, c("D1","D2","D3","D4","Overall")))

overall_map <- c(
  fully_aligned="A",
  materially_misaligned="M",
  indeterminate_or_partial="I"
)
mi_rel <- rel %>%
  transmute(
    R1=unname(overall_map[R1_Overall]),
    R2=unname(overall_map[R2_Overall])
  ) %>%
  filter(R1!="A", R2!="A")

mi_k <- cohen_kappa(mi_rel$R1,mi_rel$R2)
mi_ac1 <- gwet_ac1(mi_rel$R1,mi_rel$R2)
reliability_mi_split <- tibble(
  measure="M versus I among publications both reviewers classified as not fully aligned",
  agreements=sum(mi_rel$R1==mi_rel$R2),
  N=nrow(mi_rel),
  raw_agreement=mi_k[["agreement"]],
  cohen_kappa=mi_k[["kappa"]],
  gwet_ac1=mi_ac1[["ac1"]]
)
stopifnot(nrow(mi_rel)==13L)

# D1-D4 are linked judgments within publications, not independent repeated
# observations. Publication-facing reliability therefore reports each domain
# separately plus the rule-based overall classification; no pooled D1-D4
# kappa is generated.

# -------------------------------------------------------------------------
# Observability composition and within-publication domain cross-tabs
# -------------------------------------------------------------------------

observability_composition <- bind_rows(lapply(levels(main$arm), function(a) {
  m <- overall %>% filter(arm==a, outcome=="materially_misaligned") %>% pull(estimate)
  i <- overall %>% filter(arm==a, outcome=="indeterminate_or_partial") %>% pull(estimate)
  nf <- m + i
  tibble(
    arm=a,
    materially_misaligned=m,
    indeterminate_or_partial=i,
    not_fully_aligned=nf,
    documented_M_share_among_not_fully=ifelse(nf>0,m/nf,NA_real_),
    insufficient_I_share_among_not_fully=ifelse(nf>0,i/nf,NA_real_)
  )
}))

domain_vars <- c(
  D1="d1_data_structure_class",
  D2="d2_inferential_goal_class",
  D3="d3_method_class",
  D4="d4_reporting_interpretation_class"
)
domain_pairs <- combn(names(domain_vars),2,simplify=FALSE)

domain_cross_tabs <- bind_rows(lapply(levels(main$arm), function(a) {
  da <- main %>% filter(arm==a)
  arm_total <- sum(da$publication_sampling_weight)
  bind_rows(lapply(domain_pairs, function(pr) {
    v1 <- unname(domain_vars[[pr[1]]])
    v2 <- unname(domain_vars[[pr[2]]])
    tibble(
      state_1=da[[v1]],
      state_2=da[[v2]],
      publication_sampling_weight=da$publication_sampling_weight
    ) %>%
      group_by(state_1,state_2) %>%
      summarise(
        raw_n=n(),
        weighted_count=sum(publication_sampling_weight),
        .groups="drop"
      ) %>%
      mutate(
        arm=a,
        domain_1=pr[1],
        domain_2=pr[2],
        weighted_percent_within_arm=100*weighted_count/arm_total
      ) %>%
      select(arm,domain_1,domain_2,state_1,state_2,raw_n,
             weighted_count,weighted_percent_within_arm)
  }))
}))

# -------------------------------------------------------------------------
# Sampling diagnostics
# -------------------------------------------------------------------------

sampling_diagnostics <- main %>%
  group_by(arm) %>%
  summarise(
    sample_n=n(),
    eligible_N=sum(publication_sampling_weight),
    min_inclusion_probability=min(inclusion_probability),
    max_inclusion_probability=max(inclusion_probability),
    min_weight=min(publication_sampling_weight),
    max_weight=max(publication_sampling_weight),
    weight_CV=sd(publication_sampling_weight)/mean(publication_sampling_weight),
    unequal_weight_DEFF=1+weight_CV^2,
    weight_ESS=sum(publication_sampling_weight)^2/sum(publication_sampling_weight^2),
    .groups="drop"
  )

# -------------------------------------------------------------------------
# Write numerical outputs
# -------------------------------------------------------------------------

write_csv(overall,file.path(out_dir,"Table_primary_overall_alignment.csv"))
write_csv(arm_differences,file.path(out_dir,"Table_between_arm_differences.csv"))
write_csv(domain_states,file.path(out_dir,"Table_domain_states.csv"))
write_csv(survey_item_results,file.path(out_dir,"Table_DHS_MICS_items.csv"))
write_csv(dhis_item_results,file.path(out_dir,"Table_DHIS2_items.csv"))
write_csv(report_item_results,file.path(out_dir,"Table_reporting_items.csv"))
write_csv(survey_reporting,file.path(out_dir,"Table_survey_design_reporting.csv"))
write_csv(pitfall_results,file.path(out_dir,"Table_sentinel_indicators.csv"))
write_csv(sensitivity,file.path(out_dir,"Table_sensitivity.csv"))
write_csv(lonely_sensitivity,file.path(out_dir,"Table_lonely_stratum_sensitivity.csv"))
write_csv(reliability,file.path(out_dir,"Table_reliability.csv"))
write_csv(reliability_mi_split,file.path(out_dir,"Table_reliability_MI_split.csv"))
write_csv(observability_composition,file.path(out_dir,"Table_observability_composition.csv"))
write_csv(domain_cross_tabs,file.path(out_dir,"Table_domain_cross_tabs.csv"))
write_csv(sampling_diagnostics,file.path(out_dir,"Table_sampling_diagnostics.csv"))

# -------------------------------------------------------------------------
# Figures: black-and-white, shape-coded, vector output
# -------------------------------------------------------------------------

overall_plot <- overall %>%
  mutate(
    arm=factor(arm,levels=c("DHS/MICS","DHIS2")),
    outcome_label=factor(outcome_label,levels=rev(c("Fully aligned","Materially misaligned","Indeterminate / partial")))
  )

p1 <- ggplot(overall_plot,aes(x=estimate*100,y=outcome_label,shape=arm)) +
  geom_errorbar(aes(xmin=ci_low*100,xmax=ci_high*100),
                position=position_dodge(width=.38),width=.16,linewidth=.45) +
  geom_point(position=position_dodge(width=.38),size=2.8) +
  scale_shape_manual(values=c(1,16)) +
  scale_x_continuous(limits=c(0,100),breaks=seq(0,100,20)) +
  labs(x="Estimated percentage of eligible publications",y=NULL,shape=NULL) +
  theme_bw(base_size=10) +
  theme(legend.position="none",panel.grid.minor=element_blank())

domain_plot <- domain_states %>%
  mutate(
    arm=factor(arm,levels=c("DHS/MICS","DHIS2")),
    state=factor(state,levels=c("A","M","I")),
    domain=factor(domain,levels=c("D1","D2","D3","D4"))
  )

p2 <- ggplot(domain_plot,aes(x=estimate*100,y=state,shape=arm)) +
  geom_point(position=position_dodge(width=.42),size=2.5) +
  facet_wrap(~domain,ncol=2) +
  scale_shape_manual(values=c(1,16)) +
  scale_x_continuous(limits=c(0,100),breaks=seq(0,100,25)) +
  labs(x="Estimated percentage of eligible publications",y=NULL,shape=NULL) +
  theme_bw(base_size=10) +
  theme(legend.position="none",panel.grid.minor=element_blank(),
        strip.background=element_blank(),strip.text=element_text(face="bold"))

pit_plot_data <- pitfall_results %>%
  filter(!is.na(estimate)) %>%
  mutate(
    arm=factor(arm,levels=c("DHS/MICS","DHIS2")),
    pitfall_id=factor(pitfall_id,levels=rev(paste0("P",1:12)))
  )

p3 <- ggplot(pit_plot_data,aes(x=estimate*100,y=pitfall_id,shape=arm)) +
  geom_errorbar(aes(xmin=ci_low*100,xmax=ci_high*100),
                position=position_dodge(width=.38),width=.15,linewidth=.42) +
  geom_point(position=position_dodge(width=.38),size=2.6) +
  scale_shape_manual(values=c(1,16)) +
  scale_x_continuous(limits=c(0,100),breaks=seq(0,100,20)) +
  labs(x="Prevalence among applicable publications (%)",y=NULL,shape=NULL) +
  theme_bw(base_size=10) +
  theme(legend.position="none",panel.grid.minor=element_blank())

save_vector <- function(plot,stem,width,height) {
  ggsave(file.path(out_dir,paste0(stem,".pdf")),plot,width=width,height=height,units="in",
         device=cairo_pdf)
  ggsave(file.path(out_dir,paste0(stem,".eps")),plot,width=width,height=height,units="in",
         device="eps")
  ggsave(file.path(out_dir,paste0(stem,".png")),plot,width=width,height=height,units="in",
         dpi=600)
}
save_vector(p1,"Figure1_overall_alignment",7.1,4.2)
save_vector(p2,"Figure2_domain_states",7.1,5.5)
save_vector(p3,"Supplementary_Figure_S1_sentinel_indicators",7.1,5.8)

# -------------------------------------------------------------------------
# Environment and compact console checkpoint
# -------------------------------------------------------------------------

capture.output(sessionInfo(),file=file.path(out_dir,"R_sessionInfo.txt"))

cat("\nPRIMARY OVERALL ALIGNMENT\n")
print(overall %>% select(arm,outcome_label,estimate,ci_low,ci_high,design_df))
cat("\nBETWEEN-ARM DIFFERENCES\n")
print(arm_differences)
cat("\nLONELY-STRATUM SENSITIVITY\n")
print(lonely_sensitivity)
cat("\nRELIABILITY\n")
print(reliability)
cat("\nOutputs written to: ", normalizePath(out_dir), "\n", sep="")