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

class Query
	def self.create (options = {})
		struct = C::Query.new

		C.glyr_query_init(struct.pointer)

		wrap(struct.pointer, options)

	end

	def self.wrap (pointer, options = {})
		new(pointer, options).tap {|x|
			ObjectSpace.define_finalizer x, finalizer(pointer)
		}
	end

	def self.finalizer (pointer)
		proc {
			C.glyr_query_destroy(pointer)
		}
	end

	def initialize (pointer, options = {})
		@internal = pointer.is_a?(FFI::Pointer) ? C::Query.new(pointer) : pointer

		options.each {|name, value|
			if value == true
				__send__ "#{name}!"
			elsif value == false
				__send__ "no_#{name}!"
			else
				__send__ name, *value
			end
		}
	end

	def type (value)
		raise_if_error C.glyr_opt_type(to_native, value.is_a?(Symbol) ? value : C::GetType[value])
	end

	def artist (value)
		raise_if_error C.glyr_opt_artist(to_native, value)
	end

	def album (value)
		raise_if_error C.glyr_opt_album(to_native, value)
	end

	def title (value)
		raise_if_error C.glyr_opt_title(to_native, value)
	end

	def parallel (value)
		raise_if_error C.glyr_opt_parallel(to_native, value)
	end

	def timeout (value)
		raise_if_error C.glyr_opt_timeout(to_native, value)
	end

	def redirects (value)
		raise_if_error C.glyr_opt_redirects(to_native, value)
	end

	def user_agent (value)
		raise_if_error C.glyr_opt_useragent(to_native, value)
	end

	def language (value)
		raise_if_error C.glyr_opt_lang(to_native, value)
	end

	def language_aware!
		raise_if_error C.glyr_opt_lang_aware_only(to_native, true)
	end

	def no_language_aware!
		raise_if_error C.glyr_opt_lang_aware_only(to_native, false)
	end

	def number (value)
		raise_if_error C.glyr_opt_number(to_native, value)
	end

	def verbosity (value)
		raise_if_error C.glyr_opt_verbosity(to_native, value)
	end

	def from (*providers)
		raise_if_error C.glyr_opt_from(to_native, providers.flatten.compact.uniq.join(';'))
	end

	def allowed_formats (*formats)
		raise_if_error C.glyr_opt_allowed_formats(to_native, formats.flatten.compact.uniq.join(';'))
	end

	def download!
		raise_if_error C.glyr_opt_download(to_native, true)
	end

	def no_download!
		raise_if_error C.glyr_opt_download(to_native, false)
	end

	def fuzzyness (value)
		raise_if_error C.glyr_opt_fuzzyness(to_native, value)
	end

	def ratio (value)
		raise_if_error C.glyr_opt_qsratio(to_native, value)
	end

	def proxy (value)
		raise_if_error C.glyr_opt_proxy(to_native, value)
	end

	def force_utf8!
		raise_if_error C.glyr_opt_force_utf8(to_native, true)
	end

	def no_force_utf8!
		raise_if_error C.glyr_opt_force_utf8(to_native, false)
	end

	def get
		error  = FFI::MemoryPointer.new :int
		result = C.glyr_get(to_native, error, nil)

		raise_if_error error.typecast(:int)

		Result.wrap(result)
	end

	%w[cover_art lyrics artist_photos artist_bio similar_artists similar_songs album_reviews tracklist tags relations album_list guitar_tabs backdrops].each {|name|
		name = name.to_sym

		define_method name do
			type(name).get
		end
	}

	def stop
		C.glyr_signal_exit(to_native)
	end

	def to_native
		@internal
	end

private
	def raise_if_error (value)
		value = C::Error[value] unless value.is_a? Symbol

		if value != :ok
			raise C.glyr_strerror(value)
		end

		self
	end
end

end
