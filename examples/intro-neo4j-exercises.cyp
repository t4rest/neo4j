// :play intro-neo4j-exercises

// 1
CALL db.schema.visualization();       // Data model - returns information about the nodes, labels, and relationships in the graph
CALL db.propertyKeys();               // Retrieve all properties
CALL db.schema.nodeTypeProperties();  //
CALL db.schema.relTypeProperties()    //
MATCH ()-->() RETURN COUNT(*);        // Count all relationships
MATCH (n) RETURN count(n);            // Count all nodes
MATCH (n) RETURN n;                   // Retrieve all nodes from the database
// Retrieve all Movie nodes that have a released property value of 2003.
MATCH (m:Movie {released: 2003}) RETURN m;
// Retrieve all movies that are connected to the person, Tom Hanks.
MATCH (m:Movie)<--(:Person {name: 'Tom Hanks'}) RETURN m.title;
// Retrieve information about the relationships Tom Hanks has with the set of movies retrieved earlier.
MATCH (m:Movie)-[rel]-(:Person {name: 'Tom Hanks'}) RETURN m.title, type(rel)
// Retrieve all people who wrote the movie Speed Racer.
MATCH (p:Person)-[:WROTE]->(:Movie {title: 'Speed Racer'}) RETURN p.name;
// Retrieve information about the roles that Tom Hanks acted in
MATCH (m:Movie)-[rel:ACTED_IN]-(:Person {name: 'Tom Hanks'}) RETURN m.title, rel.roles;


// 2
// Retrieve all movies that Tom Cruise acted in
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE a.name = 'Tom Cruise' RETURN m.title AS Movie
// Retrieve all people that were born in the 70’s
MATCH (a:Person) WHERE a.born >= 1970 AND a.born < 1980 RETURN a.name AS Name, a.born AS `Year Born`
// Retrieve the actors who acted in the movie The Matrix who were born after 1960
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE a.born > 1960 AND m.title = 'The Matrix' RETURN a.name AS Name, a.born AS `Year Born`;
// Retrieve all movies by testing the node label and a property
MATCH (m) WHERE m:Movie AND m.released = 2000 RETURN m.title;
// Retrieve all people that wrote movies by testing the relationship between two nodes
MATCH (a)-[rel]->(m) WHERE a:Person AND type(rel) = 'WROTE' AND m:Movie RETURN a.name AS Name, m.title AS Movie;
// Retrieve all people in the graph that do not have a born property, returning their names.
MATCH (a:Person) WHERE NOT exists(a.born) RETURN a.name AS Name;


