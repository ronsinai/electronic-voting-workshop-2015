require 'models/votes'
require 'models/ZKP'

post '/sendVote' do

  #todo: verify signature. need to have table for public keys
  
  for index in 0 ... params['votes'].size
    create = Votes.create(vote_value: params['votes'].fetch(index)['vote_value'],
                          ballot_box: params['ballot_box'].to_i,
                          serial_number: params['serial_number'].to_i,
                          race_id: index+1)
  end
  
end

get '/getBBVotes/:race_id' do |n|
    
  if n.to_i != -1
    votes_hash = Votes.where(race_id: n)
  else
  	votes_hash = Votes.all
  end
  
  	votes_hash.to_json(:except => :updated_at)
end


post '/publishZKP' do
	begin

		_signature = params['signature']
		_vote_id = params['vote_id'].to_i
		_race_id = params['race_id']
		_party_id = params['party_id'].to_i
		_zkp = params['zkp']

		#todo: verify signature. need to have table for public keys
	
		voteZkp = ZKP.find_by!(vote_id: _vote_id, race_id: _race_id, party_id: _party_id)
		raise "ZKP already exists for vote_id #{_vote_id}, race_id #{_race_id}, party_id #{_party_id}, zkp: #{_zkp}"

	rescue ActiveRecord::RecordNotFound
		newZkp = ZKP.create(vote_id: _vote_id, party_id: _party_id, race_id: _race_id, zkp: _zkp)
	end
  
end

get '/getZKP' do
    
  	ZKP.all.to_json(:except => :id)
  
end
