
#' Get informative priors for bboutools logistic models
#'
#' Returns intercept prior parameter values for bboutools logistic models
#' that are informed by national demographic-disturbance relationships.
#'
#' This is done by ... TO DO.
#'
#' See `caribouMetrics::betaNationalPriors()` for additional details.
#'
#' @param Anthro numeric. Percent non-overlapping buffered anthropogenic
#'   disturbance.
#' @param fire_excl_anthro numeric. Percent fire not overlapping with
#'   anthropogenic disturbance.
#' @param month logical. Does the survival data to be analyzed include month, or
#'   is it aggregated by year?
#' @param force_run_model logical. Default is FALSE which means the priors are
#'   drawn from the pre-calculated `bbou_national_priors_table`. When TRUE the
#'   model is run to calculate the priors.
#'
#' @return a list with values:
#' * priors_survival = c(b0_mu,b0_sd). Passed to `bboutools::bb_fit_survival`.
#'   See `bb_priors_survival` for details.
#' * priors_recruitment=c(b0_mu,b0_sd). Passed to `bboutools::bb_fit_recruitment`.
#'   See `bb_priors_recruitment` for details.
#'
#' @examples
#' nat_priors <- bbouNationalPriors(Anthro=50,fire=5)
#' print(nat_priors)
#' @export
#' @import dplyr
bbouNationalPriors<-function(Anthro,fire_excl_anthro, month = TRUE, force_run_model = FALSE){
  #Anthro=5;fire_excl_anthro=1
  if(!force_run_model){
    out <- filter(bbou_national_priors_table, .data$Anthro == .env$Anthro,
                  .data$fire_excl_anthro == .env$fire_excl_anthro)

    if(nrow(out) == 1){
      priors_recruitment <- out[which(grepl("recruitment", names(out)))] %>% unlist()
      names(priors_recruitment) <- gsub("priors_recruitment_", "", names(priors_recruitment))

      priors_survival <- out[which(grepl("survival", names(out)))] %>% unlist()
      names(priors_survival) <- gsub("priors_survival_", "", names(priors_survival))

      out <- list(priors_recruitment = priors_recruitment,
                  priors_survival = priors_survival)
      return(out)
    } else if (nrow(out) > 1){
      stop("Multiple matches with bbou_national_priors_table. Anthro and ",
           "fire_excl_anthro must have length 1")
    } else {
      warning("Values of Anthro and fire_excl_anthro did not match integers in ",
              "bbou_national_priors_table, the model will be run. Consider ",
              "rounding to integers for faster processing")
    }

  }

  if(!requireNamespace("caribouMetrics", quietly = TRUE)){
    stop("install the caribouMetrics package to run the model")
  }

  # using library here so that I don't have to have nimble in Depends. It is
  # only run if the model is run in which case nimble is attached and loaded
  # which is the same as if it was listed in Depends like it is in both
  # bboutools and caribouMetrics
  library(nimble)

  surv_dataE = bboudata::bbousurv_a %>% filter(Year > 2010)
  surv_dataE$StartTotal=1;surv_dataE[,5:6][surv_dataE[,5:6]>-1]=NA

  recruit_dataE=bboudata::bbourecruit_a %>% filter(Year > 2010)
  recruit_dataE[,5:9][recruit_dataE[,5:9]>-1]=NA

  disturbance = data.frame(Year=unique(surv_dataE$Year),Anthro=Anthro,fire_excl_anthro=fire_excl_anthro)
  modBetaEmpty <- caribouMetrics::bayesianTrajectoryWorkflow(surv_dataE,recruit_dataE,disturbance, returnSamples = TRUE)

  Rbar <- subset(modBetaEmpty$result$samples,MetricTypeID=="Rbar")$Amount
  Sbar <- subset(modBetaEmpty$result$samples,MetricTypeID=="Sbar")$Amount
  if(month){
    Sbar = Sbar^(1/12)
  }
  b0Priors = list(priors_recruitment=c(b0_mu = mean(logit(Rbar)),b0_sd = sd(logit(Rbar))),
                  priors_survival=c(b0_mu = mean(logit(Sbar)),b0_sd = sd(logit(Sbar))))
  return(b0Priors)
}
