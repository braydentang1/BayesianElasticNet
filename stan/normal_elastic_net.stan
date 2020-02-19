data {
  
  real<lower=0> lambda_one;
  real<lower=0> lambda_two;
  int<lower=0> N;
  int<lower=0> K;
  vector[N] y;
  matrix[N, K] x;
  
  
}

parameters {
  
  vector<lower=0.0, upper=1.0>[K] tau;
  real<lower=0.0> sigma;
  vector[K] beta;
  real<lower=0> alpha;

}

transformed parameters {
  
  vector<lower=0.0, upper=1.0>[K] ess_tee;
  
  for (k in 1:K) {
    
  ess_tee[k] = 1 - tau[k];
  
  }
}

model {
  
  for (k in 1:K) {
    
    tau[k] ~ inv_gamma(0.5, (0.5 * lambda_one^2) / (4.0 * sigma^2  * lambda_two)) T[0, 1];
    beta[k] ~ normal(0.0, (sigma^2/lambda_two) * ess_tee[k]);
    
}

  y ~ normal(alpha + x * beta, sigma);
  
}
