------------------------------------------------
---- CSIPROJECT                 ----
------------------------------------------------

CREATE USER CSIPROJECT IDENTIFIED BY mohammed; 
GRANT CREATE SESSION TO CSIPROJECT;
GRANT CREATE TABLE TO CSIPROJECT;
GRANT CREATE VIEW TO CSIPROJECT;
GRANT CREATE PROCEDURE TO CSIPROJECT;
GRANT CREATE SYNONYM TO CSIPROJECT;
GRANT CREATE SEQUENCE TO CSIPROJECT;
ALTER USER CSIPROJECT QUOTA UNLIMITED ON USERS;

connect CSIPROJECT/mohammed;

CREATE USER CSIPROJECT IDENTIFIED BY mohammed; 
GRANT CREATE SESSION TO CSIPROJECT;
GRANT CREATE TABLE TO CSIPROJECT;
GRANT CREATE VIEW TO CSIPROJECT;
GRANT CREATE PROCEDURE TO CSIPROJECT;
GRANT CREATE SYNONYM TO CSIPROJECT;
GRANT CREATE TRIGGER TO CSIPROJECT;
GRANT CREATE SEQUENCE TO CSIPROJECT;
ALTER USER CSIPROJECT QUOTA UNLIMITED ON USERS;

connect CSIPROJECT/mohammed;

CREATE TABLE cities (
      name VARCHAR2(40),
      PRIMARY KEY(name),
      population NUMBER(9),
      crimeRate NUMBER(6,1), -- crimes per 100,000 per year??
      CHECK (crimeRate >= 0),
      propertyTaxRate NUMBER(7,4), -- mils (/$1000 of assessed value)
      CHECK (propertyTaxRate >= 0),
      incomeTaxRate NUMBER(7,4)    -- mils (/$1000 of assessed value)
     CHECK (incomeTaxRate >= 0)
);
CREATE TABLE zip (
	zip NUMBER(5) CHECK (zip>9999),
    PRIMARY KEY(zip),
    averageIncome NUMBER(9,2),
    unemploymentRate NUMBER(3,3)
);
CREATE TABLE schoolDistrict (
      name VARCHAR2(40),
      PRIMARY KEY(name),
      meapMathPassRate NUMBER(3,3),
      meapEnglishPassRate NUMBER(3,3),
      nStudents NUMBER(6),
      nTeachers NUMBER(5),
      propertyTaxRate NUMBER(7,4)
);
CREATE TABLE homes (
           -- these attributes from entity `Home`
     HomeID INTEGER,
     Address CHAR(50) NOT NULL,
     Floorspace NUMBER(5,1),
     Floors NUMBER(1),
     Bedrooms NUMBER(2),
     FullBathrooms NUMBER(2),
     HalfBathrooms NUMBER(2),
     Landsize NUMBER(6,2),
     YearConstructed NUMBER(4),
     PRIMARY KEY (HomeID),
     CHECK (Floorspace > 0),
     CHECK (Floors > 0),
     CHECK (YearConstructed > 1500) ,
    -- these attributes from relation `Location`
     city VARCHAR2(40),
     FOREIGN KEY (city) REFERENCES cities (name),
     zip NUMBER(5),
     FOREIGN KEY (zip) REFERENCES zip,
     schoolDistrict VARCHAR2(40),
     FOREIGN KEY (schoolDistrict) REFERENCES schoolDistrict (name)
);
CREATE TABLE apartmentComplexes (
      ComplexID INTEGER,
      Name CHAR(30),
      OfficeAddress CHAR(50),
      OfficePhone NUMBER(10) CHECK (officePhone >= 2011010000),
      ComplexPhoto BLOB,
      PRIMARY KEY (ComplexID),
      UNIQUE(Name, OfficeAddress)
);
CREATE TABLE apartments (
           -- from entity Apartment
     HomeID INTEGER,
     FloorNr INTEGER, -- (could be NOT NULL)
     PetsOK CHAR(1), -- Y/N
     Rent INTEGER, -- (could be NOT NULL)
     PRIMARY KEY (HomeID),
     FOREIGN KEY (HomeID) references homes,
     CHECK (PetsOK = 'Y' OR PetsOK = 'N'),
     CHECK (FloorNr > 0),
     CHECK (Rent > 0) ,
    -- from relationship BelongsTo
     ComplexID INTEGER NOT NULL,
     FOREIGN KEY (ComplexID) references apartmentComplexes
);
CREATE TABLE condos (
      HomeID INTEGER,
      AssociationFee INTEGER,
      PRIMARY KEY (HomeID),
      FOREIGN KEY (HomeID) references Homes,
      CHECK (AssociationFee >= 0)
);
CREATE TABLE townHouses (
      HomeID INTEGER,
      -- OutsidePhoto      BLOB, --
      PRIMARY KEY (HomeID),
      FOREIGN KEY (HomeID) references Homes
);
CREATE TABLE mansions (
      HomeID INTEGER,
      Architect CHAR(30),
      HistoricStatus CHAR(15),
      ServantBedrooms INTEGER,
      GuestBedrooms INTEGER,
      -- InsidePhoto       BLOB, --
      PRIMARY KEY (HomeID),
      FOREIGN KEY (HomeID) references TownHouses
);
-- 'person' table:  root of this hierarchy
 -- NOTE:  SSN and driversLicenseNr (spelling changed) are each
 -- unique on their own,  not as a group
