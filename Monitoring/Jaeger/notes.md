elasticsearch or not cassandra
- go with elastic search as it has higher flexibility and functionality searching 
- if tone of knowledge with the builing systems with cassandra then go for it

kafka or not
- optional piece 
- it provides a stable and durable queue once the backend is back online it gives the traffic

positionaling of agent
- as close as to the application!!
- it is the fastest way to off-load spans
- application is generating spans pretty quickly thus filling up the queue in the client and also it is UDP spans so closest it is less drops there will be

> **RECOMMENDED** setup 'remoteSampling'
it allows to centrally control all the different services and their sampling rates
like some endpoints 100% sample and for some 0% thus you have a higher level of flexibility 

traces and spans
