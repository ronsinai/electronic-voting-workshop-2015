require 'models/commitment'
require 'models/message'
require 'models/complaint'
require 'models/secret_commitment'
require 'models/VotingPublicKey'

def publish_and_retrieve( model, publish_url, retrieve_url )
    post publish_url do
		demand_valid_signature!( request )
        publication = model.create!( content: params[ "content" ].to_json )
    end

    get retrieve_url do
        all = model.all.to_a.map do |publication| 
            JSON.parse publication.content
        end
        all.to_json
    end
end

def publish_and_retrieve_without_signature( model, publish_url, retrieve_url )
    post publish_url do
        publication = model.create!( content: params[ "content" ].to_json )
    end

    get retrieve_url do
        all = model.all.to_a.map do |publication| 
            hash = JSON.parse publication.content
            hash
        end
        all.to_json
    end
end

publish_and_retrieve Commitment, '/publishCommitment', '/retrieveCommitment'
publish_and_retrieve SecretCommitment, '/publishSecretCommitment', '/retrieveSecretCommitment'
publish_and_retrieve_without_signature Complaint, '/publishComplaint', '/retrieveComplaint'
publish_and_retrieve_without_signature VotingPublicKey, '/publishVotingPublicKey', '/retrieveVotingPublicKey'
