commands = [
'set server.http-service.access-log.format="common"',
'set server.http-service.access-logging-enabled=true',
'set server.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size=128',
'create-jdbc-connection-pool --datasourceclassname org.apache.derby.jdbc.ClientDataSource --restype javax.sql.DataSource --failconnection=true --steadypoolsize 2 --maxpoolsize 8 --ping --property "icatProperties=Password=APP:User=APP:serverName=localhost:DatabaseName=icat:connectionAttributes=\\";\\"create\\"\'\\"=\\"\'\\"true\\" icat',
'create-jdbc-resource --connectionpoolid icat jdbc/icat',
'create-jms-resource --restype javax.jms.QueueConnectionFactory jms/ICATQueueConnectionFactory',
'create-jms-resource --restype javax.jms.TopicConnectionFactory jms/ICATTopicConnectionFactory',
'create-jms-resource --restype javax.jms.Queue jms/ICATQueue',
'create-jms-resource --restype javax.jms.Topic jms/ICATTopic'
]

  commands.each {
    |command| 
    glassfish_asadmin "#{command}" do
       username "admin"
       password_file "testpassword"    
       domain_name 'domain1'
   end
  }
