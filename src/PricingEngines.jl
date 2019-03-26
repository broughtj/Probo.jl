abstract type PricingEngine end
abstract type BinomialEngine <: PricingEngine end
abstract type MonteCarloEngine <: PricingEngine end
abstract type AnalyticEngine <: PricingEngine end


## Stucts here

struct EuropeanBinomial <: BinomialEngine
	steps::Integer
end

struct AmericanBinomial <: BinomialEngine
	steps::Integer
end

struct NaiveMonteCarlo <: MonteCarloEngine
    steps::Integer
    repititions::Integer
end

#=
struct LeastSquaresMonteCarlo <: MonteCarloEngine
    steps::Integer
    repititions::Integer
end
=#


## Methods here

function calculate(option::VanillaOption, engine::EuropeanBinomial, data::MarketData)
	return 3.14
end

function calculate(option::VanillaOption, engine::AmericanBinomial, data::MarketData)
	nodes = engine.steps + 1
	dt = option.expiry / engine.steps
	u = exp((data.rate - data.dividend) * dt + data.volatility * sqrt(dt))
	d = exp((data.rate - data.dividend) * dt - data.volatility * sqrt(dt))
	pu = (exp((data.rate - data.dividend) * dt) - d) / (u - d)
	pd = 1.0 - pu
	df = exp(-data.rate * dt)
	dpu = df * pu
	dpd = df * pd

	Ct = zeros(nodes)
	St = zeros(nodes)

	for i in 1:nodes
		St[i] = data.spot * (u ^ (engine.steps - i + 1)) * (d ^ (i-1))
		Ct[i] = payoff(option, St[i])
	end

	for i in engine.steps:-1:1
		for j in 1:i
			Ct[j] = dpu * Ct[j] + dpd * Ct[j+1]
			St[j] /= u
			St[j] = max(Ct[j], payoff(option, St[j]))
		end
	end

	return Ct
end

function calculate(option::VanillaOption, engine::NaiveMonteCarloEngine, data::MarketData)
    rate = data.rate
    spot = data.spot
    vol = data.volatility
    div = data.dividend
    
    dt = option.expiry / engine.steps
    z = randn(engine.repititions)
    spotT = zeros(engine.repititions)
    prcT = zeros(engine.repititions)
    drift = (rate - div - 0.5 * vol * vol) * dt
    sigma = vol * sqrt(dt)
    
    for i in 1:engine.repetititions
        spotT[i] = spot * exp(drift + sigma * z[i])
        prcT[i] = payoff(option, spotT[i])
    end
    
    prc = mean(prcT)
    prc *= exp(-data.rate * dt)
    
    return prc
    
end

#=
function calcualte(option::VanillaOption, engine::LeastSquaresMonteCarlo, data::MarketData)
   return 9.21233 
end
=#  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    