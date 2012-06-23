#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Glyr

class Sources
	class Source
		attr_reader :provider

		def initialize (pointer, provider)
			@internal = pointer.is_a?(FFI::Pointer) ? C::SourceInfo.new(pointer) : pointer
			@provider = provider
		end

		def name
			to_native[:name]
		end

		def key
			to_native[:key].chr
		end

		def quality
			to_native[:quality]
		end
		
		def speed
			to_native[:speed]
		end

		def language_aware?
			to_native[:lang_aware]
		end

		alias to_s name

		def to_sym
			to_s.to_sym
		end

		def to_native
			@internal
		end

		def inspect
			"#<Glyr::Source(#{name}): quality=#{quality} speed=#{speed}#{' language_aware' if language_aware?}>"
		end
	end

	include Enumerable

	attr_reader :provider

	def initialize (pointer, provider)
		@internal = pointer.is_a?(FFI::Pointer) ? C::SourceInfo.new(pointer) : pointer
		@provider = provider
	end

	def each (&block)
		current = @internal

		until current.null?
			block.call(Source.new(current, provider))

			current = C::SourceInfo.new(current[:next])
		end
	end

	def [] (name)
		find { |p| p.name == name || p.key == name }
	end

	def to_hash
		Hash[map { |p| [p.to_sym, p] }]
	end

	def to_native
		@internal
	end
end

end
