---
name: ch16-mcmc-appendix
description: Chapter 16 (MCMC: Markov Chain Monte Carlo), an appendix: content knowledge and tutoring guidance for the EDA Companion. Use whenever the student works with the appendix, including any ch16 file (ch16-work.qmd, files in the ch16-mcmc-appendix directory), or asks about Markov chains and transition probabilities, stationary distributions and detailed balance, the Metropolis-Hastings algorithm, random-walk Metropolis, step-size tuning and acceptance rates, burn-in, mixing, and trace plots, effective sample size for MCMC, or Bayesian sampling tools such as Gibbs, HMC, NUTS, and Stan.
---

<!-- Ported to Posit Assistant skill format from ch16.instructions.md (applyTo glob replaced by the description trigger above); body unchanged. Authored and ported 2026-07-11; slug and title per inst/templates/book-chapters.txt. -->

<!-- Last updated: 2026-07-11 -->

<!-- Source of truth: eda4ml-positron/ch-instructions/ch16.instructions.md -->

<!-- Authoring note: chapters 16 and 17 are appendices, distinct in intent and structure from chapters 1-15. They are reference deep-dives that students visit from other chapters, not stops on the book's arc. This file therefore replaces the chapter template's Learning Objectives and Exercise Map (the appendix has neither) with an Entry Points orientation. -->

# Chapter 16 (Appendix): MCMC, Markov Chain Monte Carlo

## Appendix Role and Entry Points

This appendix is a reference deep-dive, not a stop on the book's arc. Students arrive by following a pointer from another chapter or out of curiosity about Bayesian and probabilistic machine learning. Meet them where they came from:

| Arriving from | Likely wanting |
|---------------|----------------|
| Ch 4 (Statistical Simulation) | The MCMC preview expanded: what to do when you can evaluate a density but cannot sample from it directly, and how this differs from importance sampling |
| Ch 12 (Time Series Data) | Recognition that an MCMC chain is itself a time series: stationarity, autocorrelation, and effective sample size reappear here as working tools |
| Ch 11 (Topic Models) | The sampling machinery behind inference in latent-variable models |
| General curiosity | What "MCMC" means in the Bayesian and probabilistic ML literature, and what Stan, HMC, and NUTS are |

**The appendix's through-line:** We want a random sample from a distribution with density p(x) that we can evaluate but cannot sample from directly. The solution is indirect and initially surprising: construct a Markov chain whose stationary distribution is p, run the chain long enough, and treat its later values as (correlated) draws from p. The rest of the appendix makes each piece of that sentence precise: what a Markov chain is, what stationarity and detailed balance mean, how the Metropolis-Hastings algorithm constructs the chain, and how to judge whether the resulting sample is any good.

**The worked example:** A random-walk Metropolis sampler for the standard normal, implemented in plain R. The step size delta is varied to show the tuning trade-off, with trace plots, histograms, and effective sample size (via `astsa::ESS()`) making the consequences visible.

**Assumed background:** Basic probability; Markov chains are recalled briefly rather than developed. Peng (Advanced Statistical Computing, chapter 7) is the cited companion reference.

## What the Appendix Covers

- The problem framing: sample from p(x) given only the ability to evaluate it; the parallel and contrast with importance sampling (Ch 4).
- Markov chains: the conditional distribution of the present given the entire past reduces to dependence on the immediately preceding value; transition probabilities illustrated on a finite state space.
- Time reversal and detailed balance: the condition under which a chain has the desired stationary distribution, and the design principle behind Metropolis-Hastings.
- The Metropolis-Hastings algorithm: propose from a proposal distribution, accept or reject via the acceptance ratio; the Metropolis special case with a symmetric proposal.
- The standard-normal example: random-walk proposals, the acceptance log-ratio, and generated chains at several step sizes.
- Effect of step size: too small and the chain crawls (high autocorrelation, narrow coverage); too large and proposals are mostly rejected. The 20 to 50 percent acceptance-rate rule of thumb.
- Effective sample size: positively correlated draws carry less information than independent ones; `astsa::ESS()` quantifies how many independent observations the chain is worth.
- Diagnostics: trace plots (stationarity and mixing by eye), autocorrelation, multiple chains from dispersed starts, burn-in.
- Applications in machine learning: Bayesian posterior sampling, probabilistic graphical models, latent-variable models including topic models, uncertainty quantification; modern gradient-based variants (HMC, NUTS) and Stan as the practical toolchain.

## Common Misconceptions

**1. "MCMC gives you a random sample, like rnorm() but slower."**

MCMC draws are correlated by construction: each value is generated from the previous one. The sample is from the right distribution (eventually), but n MCMC draws carry the information of far fewer independent draws. That is exactly what effective sample size measures.

*Probe:* "Your chain produced 10,000 values and astsa::ESS() reports 400. What does that mean for the precision of your estimates?"

**2. "The chain samples from p from the very first step."**

The stationary distribution is where the chain converges, not where it starts. Early values reflect the arbitrary starting point, which is why burn-in samples are discarded. Convergence is assessed, not assumed: trace plots and multiple chains from different starting points are the working diagnostics.

*Probe:* "If you started the standard-normal sampler at x = 50, what would the first few hundred values look like, and would you want them in your sample?"

**3. "A higher acceptance rate means a better sampler."**

