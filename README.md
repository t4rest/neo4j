# neo4j

- Node labels are CamelCase and begin with an upper-case letter (examples: Person, NetworkAddress). Note that node 
  labels are case-sensitive.
- Property keys, variables, parameters, aliases, and functions are camelCase and begin with a lower-case letter 
  (examples: businessAddress, title). Note that these elements are case-sensitive.
- Relationship types are in upper-case and can use the underscore. (examples: ACTED_IN, FOLLOWS). Note that relationship 
  types are case-sensitive and that you cannot use the “-” character in a relationship type.
- Cypher keywords are upper-case (examples: MATCH, RETURN). Note that Cypher keywords are case-insensitive, but a best 
  practice is to use upper-case.
- String constants are in single quotes, unless the string contains a quote or apostrophe (examples: ‘The Matrix’, 
  “Something’s Gotta Give”). Note that you can also escape single or double quotes within strings that are quoted with the same using a backslash character.
- Specify variables only when needed for use later in the Cypher statement.
- Place named nodes and relationships (that use variables) before anonymous nodes and relationships in your MATCH 
  clauses when possible.
- Specify anonymous relationships with -->, --, or <--