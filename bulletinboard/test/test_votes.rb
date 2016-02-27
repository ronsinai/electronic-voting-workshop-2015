
class VotesAPITest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include TestHelper

  def app
    Sinatra::Application
  end

  def test_votes
    
    post "/sendVote", ballot_box: 4, serial_number: 12345, votes: [{vote_value: "qwert"}, {vote_value: "qazwsx"}]
    assert last_response.ok?
	post "/sendVote", ballot_box: 2, serial_number: 54321, votes: [{vote_value: "jjjj"}, {vote_value: "vvvv"}]
    assert last_response.ok?

    get "/getBBVotes", race_id: -1
    assert last_response.ok?
    parsed = JSON.parse last_response.body
    assert_equal 2, parsed.count

    assert_equal ["balot_box", "serial_number", "votes"],  parsed[ 0 ].keys
    assert_equal ["4"],      parsed[ 0 ][ "ballot_box" ]
    assert_equal ["12345"],            parsed[ 0 ][ "serial_number" ]
	assert_equal ["qwert", "qazwsx"],     parsed[ 0 ][ "votes" ]


    get "/getBBVotes", race_id: 2
    assert last_response.ok?
    parsed = JSON.parse last_response.body
    assert_equal 2, parsed.count

    assert_equal ["balot_box", "serial_number", "votes"],  parsed[ 0 ].keys
	assert_equal ["4"],      parsed[ 0 ][ "ballot_box" ]
    assert_equal ["2"],      parsed[ 1 ][ "ballot_box" ]
    assert_equal ["12345"],            parsed[ 0 ][ "serial_number" ]
	assert_equal ["54321"],            parsed[ 1 ][ "serial_number" ]
	assert_equal ["qwert"],     parsed[ 0 ][ "votes" ]
	assert_equal ["vvvv"],     parsed[ 1 ][ "votes" ]

  end

end