A near-100-percent acceptance rate usually means the proposals are tiny, so the chain barely moves and autocorrelation is severe. Near-zero acceptance means proposals are wild and the chain sticks. The rule of thumb targets 20 to 50 percent precisely because both extremes fail; the appendix's three step sizes make this visible.

*Probe:* "The smallest step size accepts almost every proposal yet has the worst effective sample size. How can accepting more proposals produce a worse sample?"

**4. "Detailed balance is a technicality to skip."**

Detailed balance is the design principle that makes the whole method work: it is the checkable condition guaranteeing that p is the chain's stationary distribution, and the Metropolis-Hastings acceptance ratio is constructed exactly so that detailed balance holds. Skipping it leaves the algorithm looking like magic.

*Probe:* "Where in the Metropolis acceptance rule does the target density p appear, and why does the rule only need p up to a normalizing constant?"

**5. "MCMC is only for Bayesians."**

Bayesian posterior sampling is the flagship application, but the method solves the general problem of sampling from any evaluable density: latent-variable models, graphical models, and uncertainty quantification all lean on it. The appendix's own example is not Bayesian at all.

*Probe:* "The standard-normal example has no prior and no posterior. What problem is MCMC solving there?"

## Scaffolding Strategies

**When the student arrives from Chapter 4:** Anchor on the contrast with importance sampling, which they already know: importance sampling reweights draws from a convenient distribution; MCMC instead constructs a process whose own long-run behavior is the target. Ask: "Both methods handle densities you can evaluate but not sample. When would reweighting break down, and why might a chain do better?"

**When the student arrives from Chapter 12:** Hand them the connection explicitly: an MCMC chain is a time series, and everything they learned there applies. The trace plot is a time series plot; mixing is low autocorrelation; `astsa::ESS()` is the very function from Chapter 12. Ask them to compute and interpret the ACF of the appendix's chains at each step size; the Chapter 12 vocabulary does the explanatory work.

**When the student arrives from Chapter 11:** Position MCMC as one of the two great inference strategies for latent-variable models (sampling versus optimization; the EM appendix is the optimization side). No need to develop Gibbs sampling formally; the point is that posterior inference in models like LDA needs machinery, and this is that machinery's family.

**When the student wants the mathematics:** The detailed-balance argument rewards a careful pass: have them verify that the Metropolis acceptance ratio makes the transition kernel satisfy detailed balance with respect to p, and notice that normalizing constants cancel. That cancellation is the practical superpower (p need only be known up to proportionality).

**When the student wants hands-on work:** The appendix's own sampler is the exercise. Natural explorations: vary delta beyond the three given values and chart ESS against acceptance rate; change the target density (the acceptance log-ratio is two lines); start the chain far from the mode and watch burn-in happen in the trace plot.

## Key Connections

**Backward into the chapters:**
- Ch 4 (Statistical Simulation): d/p/q/r sampling, Monte Carlo, and importance sampling are the prerequisites and the contrast class; the appendix redeems Ch 4's MCMC preview.
- Ch 12 (Time Series Data): stationarity, ACF, and effective sample size transfer wholesale; the chain is a time series.
- Ch 2 (Conditional Distributions): transition probabilities are conditional distributions.
- Ch 11 (Topic Models): latent-variable posteriors as a destination for this machinery.

**Beyond the book:** Hamiltonian Monte Carlo and NUTS (gradient-guided proposals), Stan as the modern probabilistic-programming toolchain, Gibbs sampling as the coordinate-wise special case. Acknowledge these as where practice has gone; the appendix's random-walk Metropolis is the conceptual foundation they build on.

## Terminology

| Term | Definition |
|------|-----------|
| Markov chain | Process whose present depends on the past only through the immediately preceding value |
| Transition probability | Conditional probability of the next state given the current one |
| Stationary distribution | Distribution the chain converges to and then preserves |
| Detailed balance | Reversibility condition guaranteeing a given stationary distribution |
| Proposal distribution | Distribution generating candidate moves in Metropolis-Hastings |
| Acceptance ratio | Probability of accepting a proposed move; constructed so detailed balance holds |
| Random-walk Metropolis | Metropolis with symmetric proposals centered at the current value |
| Burn-in | Early portion of the chain discarded as pre-convergence |
| Mixing | How rapidly the chain explores the target distribution |
| Trace plot | Time series plot of the chain, read for stationarity and mixing |
| Effective sample size (ESS) | Number of independent draws the correlated chain is worth |

## Companion Guidance

This is an appendix: there are no exercises, no learning objectives, and no place in the book's arc to defend. The student is here because something pointed them here. Find out what that was and serve it; the Entry Points table is the map.

The workspace may scaffold a ch16 folder and work file like any chapter's. If the student chooses to work the appendix that way, support it as self-directed exploration (the sampler variations above are the natural material), but do not impose chapter rituals such as summary expectations.

The single most valuable move available in this appendix is the Chapter 12 bridge: students who realize the chain is a time series suddenly own diagnostic tools they thought were new. Offer that bridge early to anyone with Chapter 12 behind them.

Keep the mathematics optional but available. The appendix states detailed balance without belaboring it; a student who wants the derivation should get an appreciative partner, and a student who wants to run samplers and read trace plots should never be made to feel the mathematics is an entry fee.
