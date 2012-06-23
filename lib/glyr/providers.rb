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

class Providers
	class Provider
		def initialize (pointer, providers)
			@internal  = pointer.is_a?(FFI::Pointer) ? C::FetcherInfo.new(pointer) : pointer
			@providers = providers
		end

		def name
			to_native[:name]
		end

		def type
			to_native[:type]
		end

		def requirements
			FieldRequirements[to_native[:reqs]]
		end

		def sources
			Sources.new(to_native[:head], self)
		end

		alias to_s name

		alias to_sym type

		def to_native
			@internal
		end

		def inspect
			"#<Glyr::Provider(#{name}): #{requirements}>"
		end
	end

	def self.create
		pointer = C.glyr_info_get

		wrap(pointer)
	end

	def self.wrap (pointer)
		new(pointer).tap {|x|
			ObjectSpace.define_finalizer x, finalizer(pointer)
		}
	end

	def self.finalizer (pointer)
		proc {
			C.glyr_info_free(pointer)
		}
	end

	include Enumerable

	def initialize (pointer)
		@internal = pointer.is_a?(FFI::Pointer) ? C::FetcherInfo.new(pointer) : pointer
	end

	def each (&block)
		current = @internal

		until current.null?
			block.call(Provider.new(current, self))

			current = C::FetcherInfo.new(current[:next])
		end
	end

	def [] (name)
		find { |p| p.name == name || p.type == name }
	end

	def to_hash
		Hash[map { |p| [p.to_sym, p] }]
	end

	def to_native
		@internal
	end
end

end
