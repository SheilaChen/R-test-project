# Sample scripts for Markov Chain Monte Carlo simulations
# 
library(runjags)  # depends on JAGS
testjags()

# Build the model
our.model <- "
model {
  # likelihood function
  numSuccesses ~ dbinom(successProb, numTrials)

  # prior
  successProb ~ dbeta(1, 1)

  # parameter of interest
  theta <- numSuccesses / numTrials
}"

# Build the data used for simulation
# Are these initial data?
our.data <- list(
  numTrials = 40,
  successProb = 36/40
)

results <- autorun.jags(our.model,
                        data = our.data,
                        n.chains = 3,
                        monitor = c('theta'))

plot(results,
     plot.type = c("histogram", "trace"),
     layout = c(2,1))


results.matrix <- as.matrix(results$mcmc)
theta.samples <- results.matrix[, 'theta']
plot(density(theta.samples, adjust = 5))
quantile(theta.samples, c(.025, .975))
lines(c(.8, .975), c(.1, .1))
lines(c(.8, .8), c(.05, .15))
lines(c(.975, .975), c(.05, .15))

# Example 2: Fitting Distribution the Bayesian Way
# 
the.model <- "
model {
  mu ~ dunif(0, 60)
  stddev ~ dunif(0, 30)
  tau <- pow(stddev, -2)

  for (i in 1:theLength){
    samp[i] ~ dnorm(mu, tau)
  }
}"

the.data <- list(
  samp = precip,
  theLength = length(precip)
)

results <- autorun.jags(the.model,
                        data = the.data,
                        n.chains = 3,
                        monitor = c('mu', 'stddev'))

plot(results,
     plot.type = c("histogram", "trace"),
     layout = c(2, 2))

results.matrix <- as.matrix(results$mcmc)
library(MASS)
# make a kernel density
z <- kde2d(results.matrix[, 'mu'],
           results.matrix[, 'stddev'],
           n = 50)
plot(results.matrix)
contour(z, drawlabels = FALSE,
        nlevels = 11, col = rainbow(11),
        lwd = 3, add = TRUE)


# Example 3: Bayesian independent samples t-test
the.model <- "
model {
  # each group will have a separate mu and stddev
  for (j in 1:2){
    mu[j] ~ dunif(0, 20)
    stddev[j] ~ dunif(0, 20)
    tau[j] <- pow(stddev[j], -2)
  }
  for (i in 1:theLength){
    y[i] ~ dnorm(mu[x[i]], tau[x[i]])
  }
}"

the.data <- list(
  y = mtcars$mpg,
  x = ifelse(mtcars$am == 1, 2, 1),
  theLength = nrow(mtcars)
)

results <- autorun.jags(the.model,
                        data = the.data,
                        n.chains = 3,
                        monitor = c('mu', 'stddev'))

results.matrix <- as.matrix(results$mcmc)
difference.in.means <- (results.matrix[,1] - results.matrix[,2])
plot(density(difference.in.means))
quantile(difference.in.means, c(.05, .95))