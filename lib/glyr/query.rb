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
	# create a Query object with the passed options
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

	def self.finalizer (pointer) # :nodoc:
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

	# tell the Query what you want to get
	def type (value = nil)
		if value
			raise_if_error C.glyr_opt_type(to_native, value.is_a?(Symbol) ? value : C::GetType[value])
		else
			to_native[:type]
		end
	end

	# set the artist
	def artist (value = nil)
		if value
			raise_if_error C.glyr_opt_artist(to_native, value)
		else
			to_native[:artist]
		end
	end

	# set the album
	def album (value = nil)
		if value
			raise_if_error C.glyr_opt_album(to_native, value)
		else
			to_native[:album]
		end
	end

	# set the title
	def title (value = nil)
		if value
			raise_if_error C.glyr_opt_title(to_native, value)
		else
			to_native[:title]
		end
	end

	# set the image size boundaries
	def image_boundaries (min = nil, max = min)
		if min && max
			raise_if_error C.glyr_opt_img_minsize(to_native, min)
			raise_if_error C.glyr_opt_img_maxsize(to_native, max)
		else
			[to_native[:img_min_size], to_native[:img_max_size]]
		end
	end

	# set the number of parallel searches
	def parallel (value = nil)
		if value
			raise_if_error C.glyr_opt_parallel(to_native, value)
		else
			to_native[:parallel]
		end
	end

	# set the timeout for the searching
	def timeout (value = nil)
		if value
			raise_if_error C.glyr_opt_timeout(to_native, value)
		else
			to_native[:timeout]
		end
	end

	# set the max amount of redirects
	def redirects (value = nil)
		if value
			raise_if_error C.glyr_opt_redirects(to_native, value)
		else
			to_native[:redirects]
		end
	end

	# set the user agent to use
	def user_agent (value = nil)
		if value
			raise_if_error C.glyr_opt_useragent(to_native, value)
		else
			to_native[:useragent]
		end
	end

	# set or get the language to search for
	def language (value = nil)
		if value
			raise_if_error C.glyr_opt_lang(to_native, value)
		else
			to_native[:lang]
		end
	end

	def language_aware?
		to_native[:lang_aware_only]
	end

	# only fetch from language aware providers
	def language_aware!
		raise_if_error C.glyr_opt_lang_aware_only(to_native, true)
	end

	# don't force language aware providers
	def no_language_aware!
		raise_if_error C.glyr_opt_lang_aware_only(to_native, false)
	end

	# set the maximum number of results
	def maximum (value = nil)
		if value
			raise_if_error C.glyr_opt_number(to_native, value)
		else
			to_native[:number]
		end
	end

	# set the maximum number of results per provider
	def maximum_per_provider (value = nil)
		if value
			raise_if_error C.glyr_opt_plugmax(to_native, value)
		else
			to_native[:plugmax]
		end
	end

	# set the level of verbosity
	def verbosity (value = nil)
		if value
			raise_if_error C.glyr_opt_verbosity(to_native, value)
		else
			to_native[:verbosity]
		end
	end

	# use only the passed providers (you can use all and disable single providers by prefixing
	# them with a -)
	def from (*providers)
		unless providers.empty?
			raise_if_error C.glyr_opt_from(to_native, providers.flatten.compact.uniq.join(';'))
		else
			to_native[:from] && to_native[:from].split(/\s*;\s*/)
		end
	end

	# use only the passed formats
	def allowed_formats (*formats)
		unless formats.empty?
			raise_if_error C.glyr_opt_allowed_formats(to_native, formats.flatten.compact.uniq.join(';'))
		else
			to_native[:allowed_formats] && to_native[:allowed_formats].split(/\s*;\s*/)
		end
	end

	def cache (value = nil)
		if value
			@cache = Database.create(value)
		else
			@cache
		end
	end

	def download?
		to_native[:download]
	end

	# download the data instead of just passing a URL
	def download!
		raise_if_error C.glyr_opt_download(to_native, true)
	end

	# don't download the data, just pass the URL
	def no_download!
		raise_if_error C.glyr_opt_download(to_native, false)
	end

	def fuzzyness (value = nil)
		if value
			raise_if_error C.glyr_opt_fuzzyness(to_native, value)
		else
			to_native[:fuzzyness]
		end
	end

	def ratio (value = nil)
		if value
			raise_if_error C.glyr_opt_qsratio(to_native, value)
		else
			to_native[:qsratio]
		end
	end

	# use the passed proxy to fetch the stuff
	def proxy (value = nil)
		if value
			raise_if_error C.glyr_opt_proxy(to_native, value)
		else
			to_native[:proxy]
		end
	end

	def path (value = nil)
		if value
			raise_if_error C.glyr_opt_musictree_path(to_native, vlaue)
		else
			to_native[:musictree_path]
		end
	end

	def force_utf8?
		to_native[:force_utf8]
	end

	def force_utf8!
		raise_if_error C.glyr_opt_force_utf8(to_native, true)
	end

	def no_force_utf8!
		raise_if_error C.glyr_opt_force_utf8(to_native, false)
	end

	def get (&block)
		error  = FFI::MemoryPointer.new :int
		length = FFI::MemoryPointer.new :int

		if block
			raise_if_error C.glyr_opt_dlcallback(to_native, proc {|data, query|
				result = block.call(Result.copy(C::MemCache.new(data)))

				if result.respond_to? :to_i
					C::Error[result.to_i]
				elsif result.respond_to? :to_sym
					result.to_sym.downcase
				else
					:ok
				end
			}, nil)
		else
			raise_if_error C.glyr_opt_dlcallback(to_native, nil, nil)
		end

		if db = cache || Glyr.cache_at
			raise_if_error C.glyr_opt_lookup_db(to_native, db.to_native)
			raise_if_error C.glyr_opt_db_autoread(to_native, true) if db.read?
			raise_if_error C.glyr_opt_db_autowrite(to_native, true) if db.write?
		end

		result = C.glyr_get(to_native, error, length)

		raise_if_error error.typecast(:int)

		Results.wrap(result, length.typecast(:int))
	end

	%w[cover_art lyrics artist_photos artist_bio similar_artists similar_songs album_reviews tracklist tags relations album_list guitar_tabs backdrops].each {|name|
		name = name.to_sym

		define_method name do |&block|
			type(name).get(&block)
		end
	}

	# stop the current fetching
	def stop
		C.glyr_signal_exit(to_native)
	end

	# get the FFI::Struct
	def to_native
		@internal
	end

private
	def raise_if_error (value) # :nodoc:
		value = C::Error[value] unless value.is_a? Symbol

		if value != :ok
			raise C.glyr_strerror(value)
		end

		self
	end
end

end