// 3
// Retrieve all people related to movies where the relationship has the rating property, then return their name, movie title, and the rating.
MATCH (a:Person)-[rel]->(m:Movie) WHERE exists(rel.rating) RETURN a.name AS Name, m.title AS Movie, rel.rating AS Rating;
// Retrieve all actors whose name begins with James, returning their names.
MATCH (a:Person)-[:ACTED_IN]->(:Movie) WHERE a.name STARTS WITH 'James' RETURN a.name;
// Retrieve all all REVIEW relationships from the graph where the summary of the review contains the string fun,
// returning the movie title reviewed and the rating and summary of the relationship.
MATCH (:Person)-[r:REVIEWED]->(m:Movie) WHERE toLower(r.summary) CONTAINS 'fun' RETURN  m.title AS Movie, r.summary AS Review, r.rating AS Rating
// Retrieve all people who have produced a movie, but have not directed a movie, returning their names and the movie titles.
MATCH (a:Person)-[:PRODUCED]->(m:Movie) WHERE NOT ((a)-[:DIRECTED]->(:Movie)) RETURN a.name, m.title;
// Retrieve the movies and their actors where one of the actors also directed the movie, returning the actors names,
// the director’s name, and the movie title.
MATCH (a1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(a2:Person) WHERE exists( (a2)-[:DIRECTED]->(m) )
RETURN  a1.name AS Actor, a2.name AS `Actor/Director`, m.title AS Movie;


// 4
// Retrieve all movies that were released in the years 2000, 2004, and 2008, returning their titles and release years.
MATCH (m:Movie) WHERE m.released IN [2000, 2004, 2008] RETURN m.title, m.released;
// Retrieve the movies that have an actor’s role that is the name of the movie, return the movie title and the role.
MATCH (a:Person)-[r:ACTED_IN]->(m:Movie) WHERE m.title IN r.roles RETURN  m.title AS Movie, a.name AS Actor;
// Write a Cypher query that retrieves all movies that Gene Hackman has acted it, along with the directors of the movies.
// In addition, retrieve the actors that acted in the same movies as Gene Hackman. Return the name of the movie,
// the name of the director, and the names of actors that worked with Gene Hackman.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person), (a2:Person)-[:ACTED_IN]->(m) WHERE a.name = 'Gene Hackman'
RETURN m.title AS movie, d.name AS director, a2.name AS `co-actors`;
// Retrieve all nodes that the person named James Thompson directly has the FOLLOWS relationship in either direction.
MATCH (p1:Person)-[:FOLLOWS]-(p2:Person) WHERE p1.name = 'James Thompson' RETURN p1, p2;
// Modify the query to retrieve nodes that are exactly three hops away.
MATCH (p1:Person)-[:FOLLOWS*3]-(p2:Person) WHERE p1.name = 'James Thompson' RETURN p1, p2;
// Modify the query to retrieve nodes that are one and two hops away.
MATCH (p1:Person)-[:FOLLOWS*1..2]-(p2:Person) WHERE p1.name = 'James Thompson' RETURN p1, p2;
// Modify the query to retrieve all nodes that are connected to James Thompson by a Follows relationship no matter how many hops are required.
MATCH (p1:Person)-[:FOLLOWS*]-(p2:Person) WHERE p1.name = 'James Thompson' RETURN p1, p2;


// 5
// Write a Cypher query to retrieve all people in the graph whose name begins with Tom and optionally
// retrieve all people named Tom who directed a movie.
MATCH (p:Person) WHERE p.name STARTS WITH 'Tom' OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie) RETURN p.name, m.title;
// Retrieve actors and the movies they have acted in, returning each actor’s name and the list of movies they acted in.
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) RETURN p.name AS actor, collect(m.title) AS `movie list`;
// Retrieve all movies that Tom Cruise has acted in and the co-actors that acted in the same movie,
// returning the movie title and the list of co-actors that Tom Cruise worked with.
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person) WHERE p.name ='Tom Cruise'
RETURN m.title AS movie, collect(p2.name) AS `co-actors`;
// Retrieve all people who reviewed a movie, returning the list of reviewers and how many reviewers reviewed the movie.
MATCH (p:Person)-[:REVIEWED]->(m:Movie) RETURN m.title AS movie, count(p) AS numReviews, collect(p.name) AS reviewers;
// Retrieve all directors, their movies, and people who acted in the movies, returning the name of the director,
// the number of actors the director has worked with, and the list of actors.
MATCH (d:Person)-[:DIRECTED]->(m:Movie)<-[:ACTED_IN]-(a:Person)
RETURN d.name AS director, count(a) AS `number actors`, collect(a.name) AS `actors worked with`;
// Retrieve the actors who have acted in exactly five movies, returning the name of the actor, and the list of movies for that actor.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WITH  a, count(a) AS numMovies, collect(m.title) AS movies WHERE numMovies = 5
RETURN a.name, movies;
// Retrieve the movies that have at least 2 directors, and optionally the names of people who reviewed the movies.
MATCH (m:Movie) WITH m, size((:Person)-[:DIRECTED]->(m)) AS directors WHERE directors >= 2 OPTIONAL MATCH (p:Person)-[:REVIEWED]->(m)
RETURN  m.title, p.name;


// 6
// You want to know what actors acted in movies in the decade starting with the year 1990. First write a query to retrieve
// all actors that acted in movies during the 1990s, where you return the released date, the movie title,
// and the collected actor names for the movie. For now do not worry about duplication.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 AND m.released < 2000
RETURN DISTINCT m.released, m.title, collect(a.name);
// The results returned from the previous query include multiple rows for a movie released value. Next, modify the query
// so that the released date records returned are not duplicated. To implement this, you must add the collection of the
// movie titles to the results returned.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 AND m.released < 2000
RETURN  m.released, collect(m.title), collect(a.name);
// The results returned from the previous query returns the collection of movie titles with duplicates. That is because
// there are multiple actors per released year. Next, modify the query so that there is no duplication of the movies listed for a year.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 AND m.released < 2000
RETURN  m.released, collect(DISTINCT m.title), collect(a.name);
// Modify the query that you just wrote to order the results returned so that the more recent years are displayed first.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 AND m.released < 2000
RETURN  m.released, collect(DISTINCT m.title), collect(a.name) ORDER BY m.released DESC;
// Retrieve the top 5 ratings and their associated movies, returning the movie title and the rating.
MATCH (:Person)-[r:REVIEWED]->(m:Movie) RETURN  m.title AS movie, r.rating AS rating ORDER BY r.rating DESC LIMIT 5;
// Retrieve all actors that have not appeared in more than 3 movies. Return their names and list of movies.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WITH a, count(a) AS numMovies, collect(m.title) AS movies WHERE numMovies <= 3
RETURN a.name, movies;


