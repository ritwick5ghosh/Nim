import os
import json
import httpclient
import asyncdispatch
import threadpool

#synch web call
proc syncWebCall(i: int) = 
    let client = newHttpClient()
    echo "From " & $i & client.getContent("http://localhost:5000")

#synch web calls in parallel using spwan
proc doWebCallsInParallel() = 
    for i in 1..100:
        spawn syncWebCall(i)

doWebCallsInParallel()
sync()

proc serialTask(i: int) = 
    sleep(100)
    echo "Called with " & $i

#Parallel with spwan - uses threads from threadpool to execute task
proc doSomeThingInParallel() = 
    for i in 1..100:
        spawn serialTask(i)

#doSomeThingInParallel()
#sync()

#Asynch HTTP calls
proc callAsynchService() {.async.} =
    let client = newAsyncHttpClient()
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")
    echo await client.getContent("http://localhost:5000")

#waitFor(callAsynchService())

proc handleHttps() = 
    let client = newHttpClient()
    client.headers = newHttpHeaders({ "Content-Type": "application/x-www-form-urlencoded" })
    #[
        let body = %*{
        "username": "rghosh",
        "password": "P@ssword2"
    }
    ]#
    echo client.postContent("https://preprod.uno.walmart.com/uno-webservices/ws/security/checkLogin?username=rghosh&password=P%40ssword4", body = "")
    #echo client.postContent(url = "http://qa-int.uno.walmart.com:8080/uno-webservices/ws/security/checkLogin?username=rghosh&password=P%40ssword2", body = "")

proc tests() =
    #recursively searching through "/Users/rghosh/notespump/queue/" matching pattern *.txt
    for path in walkPattern(r"/Users/rghosh/notespump/queue/*.txt"):
        let
            #read contents of found txt file into contents 
            contents = readFile(path)
            #parsing this string contents into json
            json = parseJson(contents)

        if nil != json{"payload"} and nil != json{"payload"}{"customerNotesBatch"} and len(json["payload"]["customerNotesBatch"]) > 0:
            #getting the contents of the note from within payload > customerNotesBatch > [0] with the assumption that there will always be one note within this structure.
            let msg = json{"payload"}{"customerNotesBatch"}[0]
            #trying to get a specific attribute from the structure
            let customerAccountId = msg{"customerAccountId"}
            #echo json{"missing key"}.getFNum() #looking up missing key does not throw an error which means that we can remove the if above but it's good to have. 
            let herAge = 12
            #this is how we can create a new JSON using attributes already obtained in code like the customerAccountId
            let newJson = %*
                [
                    {
                    "name": "Name",
                    "id": customerAccountId
                    },
                    {
                    "name": "Susan",
                    "age": herAge
                    }
                ]
    
            echo newJson