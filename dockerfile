FROM openjdk

COPY [".", "/usr/src"]

WORKDIR /usr/src

#RUN apt update 
#RUN apt install maven
RUN ./mvnw clean verify

EXPOSE 8081

CMD ["java", "-jar","target/react-and-spring-data-rest-*.jar"]
#CMD ["npx", "nodemon", "index.js"]