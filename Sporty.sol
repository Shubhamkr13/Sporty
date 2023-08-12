// SPDX-License-Identifier: MIT
pragma solidity =0.8.18;

contract Sports {

    struct Turf {
        uint turfId;
        address turfOwner;
        string turfName;
        bool isRegistered;
    }

    struct Tournament {
        uint turfId;
        address turfOwner;
        uint tournamentId;
        string tournamentName;
        bool created;
        uint noOfParticipants;
        uint playersPerTeam;
        uint entryFeesAmount;

    }

    struct Participant {
        uint participantId;
        address participant;
        string participantName;
        uint noOfPlayersPerTeam;
        bool participated;
        uint turfId;
        uint tournamentId;
        
    }

    Tournament[] public listOfTournaments;

    mapping (uint => Turf) public turfDetails;
    mapping (uint => Participant) public participationDetails;

    error AlreadyParticipatedInThisTournament();
    error noOfPlayersCriteriaMismatched();
    error entryFeesAmountIsWrong();
    error YourTurfIsNotRegistered();

    uint turfDetailsKey = 1;
    uint participationDetailsKey = 1;

    uint public tournamentId = 1;
    uint public turfId = 0;
    uint public participantId = 1;
    uint public _arrayIndex = 0;


    modifier participationCriteria(uint _turfId, uint _tournamentId, uint _noOfPlayersPerTeam) {
        if (participationDetails[_tournamentId].participated) {
            revert AlreadyParticipatedInThisTournament();
        }

        if (listOfTournaments[_arrayIndex].playersPerTeam != _noOfPlayersPerTeam) {
            revert noOfPlayersCriteriaMismatched();
        }

        if (listOfTournaments[_arrayIndex].entryFeesAmount != msg.value) {
            revert entryFeesAmountIsWrong();
        }
        _;
    }

    modifier isTurfRegistered(uint _turfId) {
        
        if(!turfDetails[_turfId].isRegistered) {
            revert YourTurfIsNotRegistered();
        }
        _;

    }

    function registerTurf(string memory _turfName) public {
        
        uint _turfId = turfId;
        _turfId++;
        turfDetails[turfDetailsKey] = Turf(_turfId, msg.sender, _turfName, true);     
        turfDetailsKey++;
        turfId = _turfId;

    }
        

    function createTournament(uint _turfId, string memory _tournamentName,uint _noOfParticipants, uint _playersPerTeam, uint _entryFeesAmount) public isTurfRegistered(_turfId) {
        uint _newTournamentId = tournamentId;
        listOfTournaments.push(Tournament(_turfId, msg.sender, _newTournamentId, _tournamentName, true, _noOfParticipants, _playersPerTeam, _entryFeesAmount));
        _newTournamentId++;
        tournamentId = _newTournamentId;
        
    }


    function participantRegistration(string memory _participantName, uint _turfId ,uint _tournamentId, uint _noOfPlayersPerTeam) public payable participationCriteria(_turfId, _tournamentId, _noOfPlayersPerTeam) {
        
        uint _participantId = participantId;
        participationDetails[participationDetailsKey] = Participant(_participantId, msg.sender, _participantName, _noOfPlayersPerTeam, true, _turfId, _tournamentId);
        _participantId++;
        participationDetailsKey++;
        participantId = _participantId;
    }
    
}

