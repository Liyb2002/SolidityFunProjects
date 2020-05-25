pragma solidity >=0.4.22 <0.7.0;

contract Voting {
    struct Voter {
        uint8 id;
        string name;
        uint8 weight; 
        bool voted;  
        uint8 votedForWho;   
    }
    
     struct Candidate {
        string name;   
        uint16 voteCount; 
    }
    
    constructor ()public{
        chairMan=msg.sender;
        //chairMan is also an admin
        admins.push(msg.sender);
        
    }
    //admins can also approve candidates
    address []admins;
    Candidate [] public candidates;
    Voter [] public waitApprove;
    mapping(address => Voter) public voters;
    address public chairMan;
    uint8 VoterId=0;
    
    function createCandidate(string memory name) public{
        candidates.push(Candidate(name, 0));
    }
    
    //chairMan can add admins to help him regulate
    function addAdmins(address admin)public{
        require(msg.sender==chairMan, "Only chairMan can addAdmins");
        admins.push(admin);
    }
    
    function isAdmin(address admin)public view returns(bool){
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i]==admin) {
                return true;
            }
        }
        return false;
    }
    
    //Voters need to RegisterForVote
    function RegisterForVote(string memory voterName)public{
        waitApprove.push(voters[msg.sender]);
        voters[msg.sender].name=voterName;
        voters[msg.sender].id=VoterId;
        VoterId++;
    }
    
    //chairMan choose to approve all voters
    function approveAllVotes()public{
        require(isAdmin(msg.sender), "Only chairMan can approveVotes");
        for (uint i = 0; i < waitApprove.length; i++) {
            if (waitApprove[i].weight ==0) {
                waitApprove[i].weight = 1;
            }
        }
    }
    
    //chairMan choose to approve certain voter
    function giveRightToVote(address voter) public {
        require(isAdmin(msg.sender), "Only chairMan or admins can approveVotes");
        require(!voters[voter].voted,"The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }
    
    //Votes vote for candidates
    function Vote(uint8 candidateNumber)public{
        Voter storage sender = voters[msg.sender];
        sender.voted = true;
        sender.votedForWho=candidateNumber;
        candidates[candidateNumber].voteCount+=sender.weight;
    }
    
    //return winning candidate's name and count
     function winningCandidate() public view returns (string memory candidateName, uint16 winningVoteCount){
        winningVoteCount = 0;
        uint winningCandidateId=0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winningCandidateId = p;
            }
        }
        candidateName=candidates[winningCandidateId].name;
        
    }
    
}