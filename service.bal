import ballerina/io;
import ballerinax/github;
import ballerina/http;

type Repository record {
    
};

configurable string tokenVal = ?;

string[] recordArray=[];

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {
//comment
    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get githubinfo() returns string[]|error {
        // Send a response back to the caller.

        github:Client githubEp = check new (config = {
            auth: {
                token:tokenVal
            }
        });

        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories();
        //io:println(getRepositoriesResponse.toString());

        github:Repository[]? gitrepos = check from var rep in getRepositoriesResponse
            select rep;

        if(gitrepos is null){
            return error ("shit!");
        }    



        foreach var item in gitrepos {
            io:println("Count", item.stargazerCount.toBalString());
            io:println("Name", item.name);
            recordArray.push(item.name);
        }

        if (recordArray[0] is ""){
            return error ("More Shit!");
        }
        return recordArray;
    }
}
