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

class Results
	def self.wrap (pointer, length = nil) # :nodoc:
		new(pointer, length).tap {|x|
			ObjectSpace.define_finalizer x, finalizer(pointer)
		}
	end

	def self.finalizer (pointer) # :nodoc:
		proc {
			C.glyr_free_list(pointer)
		}
	end

	include Enumerable

	attr_reader :length

	def initialize (pointer, length = nil)
		@internal = pointer.is_a?(FFI::Pointer) ? C::MemCache.new(pointer) : pointer
		@length   = length
	end

	def each (&block)
		current = @internal

		until current.null?
			block.call(Result.wrap(current, self))

			current = C::MemCache.new(current[:next])
		end

		self
	end

	def to_native
		@internal
	end
end

class Result
	def self.wrap (struct, result) # :nodoc:
		return if struct[:type] == :noidea

		::Glyr.const_get(struct[:type].to_s.capitalize.gsub(/_(\w)/) { $1.upcase }).
			new(struct, result)
	end

	def self.copy (struct) # :nodoc:
		return if struct[:type] == :noidea

		pointer = C.glyr_cache_copy(struct)

		::Glyr.const_get(struct[:type].to_s.capitalize.gsub(/_(\w)/) { $1.upcase }).
			new(pointer).tap {|data|
				ObjectSpace.define_finalizer data, finalizer(pointer)
			}
	end

	def self.finalizer (pointer) # :nodoc:
		proc {
			C.glyr_cache_free(pointer)
		}
	end

	def initialize (pointer, result = nil)
		@internal = pointer.is_a?(FFI::Pointer) ? C::MemCache.new(pointer) : pointer
		@result   = result
	end

	def clone
		self.class.copy(to_native)
	end

	alias dup clone

	def data
		to_native[:data].typecast(:string, to_native[:size])
	end

	def url
		to_native[:dsrc].typecast(:string)
	end

	def source
		Glyr.providers[type].sources[to_native[:prov].typecast(:string)]
	end

	def rating
		to_native[:rating]
	end

	def rating= (value)
		to_native[:rating] = value
	end

	def type
		to_native[:type]
	end

	def to_native
		@internal
	end

	module Image
		def to_blob
			data
		end

		def format
			to_native[:img_format].typecast(:string)
		end
	end

	module Text
		def to_s
			string = data

			if string.force_encoding('UTF-8').valid_encoding?
				string
			elsif string.force_encoding('ISO-8859-1').valid_encoding?
				string.encode!('UTF-8')
			else
				string.encode!('UTF-8', invalid: :replace, undef: :replace)
			end

			string
		end

		alias to_str to_s
	end

end

class CoverArt < Result
	include Result::Image
end

class Lyrics < Result
	include Result::Text
end

class AlbumReview < Result
	include Result::Text
end

class ArtistPhoto < Result
	include Result::Image
end

class SimilarArtist < Result
	attr_reader :name, :url

	def initialize (*)
		super

		@name, _, @url = data.lines.map(&:chomp)
	end

end

class SimilarSong < Result
	attr_reader :title, :artist, :url

	def initialize (*)
		super

		@title, @artist, _, @url = data.lines.map(&:chomp)
	end
end

class AlbumList < Result
end

class Tag < Result
	include Result::Text
end

class TagArtist < Result
	include Result::Text
end

class TagAlbum < Result
	include Result::Text
end

class TagTitle < Result
	include Result::Text
end

class Relation < Result
	include Result::Text
end

class ImageUrl < Result
	include Result::Text
end

class TextUrl < Result
	include Result::Text
end

class Track < Result
	include Result::Text
end

class GuitarTabs < Result
	include Result::Text
end

class Backdrops < Result
	include Result::Text
end

end
