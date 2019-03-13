abstract type Instrument end
abstract type OptionContract <: Instrument end
abstract type VanillaOption <: OptionContract end
abstract type ExoticOption <: OptionContract end

@enum ExerciseStyle begin
	European
	American
	Bermudan
end

struct CallOption <: VanillaOption
	strike::AbstractFloat
	expiry::AbstractFloat
	style::ExerciseStyle
end

struct PutOption <: VanillaOption
	strike::AbstractFloat
	expiry::AbstractFloat
	style::ExerciseStyle
end

function payoff(option::CallOption, spot::AbstractFloat)
	return max(spot - option.strike, 0.0)
end

function payoff(option::PutOption, spot::AbstractFloat)
	return max(option.strike - spot, 0.0)
end
