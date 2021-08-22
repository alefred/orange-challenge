FROM openjdk

COPY [".", "/usr/src"]

WORKDIR /usr/src

#RUN apt update 
RUN chmod +x mvnw
RUN ./mvnw clean verify

EXPOSE 8080

CMD ["java", "-jar","target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar"]
#CMD ["npx", "nodemon", "index.js"]