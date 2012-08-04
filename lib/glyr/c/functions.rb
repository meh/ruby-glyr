#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Glyr; module C

attach_function :glyr_init, [], :void
attach_function :glyr_cleanup, [], :void

attach_function :glyr_query_init, [:pointer], :void
attach_function :glyr_query_destroy, [:pointer], :void
attach_function :glyr_signal_exit, [:pointer], :void # this dumb name is aimed to stop a query

attach_function :glyr_get, [:pointer, :pointer, :pointer], :pointer
attach_function :glyr_free_list, [:pointer], :void

attach_function :glyr_cache_new, [], :pointer
attach_function :glyr_cache_free, [:pointer], :void
attach_function :glyr_cache_copy, [:pointer], :pointer
attach_function :glyr_cache_set_dsrc, [:pointer, :string], :void
attach_function :glyr_cache_set_prov, [:pointer, :string], :void
attach_function :glyr_cache_set_img_format, [:pointer, :string], :void
attach_function :glyr_cache_set_type, [:pointer, DataType], :void
attach_function :glyr_cache_set_rating, [:pointer, :int], :void
attach_function :glyr_cache_set_data, [:pointer, :pointer, :int], :void
attach_function :glyr_cache_write, [:pointer, :string], :int
attach_function :glyr_cache_update_md5sum, [:pointer], :void
attach_function :glyr_cache_print, [:pointer], :void

attach_function :glyr_opt_dlcallback, [:pointer, :DLCallback, :pointer], Error
attach_function :glyr_opt_type, [:pointer, GetType], Error
attach_function :glyr_opt_artist, [:pointer, :string], Error
attach_function :glyr_opt_album, [:pointer, :string], Error
attach_function :glyr_opt_title, [:pointer, :string], Error
attach_function :glyr_opt_img_minsize, [:pointer, :int], Error
attach_function :glyr_opt_img_maxsize, [:pointer, :int], Error
attach_function :glyr_opt_parallel, [:pointer, :ulong], Error
attach_function :glyr_opt_timeout, [:pointer, :ulong], Error
attach_function :glyr_opt_redirects, [:pointer, :ulong], Error
attach_function :glyr_opt_useragent, [:pointer, :string], Error
attach_function :glyr_opt_lang, [:pointer, :string], Error
attach_function :glyr_opt_lang_aware_only, [:pointer, :bool], Error
attach_function :glyr_opt_number, [:pointer, :ulong], Error
attach_function :glyr_opt_verbosity, [:pointer, :uint], Error
attach_function :glyr_opt_from, [:pointer, :string], Error
attach_function :glyr_opt_plugmax, [:pointer, :int], Error
attach_function :glyr_opt_allowed_formats, [:pointer, :string], Error
attach_function :glyr_opt_download, [:pointer, :bool], Error
attach_function :glyr_opt_fuzzyness, [:pointer, :int], Error
attach_function :glyr_opt_qsratio, [:pointer, :float], Error
attach_function :glyr_opt_proxy, [:pointer, :string], Error
attach_function :glyr_opt_force_utf8, [:pointer, :bool], Error
attach_function :glyr_opt_lookup_db, [:pointer, :pointer], Error
attach_function :glyr_opt_db_autowrite, [:pointer, :bool], Error
attach_function :glyr_opt_db_autoread, [:pointer, :bool], Error
attach_function :glyr_opt_musictree_path, [:pointer, :string], Error
attach_function :glyr_opt_normalize, [:pointer, :int], Error

attach_function :glyr_download, [:string, :pointer], :pointer
attach_function :glyr_strerror, [Error], :string
attach_function :glyr_version, [], :string

attach_function :glyr_info_get, [], :pointer
attach_function :glyr_info_free, [:pointer], :void

attach_function :glyr_data_type_to_string, [DataType], :string
attach_function :glyr_get_type_to_string, [GetType], :string
attach_function :glyr_md5sum_to_string, [:pointer], :string

attach_function :glyr_string_to_data_type, [:string], DataType
attach_function :glyr_string_to_get_type, [:string], GetType
attach_function :glyr_string_to_md5sum, [:string, :pointer], :void

attach_function :glyr_get_requirements, [GetType], :int

attach_function :glyr_type_is_image, [GetType], :bool

attach_function :glyr_db_init, [:string], :pointer
attach_function :glyr_db_destroy, [:pointer], :void
attach_function :glyr_db_lookup, [:pointer, :pointer], :pointer
attach_function :glyr_db_insert, [:pointer, :pointer, :pointer], :void
attach_function :glyr_db_delete, [:pointer, :pointer], :int
attach_function :glyr_db_edit, [:pointer, :pointer, :pointer], :int
attach_function :glyr_db_replace, [:pointer, :pointer, :pointer, :pointer], :void
attach_function :glyr_db_foreach, [:pointer, :glyr_foreach_callback, :pointer], :void
attach_function :glyr_db_make_dummy, [], :pointer

end; end
