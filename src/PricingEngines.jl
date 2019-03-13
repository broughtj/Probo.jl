abstract type PricingEngine end
abstract type BinomialEngine <: PricingEngine end
abstract type MonteCarloEngine <: PricingEngine end
abstract type AnalyticEngine <: PricingEngine end

struct EuropeanBinomial <: BinomialEngine
	steps::Integer
end

struct AmericanBinomial <: BinomialEngine
	steps::Integer
end

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