CREATE TABLE   person (
          PersonId INTEGER CHECK (PersonId > 0),
          Name VARCHAR2(50) NOT NULL,
          SSN NUMBER(9) CHECK (SSN > 0),
          driversLicenseNr CHAR(13), -- assume only MI licenses?
          BirthDate DATE,
          BirthPlace VARCHAR2(50),
          PRIMARY KEY (PersonId) ,
          UNIQUE (SSN),
          UNIQUE (driversLicenseNr),
          CHECK ( PersonId > 0 ) -- i.e,  non-negative
);
-- `owner` table, a subclass of `person`
CREATE TABLE  owners (
           PersonId INTEGER,
           Profession CHAR(50),
           Income NUMBER(10,2),
           PRIMARY KEY (PersonId),
           FOREIGN KEY (PersonId) REFERENCES PERSON (PersonId)
);
-- `Agent` table, `Person`
CREATE TABLE   agents (
           LicenseNum INTEGER NOT NULL,
           UNIQUE (LicenseNum),
           CHECK (LicenseNum > 0 ),
           PersonId INTEGER,
           PRIMARY KEY (PersonId),
           FOREIGN KEY (PersonId) REFERENCES PERSON (PersonId)
);
-- `Dependent` entity (irrelevant to project requirements)
--    was familyMember or familyMembers previously
CREATE TABLE dependents (
           head INTEGER NOT NULL,
           FOREIGN KEY (head) REFERENCES Owners (personId),
           dependent INTEGER,
           FOREIGN KEY (dependent) REFERENCES PERSON (personId),
           PRIMARY KEY (dependent),
           relationship CHAR(6),
           CHECK (relationship IN ('spouse','child','other'))
);
-- `Company`;  we need to define this before `WorksFor` or `Office`
CREATE TABLE companies (
           name CHAR(50),
           PRIMARY KEY(name)
);
-- relation `WorksFor`
CREATE TABLE worksFor (
           agent INTEGER,
           FOREIGN KEY (agent) REFERENCES AGENTs (personId),
           worksFor CHAR (50),
           FOREIGN KEY (worksFor) REFERENCES companies (name),
           PRIMARY KEY (agent, WorksFor),
           Commission NUMBER(4,4), -- expressed as fraction
           workPhone NUMBER(10) CHECK(workPhone >= 2011010000)
);
-- entity 'Office' and relationships 'In' and 'Has', combined
CREATE TABLE hasOfficeIn (
           company CHAR(50),
           FOREIGN KEY (company) REFERENCES companies(name),
           address VARCHAR2(40),
           city VARCHAR2(40),
           FOREIGN KEY (city) REFERENCES cities(name),
           PRIMARY KEY(company,city)
);
--  appliances related to homes
CREATE TABLE appliances (
      modelNr NUMBER(8) CHECK( modelNr > 0 ),
      PRIMARY KEY(modelNr),
      make VARCHAR2(40),
      name VARCHAR2(40),
      UNIQUE(make,name),
      description VARCHAR(1000)
);
CREATE TABLE includes (
      homeId  NUMBER(11), FOREIGN KEY(homeId) REFERENCES homes(homeId),
      modelNr NUMBER(8), --FOREIGN KEY(modelNr) REFERENCES appliances(modelNr),
      PRIMARY KEY(homeId,modelNr),
      serialNr VARCHAR2(20),
      FOREIGN KEY (modelNr) REFERENCES appliances (modelNr)
);
-- isSelling:  {homeId}->{*}
CREATE TABLE   isSelling (
      agent INTEGER NOT NULL,
      FOREIGN KEY (agent) REFERENCES agents (personId),
      home INTEGER,
      FOREIGN KEY (home) REFERENCES homes (homeId),
      PRIMARY KEY (home),
      offerPrice NUMBER(9,2)
);
-- sold:  {homeId,saleDate}->{*}    (entity `Sale`)
CREATE TABLE  sold (
     home INTEGER,
     FOREIGN KEY (home) REFERENCES homes (homeId),
     agent INTEGER,
     company CHAR(50),
     FOREIGN KEY (agent,company) REFERENCES worksFor (agent,worksFor),
     buyer INTEGER,
     FOREIGN KEY (buyer) REFERENCES owners (personId),
     seller INTEGER,
     FOREIGN KEY (seller) REFERENCES owners (personId),
     salePrice NUMBER(9,2),
     saleDate  DATE,
     PRIMARY KEY (home,saleDate)
);
-- nowOwns: {homeId}->{*}
-- note:  we need to remember to always update this
--        when inserting into `sold`
CREATE TABLE  nowOwns (
     owner INTEGER,
     FOREIGN KEY (owner) REFERENCES owners (personId),
     home INTEGER,
     FOREIGN KEY (home) REFERENCES homes (homeId),
     PRIMARY KEY (home)
    );