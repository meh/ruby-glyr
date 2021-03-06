#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'glyr/c'

require 'glyr/version'
require 'glyr/query'
require 'glyr/database'
require 'glyr/results'
require 'glyr/providers'
require 'glyr/sources'

module Glyr
	# helper to create a Query object
	def self.query (options = {})
		Query.create(options)
	end

	def self.providers
		@providers ||= Providers.create
	end

	def self.cache_at (path = nil)
		if path
			@database = Database.create(path).write!.read!

			self
		else
			@database
		end
	end
end
