require 'minitest/assertions'

module MiniTest::Assertions

	def dado_que(qqcoisa)
	    qqcoisa
	end

	alias_method :quando, :dado_que
	alias_method :entao, :dado_que
	alias_method :e, :dado_que

	def assert_false(actual)
	    assert_equal false, actual
	end

	def assert_not_nil(actual)
	    assert_false actual.nil?
	end

	def assert_raises_with_message(exception, msg, &block)
	    begin
	      block.call
	    rescue exception => e
				assert_match msg, e.message
				return
	    end
			fail "Deveria ter lançado [#{exception}] com a mensagem [#{msg}]"
	end


end
