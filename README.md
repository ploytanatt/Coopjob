# Coopjob 
The main objective of this website is to centralize job postings from various companies for students' consideration. It will also collect and store information regarding student applications and any issues they encounter during their cooperate.

### Follow the steps
1) Clone the repository
2) type the following command

```
cd Coopjob_frontend
npm install
npm run serve
```

```
cd Coopjob_backend
npm install
npm start
```
3) You need to install MySQL Community Server and MySQL Workbench and import file from folder >> db >> coop.sql
4) Go to the project folder >> Coopjob_backend >> config.js file and change the Connections according to your database connection and credentials.
5) Go to the project folder >> Coopjob_backend create .env file and change the password of your database connection
```
DB_PASSWORD=
```
6) webpack development server will start at: http://localhost:3000
