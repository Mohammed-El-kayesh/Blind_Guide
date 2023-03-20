abstract class emergencyCallStates{}

class emergencyCallInitialState extends emergencyCallStates{}

class emergencyCallCreateDBState extends emergencyCallStates{}
class emergencyCallOpenDBState extends emergencyCallStates{}
class emergencyCallLoadedContacts extends emergencyCallStates{}
class emergencyCallErrorDBState extends emergencyCallStates{}

class emergencyCallInsertIntoDBSuccessfully extends emergencyCallStates{}
class emergencyCallInsertIntoDBError extends emergencyCallStates{}

class emergencyCallDeleteFromDBSuccessfully extends emergencyCallStates{}