// 7
// Write a Cypher query that retrieves all actors that acted in movies, and also retrieves the producers for those movies.
// During the query, collect the names of the actors and the names of the producers. Return the movie titles,
// along with the list of actors for each movie, and the list of producers for each movie making sure there is no duplication of data.
// Order the results returned based upon the size of the list of actors.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie), (m)<-[:PRODUCED]-(p:Person)
WITH  m, collect(DISTINCT a.name) AS cast, collect(DISTINCT p.name) AS producers
RETURN DISTINCT m.title, cast, producers ORDER BY size(cast);
// Write a Cypher query that retrieves all actors that acted in movies, and collects the list of movies for any actor
// that acted in more than five movies. Return the name of the actor and the list.
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) WITH p, collect(m) AS movies WHERE size(movies)  > 5 RETURN p.name, movies;
// Modify the query you just wrote so that before the query processing ends, you unwind the list of movies and then
// return the name of the actor and the title of the associated movie
MATCH (p:Person)-[:ACTED_IN]->(m:Movie) WITH p, collect(m) AS movies WHERE size(movies)  > 5
WITH p, movies UNWIND movies AS movie RETURN p.name, movie.title;
// Write a query that retrieves all movies that Tom Hanks acted in, returning the title of the movie, the year the movie
// was released, the number of years ago that the movie was released, and the age of Tom when the movie was released.
MATCH (a:Person)-[:ACTED_IN]->(m:Movie) WHERE a.name = 'Tom Hanks'
RETURN  m.title, m.released, date().year - m.released AS yearsAgoReleased, m.released  - a.born AS `age of Tom` ORDER BY yearsAgoReleased;



// 8
// Create a Movie node for the movie with the title, Forrest Gump.
CREATE (:Movie {title: 'Forrest Gump'});
// Retrieve the node you just created by its title.
MATCH (m:Movie) WHERE m.title = 'Forrest Gump' RETURN m;
// Create a Person node for the person with the name, Robin Wright.
CREATE (:Person {name: 'Robin Wright'});
// Retrieve the Person node you just created by its name.
MATCH (p:Person) WHERE p.name = 'Robin Wright' RETURN p;
// Add the label OlderMovie to any Movie node that was released before 2010.
MATCH (m:Movie) WHERE m.released < 2010 SET m:OlderMovie RETURN DISTINCT labels(m);
// Retrieve all older movie nodes to test that the label was indeed added to these nodes.
MATCH (m:OlderMovie) RETURN m.title, m.released;
// Add the label Female to all Person nodes that has a person whose name starts with Robin.
MATCH (p:Person) WHERE p.name STARTS WITH 'Robin' SET p:Female;
// Retrieve all Female nodes
MATCH (p:Female) RETURN p.name;
// We’ve decided to not use the Female label. Remove the Female label from the nodes that have this label.
MATCH (p:Female) REMOVE p:Female;
// View the current schema of the graph.
CALL db.schema.visualization();
// Add the following properties to the movie, Forrest Gump:
// released: 1994;
// tagline: Life is like a box of chocolates…​you never know what you’re gonna get.
// lengthInMinutes: 142
MATCH (m:Movie) WHERE m.title = 'Forrest Gump'
SET m:OlderMovie, m.released = 1994,  m.tagline = 'Life is like a box of chocolates...', m.lengthInMinutes = 142;
// Retrieve this OlderMovie node to confirm that the properties and label have been properly set.
MATCH (m:OlderMovie) WHERE m.title = 'Forrest Gump' RETURN m;
// Add the following properties to the person, Robin Wright:
// born: 1966
// birthPlace: Dallas
MATCH (p:Person) WHERE p.name = 'Robin Wright' SET p.born = 1966, p.birthPlace = 'Dallas';
// Retrieve this Person node to confirm that the properties have been properly set.
MATCH (p:Person) WHERE p.name = 'Robin Wright' RETURN p;
// Remove the lengthInMinutes property from the movie, Forrest Gump.
MATCH (m:Movie) WHERE m.title = 'Forrest Gump' SET m.lengthInMinutes = null;
// Retrieve the Forrest Gump node to confirm that the property has been removed.
MATCH (m:Movie) WHERE m.title = 'Forrest Gump' RETURN m;
// Remove the birthPlace property from the person, Robin Wright.
MATCH (p:Person) WHERE p.name = 'Robin Wright' REMOVE p.birthPlace;
// Retrieve the Robin Wright node to confirm that the property has been removed.
MATCH (p:Person) WHERE p.name = 'Robin Wright' RETURN p;
