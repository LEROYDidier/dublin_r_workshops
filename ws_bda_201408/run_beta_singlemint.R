source("setup_data.R", echo = TRUE);


### Set a seed to ensure that the random processes are repeatable.
set.seed(42);

sample.count <- 1000;

chain.count  <- 3;
adapt.steps  <- 500;
burnin.steps <- 1000;

jags.file <- 'singlemint_beta.jag';


generate.jags.beta.samples <- function(mintdata.dt) {
    data.nCoins      <- length(unique(mintdata.dt$coinid));
    data.tosscount   <- mintdata.dt$tosscount
    data.y           <- mintdata.dt$success;

    data.jags <- list(nCoins    = data.nCoins,
                      tosscount = data.tosscount,
                      y         = data.y);

    jagsModel <- jags.model(jags.file, data = data.jags, n.chains = chain.count, n.adapt = adapt.steps);

    update(jagsModel, n.iter = burnin.steps);

    coda.data <- coda.samples(jagsModel, variable.names = c('mu', 'kappa'), n.iter = sample.count);

    return(coda.data);
}


### Setup and run the model for mint 1
mintdata.dt <- use.data.dt[, list(success = sum(outcome), tosscount = dim(.SD)[1]), by = list(mintid, coinid)]

coda.beta.mint1 <- generate.jags.beta.samples(mintdata.dt[mintid == 1]);
coda.beta.mint2 <- generate.jags.beta.samples(mintdata.dt[mintid == 2]);
coda.beta.mint3 <- generate.jags.beta.samples(mintdata.dt[mintid == 3]);

coda.beta.lst <- list(mint1 = coda.beta.mint1,
                      mint2 = coda.beta.mint2,
                      mint3 = coda.beta.mint3);
