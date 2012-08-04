#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'bitmap'

module Glyr; module C

Error = FFI::Enum.new([
	:unknown, 0,
	:ok,
	:bad_option,
	:bad_value,
	:empty_struct,
	:no_provider,
	:unknown_get,
	:insuff_data,
	:skip,
	:stop_post,
	:stop_pre,
	:no_init,
	:was_stopped
])

GetType = FFI::Enum.new([
	:noidea,
	:cover_art,
	:lyrics,
	:artist_photos,
	:artist_bio,
	:similar_artists,
	:similar_songs,
	:album_reviews,
	:tracklist,
	:tags,
	:relations,
	:album_list,
	:guitar_tabs,
	:backdrops,
	:any
])

DataType = FFI::Enum.new([
	:noidea,
	:lyrics,
	:album_review,
	:artist_photo,
	:cover_art,
	:artist_bio,
	:similar_artist,
	:similar_song,
	:album_list,
	:tag,
	:tag_artist,
	:tag_album,
	:tag_title,
	:relation,
	:image_url,
	:text_url,
	:track,
	:guitar_tabs,
	:backdrops
])

Normalization = Bitmap.new(
	none:       1 << 0,
	moderate:   1 << 1,
	aggressive: 1 << 2,
	artist:     1 << 3,
	album:      1 << 4,
	title:      1 << 5
)

FieldRequirement = Bitmap.new(
	requires_artist: 1 << 0,
	requires_album:  1 << 1,
	requires_title:  1 << 2,
	optional_artist: 1 << 3,
	optional_album:  1 << 4,
	optional_title:  1 << 5
)

callback :DLCallback, [:pointer, :pointer], Error

class MemCache < FFI::Struct
	layout \
		:data,       :pointer,
		:size,       :size_t,
		:dsrc,       :pointer,
		:prov,       :pointer,
		:type,       DataType,
		:duration,   :int,
		:rating,     :int,
		:is_image,   :bool,
		:img_format, :pointer,
		:md5sum,     [:uchar, 16],
		:cached,     :bool,
		:timestamp,  :double,

		:next, :pointer,
		:prev, :pointer
end

callback :glyr_foreach_callback, [:pointer, :pointer, :pointer], :int

class Database < FFI::Struct
	layout \
		:root_path, :pointer,
		:db_handle, :pointer
end

class Query < FFI::Struct
	class Callback < FFI::Struct
		layout \
			:download,     :DLCallback,
			:user_pointer, :pointer
	end

	layout \
		:type,      GetType,
		:number,    :int,
		:plugmax,   :int,
		:verbosity, :int,
		:fuzzyness, :size_t,
		
		:img_min_size, :int,
		:img_max_size, :int,

		:parallel,  :int,
		:timeout,   :int,
		:redirects, :int,

		:force_utf8, :bool,
		:download,   :bool,
		:qsratio,    :float,

		:q_errno, Error,

		:db_autoread,  :bool,
		:db_autowrite, :bool,
		:local_db,     :pointer,

		:lang_aware_only, :bool,

		:signal_exit, :int,

		:lang,            :string,
		:proxy,           :string,
		:artist,          :string,
		:album,           :string,
		:title,           :string,
		:from,            :string,
		:allowed_formats, :string,
		:useragent,       :string,
		:musictree_path,  :string,

		:callback, Callback,

		:itemcr,         :int,
		:info,           [:pointer, 10],
		:imagejob,       :bool,
		:is_initialized, :bool
end

class SourceInfo < FFI::Struct
	layout \
		:name,       :string,
		:key,        :char,
		:type,       GetType,
		:quality,    :int,
		:speed,      :int,
		:lang_aware, :bool,

		:next, :pointer,
		:prev, :pointer
end

class FetcherInfo < FFI::Struct
	layout \
		:name, :string,
		:type, GetType,
		:reqs, :int,
		:head, :pointer,

		:next, :pointer,
		:prev, :pointer
end

end; end
