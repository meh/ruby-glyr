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

class Result
	def self.wrap (pointer)
		new(pointer).tap {|x|
			ObjectSpace.define_finalizer x, finalizer(pointer)
		}
	end

	def self.finalizer (pointer)
		proc {
			C.glyr_free_list(pointer)
		}
	end

	class Data
		def self.wrap (struct, result)
			return new(struct, result) if struct[:type] == :noidea

			::Glyr.const_get(struct[:type].to_s.capitalize.gsub(/_(\w)/) { $1.upcase }).
				new(struct, result)
		end

		attr_reader   :result
		attr_accessor :rating

		def initialize (pointer, result)
			@internal = pointer.is_a?(FFI::Pointer) ? C::MemCache.new(pointer) : pointer
			@result   = result
		end

		def source
			to_native[:dsrc].read_string
		end

		def provider
			to_native[:prov].read_string
		end

		def to_native
			@internal
		end

		module Image
			def to_blob
				to_native[:data].read_string(to_native[:size]).force_encoding('BINARY')
			end

			def format
				to_native[:img_format].read_string
			end
		end

		module Text
			def to_s
				to_native[:data].read_string(to_native[:size])
			end

			alias to_str to_s
		end

		class ::Glyr::CoverArt < self
			include Image
		end

		class ::Glyr::Lyrics < self
			include Text
		end

		class ::Glyr::AlbumReview < self
			include Text
		end

		class ::Glyr::ArtistPhoto < self
			include Image
		end

		class ::Glyr::SimilarArtist < self
			attr_reader :name, :url

			def initialize (*)
				super

				@name, _, @url = to_native[:data].read_string(to_native[:size]).lines.map(&:chomp)
			end

		end

		class ::Glyr::SimilarSong < self
			attr_reader :title, :artist, :url

			def initialize (*)
				super

				@title, @artist, _, @url = to_native[:data].read_string(to_native[:size]).lines.map(&:chomp)
			end
		end

		class ::Glyr::AlbumList < self
		end

		class ::Glyr::Tag < self
			include Text
		end

		class ::Glyr::TagArtist < self
			include Text
		end

		class ::Glyr::TagAlbum < self
			include Text
		end

		class ::Glyr::TagTitle < self
			include Text
		end

		class ::Glyr::Relation < self
			include Text
		end

		class ::Glyr::ImageUrl < self
			include Text
		end

		class ::Glyr::TextUrl < self
			include Text
		end

		class ::Glyr::Track < self
			include Text
		end

		class ::Glyr::GuitarTabs < self
			include Text
		end

		class ::Glyr::Backdrops < self
			include Text
		end
	end

	include Enumerable

	def initialize (pointer)
		@internal = pointer.is_a?(FFI::Pointer) ? C::MemCache.new(pointer) : pointer
	end

	def each (&block)
		current = @internal

		until current.null?
			block.call(Data.wrap(current, self))

			current = C::MemCache.new(@internal[:next])
		end

		self
	end

	def to_native
		@internal
	end
end

end
