struct OptionFacade
	option::OptionContract
	engine::PricingEngine
	data::MarketData
end

function price(facade::OptionFacade)
	val = calculate(facade.option, facade.engine, facade.data)
end
