abstract type MarketData end

struct SimpleMarketData <: MarketData
	rate::AbstractFloat
	spot::AbstractFloat
	volatility::AbstractFloat
	dividend::AbstractFloat
end
