#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'ffi'
require 'ffi/extra'

module Glyr

module C
	extend FFI::Library

	ffi_lib 'glyr'
end

end

require 'glyr/c/types'
require 'glyr/c/functions'

Glyr::C.glyr_init

at_exit {
	Glyr::C.glyr_cleanup
}
