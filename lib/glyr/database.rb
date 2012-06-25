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

class Database
	# create a Query object with the passed options
	def self.create (path)
		pointer = C.glyr_db_init(path)

		if pointer.null?
			raise ArgumentError, "could not open/create database at #{path}"
		end

		wrap(pointer)
	end

	def self.wrap (pointer)
		puts pointer.inspect

		new(pointer).tap {|x|
			ObjectSpace.define_finalizer x, finalizer(pointer)
		}
	end

	def self.finalizer (pointer) # :nodoc:
		proc {
			C.glyr_db_destroy(pointer)
		}
	end

	include Enumerable

	def initialize (pointer)
		@internal = pointer.is_a?(FFI::Pointer) ? C::Database.new(pointer) : pointer
	end

	def path
		to_native[:root_path]
	end

	def write?; !!@write; end
	def read?;  !!@read;  end

	def write!
		@write = true

		self
	end

	def read!
		@read = true

		self
	end

	def lookup (query)
		Results.wrap(C.glyr_db_lookup(to_native, query.to_native))
	end

	def insert (query, results)
		C.glyr_db_insert(to_native, query.to_native, results.to_native)

		self
	end

	def delete (query)
		C.glyr_db_delete(to_native, query.to_native)
	end

	def replace (query, results)
		C.glyr_db_edit(to_native, query.to_native, results.to_native)
	end

	def swap (query, a, b)
		C.glyr_db_replace(to_native, a.respond_to?(:md5) ? a.md5 : a.to_s, query.to_native, b.to_native)

		self
	end

	def each (&block)
		C.glyr_db_foreach(to_native, proc {|query, item|
			block.call [Query.new(query), Result.new(item)]
		}, nil)

		self
	end

	def to_native
		@internal
	end
end

end
